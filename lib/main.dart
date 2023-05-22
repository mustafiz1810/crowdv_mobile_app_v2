import 'package:crowdv_mobile_app/feature/screen/splash/view/splash_view.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';

void main() async {
  await GetStorage.init();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51MErClGMOrTjnIDXfADj9vMxJehviEHD2jOle7cVeZmqLfK5BW30y0Bqf79ExQxkI9QYZX0H2mA8uqJtPRqtDusL00bD1S1UTN';
  runApp(MyApp());
  configLoading();
}
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = primaryColor
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
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
        checkerboardOffscreenLayers: false,
        defaultTransition: Transition.fadeIn,
        initialRoute: "/",
        home: SplashView(),
        builder: (BuildContext context, Widget child) {
          return FlutterEasyLoading(
            child: Material(
              child: OfflineBuilder(
                connectivityBuilder: (
                  BuildContext context,
                  ConnectivityResult connectivity,
                  Widget child,
                ) {
                  final bool connected = connectivity != ConnectivityResult.none;
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      child,
                      Positioned(
                        top: 26,
                        left: 0.0,
                        right: 0.0,
                        height: 20.0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          color: connected ? null : Colors.red.withOpacity(0.6),
                          child: connected
                              ? null
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "No internet connection",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                    SizedBox(width: 8.0),
                                    SizedBox(
                                      width: 12.0,
                                      height: 12.0,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.0,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      connected?Container():AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        color: Colors.black.withOpacity(0.6),
                        child: connected
                            ? null
                            : AlertDialog(
                          title: Column(
                            children: [
                              Image.asset("assets/no-wifi.png",height: 50,),
                              Text("No Internet Connection"),
                            ],
                          ),
                          content: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Your internet connection may be limited. Please check your connection and try again.",
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("OK"),
                              onPressed: () {
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
