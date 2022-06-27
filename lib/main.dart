import 'package:crowdv_mobile_app/feature/screen/splash/view/splash_view.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hexcolor/hexcolor.dart';

void main() async {
  // setup();
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Color _primaryColor = primaryColor;
  // Color _accentColor = Colors.white70;
  // Color _primaryColor= HexColor('#FFC867');
  // Color _accentColor= HexColor('#FF3CBD');
  // Color _primaryColor= HexColor('#D44CF6');
  // Color _accentColor= HexColor('#5E18C8');
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    return DefaultTabController(
      length: 3,
      child: GetMaterialApp(
        // theme: ThemeData(
        //   primaryColor: _primaryColor,
        //   accentColor: _accentColor,
        //   scaffoldBackgroundColor: Colors.grey.shade100,
        //   primarySwatch: Colors.grey,
        // ),
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.rightToLeft,
        initialRoute: "/",
        home: SplashView(),
        builder: EasyLoading.init(),
      ),
    );
  }
}
