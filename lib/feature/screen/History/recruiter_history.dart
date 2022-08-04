import 'dart:convert';
import 'package:crowdv_mobile_app/data/models/recruiter/recruiter_history_model.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/widgets/details.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RecruiterHistory extends StatefulWidget {
  @override
  _RecruiterHistoryState createState() => _RecruiterHistoryState();
}

class _RecruiterHistoryState extends State<RecruiterHistory> {
  TextEditingController reviewController = TextEditingController();
  String token = "";

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

  void review(String review, int id) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'recruiter/review/$id'),
          headers: {
            "Authorization": "Bearer ${token}"
          },
          body: {
            'remark': review,
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // print(data);
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

  void rate(String rating, int id) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'recruiter/rating/$id'),
          headers: {
            "Authorization": "Bearer ${token}"
          },
          body: {
            'rating': rating,
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
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

  Future<RecruiterHistoryModel> getRHistoryApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'opportunity/history'),
        headers: {"Authorization": "Bearer ${token}"});
    var data = jsonDecode(response.body.toString());
    print(data.toString());
    showToast(context, data['message']);
    if (response.statusCode == 200) {
      return RecruiterHistoryModel.fromJson(data);
    } else {
      return RecruiterHistoryModel.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('History'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                  child: FutureBuilder<RecruiterHistoryModel>(
                future: getRHistoryApi(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 10, right: 10),
                          child: Container(
                            width: 350,
                            height: 240,
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
                            child: Stack(
                              children: [
                                // --------------------------------------------Body
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20, top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            snapshot.data.data[index].title,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Get.to(() => OpportunityDetails(
                                                  role: snapshot
                                                      .data
                                                      .data[index]
                                                      .recruiter
                                                      .role,
                                                  id: snapshot
                                                      .data.data[index].id,
                                                  token: token));
                                            },
                                            child: Container(
                                              width: 80,
                                              height: 35,
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 5),
                                              decoration: BoxDecoration(
                                                color: primaryColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              child: Center(
                                                  child: Text('Details',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color:
                                                              Colors.white))),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1,
                                      height: 5,
                                      color: primaryColor,
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20, top: 5),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Location : ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                Text(
                                                    snapshot.data.data[index]
                                                            .city +
                                                        ", " +
                                                        snapshot.data
                                                            .data[index].state,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Job Type: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                Text(
                                                    snapshot.data.data[index]
                                                        .taskType,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Your Rating: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                Text(
                                                    snapshot
                                                                .data
                                                                .data[index]
                                                                .recruiter
                                                                .rating
                                                                .toString() !=
                                                            null
                                                        ? snapshot
                                                            .data
                                                            .data[index]
                                                            .recruiter
                                                            .rating
                                                            .toString()
                                                        : "",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14))
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Your Review: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                Text(
                                                    snapshot
                                                                .data
                                                                .data[index]
                                                                .recruiter
                                                                .review !=
                                                            null
                                                        ? snapshot
                                                            .data
                                                            .data[index]
                                                            .recruiter
                                                            .review
                                                        : "",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14))
                                              ],
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                // -------------------------------------------------Card
                                Positioned(
                                    top: 160,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        height: 70,
                                        width: 342,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  shadowColor.withOpacity(0.2),
                                              spreadRadius: .1,
                                              blurRadius: 3,
                                              // offset: Offset(0, 1), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                                // ----------------------------------------------------review
                                Positioned(
                                    right: 20,
                                    top: 180,
                                    child: Row(
                                      children: [
                                        IconBox(
                                          child: Icon(
                                            Icons.rate_review_rounded,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                          bgColor: Colors.teal,
                                          onTap: () {
                                            return showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Row(
                                                      children: [
                                                        Text(
                                                            'Give a review to the user'),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Icon(Icons.create),
                                                      ],
                                                    ),
                                                    content: TextFormField(
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      controller:
                                                          reviewController,
                                                      maxLines: 4,
                                                      maxLength: 100,
                                                      decoration:
                                                          InputDecoration(
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                              enabledBorder:
                                                                  UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .white),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.0),
                                                              ),
                                                              filled: true,
                                                              hintStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16,
                                                              ),
                                                              hintText: snapshot
                                                                  .data
                                                                  .data[index]
                                                                  .volunteer
                                                                  .review,
                                                              fillColor: Colors
                                                                  .grey
                                                                  .shade200),
                                                    ),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        child:
                                                            new Text('Cancel'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                      FlatButton(
                                                        child:
                                                            new Text('Submit'),
                                                        onPressed: () {
                                                          review(
                                                              reviewController
                                                                  .text
                                                                  .toString(),
                                                              snapshot
                                                                  .data
                                                                  .data[index]
                                                                  .id);
                                                        },
                                                      )
                                                    ],
                                                  );
                                                });
                                          },
                                        ),
                                        // SizedBox(
                                        //   width: 5,
                                        // ),
                                        // IconBox(
                                        //   child: Icon(
                                        //     Icons.report,
                                        //     color: Colors.white,
                                        //     size: 20,
                                        //   ),
                                        //   onTap: (){
                                        //     displayDialog(context);
                                        //   },
                                        //   bgColor: Colors.redAccent,
                                        // ),
                                      ],
                                    )),
                                // ---------------------------------------------------Rating
                                Positioned(
                                    left: 10,
                                    top: 170,
                                    child: Row(
                                      children: [
                                        // Column(
                                        //   children: [
                                        //     CircleAvatar(
                                        //       backgroundImage: NetworkImage(
                                        //           snapshot.data.data[index]
                                        //               .volunteer.image),
                                        //       radius: 25,
                                        //     ),
                                        //   ],
                                        // ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data.data[index]
                                                      .volunteer.firstName +
                                                  " " +
                                                  snapshot.data.data[index]
                                                      .volunteer.lastName,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                RatingBar.builder(
                                                  itemSize: 20,
                                                  initialRating: snapshot
                                                              .data
                                                              .data[index]
                                                              .volunteer
                                                              .rating ==
                                                          null
                                                      ? 0
                                                      : snapshot
                                                          .data
                                                          .data[index]
                                                          .volunteer
                                                          .rating
                                                          .toDouble(),
                                                  minRating: 1,
                                                  direction: Axis.horizontal,
                                                  itemCount: 5,
                                                  itemPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 4.0),
                                                  itemBuilder: (context, _) =>
                                                      Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                                  onRatingUpdate: (rating) {
                                                    rate(
                                                        rating.toString(),
                                                        snapshot.data
                                                            .data[index].id);
                                                  },
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
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
                        packageImage: PackageImage.Image_3,
                        title: 'Empty',
                        subTitle: 'No history available',
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
