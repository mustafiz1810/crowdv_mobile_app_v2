import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/feature/screen/Organization/home.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_page.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/header_widget.dart';
import 'package:crowdv_mobile_app/widgets/progres_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../widgets/show_toast.dart';
class RoleCheck extends StatefulWidget {
  final dynamic id,token,email,password;
  final String uid;
  RoleCheck({@required this.id,this.token,this.uid,this.email,this.password});
  @override
  State<StatefulWidget> createState() {
    return _RoleCheckState();
  }
}
class Role {
  const Role(this.value,this.text);

  final String value;
  final String text;
}
class _RoleCheckState extends State<RoleCheck> {
  Role selectedUser;
  List<Role> users = <Role>[const Role('volunteer','Volunteer'), const Role('recruiter','Individual Recruiter',),const Role('organization','Organizational Recruiter')];
  final _auth = FirebaseAuth.instance;
  void role(String uid) async {
    try {
      Response response = await post(Uri.parse(
          NetworkConstants.BASE_URL + 'role/${widget.id}/${selectedUser.value}'),
        headers: {
          "Accept": "application/json"
        },
        body: {
          "uid" : uid
        },);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        if(data['data']['role'] != "organization")
        {
          final newUser = await _auth.signInWithEmailAndPassword(email: widget.email.trim(), password: widget.password);
          if (newUser != null) {
            uidRoute(widget.uid);
            pageRoute(widget.token.toString());
            idRoute(data['data']['id']);
            roleRoute(data['data']['role']);
            setState(() {
              isApiCallProcess = false;
            });
            showToast(context, data['message']);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                      id: data['data']['id'],
                      role: data['data']['role'],)),
                    (Route<dynamic> route) => false);}
        }
        else{
          pageRoute(widget.token.toString());
          idRoute(data['data']['id']);
          roleRoute(data['data']['role']);
          setState(() {
            isApiCallProcess = false;
          });
          showToast(context, data['message']);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => OrganizationHome(
                    id: data['data']['id'],
                    role: data['data']['role'],)),
                  (Route<dynamic> route) => false);
        }
      }
      else {
        var data = jsonDecode(response.body.toString());
        showToast(context, data['message']);
        print(data);
        setState(() {
          isApiCallProcess = false;
        });
      }
    } catch (e) {
      setState(() {
        print(e);
        isApiCallProcess = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Exception:"),
              content: Text(e.toString()),
              actions: [
                FlatButton(
                  child: Text("Try Again"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  void pageRoute(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("user", token);
  }
  void idRoute(int id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt("id", id);
  }
  void uidRoute(String uid) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("uid", uid);
  }
  void roleRoute(String role) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("role", role);
  }
  void bannerRoute(List<String> banner) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setStringList("banner", banner);
  }
  bool isApiCallProcess = false;
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _signup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _signup(BuildContext context) {
    double _headerHeight = 270;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderLogo(_headerHeight),
            ),
            SafeArea(
              child: Container(
                margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'You are almost done!',
                            style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                            // textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Select your role to complete your registration.',
                            style: TextStyle(
                                // fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54),
                            // textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Column(
                      children: <Widget>[
                        Container(
                          width: 360,
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(color: Colors.grey, offset: Offset(0, 1), blurRadius: 1.8)
                            ],),
                          child: Center(
                            child:  DropdownButton<Role>(
                              underline: SizedBox(),
                              hint: Center(
                                child: Text(
                                  'Select Role',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              isExpanded: true,
                              value: selectedUser,
                              onChanged: (Role newValue) {
                                setState(() {
                                  selectedUser = newValue;
                                  print(selectedUser.value);
                                });
                              },
                              iconEnabledColor: Colors.black,
                              items: users.map((Role user) {
                                return new DropdownMenuItem<Role>(
                                  value: user,
                                  child: new Text(
                                    user.text,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight:
                                      FontWeight.bold),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Container(
                          decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "submit".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: (){
                              role(widget.uid);

                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
