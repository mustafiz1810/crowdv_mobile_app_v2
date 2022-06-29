import 'dart:async';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_page.dart';
import 'package:crowdv_mobile_app/feature/screen/password/change_pass.dart';
import 'package:crowdv_mobile_app/feature/screen/profile/recruiter_profile.dart';
import 'package:crowdv_mobile_app/feature/screen/profile/volunteer_profile.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/get_prefs.dart';
import 'package:crowdv_mobile_app/widgets/header_without_logo.dart';
import 'package:crowdv_mobile_app/widgets/http_request.dart';
import 'package:flutter/material.dart';
import 'package:crowdv_mobile_app/feature/screen/authentication/sign_in/sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/view_utils/common_util.dart';

class NavDrawer extends StatefulWidget {
  final dynamic id, role;
  NavDrawer({@required this.id, this.role});
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  String token = "";
  String role;
  @override
  void initState() {
    super.initState();
    getCred();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
    });
  }

  // Future<ProfileModel> getProfileApi() async {
  //   final response = await http.get(
  //       Uri.parse(NetworkConstants.BASE_URL + 'user/${widget.id}'),
  //       headers: {"Authorization": "Bearer $token"});
  //   var data = jsonDecode(response.body.toString());
  //   if (response.statusCode == 200) {
  //     return ProfileModel.fromJson(data);
  //   } else {
  //     return ProfileModel.fromJson(data);
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Stack(children: [
            Container(
              height: 210,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: primaryColor,
              ),
            ),
            UserAccountsDrawerHeader(
              accountName: new Text("Mustafizur Rahman"),
              accountEmail: new Text("munna.kodeeo@gmail.com"),
              decoration: new BoxDecoration(
                color: Colors.transparent,
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/avater.png'),
                backgroundColor: Colors.transparent,
              ),
            ),

          ]),
          token != null
              ? Container()
              : ListTile(
                  leading: Icon(FontAwesomeIcons.signInAlt),
                  title: const Text("Sign In"),
                  onTap: () {
                    // Navigator.pushNamed(context, '/categories');
                    Get.to(const LoginPage());
                  }),
          widget.role == 'volunteer'
              ? ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Profile"),
                  onTap: () {
                    Get.to(() => ProfilePage());
                  })
              : ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Profile"),
                  onTap: () {
                    Get.to(() => RecruiterProfile());
                  }),
          ListTile(
              leading: Icon(Icons.password_rounded),
              title: Text("Change Password"),
              onTap: () {
                Get.to(() => ChangePassword());
              }),
          ListTile(
              leading: Icon(Icons.settings),
              title: new Text("Settings"),
              onTap: () {
                Navigator.pop(context);
              }),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text("About"),
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => AboutUs()),
            //   );
            // }
          ),
          const ListTile(
            leading: Icon(Icons.policy),
            title: Text("Policy"),
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => PrivacyPolicy()),
            //   );
            // }
          ),
          token != null
              ? new ListTile(
                  leading: Icon(Icons.power_settings_new),
                  title: new Text("Logout"),
                  onTap: () async {
                    // print(user['token']);
                    // await prefs.clear();
                    // Navigator.pop(context);
                    getRequest('/api/v1/logout', null, {
                      'Content-Type': "application/json",
                      "Authorization": "Bearer ${token}"
                    }).then((value) async {
                      await prefs.clear();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                      showToast("Logged Out");
                    });
                  })
              : Container(
                  height: 0,
                ),
        ],
      ),
    );
  }
}
