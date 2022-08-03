import 'dart:convert';
import 'package:crowdv_mobile_app/data/models/volunteer/upcoming_opportunity.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/widgets/details.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UpcomingOpportunity extends StatefulWidget {
  final dynamic role;
  UpcomingOpportunity({this.role});
  @override
  State<UpcomingOpportunity> createState() => _UpcomingOpportunityState();
}

class _UpcomingOpportunityState extends State<UpcomingOpportunity> {
  String token = "";

  @override
  void initState() {
    super.initState();
    getUOpportunityApi();
    getCred();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
    });
  }

  Future<VolunteerOpportunity> getUOpportunityApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'volunteer/tasks/list'),
        headers: {"Authorization": "Bearer ${token}"});
    var data = jsonDecode(response.body.toString());
    print(data);
    if (response.statusCode == 200) {
      return VolunteerOpportunity.fromJson(data);
    } else {
      return VolunteerOpportunity.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          // collapsedHeight: 150,
          title: const Text(
            'Upcoming Opportunity',
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
                  child: FutureBuilder<VolunteerOpportunity>(
                future: getUOpportunityApi(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5),
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
                                Column(
                                  children: [
                                    Container(
                                      height: 55,
                                      width: 370,
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
                                            left: 20, right: 20, top: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              snapshot.data.data[index].title,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            Container(
                                              width: 80,
                                              height: 35,
                                              margin: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 5),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              child: Center(
                                                child: Text(
                                                    snapshot.data.data[index]
                                                        .status,
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
                                                SizedBox(
                                                  height: 40,
                                                  child: Text(
                                                    'Details:  ',
                                                    style: TextStyle(
                                                        color: primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 250,
                                                  height: 40,
                                                  child: Text(
                                                    snapshot.data.data[index].details,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Location : ',
                                                  style: TextStyle(
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                    snapshot
                                                        .data.data[index].city,
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
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                    snapshot.data.data[index].taskType,
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
                                Positioned(
                                    top: 180,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        height: 50,
                                        width: 355,
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
                                Positioned(
                                    left: 20,
                                    top: 202,
                                    child: Row(
                                      children: [
                                        Text("Recruiter Name: "),
                                        Text(
                                          snapshot.data.data[index].recruiter
                                                  .firstName +
                                              " " +
                                              snapshot.data.data[index]
                                                  .recruiter.lastName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )),
                                Positioned(
                                    right: 20,
                                    top: 193,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 35,
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
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => OpportunityDetails(
                                                          role: widget.role,
                                                          id: snapshot
                                                              .data.data[index].id,
                                                          token: token)),
                                                ).then((value) => setState(() {}));
                                              },
                                              child: Container(
                                                // width: 80,
                                                // height: 30,
                                                // margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                                // decoration: BoxDecoration(
                                                //   color: primaryColor,
                                                //   borderRadius: BorderRadius.all(Radius.circular(20)),
                                                // ),
                                                child: Center(
                                                    child: Text('Details',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                            color:
                                                                Colors.white))),
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
                  } else {
                    return Container(
                      alignment: Alignment.center,
                      child: EmptyWidget(
                        image: null,
                        packageImage: PackageImage.Image_3,
                        title: 'No Opportunity',
                        subTitle: 'No  Opportunity available',
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
