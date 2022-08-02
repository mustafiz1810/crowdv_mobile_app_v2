import 'dart:convert';
import 'package:crowdv_mobile_app/data/models/volunteer/exam_model.dart';
import 'package:crowdv_mobile_app/data/models/volunteer/test_model.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/Training/Exam/exam_main.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/http_request.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Test extends StatefulWidget {
  final trainingId;
  const Test({this.trainingId});

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  String token = "";
  @override
  void initState() {
    getCred();
    super.initState();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
    });
  }

  Future<TestModel> getTestApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'test/list/${widget.trainingId}'),
        headers: {"Authorization": "Bearer ${token}"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return TestModel.fromJson(data);
    } else {
      return TestModel.fromJson(data);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Test"),
          backgroundColor: primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                  child: FutureBuilder<TestModel>(
                future: getTestApi(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.data.tests.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            height: MediaQuery.of(context).size.height / 5,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            decoration: BoxDecoration(
                              // image: DecorationImage(
                              //   fit: BoxFit.cover,
                              //   image: AssetImage("assets/undraw_pilates_gpdb.png"),
                              // ),
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: shadowColor.withOpacity(0.4),
                                  spreadRadius: .1,
                                  blurRadius: 2,
                                  // offset: Offset(0, 1), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 35,
                                  width: MediaQuery.of(context).size.width / 1,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: shadowColor.withOpacity(0.2),
                                        spreadRadius: .1,
                                        blurRadius: 3,
                                        // offset: Offset(0, 1), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          snapshot.data.data.tests[index].title,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 4,
                                  height: 10,
                                  color: Colors.white,
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Name:  ',
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                              snapshot
                                                  .data.data.tests[index].title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Total Score : ',
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                                snapshot.data.data.tests[index]
                                                    .totalScore
                                                    .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Passing mark: ',
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                                snapshot.data.data.tests[index]
                                                    .totalScore
                                                    .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14))
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              width: 100,
                                              height: 30,
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 5),
                                              decoration: BoxDecoration(
                                                color: Colors.teal,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              child: Center(
                                                child: InkWell(
                                                  onTap: () async {
                                                    getRequest('/api/v1/question/list/${snapshot.data.data.tests[index].id}', null, {
                                                      'Content-Type': "application/json",
                                                      "Authorization": "Bearer ${token}"
                                                    }).then((value) async {
                                                      showToast(context, value['message']);
                                                      print(snapshot.data.data.tests[index].id);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => ExamPage(data:value["data"]["questions"])),
                                                      );
                                                    });
                                                  },
                                                  child: Container(
                                                    child: Center(
                                                        child: Text('Take Test',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .white))),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Container(
                      alignment: Alignment.center,
                      child: EmptyWidget(
                        image: null,
                        packageImage: PackageImage.Image_1,
                        title: 'Empty',
                        titleTextStyle: TextStyle(
                          fontSize: 22,
                          color: Color(0xff9da9c7),
                          fontWeight: FontWeight.w500,
                        ),
                        subtitleTextStyle: TextStyle(
                          fontSize: 14,
                          color: Color(0xffabb8d6),
                        ),
                      ),
                    );
                  }
                },
              )),
            ],
          ),
        ));
  }
}
