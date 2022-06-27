
import 'package:crowdv_mobile_app/feature/screen/authentication/otp_config/volunteer/email_v.dart';
import 'package:crowdv_mobile_app/feature/screen/authentication/sign_in/sign_in.dart';
import 'package:crowdv_mobile_app/feature/screen/authentication/widgets/rounded_button.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class VolunteerAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Row(
              children: [
                const Text(
                  "WELCOME TO ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Center(
                  child:
                      Image.asset('assets/logo.png', width: 200, height: 200),
                ),
              ],
            ),
          ),
          // Text(
          //   "Let's save some time and energy today!",
          //   style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
          // ),
          // // SizedBox(height: 15),
          RoundedButton(
            text: "Sign In",
            color: primaryColor,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginPage();
                  },
                ),
              );
            },
          ),
          RoundedButton(
            text: "SignUp",
            color: secondaryColor,
            press: () {
              Get.to(() => EmailVolunteer());
            },
          ),
        ],
      ),
    ));
  }
}
