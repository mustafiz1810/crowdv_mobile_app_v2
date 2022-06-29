import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/feature/screen/authentication/otp_config/volunteer/otp_v.dart';
import 'package:crowdv_mobile_app/feature/screen/authentication/otp_config/volunteer/phone_otp.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/widgets/header_widget.dart';
import 'package:crowdv_mobile_app/widgets/progres_hud.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../../../../widgets/show_toast.dart';

class PhoneVerify extends StatefulWidget {
  final dynamic email;
  PhoneVerify(
      {@required this.email});
  @override
  _PhoneVerifyPageState createState() => _PhoneVerifyPageState();
}

class _PhoneVerifyPageState extends State<PhoneVerify> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController phoneEditingController = TextEditingController();
  void phone(String phone,email) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'phone-number-verify'),
          body: {
            'phone': phone,
            'email': email,

          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(phoneEditingController.text.toString()+"  "+widget.email.toString());
        print(data);
        setState(() {
          isApiCallProcess = false;
        });
        showToast(context, data['message']);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PhoneOtp(email: widget.email.toString(),phone: phoneEditingController.text.toString(),)),
        );
      } else {
        var data = jsonDecode(response.body.toString());
        showToast(context, data['message']);
        setState(() {
          isApiCallProcess = false;
        });
      }
    } catch (e) {
      setState(() {
        isApiCallProcess = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(e.toString()),
              actions: [
                FlatButton(
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

  bool isApiCallProcess = false;

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    double _headerHeight = 300;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: _headerHeight,
                child: HeaderLogo(_headerHeight),
              ),
              SafeArea(
                child: Container(
                  margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Phone',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                              // textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Enter your phone number to verify & register your account.',
                              style: TextStyle(
                                // fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                              // textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'We will send you a verification code to check your authenticity.',
                              style: TextStyle(
                                color: Colors.black38,
                                // fontSize: 20,
                              ),
                              // textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: TextFormField(
                                controller: phoneEditingController,
                                decoration: ThemeHelper().textInputDecoration(
                                    "Phone Number", "Enter your phone number"),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty) {
                                    return 'Please enter your phone';
                                  }
                                  if (value.length < 11) {
                                    return 'Phone number has to be 11 character';
                                  }
                                  return null;
                                },
                              ),
                              decoration:
                              ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 40.0),
                            Container(
                              decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "Send".toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      isApiCallProcess = true;
                                    });
                                    phone(
                                      phoneEditingController.text.toString(),
                                      widget.email.toString(),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
