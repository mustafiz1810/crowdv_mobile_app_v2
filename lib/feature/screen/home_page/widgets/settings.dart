import 'dart:convert';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/view_utils/colors.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool checkedValue = false;
  bool inApp = false;
  bool inSms = false;
  bool inMail = false;
  var fcmToken;
  String token = "";

  @override
  void initState() {
    super.initState();
    getCred();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
    });
  }
  void save(app,sms,email) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'notification/channel-setting'),
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          },
          body: {
            'is_app_notification': app.toString(),
            'is_sms_notification': sms.toString(),
            'is_email_notification': email.toString(),
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        showToast(context, data['message']);
      } else {
        var data = jsonDecode(response.body.toString());
        showToast(context, data['message'].toString());
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Exception:"),
              content: Text(e.toString()),
              actions: [
                TextButton(
                  child: Text("Try Again"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        // collapsedHeight: 150,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: Container(
        color: Color(0xFFe9ecef),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Notification',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  TextButton(
                      child:Text(
                        "Save".toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      onPressed: () {
                        save(inApp, inSms, inMail);
                      }
                  )
                ],
              ),
              SizedBox(height: 5,),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Column(
                  children: [
                    FormField<bool>(
                      builder: (state) {
                        return ListTile(
                          leading: Icon(Icons.phone_android_rounded),
                          title: RichText(
                            text: new TextSpan(
                              style: new TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                new TextSpan(
                                  text: "Enable app notification",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          trailing: Checkbox(
                              value: inApp,
                              onChanged: (value) {
                                setState(() {
                                  inApp = value;
                                  state.didChange(value);
                                  print(inApp);
                                });
                              }),
                        );
                      },
                    ),
                    FormField<bool>(
                      builder: (state) {
                        return ListTile(
                          leading: Icon(Icons.sms_outlined),
                          title: RichText(
                            text: new TextSpan(
                              style: new TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                new TextSpan(
                                  text: "Enable sms notification",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          trailing: Checkbox(
                              value: inSms,
                              onChanged: (value) {
                                setState(() {
                                  inSms = value;
                                  state.didChange(value);
                                  print(inSms);
                                });
                              }),
                        );
                      },
                    ),
                    FormField<bool>(
                      builder: (state) {
                        return ListTile(
                          leading: Icon(Icons.mail_outline_rounded),
                          title: RichText(
                            text: new TextSpan(
                              style: new TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              children: [
                                new TextSpan(
                                  text: "Enable email notification",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          trailing: Checkbox(
                              value: inMail,
                              onChanged: (value) {
                                setState(() {
                                  inMail = value;
                                  state.didChange(value);
                                  print(inMail);
                                });
                              }),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
