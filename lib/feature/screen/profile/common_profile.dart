import 'dart:convert';
import 'package:crowdv_mobile_app/data/models/common_profile_model.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CommonProfile extends StatefulWidget {
  final id;
  CommonProfile({
    this.id,
  });
  @override
  State<StatefulWidget> createState() {
    return _CommonProfileState();
  }
}

class _CommonProfileState extends State<CommonProfile> {
  String token = "";

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

  Future<CommonProfileModel> getCommonProfileApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'user-profile/${widget.id}'),
        headers: {"Authorization": "Bearer $token"});
    var data = jsonDecode(response.body.toString());
    print(data);
    if (response.statusCode == 200) {
      return CommonProfileModel.fromJson(data);
    } else {
      return CommonProfileModel.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile Page",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          elevation: 0.5,
          iconTheme: IconThemeData(color: Colors.black),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
        body: FutureBuilder<CommonProfileModel>(
          future: getCommonProfileApi(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: [
                        Stack(children: [
                          Container(
                            height: 95,
                            child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              backgroundImage:
                                  NetworkImage(snapshot.data.data.image),
                              radius: 46,
                            ),
                          ),
                          Positioned(
                              top: 49,
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                backgroundImage: NetworkImage(
                                    snapshot.data.data.membership.icon),
                                radius: 22,
                              ))
                        ]),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Text(
                                  snapshot.data.data.firstName.toString() +
                                      " " +
                                      snapshot.data.data.lastName.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Colors.black),
                                ),
                                snapshot.data.data.isOnline == true
                                    ? Icon(
                                        Icons.fiber_manual_record_rounded,
                                        size: 12,
                                        color: Colors.green,
                                      )
                                    : Icon(
                                        Icons.fiber_manual_record_rounded,
                                        size: 12,
                                        color: Colors.grey,
                                      ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 13,
                            ),
                            Text(
                              snapshot.data.data.state.name.toString(),
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  snapshot.data.data.opportunities.toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Text(
                                  "Opportunity",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      snapshot.data.data.rating.toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    )
                                  ],
                                ),
                                Text(
                                  "Rating",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(snapshot.data.data.workingHours.toString(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                Text("Working Hour",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black)),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 10,
                    color: Colors.black,
                  ),
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: TabBar(
                              tabs: [
                                Tab(child: const Text('Basic Info')),
                                Tab(child: const Text('Review')),
                              ],
                              indicatorSize: TabBarIndicatorSize.label,
                              indicatorColor: Colors.teal,
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.black38,
                            ),
                          ),
                          SliverFillRemaining(
                            child: Column(
                              children: [
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.only(left: 5, right: 5),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: <Widget>[
                                              ...ListTile.divideTiles(
                                                color: Colors.grey,
                                                tiles: [
                                                  ListTile(
                                                    leading: Icon(Icons
                                                        .person_outline_rounded),
                                                    title: Text("Name:"),
                                                    subtitle: Text(
                                                      snapshot.data.data
                                                              .firstName
                                                              .toString() +
                                                          " " +
                                                          snapshot.data.data
                                                              .lastName,
                                                    ),
                                                  ),
                                                  ListTile(
                                                      leading: Icon(Icons
                                                          .work_outline_rounded),
                                                      title:
                                                          Text("Profession:"),
                                                      subtitle: Text(snapshot
                                                                  .data
                                                                  .data
                                                                  .profession !=
                                                              null
                                                          ? snapshot.data.data
                                                              .profession
                                                          : "")),
                                                  ListTile(
                                                      leading: Icon(Icons.male),
                                                      title: Text("Gender:"),
                                                      subtitle: Text(snapshot
                                                                  .data
                                                                  .data
                                                                  .gender !=
                                                              null
                                                          ? snapshot
                                                              .data.data.gender
                                                          : "")),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 15, right: 15, top: 10),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  snapshot.data.data.rating
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    RatingBar.builder(
                                                      itemSize: 25,
                                                      initialRating: snapshot
                                                                  .data
                                                                  .data
                                                                  .rating ==
                                                              null
                                                          ? 0
                                                          : snapshot
                                                              .data.data.rating
                                                              .toDouble(),
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      itemCount: 5,
                                                      ignoreGestures: true,
                                                      tapOnlyMode: true,
                                                      itemPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 4.0),
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      onRatingUpdate:
                                                          (rating) {},
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "   From ${snapshot.data.data.reviews.length.toString()} people",
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount: snapshot
                                                    .data.data.reviews.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5),
                                                              spreadRadius: -1,
                                                              blurRadius: 3,
                                                              offset: Offset(-1,
                                                                  0), // changes position of shadow
                                                            ),
                                                          ],
                                                        ),
                                                        child: ListTile(
                                                          leading: CircleAvatar(
                                                            backgroundImage:
                                                            NetworkImage(
                                                                snapshot
                                                                    .data
                                                                    .data
                                                                    .reviews[
                                                                index]
                                                                    .reviewFrom
                                                                    .image),
                                                            radius: 20,
                                                          ),
                                                          title: Padding(
                                                            padding: const EdgeInsets.only(top: 10.0,bottom: 8.0),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width:130,
                                                                    child: Text(snapshot
                                                                        .data
                                                                        .data
                                                                        .reviews[index]
                                                                        .reviewFrom
                                                                        .firstName,style: TextStyle(overflow: TextOverflow.ellipsis),)),
                                                                SizedBox(width: 5,),
                                                                RatingBar.builder(
                                                                  itemSize: 15,
                                                                  initialRating:  snapshot
                                                                      .data
                                                                      .data
                                                                      .rating ==
                                                                      null
                                                                      ? 0
                                                                      : snapshot
                                                                      .data.data.rating
                                                                      .toDouble(),
                                                                  minRating: 1,
                                                                  direction:
                                                                  Axis.horizontal,
                                                                  itemCount: 5,
                                                                  ignoreGestures: true,
                                                                  tapOnlyMode: true,
                                                                  itemPadding:
                                                                  EdgeInsets.symmetric(
                                                                      horizontal: 4.0),
                                                                  itemBuilder:
                                                                      (context, _) => Icon(
                                                                    Icons.star,
                                                                    color: Colors.amber,
                                                                  ),
                                                                  onRatingUpdate:
                                                                      (rating) {},
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          subtitle: Text(snapshot
                                                              .data
                                                              .data
                                                              .reviews[index]
                                                              .remark),

                                                        )),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
