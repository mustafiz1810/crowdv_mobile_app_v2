import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdv_mobile_app/data/models/volunteer/volunteer_opportunity_model.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/widgets/details.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/widgets/chat.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/http_request.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sweetalert/sweetalert.dart';

class VolunteerMyOpportunity extends StatefulWidget {
  final dynamic role;
  VolunteerMyOpportunity({this.role});
  @override
  State<VolunteerMyOpportunity> createState() => _VolunteerMyOpportunityState();
}

class _VolunteerMyOpportunityState extends State<VolunteerMyOpportunity> {
  final CustomTimerController _controller = CustomTimerController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return to.difference(from).inDays;
  }

  String token = "";
  String uid;
  bool isRead;

  @override
  void initState() {
    getCred();
    super.initState();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
      uid = pref.getString("uid");
    });
  }

  Future<VolunteerOpportunityModel> getVOpportunityApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'volunteer/own/tasks'),
        headers: {"Authorization": "Bearer ${token}"});
    var data = jsonDecode(response.body.toString());
    print(data);
    if (response.statusCode == 200) {
      return VolunteerOpportunityModel.fromJson(data);
    } else {
      return VolunteerOpportunityModel.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          // collapsedHeight: 150,
          title: const Text(
            'My Opportunity',
            style: TextStyle(color: Colors.white),
          ),
          // ),
          // centerTitle: true,
          backgroundColor: primaryColor,
          // pinned: true,
          // floating: true,
          // forceElevated: innerBoxIsScrolled,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                  child: FutureBuilder<VolunteerOpportunityModel>(
                future: getVOpportunityApi(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data.data.length == 0) {
                      return Container(
                        alignment: Alignment.center,
                        child: EmptyWidget(
                          image: null,
                          packageImage: PackageImage.Image_3,
                          title: 'No Opportunity',
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
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 3.3,
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                    color: shadowColor.withOpacity(0.4),
                                    spreadRadius: -1,
                                    blurRadius: 4,
                                    // offset: Offset(0, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc(snapshot
                                              .data.data[index].recruiter.uid)
                                          .collection('messages')
                                          .snapshots(),
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          return ListView.builder(
                                              itemCount:
                                                  snapshot.data.docs.length,
                                              itemBuilder: (context, index) {
                                                isRead = snapshot.data
                                                    .docs[index]['is_read'];
                                                print(isRead);
                                                return Center();
                                              });
                                        }
                                        return Center();
                                      }),
                                  Padding(
                                    padding: const EdgeInsets.all(23.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OpportunityDetails(
                                                        isRead:isRead,
                                                          role: widget.role,
                                                          id: snapshot
                                                              .data
                                                              .data[index]
                                                              .taskId,
                                                          token: token,
                                                          uid: uid,
                                                          friendId: snapshot
                                                              .data
                                                              .data[index]
                                                              .recruiter
                                                              .uid,
                                                          friendName: snapshot
                                                              .data
                                                              .data[index]
                                                              .recruiter
                                                              .firstName,
                                                          friendImage: snapshot
                                                              .data
                                                              .data[index]
                                                              .recruiter
                                                              .image,
                                                          isOnline: snapshot
                                                              .data
                                                              .data[index]
                                                              .recruiter
                                                              .isOnline)),
                                            ).then((value) => setState(() {}));
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 260,
                                                child: Text(
                                                  snapshot
                                                      .data.data[index].title,
                                                  style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              SizedBox(
                                                width: 200,
                                                height: 50,
                                                child: Text(
                                                  snapshot
                                                      .data.data[index].details,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 25,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .location_on_rounded,
                                                        color:
                                                            Colors.blueAccent,
                                                        size: 20,
                                                      ),
                                                      Text(
                                                        snapshot
                                                                    .data
                                                                    .data[index]
                                                                    .city !=
                                                                null
                                                            ? snapshot
                                                                .data
                                                                .data[index]
                                                                .city
                                                            : "",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors
                                                                .blueAccent,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                      snapshot.data.data[index]
                                                          .expiredAt,
                                                      style: TextStyle(
                                                          fontSize: 12.0)),
                                                  // Column(
                                                  //   children: [
                                                  //     Text(
                                                  //         "Expired in (D:H:M)",
                                                  //         style: TextStyle(fontSize: 12.0)),
                                                  //     CustomTimer(
                                                  //         controller: _controller,
                                                  //         from: Duration(days: 5-DateTime.now().day,
                                                  //             hours:5-DateTime.now().hour,
                                                  //             minutes: 5-DateTime.now().minute),
                                                  //         to: Duration(),
                                                  //         onBuildAction: CustomTimerAction.auto_start,
                                                  //         builder: (remaining) {
                                                  //           return Text(
                                                  //               "${remaining.days+" "}:${" "+remaining.hours+" "}:${" "+remaining.minutes+" "}",
                                                  //               style: TextStyle(fontSize: 12.0));
                                                  //         }),
                                                  //   ],
                                                  // ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          height: 5,
                                          color: Colors.grey.withOpacity(.5),
                                          thickness: 1,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            snapshot.data.data[index].status ==
                                                    "hired"
                                                ? IconBox(
                                                    onTap: () {
                                                      SweetAlert.show(context,
                                                          subtitle:
                                                              "Are you sure?",
                                                          style: SweetAlertStyle
                                                              .confirm,
                                                          showCancelButton:
                                                              true,
                                                          onPress:
                                                              (bool isConfirm) {
                                                        if (isConfirm) {
                                                          //Return false to keep dialog
                                                          if (isConfirm) {
                                                            // SweetAlert.show(context,
                                                            //     subtitle:
                                                            //         "Deleting...",
                                                            //     style:
                                                            //         SweetAlertStyle
                                                            //             .loading);
                                                            new Future.delayed(
                                                                new Duration(
                                                                    seconds: 1),
                                                                () {
                                                              getRequestWithoutParam(
                                                                  '/api/v1/volunteer-request-for-task-complete/${snapshot.data.data[index].taskId}',
                                                                  {
                                                                    'Content-Type':
                                                                        "application/json",
                                                                    "Authorization":
                                                                        "Bearer ${token}"
                                                                  }).then(
                                                                  (value) async {
                                                                SweetAlert.show(
                                                                    context,
                                                                    title:
                                                                        "Your Task is completed",
                                                                    subtitle:
                                                                        "Please go to History ",
                                                                    style: SweetAlertStyle
                                                                        .success,
                                                                    onPress: (bool
                                                                        isConfirm) {
                                                                  if (isConfirm) {
                                                                    // return false to keep dialog
                                                                  }
                                                                  return null;
                                                                });
                                                                setState(() {});
                                                              });
                                                            });
                                                          } else {
                                                            SweetAlert.show(
                                                                context,
                                                                subtitle:
                                                                    "Canceled!",
                                                                style:
                                                                    SweetAlertStyle
                                                                        .error);
                                                          }
                                                          return false;
                                                        }
                                                        return null;
                                                      });
                                                    },
                                                    child: Icon(
                                                        Icons.check_circle,
                                                        color: Colors.green),
                                                    bgColor: Colors.white,
                                                    borderColor: Colors.black12,
                                                  )
                                                : Container(),
                                            Container(
                                              width: 80,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              child: Center(
                                                child: Text(
                                                    snapshot
                                                        .data.data[index].status
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                        color:
                                                            Colors.deepOrange)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      top: 20,
                                      right: 20,
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        child: IconBox(
                                          child: Image.network(snapshot
                                              .data.data[index].categoryIcon),
                                          bgColor: Colors.white,
                                        ),
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
                    return Center(
                        child: CircularProgressIndicator()); // loading
                  }
                },
              )),
            ],
          ),
        ));
  }
}
