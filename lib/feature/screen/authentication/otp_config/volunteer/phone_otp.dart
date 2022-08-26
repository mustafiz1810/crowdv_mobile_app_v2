import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/feature/screen/authentication/sign_up/Volunteer/volunteer_sign_up.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/header_widget.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../widgets/show_toast.dart';

class PhoneOtp extends StatefulWidget {
  final dynamic email,phone;
  PhoneOtp(
      {@required this.email,this.phone});


  @override
  _PhoneOtpPageState createState() => _PhoneOtpPageState();
}

class _PhoneOtpPageState extends State<PhoneOtp> {
  TextEditingController otpController = TextEditingController();
  final CustomTimerController _controller = CustomTimerController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  void otp(String otp) async {
    try {
      Response response =
      await post(Uri.parse(NetworkConstants.BASE_URL + 'phone-number-otp/check'),
          headers: {
            "Accept": "application/json"
          },
          body: {
        'otp': otp,
      });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        setState(() {
          isApiCallProcess = false;
        });
        showToast(context, data['message']);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VolunteerSignUp(email: widget.email.toString(),phone: widget.phone.toString(),),
        ));
      } else {
        var data = jsonDecode(response.body.toString());
        showToast(context, data['message']);
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
  bool _pinSuccess = false;

  @override
  Widget build(BuildContext context) {
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
                              'Verification',
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54),
                              // textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            RichText(
                              text: new TextSpan(
                                style: new TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                                children: [
                                  new TextSpan(
                                      text:
                                      'Enter the verification code we just sent you on ',
                                      style:
                                      new TextStyle(color: Colors.black54)),
                                  new TextSpan(
                                      text: widget.phone.replaceRange(3, 9,"******"),
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            PinCodeTextField(
                              length: 6,
                              obscureText: false,
                              animationType: AnimationType.fade,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 40,
                                activeFillColor: Colors.white,
                              ),
                              animationDuration:
                              const Duration(milliseconds: 300),
                              enableActiveFill: false,
                              controller: otpController,
                              onCompleted: (value) {
                                setState(() {
                                  _pinSuccess = true;
                                });
                              },
                              onChanged: (value) {
                                debugPrint(value);
                              },
                              beforeTextPaste: (text) {
                                return true;
                              },
                              appContext: context,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30.0),
                      CustomTimer(
                          controller: _controller,
                          from: Duration(minutes: 2),
                          to: Duration(minutes: 0),
                          onBuildAction: CustomTimerAction.auto_start,
                          builder: (remaining) {
                            return Text(
                                "${remaining.minutes}:${remaining.seconds}",
                                style: TextStyle(fontSize: 24.0));
                          }),
                      // Text.rich(
                      //   TextSpan(
                      //     children: [
                      //       TextSpan(
                      //         text: "If you didn't receive a code! ",
                      //         style: TextStyle(
                      //           color: Colors.black38,
                      //         ),
                      //       ),
                      //       TextSpan(
                      //         text: 'Resend',
                      //         recognizer: TapGestureRecognizer()
                      //           ..onTap = () {
                      //             _controller.start();
                      //             showDialog(
                      //               context: context,
                      //               builder: (BuildContext context) {
                      //                 return ThemeHelper().alartDialog(
                      //                     "Successful",
                      //                     "Verification code resend successful.",
                      //                     context);
                      //               },
                      //             );
                      //           },
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //             color: Colors.orange),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: 40.0),
                      Container(
                        decoration: _pinSuccess == true
                            ? ThemeHelper().buttonBoxDecoration(context)
                            : ThemeHelper().buttonBoxDecoration(
                            context, "#AAAAAA", "#757575"),
                        child: ElevatedButton(
                          style: ThemeHelper().buttonStyle(),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                            child: Text(
                              "Verify".toUpperCase(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed:
                          _pinSuccess == true
                              ? () {
                            setState(() {
                              isApiCallProcess = true;
                            });
                            otp(otpController.text.toString());
                          }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
