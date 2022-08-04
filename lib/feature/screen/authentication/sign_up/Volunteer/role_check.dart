import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_page.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/header_widget.dart';
import 'package:crowdv_mobile_app/widgets/progres_hud.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../widgets/show_toast.dart';

class RoleCheck extends StatefulWidget {
  final dynamic id;
  RoleCheck({@required this.id});
  @override
  State<StatefulWidget> createState() {
    return _RoleCheckState();
  }
}

class _RoleCheckState extends State<RoleCheck> {
  String _dropdown;
  List<String> _item = ["volunteer", "recruiter"];
  int selectedIndex = 0;
  String selectedValue = "";
  void role() async {
    try {
      Response response = await post(Uri.parse(
          NetworkConstants.BASE_URL + 'role/${widget.id}/$_dropdown'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        pageRoute(data['data']['token']);
        setState(() {
          isApiCallProcess = false;
        });
        showToast(context, data['message']);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(id: widget.id, role: _dropdown)),
        );
      } else {
        var data = jsonDecode(response.body.toString());
        showToast(context, data['message']);
        setState(() {
          isApiCallProcess = false;
        });
      }
    } catch (e) {
      setState(() {
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
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: DropdownButton<String>(
                                hint: Center(
                                  child: Text(
                                    'Select Role',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                value: _dropdown,
                                isExpanded: true,
                                // elevation: 5,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                                iconEnabledColor: Colors.white,
                                items: _item.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                selectedItemBuilder: (BuildContext context) =>
                                    _item
                                        .map((e) => Center(
                                              child: Text(
                                                e,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ))
                                        .toList(),
                                underline: Container(),
                                // hint: Text(
                                //   "Please choose a service",
                                //   style: TextStyle(
                                //       fontSize: 18,
                                //       color: Colors.white,
                                //       fontWeight: FontWeight.bold),
                                // ),
                                // icon: Icon(
                                //   Icons.arrow_downward,
                                //   color: Colors.yellow,
                                // ),
                                // isExpanded: true,
                                onChanged: (String value) {
                                  setState(() {
                                    _dropdown = value;
                                  });
                                }),
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
                            onPressed: () {
                              setState(() {
                                isApiCallProcess = true;
                                print(widget.id.toString() +
                                    _dropdown.toString());
                              });
                              role();
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
