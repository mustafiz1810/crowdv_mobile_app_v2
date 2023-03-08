import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowdv_mobile_app/feature/screen/Subscription/basic_page.dart';
import 'package:crowdv_mobile_app/feature/screen/Subscription/premium_page.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/widgets/about_us.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/widgets/faq.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/widgets/settings.dart';
import 'package:crowdv_mobile_app/feature/screen/password/change_pass.dart';
import 'package:crowdv_mobile_app/feature/screen/profile/profile.dart';
import 'package:crowdv_mobile_app/widgets/http_request.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:crowdv_mobile_app/feature/screen/authentication/sign_in/signin.dart';
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
      country,
      state,
      city,
      zip;
  NavDrawer({
    @required this.id,
    this.role,
    this.fname,
    this.lname,
    this.email,
    this.image,
    this.disability,
    this.prof,
    this.gender,
    this.country,
    this.state,
    this.zip,
    this.city,
  });
  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  String token = "";
  final _auth = FirebaseAuth.instance;
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
                widget.fname != null
                    ? widget.fname
                    : widget.fname + " " + widget.lname != null
                        ? widget.lname
                        : "",
                style: TextStyle(color: Colors.black)),
            accountEmail: new Text(
              widget.email != null ? widget.email : widget.email,
              style: TextStyle(color: Colors.black),
            ),
            decoration: new BoxDecoration(
              color: Colors.white,
            ),
            currentAccountPicture: CachedNetworkImage(
              imageUrl: widget.image,
              imageBuilder: (context, imageProvider) => Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: imageProvider, fit: BoxFit.fitHeight),
                ),
              ),
              placeholder: (context, url) => Icon(Icons.downloading_rounded,
                  size: 30, color: Colors.grey),
              errorWidget: (context, url, error) => Icon(
                Icons.image_outlined,
                size: 30,
                color: Colors.grey,
              ),
            ),
            // Stack(children: [
            //   CachedNetworkImage(
            //     imageUrl: widget.image,
            //     imageBuilder: (context, imageProvider) => Container(
            //       width: 150.0,
            //       height: 150.0,
            //       decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         image: DecorationImage(
            //             image: imageProvider, fit: BoxFit.fitHeight),
            //       ),
            //     ),
            //     placeholder: (context, url) => Icon(Icons.downloading_rounded,
            //         size: 30, color: Colors.grey),
            //     errorWidget: (context, url, error) => Icon(
            //       Icons.image_outlined,
            //       size: 30,
            //       color: Colors.grey,
            //     ),
            //   ),
            //   Container(
            //     decoration: BoxDecoration(
            //         color: Colors.transparent,
            //         border: Border.all(color: Colors.lightBlueAccent, width: 4),
            //         borderRadius: BorderRadius.circular(100)),
            //   ),
            //   Positioned(
            //       bottom: 38,
            //       left: 40,
            //       child: Image.asset(
            //         "assets/premium.png",
            //         height: 40,
            //         width: 40,
            //       ))
            // ]),
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
                print(widget.disability);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                            data: value["data"],
                            role: widget.role,
                            disability: widget.disability,
                            chosenValue: widget.prof,
                            dropdown: widget.gender,
                            country: widget.country,
                            state: widget.state,
                            city: widget.city,
                            zip: widget.zip,
                          )),
                ).then((value) =>
                    setState(
                            () {

                            }));
                setState(() {});
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
          // ListTile(
          //     leading: Icon(Icons.workspace_premium, color: Colors.black),
          //     title: Text("Subscription "),
          //     onTap: () {
          //       Get.to(() => BasicPage());
          //     }),
          // ListTile(
          //     leading: Icon(Icons.workspace_premium, color: Colors.black),
          //     title: Text("Subscription premium"),
          //     onTap: () {
          //       Get.to(() => PremiumPage());
          //     }),
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
              title: new Text("FAQ'S"),
              onTap: () {
                Get.to(() => Faq());
              }),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.black),
            title: new Text("Settings"),
            onTap: () async {
              getRequest('/api/v1/profile', null, {
                'Content-Type': "application/json",
                "Authorization": "Bearer ${token}"
              }).then((value) async {
                print(value['data']['is_email_notification']);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Settings(
                            smsNotify: value['data']['is_sms_notification'],
                            emailNotify: value['data']['is_email_notification'],
                            appNotify: value['data']
                                ['is_database_notification'],
                          )),
                );
              });
            },
          ),
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
                      _auth.signOut();
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
