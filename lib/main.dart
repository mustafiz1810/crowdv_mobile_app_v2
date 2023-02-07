import 'package:crowdv_mobile_app/feature/screen/splash/view/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  await GetStorage.init();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = 'pk_test_51MErClGMOrTjnIDXfADj9vMxJehviEHD2jOle7cVeZmqLfK5BW30y0Bqf79ExQxkI9QYZX0H2mA8uqJtPRqtDusL00bD1S1UTN';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return DefaultTabController(
      length: 3,
      child: GetMaterialApp(
        theme: ThemeData(fontFamily: 'Airbnb Cereal'),
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.fadeIn,
        initialRoute: "/",
        home: SplashView(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
