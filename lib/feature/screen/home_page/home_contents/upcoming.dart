import 'dart:convert';
import 'package:crowdv_mobile_app/data/models/volunteer/upcoming_opportunity.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/widgets/details.dart';
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
                            width: MediaQuery.of(context).size.width,
                            height:  MediaQuery.of(context).size.height/3.1,
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
                                Column(
                                  children: [
                                    Container(
                                      height: 55,
                                      width: MediaQuery.of(context).size.width,
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
                                            left: 20, right: 20, top: 10,bottom: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
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
                                            IconBox(
                                              child: Icon(Icons.info_outline,color: Colors.white,),
                                              bgColor: Colors.transparent,
                                              onTap: (){
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text("Details"),
                                                        content: Text(snapshot.data.data[index]
                                                            .details,),
                                                        actions: [
                                                          FlatButton(
                                                            child: Text("ok",style: TextStyle(color: Colors.white),),
                                                            onPressed: () {
                                                              Navigator.of(context).pop();
                                                            },
                                                            color: primaryColor,
                                                          )
                                                        ],
                                                      );
                                                    });

                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 20.0,bottom: 10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Title : ',
                                                style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                'Location : ',
                                                style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                'Job Type: ',
                                                style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 16),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                'Category: ',
                                                style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                snapshot.data.data[index].title,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  snapshot
                                                      .data.data[index].city,
                                                  style: TextStyle(
                                                      fontSize: 14)),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  snapshot.data.data[index]
                                                      .taskType,
                                                  style: TextStyle(
                                                      fontSize: 14)),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  snapshot
                                                      .data
                                                      .data[index]
                                                      .category
                                                      .name,
                                                  style: TextStyle(
                                                      fontSize: 14))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        height: 55,
                                        width: MediaQuery.of(context).size.width/1.1,
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
                                    )
                                  ],
                                ),
                                Positioned(
                                    left: 20,
                                    top: 195,
                                    child: Row(
                                      children: [
                                        Icon(Icons.wheelchair_pickup_sharp),
                                        SizedBox(width: 10,),
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
                                    child: Container(
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
