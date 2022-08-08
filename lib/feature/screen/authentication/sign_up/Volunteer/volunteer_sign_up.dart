import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/feature/screen/authentication/sign_up/Volunteer/role_check.dart';
import 'package:crowdv_mobile_app/feature/screen/authentication/widgets/terms_condition.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/widgets/header_widget.dart';
import 'package:crowdv_mobile_app/widgets/progres_hud.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import '../../../../../widgets/show_toast.dart';

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
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool checkedValue = false;
  bool checkboxValue = false;
  void signup(String fname, lname, email, phone, password, check) async {
    try {
      Response response =
      await post(Uri.parse(NetworkConstants.BASE_URL + 'registration'), body: {
        'first_name': fname,
        'last_name': lname,
        'email': email,
        'phone': phone,
        'password': password,
        'terms_and_conditions': check,
      });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        showToast(context, data['message']);
        setState(() {
          isApiCallProcess = false;
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
          RoleCheck(id: data['data']['id'],)),
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
                        // GestureDetector(
                        //   child: Stack(
                        //     children: [
                        //       // Container(
                        //       //   padding: EdgeInsets.all(10),
                        //       //   decoration: BoxDecoration(
                        //       //     borderRadius: BorderRadius.circular(100),
                        //       //     border: Border.all(
                        //       //         width: 5, color: Colors.white),
                        //       //     color: Colors.white,
                        //       //     boxShadow: [
                        //       //       BoxShadow(
                        //       //         color: Colors.black12,
                        //       //         blurRadius: 20,
                        //       //         offset: const Offset(5, 5),
                        //       //       ),
                        //       //     ],
                        //       //   ),
                        //       //   child: Icon(
                        //       //     Icons.person,
                        //       //     color: Colors.grey.shade300,
                        //       //     size: 80.0,
                        //       //   ),
                        //       // ),
                        //       // Container(
                        //       //   padding: EdgeInsets.fromLTRB(80, 80, 0, 0),
                        //       //   child: Icon(
                        //       //     Icons.add_circle,
                        //       //     color: Colors.grey.shade700,
                        //       //     size: 25.0,
                        //       //   ),
                        //       // ),
                        //     ],
                        //   ),
                        // ),
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

                        // Container(
                        //   child: TextField(
                        //     controller: emailController,
                        //     keyboardType: TextInputType.multiline,
                        //     decoration: InputDecoration(
                        //         enabled: false,
                        //         contentPadding:
                        //             EdgeInsets.fromLTRB(20, 10, 20, 10),
                        //         focusedBorder: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(100.0),
                        //             borderSide: BorderSide(color: Colors.grey)),
                        //         disabledBorder: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(100.0),
                        //             borderSide: BorderSide(
                        //                 color: Colors.grey.shade400)),
                        //         errorBorder: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(100.0),
                        //             borderSide: BorderSide(
                        //                 color: Colors.red, width: 2.0)),
                        //         focusedErrorBorder: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(100.0),
                        //             borderSide: BorderSide(
                        //                 color: Colors.red, width: 2.0)),
                        //         filled: true,
                        //         hintStyle: TextStyle(
                        //             color: Colors.black,
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: 16),
                        //         hintText: widget.email.toString(),
                        //         fillColor: Colors.grey.shade200),
                        //   ),
                        //   decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        // ),
                        // SizedBox(height: 20.0),
                        // Container(
                        //   child: TextFormField(
                        //     controller: phoneController,
                        //     decoration: ThemeHelper().textInputDecoration(
                        //         "Mobile Number", "Enter your mobile number"),
                        //     keyboardType: TextInputType.phone,
                        //     validator: (val) {
                        //       if ((val.isEmpty) &&
                        //           !RegExp(r"^(\d+)*$").hasMatch(val)) {
                        //         return "Enter a valid phone number";
                        //       }
                        //       return null;
                        //     },
                        //   ),
                        //   decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        // ),
                        // SizedBox(height: 20.0),
                        Container(
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: ThemeHelper().textInputDecoration(
                                "Password", "Enter your password"),
                            validator: (val) {
                              if (val.isEmpty) {
                                return "Please enter your password";
                              }
                              return null;
                            },
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 15.0),
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
