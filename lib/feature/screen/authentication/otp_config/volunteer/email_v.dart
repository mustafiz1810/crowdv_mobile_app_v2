import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/feature/screen/authentication/otp_config/volunteer/otp_v.dart';
import 'package:crowdv_mobile_app/feature/screen/authentication/otp_config/volunteer/phone_v.dart';
import 'package:crowdv_mobile_app/feature/screen/authentication/sign_in/sign_in.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/widgets/header_widget.dart';
import 'package:crowdv_mobile_app/widgets/progres_hud.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../../../../../widgets/show_toast.dart';
import '../../sign_up/Volunteer/role_check.dart';
import '../../sign_up/Volunteer/volunteer_sign_up.dart';

class EmailVolunteer extends StatefulWidget {
  const EmailVolunteer({Key key}) : super(key: key);

  @override
  _EmailVolunteerPageState createState() => _EmailVolunteerPageState();
}

class _EmailVolunteerPageState extends State<EmailVolunteer> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailEditingController = TextEditingController();
  void email(String email) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'email-send'),
          headers: {
            "Accept": "application/json"
          },
          body: {
            'email': email,
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        showToast(context, data['message']);
        print(data);
        setState(() {
          isApiCallProcess = false;
        });
        if (data['data']['verified'] == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpVolunteer(
                      email: data['data']['email'],
                    )),
          );
        } else if (data['data']['is_phone_verified'] == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PhoneVerify(
                      email: data['data']['email'],
                    )),
          );
        } else if (data['data']['first_name'] == null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VolunteerSignUp(
                  email: data['data']['email'].toString(),
                  phone: data['data']['phone'].toString(),
                ),
              ));
        } else if (data['data']['first_name'] != null &&
            data['data']['role'] == null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RoleCheck(
                      id: data['data']['id'],
                    )),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      } else {
        var data = jsonDecode(response.body.toString());
        data['error'].length != 0?
        showToast(context, data['error']['errors'].toString()):showToast(context, data['message']);
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
                              'Your Email',
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
                              'Enter your email address to register account.',
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
                              'A verification code will be send to your email.',
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
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  controller: emailEditingController,
                                  decoration: ThemeHelper().textInputDecoration(
                                      "Email", "Enter your email"),
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return "Email can't be empty";
                                    } else if (!RegExp(
                                            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                        .hasMatch(val)) {
                                      return "Enter a valid email address";
                                    } else {
                                      return null;
                                    }
                                  },
                                  onChanged: (value) {
                                    emailEditingController.value =
                                        TextEditingValue(
                                            text: value.toLowerCase(),
                                            selection: emailEditingController
                                                .selection);
                                  }),
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
                                    email(
                                      emailEditingController.text.toString(),
                                    );
                                  } else {
                                    setState(() {});
                                  }
                                  ;
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
