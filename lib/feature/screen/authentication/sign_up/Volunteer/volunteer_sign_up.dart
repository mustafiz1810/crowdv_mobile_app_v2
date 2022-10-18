import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/feature/screen/authentication/sign_up/Volunteer/role_check.dart';
import 'package:crowdv_mobile_app/feature/screen/authentication/widgets/terms_condition.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/widgets/header_widget.dart';
import 'package:crowdv_mobile_app/widgets/progres_hud.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import '../../../../../widgets/show_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VolunteerSignUp extends StatefulWidget {
  final dynamic email,phone;
  VolunteerSignUp(
      {@required this.email,this.phone});
  @override
  State<StatefulWidget> createState() {
    return _VolunteerSignUpState();
  }
}
class _VolunteerSignUpState extends State<VolunteerSignUp> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User loggedInUser;
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool checkedValue = false;
  bool checkboxValue = false;
  var fcmToken;
  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }
  void signup(String fname, lname, email, phone, password,fcmToken, check) async {
    try {
      Response response =
      await post(Uri.parse(NetworkConstants.BASE_URL + 'registration'),
          headers: {
            "Accept": "application/json"
          },
          body: {
        'first_name': fname,
        'last_name': lname,
        'email': email,
        'phone': phone,
        'password': password,
        'fcm_token':fcmToken,
        'terms_and_conditions': check,
      });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final newUser = await _auth.createUserWithEmailAndPassword(
            email: email.trim(), password: password);
        if (newUser != null) {
          getCurrentUser();
          _firestore.collection('Users').doc(newUser.user.uid).set({
            'id': newUser.user.uid,
            'name': fname,
            'email': email,
            'phone': phone,
            'photoUrl': "",
            'timeCreation': DateTime.now(),
            'chatWith': "",
            'Token': "",
          }).whenComplete((){
            print('Document Added');
          });
        }
        print(data);
        showToast(context, data['message']);
        setState(() {
          isApiCallProcess = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
          RoleCheck(id: data['data']['id'],token:data['data']['token'],uid: newUser.user.uid,email:widget.email,password:passwordController.text.toString())),
        );
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
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
              title: Text("Exception:"),
              content: Text(e.toString()),
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
  bool _obscured = true;
  final textFieldFocusNode = FocusNode();
  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus = false;     // Prevents focus if tap on eye
    });
  }
  bool isApiCallProcess = false;
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _signup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }


  Widget _signup(BuildContext context) {
    double _headerHeight = 300;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderLogo(
                  _headerHeight), //let's create a common header widget
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 250,
                        ),
                        Container(
                          child: TextFormField(
                            controller: fnameController,
                            decoration: ThemeHelper().textInputDecoration(
                                'First Name', 'Enter your first name'),
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Please enter your first name";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          child: TextFormField(
                            controller: lnameController,
                            decoration: ThemeHelper().textInputDecoration(
                                'Last Name', 'Enter your last name'),
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Please enter your last name";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 30.0),
                        Container(
                          child: TextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _obscured,
                            obscuringCharacter: "*",
                            style: TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              labelText: "Password",
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(fontSize: 14),
                              fillColor: Colors.white,
                              contentPadding:
                              EdgeInsets.fromLTRB(15, 15, 15, 15),
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(12.0),
                                  borderSide:
                                  BorderSide(color: Colors.black)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(12.0),
                                  borderSide:
                                  BorderSide(color: Colors.black)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                      color: Colors.red, width: 2.0)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                      color: Colors.red,
                                      width:
                                      2.0)), //Hides label on focus or if filled
                              suffixIcon: Padding(
                                padding:
                                const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                child: GestureDetector(
                                  onTap: _toggleObscured,
                                  child: Icon(
                                    _obscured
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            validator: (val) {
                              if (val.length < 6) {
                                return "Password must be 6 digit";
                              }
                              return null;
                            },
                          ),
                          decoration:
                          ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 15.0),
                        FormField<bool>(
                          builder: (state) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: checkedValue,
                                        onChanged: (value) {
                                          FirebaseMessaging.instance.getToken().then((newToken){
                                            setState(() {
                                              fcmToken=newToken;
                                              print(fcmToken);
                                              checkedValue = value;
                                              state.didChange(value);
                                            });
                                          }
                                          );
                                        }),
                                    RichText(
                                      text: new TextSpan(
                                        style: new TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        children: [
                                          new TextSpan(
                                            text:
                                            "Allow Notification",
                                            style: TextStyle(color: Colors.grey),),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    state.errorText ?? '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Theme.of(context).errorColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          validator: (value) {
                            if (!checkedValue) {
                              return 'You need allow notification';
                            } else {
                              return null;
                            }
                          },
                        ),
                        FormField<bool>(
                          builder: (state) {
                            return Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Checkbox(
                                        value: checkboxValue,
                                        onChanged: (value) {
                                          setState(() {
                                            print(checkboxValue.toString());
                                            checkboxValue = value;
                                            state.didChange(value);
                                          });
                                        }),
                                    InkWell(
                                      child: RichText(
                                        text: new TextSpan(
                                          style: new TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                          children: [
                                            new TextSpan(
                                              text:
                                              "I accept all ",
                                              style: TextStyle(color: Colors.grey),),
                                            new TextSpan(
                                                text: "terms and conditions.",
                                                style: new TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue)),
                                          ],
                                        ),
                                      ),
                                      onTap:(){
                                        Get.to(()=>TermsCondition());
                                      },
                                    ),
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    state.errorText ?? '',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Theme.of(context).errorColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                          validator: (value) {
                            if (!checkboxValue) {
                              return 'You need to accept terms and conditions';
                            } else {
                              return null;
                            }
                          },
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "submit".toUpperCase(),
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
                                  // print(fnameController.text.toString() +" "+
                                  //     lnameController.text.toString() +" "+
                                  //     widget.email.toString() +" "+
                                  //     widget.phone.toString() +" "+
                                  //     passwordController.text.toString() +" "+
                                  //     checkboxValue.toString());
                                });
                                signup(
                                    fnameController.text.toString(),
                                    lnameController.text.toString(),
                                    widget.email.toString(),
                                    widget.phone.toString(),
                                    passwordController.text.toString(),
                                    fcmToken,
                                    checkboxValue.toString(),);
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
