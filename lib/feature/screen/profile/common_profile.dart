import 'dart:convert';
import 'package:crowdv_mobile_app/data/models/common_profile_model.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:flutter/material.dart';
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
                                  snapshot.data.data
                                      .firstName
                                      .toString() +
                                      " " +
                                      snapshot
                                          .data.data.lastName
                                          .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Colors.black),
                                ),
                                snapshot.data.data.isOnline ==
                                    true
                                    ? Icon(
                                  Icons
                                      .fiber_manual_record_rounded,
                                  size: 12,
                                  color: Colors.green,
                                )
                                    : Icon(
                                  Icons
                                      .fiber_manual_record_rounded,
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
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "User Information",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              ),
                              ...ListTile.divideTiles(
                                color: Colors.grey,
                                tiles: [
                                  ListTile(
                                    leading: Icon(Icons.person_outline_rounded),
                                    title: Text("Name:"),
                                    subtitle: Text(
                                      snapshot.data.data.firstName.toString() +
                                          " " +
                                          snapshot.data.data.lastName,
                                    ),
                                  ),
                                  ListTile(
                                      leading: Icon(Icons.work_outline_rounded),
                                      title: Text("Profession:"),
                                      subtitle: Text(
                                          snapshot.data.data.profession != null
                                              ? snapshot.data.data.profession
                                              : "")),
                                  ListTile(
                                      leading: Icon(Icons.male),
                                      title: Text("Gender:"),
                                      subtitle: Text(
                                          snapshot.data.data.gender != null
                                              ? snapshot.data.data.gender
                                              : "")),
                                ],
                              ),
                            ],
                          ),
                        ),
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
