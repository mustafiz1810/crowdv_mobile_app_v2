import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:toast/toast.dart';

void showToast(BuildContext context, msg) {
  print(msg);
  SemanticsService.announce(msg, TextDirection.ltr);
  ToastContext().init(context);
  Toast.show(
      msg,
      duration:  Toast.lengthLong,
      gravity: Toast.center,
      backgroundColor:
      Color(0xFFcaf0f8),
      textStyle: TextStyle(color: Colors.black),
      border: Border(
          top: BorderSide(
            color: Color.fromRGBO(203, 209, 209, 1),
          ),bottom:BorderSide(
        color: Color.fromRGBO(203, 209, 209, 1),
      ),right: BorderSide(
        color: Color.fromRGBO(203, 209, 209, 1),
      ),left: BorderSide(
        color: Color.fromRGBO(203, 209, 209, 1),
      )),
      backgroundRadius: 6
  );
}

void showErrorToast(BuildContext context, msg) {
  ToastContext().init(context);
  Toast.show(
      msg,
      duration:  Toast.lengthLong,
      gravity: Toast.center,
      backgroundColor:
      Color.fromRGBO(239, 239, 239, .9),
      textStyle: TextStyle(color: Colors.red),
      border: Border(
          top: BorderSide(
            color: Color.fromRGBO(203, 209, 209, 1),
          ),bottom:BorderSide(
        color: Color.fromRGBO(203, 209, 209, 1),
      ),right: BorderSide(
        color: Color.fromRGBO(203, 209, 209, 1),
      ),left: BorderSide(
        color: Color.fromRGBO(203, 209, 209, 1),
      )),
      backgroundRadius: 6
  );
}
