import 'dart:convert';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/view_utils/colors.dart';

class Settings extends StatefulWidget {
  final dynamic appNotify, emailNotify, smsNotify;
  Settings({this.appNotify, this.emailNotify, this.smsNotify});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool checkedValue = false;
  bool inApp ;
  bool inSms ;
  bool inMail ;
  String token = "";

  @override
  void initState() {
    inApp =widget.appNotify;
    inSms = widget.smsNotify;
    inMail = widget.emailNotify;
    super.initState();
    getCred();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
    });
  }

  void save( app, sms, email) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'notification/channel-setting'),
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          },
          body: {
            'is_database_notification': app.toString(),
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
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  TextButton(
                      child: Text(
                        "Save".toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      onPressed: () {
                        save(inApp, inSms, inMail);
                      })
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Column(
                  children: [
                    CheckboxListTile(
                      title: Row(
                        children: [
                          Icon(
                            Icons.phone_android_rounded,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 33,
                          ),
                          RichText(
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
                        ],
                      ),
                      value: inApp,
                      onChanged: (newValue) {
                        setState(() {
                          inApp = newValue;
                        });
                        print(inApp);
                      },
                    ),
                    CheckboxListTile(
                      title: Row(
                        children: [
                          Icon(
                            Icons.sms_outlined,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 33,
                          ),
                          RichText(
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
                        ],
                      ),
                      value: inSms,
                      onChanged: (newValue) {
                        setState(() {
                          inSms = newValue;
                        });
                        print(inSms);
                      },
                    ),
                    CheckboxListTile(
                      title: Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 33,
                          ),
                          RichText(
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
                        ],
                      ),
                      value: inMail,
                      onChanged: (newValue) {
                        setState(() {
                          inMail = newValue;
                        });
                        print(inMail);
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

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
  final EdgeInsets padding;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: <Widget>[
            Expanded(child: Text(label)),
            Checkbox(
              value: value,
              onChanged: (bool newValue) {
                onChanged(newValue);
              },
            ),
          ],
        ),
      ),
    );
  }
}
