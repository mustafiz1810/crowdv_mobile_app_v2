import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/data/models/volunteer/history_model.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/widgets/recruiter_task_details.dart';
import 'package:crowdv_mobile_app/feature/screen/profile/common_profile.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/bottom_nav_bar.dart';
import 'package:crowdv_mobile_app/widgets/http_request.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../home_page/home_contents/widgets/volunteer_task_details.dart';

class VolunteerHistory extends StatefulWidget {
  @override
  _VolunteerHistoryState createState() => _VolunteerHistoryState();
}

class _VolunteerHistoryState extends State<VolunteerHistory> {
  TextEditingController reviewController = TextEditingController();
  TextEditingController reportController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  String token = "";
  String role = "";

  @override
  void initState() {
    super.initState();
    getCred();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
      role = pref.getString("role");
    });
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
        Navigator.of(context).pop();
        showToast(context, data['message']);
      } else {
        var data = jsonDecode(response.body.toString());
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
        Navigator.of(context).pop();
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

  Future<VolunteerHistoryModel> getVHistoryApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'volunteer/task/history'),
        headers: {"Authorization": "Bearer ${token}"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return VolunteerHistoryModel.fromJson(data);
    } else {
      return VolunteerHistoryModel.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('My History'),
        ),
        bottomNavigationBar: CustomBottomNavigation(),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                  child: FutureBuilder<VolunteerHistoryModel>(
                future: getVHistoryApi(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data.data.length == 0) {
                      return Container(
                        alignment: Alignment.center,
                        child: EmptyWidget(
                          image: null,
                          packageImage: PackageImage.Image_1,
                          title: 'Empty',
                          subTitle: 'No  History available',
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
                                    // offset: Offset(0, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
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
                                                          role: snapshot
                                                              .data
                                                              .data[index]
                                                              .volunteer
                                                              .role,
                                                          id: snapshot.data
                                                              .data[index].id,)),
                                            );
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data.data[index].title,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                      height: 50,
                                                      child: Text("Review:  ")),
                                                  SizedBox(
                                                      width: 200,
                                                      height: 50,
                                                      child: Text(
                                                          snapshot
                                                                      .data
                                                                      .data[
                                                                          index]
                                                                      .volunteer
                                                                      .review !=
                                                                  null
                                                              ? snapshot
                                                                  .data
                                                                  .data[index]
                                                                  .volunteer
                                                                  .review
                                                              : "none",
                                                          style: TextStyle(
                                                              fontSize: 14))),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
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
                                                                    .city.name.toString(),
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

                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Divider(
                                                height: 5,
                                                color:
                                                    Colors.grey.withOpacity(.5),
                                                thickness: 1,
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    InkWell(
                                                        child: CachedNetworkImage(
                                                          imageUrl:
                                                          snapshot.data.data[index].recruiter.image,
                                                          imageBuilder: (context, imageProvider) =>
                                                              Container(
                                                                width: 40.0,
                                                                height: 40.0,
                                                                decoration: BoxDecoration(
                                                                  shape: BoxShape.circle,
                                                                  image: DecorationImage(
                                                                      image: imageProvider, fit: BoxFit.cover),
                                                                ),
                                                              ),
                                                          placeholder: (context, url) => Icon(Icons.downloading_rounded,
                                                              size: 40,
                                                              color: Colors.grey),
                                                          errorWidget: (context, url, error) =>
                                                              Icon(
                                                                Icons.image_outlined,
                                                                size: 40,
                                                                color: Colors.grey,
                                                              ),
                                                        ),
                                                        onTap: () {
                                                          Get.to(() =>
                                                              CommonProfile(
                                                                id: snapshot
                                                                    .data
                                                                    .data[index]
                                                                    .recruiter
                                                                    .id,
                                                              ));
                                                        }),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SizedBox(width: 5,),
                                                        Text(
                                                          snapshot
                                                                  .data
                                                                  .data[index]
                                                                  .recruiter
                                                                  .firstName.toString() + " " + snapshot
                                                                  .data
                                                                  .data[index]
                                                                  .recruiter
                                                                  .lastName.toString(),
                                                          maxLines: 1,
                                                          overflow:
                                                              TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    RatingBar.builder(
                                                      itemSize: 25,
                                                      initialRating: snapshot
                                                          .data
                                                          .data[
                                                      index]
                                                          .recruiter
                                                          .rating ==
                                                          null
                                                          ? 0
                                                          : snapshot
                                                          .data
                                                          .data[index]
                                                          .recruiter
                                                          .rating
                                                          .toDouble(),
                                                      minRating: 1,
                                                      direction:
                                                      Axis.horizontal,
                                                      itemCount: 5,
                                                      itemPadding: EdgeInsets
                                                          .symmetric(
                                                          horizontal:
                                                          4.0),
                                                      itemBuilder:
                                                          (context, _) =>
                                                          Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                          ),
                                                      onRatingUpdate:
                                                          (rating) {
                                                        rate(
                                                            rating.toInt(),
                                                            snapshot
                                                                .data
                                                                .data[index]
                                                                .id);
                                                      },
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                IconBox(
                                                  child: Icon(
                                                    Icons.rate_review_rounded,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                  bgColor: Colors.teal,
                                                  onTap: () async {
                                                    getRequest('/api/v1/get-review-report/${snapshot.data.data[index].id}', null, {
                                                      'Content-Type': "application/json",
                                                      "Authorization": "Bearer ${token}"
                                                    }).then((value) async {
                                                        reviewController.text = value["data"]["review"];
                                                      return showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Row(
                                                                children: [
                                                                  Text(
                                                                      'Give a review to the user'),
                                                                ],
                                                              ),
                                                              content:
                                                              TextFormField(
                                                                textInputAction:
                                                                TextInputAction
                                                                    .done,
                                                                controller:
                                                                reviewController,
                                                                maxLines: 4,
                                                                maxLength: 100,
                                                                decoration:
                                                                InputDecoration(
                                                                  focusedBorder:
                                                                  OutlineInputBorder(
                                                                    borderSide:
                                                                    BorderSide(color: Colors.white),
                                                                    borderRadius:
                                                                    BorderRadius.circular(10.0),
                                                                  ),
                                                                  enabledBorder:
                                                                  UnderlineInputBorder(
                                                                    borderSide:
                                                                    BorderSide(color: Colors.white),
                                                                    borderRadius:
                                                                    BorderRadius.circular(10.0),
                                                                  ),
                                                                  filled:
                                                                  true,
                                                                  hintStyle:
                                                                  TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                    16,
                                                                  ),
                                                                ),
                                                              ),
                                                              actions: <Widget>[
                                                                FlatButton(
                                                                  child: new Text(
                                                                      'Cancel'),
                                                                  onPressed: () {
                                                                    Navigator.of(
                                                                        context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                                FlatButton(
                                                                  child: new Text(
                                                                      'Submit'),
                                                                  onPressed: () {
                                                                    reviewController.text != ''?review(
                                                                        reviewController
                                                                            .text
                                                                            .toString(),
                                                                        snapshot
                                                                            .data
                                                                            .data[
                                                                        index]
                                                                            .id):showToast(context, "write something");
                                                                  },
                                                                )
                                                              ],
                                                            );
                                                          });
                                                    });
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                IconBox(
                                                  child: Icon(
                                                    Icons.report,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                  onTap: () async {
                                                    getRequest('/api/v1/get-review-report/${snapshot.data.data[index].id}', null, {
                                                      'Content-Type': "application/json",
                                                      "Authorization": "Bearer ${token}"
                                                    }).then((value) async {
                                                      reportController.text = value["data"]["report"] != null?value["data"]["report"]["remarks"]:"";
                                                      detailsController.text = value["data"]["report"] != null?value["data"]["report"]["details"]:"";
                                                      return showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: Row(
                                                                children: [
                                                                  Text(
                                                                      'Report to admin'),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .warning_rounded,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                ],
                                                              ),
                                                              content: Container(
                                                                height: 200,
                                                                child: Column(
                                                                  children: [
                                                                    TextFormField(
                                                                      textInputAction:
                                                                      TextInputAction
                                                                          .done,
                                                                      controller:
                                                                      reportController,
                                                                      decoration:
                                                                      ThemeHelper()
                                                                          .textInputDecoration('Subject'),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    TextFormField(
                                                                      textInputAction:
                                                                      TextInputAction
                                                                          .done,
                                                                      controller:
                                                                      detailsController,
                                                                      maxLines: 3,
                                                                      maxLength:
                                                                      100,
                                                                      decoration:
                                                                      InputDecoration(
                                                                        focusedBorder:
                                                                        OutlineInputBorder(
                                                                          borderSide:
                                                                          BorderSide(color: Colors.white),
                                                                          borderRadius:
                                                                          BorderRadius.circular(10.0),
                                                                        ),
                                                                        enabledBorder:
                                                                        UnderlineInputBorder(
                                                                          borderSide:
                                                                          BorderSide(color: Colors.white),
                                                                          borderRadius:
                                                                          BorderRadius.circular(10.0),
                                                                        ),
                                                                        filled:
                                                                        true,
                                                                        hintStyle:
                                                                        TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontSize:
                                                                          16,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              actions: <Widget>[
                                                                FlatButton(
                                                                  child: new Text(
                                                                      'Cancel'),
                                                                  onPressed: () {
                                                                    Navigator.of(
                                                                        context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                                FlatButton(
                                                                  child: new Text(
                                                                      'Submit'),
                                                                  onPressed: () {
                                                                    reportController.text != '' && detailsController.text != ''? report(
                                                                        reportController
                                                                            .text
                                                                            .toString(),
                                                                        detailsController
                                                                            .text
                                                                            .toString(),
                                                                        snapshot
                                                                            .data
                                                                            .data[
                                                                        index]
                                                                            .id):showToast(context, "write something");
                                                                  },
                                                                )
                                                              ],
                                                            );
                                                          });
                                                    });
                                                  },
                                                  bgColor: Colors.redAccent,
                                                ),
                                              ],
                                            )
                                          ],
                                        )
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
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  snapshot
                                                      .data
                                                      .data[index]
                                                      .volunteer
                                                      .rating
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 14)),
                                              Icon(
                                                   Icons.star,
                                                color: Colors.amber,
                                                size: 16,
                                              )
                                            ],
                                          ),
                                          bgColor: Colors.white,
                                        ),
                                      ))
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
