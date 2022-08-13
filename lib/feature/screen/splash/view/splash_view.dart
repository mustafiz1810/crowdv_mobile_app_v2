import 'package:crowdv_mobile_app/feature/screen/splash/controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    animation = CurvedAnimation(parent: controller, curve: Curves.ease);
    controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SplashController>(
          // specify type as Controller
          init: SplashController(), // intialize with the Controller
          builder: (splashController) {
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
          }),
    );
  }
}
