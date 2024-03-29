import 'dart:async';

import 'package:crowdv_mobile_app/feature/screen/authentication/otp_config/volunteer/email_v.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_page.dart';
import 'package:crowdv_mobile_app/feature/screen/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Organization/home.dart';
import '../../authentication/sign_in/signin.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  String token, role;
  int id;
  @override
  void initState() {
    getCred();
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    animation = CurvedAnimation(parent: controller, curve: Curves.ease);
    controller.repeat(reverse: true);
    onReady();
  }
  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
      id = pref.getInt("id");
      role = pref.getString("role");
    });
  }
   onReady() {
    Timer(
      Duration(seconds: 3),
      nextPage,
    );
  }

  void nextPage() {
    // print(token);
    // print(id);
    // print(role);
    token == null?
    Get.off(EmailVolunteer())
        :role != "organization"?Get.off(HomeScreen(id: id,role: role)):Get.off(OrganizationHome(id: id,role: role,));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ScaleTransition(
            scale: animation,
            child: SizedBox(
              height: 120,
              width: 120,
              child: Image.asset(
                'assets/crowdv_png.png',
                width: 120,
              ),
            ),
          )),
    );
  }
}
