import 'dart:convert';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/certificate.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:inkwell_splash/inkwell_splash.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Result extends StatefulWidget {
  final List<Map<String, int>> answer;
  final int id;

  Result(this.answer, this.id);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  String token = "";
  bool isVisible = false;
  bool isShow = true;
  String score = "";
  String remark = "";
  String name = "";
  String lastName = "";
  String testTitle = "";
  String membership = "";

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

  submit(testId, List<Map<String, int>> answer) async {
    String body = json.encode({'test_id': testId, 'question': answer});
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL +
              'get-participate-to-test/${widget.id}'),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          },
          body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        setState(() {
          score = data['data'][0]['total_score'].toString();
          remark = data['data'][0]['result'].toString();
          name = data['data'][0]['user']['first_name'].toString();
          lastName = data['data'][0]['user']['last_name'].toString();
          testTitle = data['data'][0]['test']['title'].toString();
          membership = data['data'][0]['user']['membership'].toString();
          // name=
          if (isVisible == false) {
            isVisible = true;
          } else
            (isVisible = false);
        });
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => HomeScreen()),
        //         (Route<dynamic> route) => false);
      } else {
        var data = jsonDecode(response.body.toString());
        setState(() {
          Navigator.of(context).pop();
        });
        print(data);
        showToast(context, data['message']);
      }
    } catch (e) {
      setState(() {
        print(e);
      });
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(
              visible: isShow,
              child: Column(
                children: [
                  Text("Test Complete",
                      style: TextStyle(
                          fontSize: 40, fontWeight: FontWeight.bold)),
                  SizedBox(height: 100,),
                  Align(
                    alignment: Alignment.center,
                    child: Lottie.asset(
                      'assets/70295-lottie-completed-animation.json',
                      height: 300,
                      width: 300,
                    ),
                  ),
                  SizedBox(height: 100,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () {
                      submit(widget.id, widget.answer);
                      setState(() {
                        if (isShow == true) {
                          isShow = false;
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("View Result",style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isVisible,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: remark == "failed"
                      ? Column(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Lottie.asset(
                                'assets/58011-stressed-woman-at-work.json',
                                height: 180,
                                width: 180,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              remark.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              name + " " + lastName,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              testTitle,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            Divider(
                              height: 40,
                              thickness: 1,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "100",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "Total Score",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                VerticalDivider(
                                  width: 5,
                                  color: Colors.grey.withOpacity(.5),
                                  thickness: 2,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      score,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "Score",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                VerticalDivider(
                                  width: 5,
                                  color: Colors.grey.withOpacity(.5),
                                  thickness: 2,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      membership,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "Membership",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 80,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                onPrimary: primaryColor,
                                elevation: 6,
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Text(
                                  "Retry",
                                  style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Lottie.asset(
                                'assets/67230-trophy-winner.json',
                                height: 180,
                                width: 180,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              remark.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Text(
                              name + " " + lastName,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              testTitle,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            Divider(
                              height: 40,
                              thickness: 1,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "100",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "Total Score",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                VerticalDivider(
                                  width: 5,
                                  color: Colors.grey.withOpacity(.5),
                                  thickness: 2,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      score,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "Score",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                VerticalDivider(
                                  width: 5,
                                  color: Colors.grey.withOpacity(.5),
                                  thickness: 2,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      membership,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "Membership",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 80,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                onPrimary: primaryColor,
                                elevation: 6,
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                              ),
                              onPressed: () {
                                Get.to(()=>Certificate());
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Text(
                                  "Claim Certificate",
                                  style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
