import 'dart:async';
import 'package:crowdv_mobile_app/feature/screen/authentication/sign_in/sign_in.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    Timer(
      Duration(seconds: 3),
      nextPage,
    );
    super.onReady();
  }

  void nextPage() {
    Get.off(LoginPage());
  }
}
