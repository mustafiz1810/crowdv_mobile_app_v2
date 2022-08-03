import 'dart:convert';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:inkwell_splash/inkwell_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Result extends StatefulWidget {
  final List<Map<String, int>> answer;
  final int id;
  final List<String> array;

  Result(this.answer, this.id, this.array);

  @override
  State<Result> createState() => _ResultState();
}

class _ResultState extends State<Result> {
  String token = "";
  bool isVisible = false;
  bool isShow = true;
  String score = "00";
  String remark = "jsadj";
  String name = "jsadj";

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
            // Text(
            //   "Your Answer",
            //   style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            //   textAlign: TextAlign.center,
            // ),
            // ListView.builder(
            //   scrollDirection: Axis.vertical,
            //   shrinkWrap: true,
            //   itemCount: widget.array.length,
            //   itemBuilder: (context, index) {
            //     return ListTile(
            //       title: Card(
            //         child: Container(
            //           width: MediaQuery.of(context).size.width,
            //           height: 50,
            //           child: Center(child: Text(widget.array[index].toString())),
            //         ),
            //       ),
            //     );
            //   },
            // ),
             Visibility(
               visible: isShow,
               child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Click to check your result"),
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
                            child: Text("Check"),
                          ),
                  ],
                ),
            ),
             ),
            SizedBox(
              height: 5,
            ),
            Visibility(
              visible: isVisible,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black12),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        "Your Result",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Divider(
                        height: 10,
                        thickness: 2,
                        color: primaryColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Candidate: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total Score: ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Text(
                            score,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Remark: ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: remark == "failed"
                                      ? Colors.red
                                      : Colors.green,
                                  borderRadius: BorderRadius.circular(20)),
                              width: 100,
                              height: 30,
                              child: Center(
                                child: Text(
                                  remark.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            )
                          ],
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
