import 'dart:convert';
import 'package:crowdv_mobile_app/feature/screen/Recruiter_search/widgets/filter.dart';
import 'package:crowdv_mobile_app/feature/screen/profile/common_profile.dart';
import 'package:crowdv_mobile_app/widgets/bottom_nav_bar.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/recruiter/Volunteer_Category.dart';
import '../../../data/models/recruiter/pending_opportunities.dart';
import '../../../widgets/http_request.dart';
import '../../../widgets/icon_box.dart';
import '../home_page/widgets/chat.dart';

class SearchPage extends StatefulWidget {
  final List<int> category;
  final List<int> membership;
  final List<String> gender;
  final List<String> profession;
  final int min_age;
  final int max_age;
  String country,state, city;

  SearchPage(
      {this.category,
      this.membership,
      this.min_age,
      this.max_age,
      this.gender,
      this.profession,
        this.country,
      this.state,
      this.city,});

  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  String token = "";
  String role = "";
  TextEditingController volunteerController = TextEditingController();

  @override
  void initState() {
    // print(widget.country);
    // print(widget.city);
    // print(widget.state);
    // print(widget.min_age);
    // print(widget.max_age);
    print(widget.category);
    print(widget.membership);
    print(widget.profession);
    print(widget.gender);

    getCred();
    super.initState();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
      role = pref.getString("role");
    });
  }

  void invite(int volunteerId, int taskId) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'send/invitations/$taskId'),
          headers: {
            "Authorization": "Bearer ${token}",
            "Accept": "application/json"
          },
          body: {
            'volunteer_id': volunteerId.toString()
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        Navigator.of(context).pop();
        showToast(context, data['message']);
      } else {
        var data = jsonDecode(response.body.toString());
        print(volunteerId.toString());
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

  Future<CategoryVolunteer> getCateVolunteerApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL +
            'volunteer-search?state_id=${widget.state}&city_id=${widget.city}&country_id=${widget.country}&category_id=${widget.category}&gender=${widget.gender}&membership_id=${widget.membership}&search=${volunteerController.text}&profession=${widget.profession}&min_age=${widget.min_age}&max_age=${widget.max_age}'),
        headers: {"Authorization": "Bearer $token"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return CategoryVolunteer.fromJson(data);
    } else {
      return CategoryVolunteer.fromJson(data);
    }
  }

  Future<PendingOpportunity> getPendingApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'pending_opportunities'),
        headers: {"Authorization": "Bearer $token"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return PendingOpportunity.fromJson(data);
    } else {
      return PendingOpportunity.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: OutlinedButton(
              onPressed: () async {
                getRequest('/api/v1/search-filter', null, {
                  'Content-Type': "application/json",
                  "Authorization": "Bearer ${token}"
                }).then((value) async {
                  print(value["data"]);
                  Get.to(() => RecruiterFilter(
                      category: value["data"]["categories"],
                      membership: value["data"]["memberships"]));
                });
              },
              child: Text(
                'Filter',
                style: TextStyle(color: Colors.white),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(width: 1.0, color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
            child: Container(
              child: TextFormField(
                controller: volunteerController,
                onTap: () => print('TextField onTap'),
                decoration: InputDecoration(
                  suffixIcon: Container(
                    margin: EdgeInsets.all(1),
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: IntrinsicHeight(
                      child: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              getCateVolunteerApi();
                            });
                          }),
                    ),
                  ),
                  hintText: "Search",
                  fillColor: Colors.black12,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.white)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.white)),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<CategoryVolunteer>(
              future: getCateVolunteerApi(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.data.length == 0) {
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
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 15, top: 10, right: 15),
                          child: Container(
                            width: 350,
                            height: 200,
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
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Get.to(() => CommonProfile(
                                                    id: snapshot
                                                        .data.data[index].id,
                                                  ));
                                            },
                                            child: Text(
                                              snapshot.data.data[index]
                                                      .firstName
                                                      .toString() +
                                                  " " +
                                                  snapshot
                                                      .data.data[index].lastName
                                                      .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                          ),
                                          snapshot.data.data[index].isOnline ==
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
                                      Row(
                                        children: [
                                          IconBox(
                                            child: Icon(
                                              Icons.message_rounded,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            onTap: () {
                                              Get.to(() => ChatUi());
                                            },
                                            bgColor: Colors.blue,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: 80,
                                            height: 28,
                                            child: OutlinedButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Container(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              'Pick Opportunity',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                          color: primaryColor,
                                                        ),
                                                        content:
                                                            inviteAlertDialogContainer(
                                                                context,
                                                                snapshot
                                                                    .data
                                                                    .data[index]
                                                                    .id),
                                                      );
                                                    });
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Invite',
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 12),
                                                  ),
                                                  SizedBox(
                                                    width: 1,
                                                  ),
                                                  Icon(
                                                    Icons.add,
                                                    color: Colors.blue,
                                                    size: 16,
                                                  ),
                                                ],
                                              ),
                                              style: OutlinedButton.styleFrom(
                                                side: BorderSide(
                                                    color: Colors.blue),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                  height: 5,
                                  color: primaryColor,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Profession : ',
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 15),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            'Gender : ',
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 15),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            'Location: ',
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 15),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            'Rating: ',
                                            style: TextStyle(
                                                color: primaryColor,
                                                fontSize: 15),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            snapshot.data.data[index].profession,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              snapshot.data.data[index].gender
                                                  .toString(),
                                              style: TextStyle(fontSize: 14)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              snapshot.data.data[index].serviceState.name.toString() +
                                                  ", " +
                                                  snapshot.data.data[index].serviceCity.name
                                                      .toString(),
                                              style: TextStyle(fontSize: 14)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              snapshot.data.data[index].rating
                                                  .toString(),
                                              style: TextStyle(fontSize: 14))
                                        ],
                                      )
                                    ],
                                  ),
                                ),
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
            ),
          )
        ],
      ),
    );
  }

  Widget inviteAlertDialogContainer(context, int id) {
    return FutureBuilder<PendingOpportunity>(
      future: getPendingApi(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data.data.length == 0) {
            return Center(
              child: Text("No Data"),
            );
          } else {
            return Container(
              height: 300.0, // Change as per your requirement
              width: 300.0, // Change as per your requirement
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        invite(id, snapshot.data.data[index].id);
                      },
                      tileColor: Colors.black12,
                      leading: Icon(
                        Icons.fiber_manual_record_rounded,
                        color: Colors.black12,
                      ),
                      title: Text(
                        snapshot.data.data[index].title,
                      ),
                    ),
                  );
                },
              ),
            );
          }
        } else if (snapshot.connectionState == ConnectionState.none) {
          return Center(child: Text('Error')); // error
        } else {
          return Center(child: CircularProgressIndicator()); // loading
        }
      },
    );
  }
}
