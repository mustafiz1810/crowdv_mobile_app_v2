import 'dart:convert';
import 'package:crowdv_mobile_app/data/models/volunteer/upcoming_opportunity.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/widgets/volunteer_task_details.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
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
  var colors = [
    Color(0xFFbde0fe),
    Color(0xFFfefae0),
    Color(0xFFdee2ff),
    Color(0xFFade8f4),
    Color(0xFFfae0e4),
    Color(0xFFffd9da),
    Color(0xFFfbf8cc),
    Color(0xFFdaf7dc),
    Color(0xFFd7fff1),
    Color(0xFFb3dee2),
  ];
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

  Future<VolunteerOpportunity> getUOpportunityApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'volunteer/tasks/list'),
        headers: {"Authorization": "Bearer ${token}"});
    var data = jsonDecode(response.body.toString());
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
            'My Upcoming Opportunities',
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
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data.data.length == 0) {
                      return Container(
                        alignment: Alignment.center,
                        child: EmptyWidget(
                          image: null,
                          packageImage: PackageImage.Image_3,
                          title: 'No opportunities',
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
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: InkWell(
                              onTap: () {
                                print(
                                  snapshot.data.data[index].status,
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VolunteerTaskDetails(
                                            role: widget.role,
                                            id: snapshot.data.data[index].id,
                                          )),
                                ).then((value) => setState(() {}));
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: shadowColor.withOpacity(0.6),
                                      spreadRadius: -1,
                                      blurRadius: 3,
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
                                          SizedBox(
                                            width: 260,
                                            child: Text(
                                              snapshot.data.data[index].title,
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          SizedBox(
                                            width: 200,
                                            height: 80,
                                            child: Text(
                                              snapshot.data.data[index].details,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.location_on_rounded,
                                                    color: Colors.blueAccent,
                                                    size: 20,
                                                  ),
                                                  Text(
                                                    snapshot.data.data[index]
                                                                .city !=
                                                            null
                                                        ? snapshot.data
                                                            .data[index].city
                                                        : "",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color:
                                                            Colors.blueAccent,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              snapshot.data.data[index].type !=
                                                      "free"
                                                  ? Row(
                                                      children: [
                                                        Text(
                                                          "Charge : ",
                                                          style: TextStyle(
                                                              fontSize: 12.0),
                                                        ),
                                                        Text(
                                                            " ${snapshot.data.data[index].charge.toString()} Tk",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize:
                                                                    12.0)),
                                                      ],
                                                    )
                                                  : Container(),
                                              Text(
                                                snapshot
                                                    .data.data[index].taskType,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
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
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.calendar_today,
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(snapshot
                                                      .data.data[index].date),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.watch_later_outlined,
                                                    color: Colors.black,
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    snapshot.data.data[index]
                                                        .startTime,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "-",
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    snapshot.data.data[index]
                                                        .endTime,
                                                  ),
                                                ],
                                              ),
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
                                            child: Image.network(snapshot
                                                .data.data[index].categoryIcon),
                                            bgColor: Colors.white,
                                          ),
                                        ))
                                  ],
                                ),
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
