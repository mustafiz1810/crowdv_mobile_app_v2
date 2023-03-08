import 'dart:convert';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_page.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/view_utils/colors.dart';
import 'show_toast.dart';

class HeaderWidget extends StatefulWidget {
  final dynamic id, role;
  HeaderWidget({this.id, this.role});
  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget>
    with TickerProviderStateMixin {
  bool volunteer = true;
  bool  recruiter = false;
  void rec() async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'role/${widget.id}/volunteer'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        roleRoute(data['data']['role']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(id: widget.id, role: data['data']['role'])),
            (Route<dynamic> route) => false);
        showToast(context, data['message']);
      } else {
        var data = jsonDecode(response.body.toString());
        showToast(context, data['message']);
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Exception:"),
              content: Text(e.toString()),
              actions: [
                TextButton(
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
  void vol() async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'role/${widget.id}/recruiter'));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        roleRoute(data['data']['role']);
        print(data);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(id: widget.id, role: data['data']['role'])),
            (Route<dynamic> route) => false);
        showToast(context, data['message']);
      } else {
        var data = jsonDecode(response.body.toString());
        showToast(context, data['message']);
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Exception:"),
              content: Text(e.toString()),
              actions: [
                TextButton(
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
  void roleRoute(String role) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("role", role);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            widget.role == "organization"
                ? Container(
                    width: 130,
                  )
                : Column(
                    children: [
                      widget.role == 'volunteer'
                          ? LiteRollingSwitch(
                              value: volunteer,
                              iconOn: Icons.accessibility,
                              iconOff: Icons.accessible,
                              colorOff: Color(0xFF508991),
                              colorOn: Colors.blueAccent,
                              onChanged: (val) {
                                volunteer = val;
                              },
                              onTap: () async{
                                SharedPreferences pref = await SharedPreferences.getInstance();
                                await pref.remove("role");
                                vol();
                              },
                              animationDuration: Duration(seconds: 1),
                              textOn: "Volunteer",
                              textOff: "Recruiter",
                            )
                          : LiteRollingSwitch(
                              value: recruiter,
                              iconOn: Icons.accessibility,
                              iconOff: Icons.accessible,
                              colorOff: Color(0xFF508991),
                              colorOn: Colors.blueAccent,
                              onChanged: (val) {
                                recruiter = val;
                              },
                              onTap: () async{
                                SharedPreferences pref = await SharedPreferences.getInstance();
                                await pref.remove("role");
                                rec();
                              },
                              animationDuration: Duration(milliseconds: 1),
                              textOn: "Volunteer",
                              textOff: "Recruiter",
                            ),
                    ],
                  ),

            Column(
              children: [
                Row(children: [
                  const Text(
                    "Crowd",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 35,
                        color: Color(0xFF015D8D)),
                  ),
                  Image.asset('assets/crowdv_png.png', width: 40, height: 50),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
