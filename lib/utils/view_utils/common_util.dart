import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


/*
double getContentHeightWithBottomAndAppBar() {
  return Get.height - (dp30 + DefaultHeight.appBarLanding + kTextTabBarHeight + 1 + dp75);
}

double getContentHeightWithBottomBar() {
  return Get.height - (dp30 + DefaultHeight.appBarLanding + dp75);
}

double getContentHeightForSignInDialog() {
  return Get.height - (dp30 + DefaultHeight.appBarLanding + dp500);
}

double getContentHeight() {
  return Get.height - (dp30 + DefaultHeight.appBarLanding);
}

double getContentHeightWithAppBar() {
  return Get.height -
      (dp30 + DefaultHeight.appBarLanding + kTextTabBarHeight + 1);
}
*/


void showToast(String text, {bool isError = false, bool isLong = false}) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: isLong ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor:
        isError ? Get.theme.accentColor : Get.theme.primaryColorDark,
    textColor: Colors.white,
    //fontSize: 16.0
  );
}

void showLoadingDialog({bool isDismissible = false}) {
  if (!Get.isDialogOpen) {
    Get.dialog(Center(child: CircularProgressIndicator()),
        barrierDismissible: isDismissible);
  }
}

void hideLoadingDialog() {
  if (Get.isDialogOpen) {
    Get.back();
  }
}

void hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}

String formatDateItem(DateTime dateTime) {
  if (dateTime != null) {
    String formatStr = DateFormat('d MMM, EE, h:mm a').format(dateTime);
    return formatStr;
  }
  return "";
}

String formatDateDetails(DateTime dateTime) {
  if (dateTime != null) {
    String formatStr = DateFormat('d MMMM y, EEEE, h:mm a').format(dateTime);
    return formatStr;
  }
  return "";
}

String formatTimeFromStringDate(String date) {
  try {
    DateTime dateTime = DateFormat("dd-MM-yyyy hh:mm:ss").parse(date);
    if (dateTime != null) {
      String formatStr = DateFormat('h:mm a').format(dateTime);
      return formatStr;
    }
  } catch (e) {}

  return date;
}

String formatDateOnly(DateTime dateTime) {
  if (dateTime != null) {
    String formatStr = DateFormat('y-MM-d').format(dateTime);
    return formatStr;
  }
  return "";
}

DateTime dateFromStringDate(String date) {
  try {
    DateTime dateTime = DateTime.parse(date);
    return dateTime;
  } catch (e) {}

  return DateTime.now();
}

String getVerboseDateTimeRepresentation(DateTime dateTime) {
  DateTime now = DateTime.now();
  DateTime justNow = now.subtract(Duration(minutes: 1));
  DateTime localDateTime = dateTime.toLocal();

  if (!localDateTime.difference(justNow).isNegative) {
    return 'Just Now';
  }

  String roughTimeString = DateFormat('jm').format(dateTime);
  if (localDateTime.day == now.day &&
      localDateTime.month == now.month &&
      localDateTime.year == now.year) {
    return 'Today, $roughTimeString';
  }

  DateTime yesterday = now.subtract(Duration(days: 1));

  if (localDateTime.day == yesterday.day &&
      localDateTime.month == now.month &&
      localDateTime.year == now.year) {
    return 'Yesterday, $roughTimeString';
  }

  if (now.difference(localDateTime).inDays < 4) {
    String weekday = DateFormat('EEEE').format(localDateTime);

    return '$weekday, $roughTimeString';
  }

  return '${DateFormat('yMd').format(dateTime)}, $roughTimeString';
}


String stringNullCheck(String value) {
  return value == null ? "" : value;
}

double makeDouble(dynamic value) {
  if (value is String) {
    return double.parse(value);
  } else if (value is int) {
    return value.toDouble();
  } else if (value is double) {
    return value;
  }
  return 0.0;
}


String getEnumString(dynamic enumValue) {
  String string = enumValue.toString();
  try {
    string = string.split(".").last;
    return string;
  } catch (e) {}
  return "";
}
