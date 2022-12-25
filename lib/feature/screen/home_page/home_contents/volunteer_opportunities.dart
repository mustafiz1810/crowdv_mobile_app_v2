import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/data/models/volunteer/volunteer_opportunity_model.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/widgets/volunteer_task_details.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/http_request.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sweetalert/sweetalert.dart';

class VolunteerMyOpportunity extends StatefulWidget {
  final dynamic role;
  VolunteerMyOpportunity({this.role});
  @override
  State<VolunteerMyOpportunity> createState() => _VolunteerMyOpportunityState();
}

class _VolunteerMyOpportunityState extends State<VolunteerMyOpportunity>
    with TickerProviderStateMixin {
  TextEditingController reviewController = TextEditingController();
  TextEditingController reportController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TabController _tabController;

  String token = "";
  String uid;
  bool isRead;

  @override
  void initState() {
    getCred();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
      uid = pref.getString("uid");
    });
  }

  void rate(int rating, int id) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'volunteer/rating/$id'),
          headers: {
            "Authorization": "Bearer ${token}",
            "Accept": "application/json"
          },
          body: {
            'rating': rating.toString(),
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        showToast(context, data['message']);
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
        showToast(context, data['message']);
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(e.toString()),
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

  void review(String review, int id) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'volunteer/review/$id'),
          headers: {
            "Authorization": "Bearer ${token}"
          },
          body: {
            'remark': review,
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        int count = 0;
        Navigator.popUntil(context, (route) => count++ == 2);
        setState(() {});
        showToast(context, data['message']);
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
        showToast(context, data['error']['errors']);
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(e.toString()),
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

  void report(String report, details, int id) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'volunteer/report/$id'),
          headers: {
            "Authorization": "Bearer ${token}"
          },
          body: {
            'remarks': report,
            'details': details,
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        int count = 0;
        Navigator.popUntil(context, (route) => count++ == 2);
        setState(() {});
        showToast(context, data['message']);
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
        showToast(context, data['message']);
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(e.toString()),
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

  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          // collapsedHeight: 150,
          title: const Text(
            'My Opportunities',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
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
                          title: 'No Opportunities',
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
                        physics: ClampingScrollPhysics(),
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
                                                      VolunteerTaskDetails(
                                                        status:snapshot
                                                            .data
                                                            .data[index]
                                                            .status,
                                                          isRead: isRead,
                                                          role: widget.role,
                                                          id: snapshot
                                                              .data
                                                              .data[index]
                                                              .taskId,
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
                                                width: 230,
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
                                                  snapshot.data.data[index]
                                                      .type !=
                                                      "free"
                                                      ? Row(
                                                    children: [
                                                      Text(
                                                        "Charge : ",
                                                        style: TextStyle(
                                                            fontSize:
                                                            12.0),
                                                      ),
                                                      Text(
                                                          " ${snapshot.data.data[index].charge.toString()} Tk",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .red,
                                                              fontSize:
                                                              12.0)),
                                                    ],
                                                  )
                                                      : Container(),
                                                  Text(
                                                      snapshot.data.data[index]
                                                          .expiredAt,
                                                      style: TextStyle(
                                                          fontSize: 12.0)),
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
                                                ? InkWell(
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
                                                                  '/api/v1/volunteer-request-for-task-done/${snapshot.data.data[index].taskId}',
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
                                                                        "Your task is done",
                                                                    subtitle:
                                                                        "Do you want to rate? ",
                                                                    style: SweetAlertStyle
                                                                        .success,
                                                                    showCancelButton:
                                                                        true,
                                                                    onPress: (bool
                                                                        isConfirm) {
                                                                  if (isConfirm) {
                                                                    if (isConfirm) {
                                                                      showDialog(
                                                                          context:
                                                                              context,
                                                                          barrierDismissible:
                                                                              false,
                                                                          builder:
                                                                              (context) {
                                                                            return Dialog(
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                                                                              child: Container(
                                                                                height: 350,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: BorderRadius.all(
                                                                                    Radius.circular(15),
                                                                                  ),
                                                                                ),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    TabBar(
                                                                                      controller: _tabController,
                                                                                      unselectedLabelColor: Colors.grey,
                                                                                      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color.fromRGBO(142, 142, 142, 1)),
                                                                                      labelColor: Colors.blue,
                                                                                      labelStyle: TextStyle(
                                                                                        fontSize: 16,
                                                                                        fontWeight: FontWeight.w600,
                                                                                      ),
                                                                                      tabs: [
                                                                                        Tab(
                                                                                          child: Text(
                                                                                            "Review",
                                                                                          ),
                                                                                        ),
                                                                                        Tab(
                                                                                          child: Text(
                                                                                            "Report",
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: TabBarView(
                                                                                        controller: _tabController,
                                                                                        children: [
                                                                                          SingleChildScrollView(
                                                                                            child: Padding(
                                                                                              padding: const EdgeInsets.all(8.0),
                                                                                              child: Column(
                                                                                                children: [
                                                                                                  CachedNetworkImage(
                                                                                                      imageUrl: snapshot.data.data[index].recruiter.image,
                                                                                                      imageBuilder: (context, imageProvider) => Container(
                                                                                                            width: 80.0,
                                                                                                            height: 80.0,
                                                                                                            decoration: BoxDecoration(
                                                                                                              shape: BoxShape.circle,
                                                                                                              image: DecorationImage(image: imageProvider, fit: BoxFit.fitHeight),
                                                                                                            ),
                                                                                                          )),
                                                                                                  Text(
                                                                                                    snapshot.data.data[index].recruiter.firstName,
                                                                                                    textAlign: TextAlign.center,
                                                                                                  ),
                                                                                                  Padding(
                                                                                                    padding: const EdgeInsets.all(5.0),
                                                                                                    child: Text(
                                                                                                      'Rate ${snapshot.data.data[index].recruiter.firstName} and tell him what you think.',
                                                                                                      style: TextStyle(fontSize: 16),
                                                                                                    ),
                                                                                                  ),
                                                                                                  RatingBar.builder(
                                                                                                    itemSize: 35,
                                                                                                    minRating: 1,
                                                                                                    direction: Axis.horizontal,
                                                                                                    itemCount: 5,
                                                                                                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                                                                    itemBuilder: (context, _) => Icon(
                                                                                                      Icons.star,
                                                                                                      color: Colors.amber,
                                                                                                    ),
                                                                                                    onRatingUpdate: (rating) {
                                                                                                      rate(rating.toInt(), snapshot.data.data[index].taskId);
                                                                                                    },
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                    height: 10,
                                                                                                  ),
                                                                                                  TextFormField(
                                                                                                      controller: reviewController,
                                                                                                      keyboardType: TextInputType.multiline,
                                                                                                      textInputAction: TextInputAction.done,
                                                                                                      maxLines: null,
                                                                                                      textAlign: TextAlign.center,
                                                                                                      decoration: InputDecoration(
                                                                                                        hintText: "Share your experience",
                                                                                                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.black)),
                                                                                                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.black)),
                                                                                                      )),
                                                                                                  FlatButton(
                                                                                                    child: new Text(
                                                                                                      'Submit',
                                                                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                                    ),
                                                                                                    onPressed: () {
                                                                                                      reviewController.text != '' ? review(reviewController.text.toString(), snapshot.data.data[index].taskId) : Navigator.popUntil(context, (route) => count++ == 2);
                                                                                                      setState(() {});
                                                                                                    },
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                            child: Column(
                                                                                              children: [
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Icon(
                                                                                                      Icons.warning_rounded,
                                                                                                      color: Colors.red,
                                                                                                    ),
                                                                                                    SizedBox(
                                                                                                      width: 5,
                                                                                                    ),
                                                                                                    Text('Report to admin'),
                                                                                                  ],
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 10,
                                                                                                ),
                                                                                                TextFormField(
                                                                                                  textInputAction: TextInputAction.done,
                                                                                                  controller: reportController,
                                                                                                  decoration: ThemeHelper().textInputDecoration('Subject'),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 10,
                                                                                                ),
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                                  children: [
                                                                                                    SizedBox(
                                                                                                      width: 5,
                                                                                                    ),
                                                                                                    Text('Details'),
                                                                                                  ],
                                                                                                ),
                                                                                                TextFormField(
                                                                                                  textInputAction: TextInputAction.done,
                                                                                                  controller: detailsController,
                                                                                                  maxLines: 4,
                                                                                                  decoration: ThemeHelper().textInputDecoration(),
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  height: 10,
                                                                                                ),
                                                                                                FlatButton(
                                                                                                  child: new Text('Submit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                                                                                  onPressed: () {
                                                                                                    reportController.text != '' && detailsController.text != '' ? report(reportController.text.toString(), detailsController.text.toString(), snapshot.data.data[index].taskId) : showToast(context, "write something");
                                                                                                  },
                                                                                                )
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            );
                                                                          });
                                                                    } else {
                                                                      SweetAlert.show(
                                                                          context,
                                                                          subtitle:
                                                                              "Canceled!",
                                                                          style:
                                                                              SweetAlertStyle.error);
                                                                    }
                                                                    return false;
                                                                  }
                                                                  setState(
                                                                      () {});
                                                                  return null;
                                                                });
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
                                                    child: Container(
                                                      width: 160,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6)),
                                                      child: Center(
                                                        child: Text(
                                                            "Mark as complete",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                    ),
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
                                                        color: Colors.grey)),
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
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 30,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                                child: Text(
                                                  snapshot.data.data[index].taskType,
                                                  style: TextStyle(color: Colors.white,fontSize: 15),
                                                )),
                                          ),
                                          SizedBox(height: 5,),
                                          Container(
                                            height: 40,
                                            width: 40,
                                            child:CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: CachedNetworkImage(
                                                imageUrl: snapshot.data.data[index].categoryIcon,
                                                imageBuilder: (context, imageProvider) =>
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                        ),
                                                      ),
                                                    ),
                                                placeholder: (context, url) => Icon(
                                                    Icons.downloading_rounded,
                                                    size: 40,
                                                    color: Colors.grey),
                                                errorWidget: (context, url, error) => Icon(
                                                  Icons.image_outlined,
                                                  size: 40,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ),
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
