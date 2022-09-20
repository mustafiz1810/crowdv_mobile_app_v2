import 'dart:convert';
import 'package:crowdv_mobile_app/data/models/volunteer/training_model.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/Training/training_video_list.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/bottom_nav_bar.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TrainingList extends StatefulWidget {
  @override
  State<TrainingList> createState() => _TrainingListState();
}

class _TrainingListState extends State<TrainingList> {
  String token,role;

  List<String> banner;

  @override
  void initState() {
    getCred();
    super.initState();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
      role = pref.getString("role");
      banner = pref.getStringList("banner");

    });
  }

  Future<TrainingModel> getTrainingApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'training/list'),
        headers: {"Authorization": "Bearer ${token}"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return TrainingModel.fromJson(data);
    } else {
      return TrainingModel.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        // collapsedHeight: 150,
        title: const Text(
          'Training List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      bottomNavigationBar: CustomBottomNavigation(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder<TrainingModel>(
              future: getTrainingApi(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.data.length == 0) {
                    return Container(
                      alignment: Alignment.center,
                      child: EmptyWidget(
                        image: null,
                        packageImage: PackageImage.Image_3,
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
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.1,
                            height: MediaQuery.of(context).size.height / 5,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: shadowColor.withOpacity(0.4),
                                  spreadRadius: .1,
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 5,bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        height: 25,
                                        child: Text(
                                          snapshot.data.data[index].trainingTitle,
                                          style: TextStyle(
                                              color: primaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      IconBox(
                                        child: Icon(
                                          Icons.info,
                                          color: primaryColor,
                                        ),
                                        bgColor: Colors.white,
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Details"),
                                                  content: Text(snapshot
                                                      .data
                                                      .data[index]
                                                      .trainingDescription),
                                                  actions: [
                                                    FlatButton(
                                                      child: Text(
                                                        "ok",
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      color: primaryColor,
                                                    )
                                                  ],
                                                );
                                              });
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 2,
                                  height: 5,
                                  color: primaryColor,
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20, top: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Status:  ',
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              snapshot.data.data[index]
                                                  .trainingStatus,
                                              style: TextStyle(
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              width: 120,
                                              height: 30,
                                              margin:
                                              EdgeInsets.fromLTRB(0, 0, 0, 5),
                                              decoration: BoxDecoration(
                                                color: primaryColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              child: Center(
                                                child: InkWell(
                                                  onTap: () {
                                                    Get.to(() => TrainingVideo(
                                                        id: snapshot
                                                            .data
                                                            .data[index]
                                                            .trainingId));
                                                  },
                                                  child: Container(
                                                    child: Center(
                                                        child: Text('Watch Video',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white))),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return Text('Error'); // error
                } else {
                  return Center(child: CircularProgressIndicator()); // loading
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
