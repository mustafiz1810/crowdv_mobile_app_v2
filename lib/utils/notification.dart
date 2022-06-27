import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationUtil {
  /*
    # Sample format

    {
        "notification": {
            "title": "Title goes here...",
            "body": "Body goes here..."
        },
        "data": {
            "title": "Title goes here...",
            "body": "Body goes here...",
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "is_background": "true",
            "content_available": "true"
        }
    }
  */

  FlutterLocalNotificationsPlugin _plugin;

  NotificationUtil._internal();

  static final NotificationUtil _instance = NotificationUtil._internal();

  static NotificationUtil on() {
    return _instance;
  }

  void configLocalNotification(SelectNotificationCallback onSelectCallback) {
    if (_plugin == null) {
      _plugin = FlutterLocalNotificationsPlugin();
    }

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification: (
              int id,
              String title,
              String body,
              String payload,
            ) async {
              onDidReceiveLocalNotification(
                id,
                title,
                body,
                payload,
              );
            });

    var initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('app_icon'),
      iOS: initializationSettingsIOS,
    );

    _plugin.initialize(
      initializationSettings,
      onSelectNotification: onSelectCallback,
    );
  }

  void onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: Get.context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      ),
    );
  }

  void showNotification(Map<String, dynamic> message) async {
    if (Platform.isAndroid &&
        message.containsKey('notification') &&
        message['notification'].containsKey('title') &&
        message['notification'].containsKey('body')) {
      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'default_channel_id',
        'Default',
        playSound: true,
        enableVibration: true,
        importance: Importance.max,
        //  icon: "app_icon",
        priority: Priority.high,
      );

      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await _plugin.show(
        message.hashCode,
        message['notification']['title'].toString(),
        message['notification']['body'].toString(),
        platformChannelSpecifics,
      );
    }

    if (Platform.isIOS &&
        message.containsKey('title') &&
        message.containsKey('body') &&
        message.containsKey('id')) {
      var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'default_channel_id',
        'Default',
        playSound: true,
        enableVibration: true,
        importance: Importance.max,
        priority: Priority.high,
      );

      var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        presentAlert: true,
        presentSound: true,
      );

      var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics,
      );

      await _plugin.show(
        message.hashCode,
        message['title'].toString(),
        message['body'].toString(),
        platformChannelSpecifics,
      );
    }
  }
}
