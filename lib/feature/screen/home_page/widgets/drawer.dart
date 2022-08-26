import 'package:crowdv_mobile_app/feature/screen/home_page/widgets/about_us.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/widgets/chat.dart';
import 'package:crowdv_mobile_app/feature/screen/password/change_pass.dart';
import 'package:crowdv_mobile_app/feature/screen/profile/profile.dart';
import 'package:crowdv_mobile_app/widgets/get_prefs.dart';
import 'package:crowdv_mobile_app/widgets/http_request.dart';
import 'package:flutter/material.dart';
import 'package:crowdv_mobile_app/feature/screen/authentication/sign_in/sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/view_utils/common_util.dart';
import '../../authentication/widgets/terms_condition.dart';

class NavDrawer extends StatefulWidget {
  final dynamic id,
      role,
      fname,
      lname,
      email,
      image,
      disability,
      prof,
      gender,
      state,
      city,
      zip;
  NavDrawer(
      {@required this.id,
      this.role,
      this.fname,
      this.lname,
      this.email,
      this.image,
      this.disability,
      this.prof,
      this.gender,
      this.state,
      this.zip,
      this.city});
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  String token = "";
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: new Text(widget.fname + " " + widget.lname,
                style: TextStyle(color: Colors.black)),
            accountEmail: new Text(
              widget.email,
              style: TextStyle(color: Colors.black),
            ),
            decoration: new BoxDecoration(
              color: Colors.white,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(widget.image),
              backgroundColor: Colors.transparent,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.person_outline_rounded,
              color: Colors.black,
            ),
            title: Text("Profile"),
            onTap: () async {
              getRequest('/api/v1/disability/list', null, {
                'Content-Type': "application/json",
                "Authorization": "Bearer ${token}"
              }).then((value) async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                            data: value["data"],
                            role: widget.role,
                            disability: widget.disability,
                            chosenValue: widget.prof,
                            dropdown: widget.gender,
                            selectedCountry: widget.state,
                            selectedProvince: widget.city,
                            zip: widget.zip,
                          )),
                );
              });
            },
          ),
          token != null
              ? Container()
              : ListTile(
                  leading:
                      Icon(FontAwesomeIcons.signInAlt, color: Colors.black),
                  title: const Text("Sign In"),
                  onTap: () {
                    // Navigator.pushNamed(context, '/categories');
                    Get.to(const LoginPage());
                  }),
          ListTile(
              leading: Icon(Icons.lock_outline_rounded, color: Colors.black),
              title: Text("Change Password"),
              onTap: () {
                Get.to(() => ChangePassword());
              }),
          ListTile(
              leading: Icon(Icons.list_alt_rounded, color: Colors.black),
              title: Text("Terms & Conditions"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TermsCondition()),
                );
              }),
          ListTile(
              leading:
                  Icon(Icons.question_answer_outlined, color: Colors.black),
              title: new Text("FAQ"),
              onTap: () {}),
          ListTile(
              leading: Icon(Icons.info_outline_rounded, color: Colors.black),
              title: Text("About"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUs()),
                );
              }),
          token != null
              ? new ListTile(
                  leading: Icon(Icons.power_settings_new, color: Colors.black),
                  title: new Text("Logout"),
                  onTap: () async {
                    getRequest('/api/v1/logout', null, {
                      'Content-Type': "application/json",
                      "Authorization": "Bearer ${token}"
                    }).then((value) async {
                      final pref = await SharedPreferences.getInstance();
                      await pref.clear();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                      showToast("Logged Out");
                    });
                  },
                )
              : Container(
                  height: 0,
                ),
        ],
      ),
    );
  }
}
