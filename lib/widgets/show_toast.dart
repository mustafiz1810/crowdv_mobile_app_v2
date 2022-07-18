import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(BuildContext context, msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    timeInSecForIosWeb: 20,
    // timeInSecForIos: 1
  );
}

void showErrorToast(BuildContext context, msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    timeInSecForIosWeb: 4,
  );
}
