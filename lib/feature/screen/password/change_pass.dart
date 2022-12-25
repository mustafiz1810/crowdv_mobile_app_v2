import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/show_toast.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key key}) : super(key: key);
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String token = "";
  final _formKey = GlobalKey<FormState>();
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

  TextEditingController oldPassEditingController = TextEditingController();
  TextEditingController newPassEditingController = TextEditingController();
  TextEditingController confirmPassEditingController = TextEditingController();
  void submit(String old_pass, new_pass, confirm_pass) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'change-password'),
          headers: {
            "Authorization": "Bearer $token"
          },
          body: {
            'old_password': old_pass,
            'password': new_pass,
            'password_confirmation': confirm_pass
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        // print('created');
        setState(() {
          isApiCallProcess = false;
        });
        showToast(context, data['message']);
        Navigator.pop(context);
      } else{
        var data = jsonDecode(response.body.toString());
        showToast(context, data['message']);
      }
    } catch (e) {
      showToast(context, 'Old password does not match');
    }
  }

  bool isApiCallProcess = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        // collapsedHeight: 150,
        title: const Text(
          'Change Password',
          style: TextStyle(color: Colors.white),
        ),
        // ),
        // centerTitle: true,
        backgroundColor: primaryColor,
        // pinned: true,
        // floating: true,
        // forceElevated: innerBoxIsScrolled,
      ),
      body: Container(
        padding: EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  children: [
                    TextFormField(
                      controller: oldPassEditingController,
                      decoration: ThemeHelper().textInputDecoration(
                          'Current password', 'Enter your current password'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: newPassEditingController,
                      decoration: ThemeHelper().textInputDecoration(
                          'New password', 'Enter your new password'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: confirmPassEditingController,
                      decoration: ThemeHelper().textInputDecoration(
                          'Confirm new password', 'Enter your password again'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value != newPassEditingController.text) {
                          return "Password and password confirm doesn't match";
                        }
                        // if (value.length < 6) {
                        //   return 'Password must be at least 6 characters in';
                        // }
                        return null;
                      },
                    ),
                  ],
                ),
                decoration: ThemeHelper().inputBoxDecorationShaddow(),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox.fromSize(
                    size: Size(180, 60), // button width and height
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      color: primaryColor, // button color
                      child: InkWell(
                        splashColor: secondaryColor, // splash color
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              isApiCallProcess = true;
                            });
                            submit(
                              oldPassEditingController.text.toString(),
                              newPassEditingController.text.toString(),
                              confirmPassEditingController.text.toString(),
                            );
                          }
                        }, // button pressed
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6), // icon
                            Text(
                              "CHANGE NOW",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ), // text
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
