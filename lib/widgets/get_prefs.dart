import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;

getUser() async {
  prefs = await SharedPreferences.getInstance();
  String encodedMap = prefs.getString('user');
  Map<String,dynamic> decodedMap = encodedMap != null ? json.decode(encodedMap) : null;
  return decodedMap;
}