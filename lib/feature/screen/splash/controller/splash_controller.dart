import 'dart:async';
import 'package:crowdv_mobile_app/feature/screen/authentication/sign_in/signin.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_page.dart';
import 'package:get/get.dart';


class SplashController extends GetxController {
  String token,role;
  int id;
  SplashController({this.token,this.role,this.id});

  @override
  void onReady() {
    Timer(
      Duration(seconds: 3),
      nextPage,
    );
    super.onReady();
  }

  void nextPage() {
    print(token);
    print(id);
    print(role);
    // token == null?
    // Get.off(LoginPage())
    //     :Get.off(HomeScreen());
  }
}
