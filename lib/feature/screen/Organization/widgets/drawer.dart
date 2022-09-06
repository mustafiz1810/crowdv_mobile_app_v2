import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/widgets/about_us.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/widgets/faq.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/widgets/settings.dart';
import 'package:crowdv_mobile_app/feature/screen/password/change_pass.dart';
import 'package:crowdv_mobile_app/widgets/http_request.dart';
import 'package:flutter/material.dart';
import 'package:crowdv_mobile_app/feature/screen/authentication/sign_in/sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../utils/view_utils/common_util.dart';
import '../../authentication/widgets/terms_condition.dart';
import '../profile_org.dart';

class OrgDrawer extends StatefulWidget {
  final dynamic id,
      name,
      email,
      phone,
  icon;
  OrgDrawer(
      {@required this.id,
        this.name,
        this.email,
        this.phone,
      this.icon});
  @override
  _OrgDrawerState createState() => _OrgDrawerState();
}

class _OrgDrawerState extends State<OrgDrawer> {
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
            accountName: new Text(
                widget.name,
                style: TextStyle(color: Colors.black)),
            accountEmail: new Text(
              widget.email ,
              style: TextStyle(color: Colors.black),
            ),
            decoration: new BoxDecoration(
              color: Colors.white,
            ),
            currentAccountPicture: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: CachedNetworkImage(
                imageUrl: widget.icon,
                imageBuilder:
                    (context, imageProvider) =>
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: imageProvider,
                        ),
                      ),
                    ),
                placeholder: (context, url) =>
                    Icon(Icons.downloading_rounded,size: 40,),
                errorWidget: (context, url, error)
                => Icon(Icons.image_outlined,size: 40,),
              ),
            )
          ),
          ListTile(
            leading: Icon(
              Icons.person_outline_rounded,
              color: Colors.black,
            ),
            title: Text("Profile"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OrgProfile()),
              );
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
              onTap: () {
                Get.to(() => Faq());
              }),
          ListTile(
              leading: Icon(Icons.settings, color: Colors.black),
              title: new Text("Settings"),
              onTap: () {
                Get.to(() => Settings());
              }),
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
