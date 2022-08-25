import 'dart:convert';
import 'package:crowdv_mobile_app/data/models/volunteer/volunteer_opportunity_model.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/widgets/details.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/http_request.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sweetalert/sweetalert.dart';
import '../../../../../widgets/show_toast.dart';

class VolunteerMyOpportunity extends StatefulWidget {
  final dynamic role;
  VolunteerMyOpportunity({this.role});
  @override
  State<VolunteerMyOpportunity> createState() => _VolunteerMyOpportunityState();
}

class _VolunteerMyOpportunityState extends State<VolunteerMyOpportunity> {
  String token = "";

  @override
  void initState() {
    getCred();
    super.initState();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
    });
  }

  Future<VolunteerOpportunityModel> getVOpportunityApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'volunteer/own/tasks'),
        headers: {"Authorization": "Bearer ${token}"});
    var data = jsonDecode(response.body.toString());
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
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OpportunityDetails(
                                        status:
                                            snapshot.data.data[index].status,
                                        role: widget.role,
                                        id: snapshot.data.data[index].taskId,
                                        token: token)),
                              ).then((value) => setState(() {}));
                            },
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
                                  Padding(
                                    padding: const EdgeInsets.all(23.0),
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
                                        SizedBox(
                                          width: 200,
                                          height: 50,
                                          child: Text(
                                            snapshot.data.data[index].details,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_rounded,
                                              color: Colors.blueAccent,
                                              size: 20,
                                            ),
                                            Text(
                                              snapshot.data.data[index].city !=
                                                      null
                                                  ? snapshot
                                                      .data.data[index].city
                                                  : "",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.blueAccent,
                                                  fontWeight: FontWeight.bold),
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
                                            snapshot.data.data[index]
                                                        .status ==
                                                    "applied"
                                                ? IconBox(
                                                    child: Icon(
                                                      Icons.message,
                                                      color: Colors.white,
                                                      size: 18,
                                                    ),
                                                    bgColor: primaryColor,
                                                  )
                                                : Container(
                                                    width: 100,
                                                    height: 35,
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 0, 0, 5),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.green),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(20),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: InkWell(
                                                        onTap: () {
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
                                                                style:
                                                                    SweetAlertStyle
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
                                                        },
                                                        child: Text('Complete',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .green)),
                                                      ),
                                                    ),
                                                  ),
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
                                                        .taskStatus
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
                              // child: Column(
                              //   children: [
                              //     Container(
                              //       height: 55,
                              //       width: MediaQuery.of(context).size.width,
                              //       decoration: BoxDecoration(
                              //         color: primaryColor,
                              //         borderRadius: BorderRadius.only(
                              //             topLeft: Radius.circular(20),
                              //             topRight: Radius.circular(20)),
                              //         boxShadow: [
                              //           BoxShadow(
                              //             color: shadowColor.withOpacity(0.2),
                              //             spreadRadius: .1,
                              //             blurRadius: 3,
                              //             // offset: Offset(0, 1), // changes position of shadow
                              //           ),
                              //         ],
                              //       ),
                              //       child: Padding(
                              //         padding: const EdgeInsets.only(
                              //             left: 20, right: 20, top: 10,bottom: 5),
                              //         child: Row(
                              //           mainAxisAlignment:
                              //           MainAxisAlignment.spaceBetween,
                              //           children: [
                              //             Container(
                              //               width: 80,
                              //               height: 35,
                              //               decoration: BoxDecoration(
                              //                 color: Colors.white,
                              //                 borderRadius: BorderRadius.all(
                              //                     Radius.circular(20)),
                              //               ),
                              //               child: Center(
                              //                 child: Text(
                              //                     snapshot.data.data[index]
                              //                         .status,
                              //                     style: TextStyle(
                              //                         fontWeight:
                              //                         FontWeight.bold,
                              //                         fontSize: 14,
                              //                         color:
                              //                         Colors.deepOrange)),
                              //               ),
                              //             ),
                              //             IconBox(
                              //               child: Icon(Icons.info_outline,color: Colors.white,),
                              //               bgColor: Colors.transparent,
                              //               onTap: (){
                              //                 showDialog(
                              //                     context: context,
                              //                     builder: (BuildContext context) {
                              //                       return AlertDialog(
                              //                         title: Text("Details"),
                              //                         content: Text(snapshot.data.data[index]
                              //                             .task.details,),
                              //                         actions: [
                              //                           FlatButton(
                              //                             child: Text("ok",style: TextStyle(color: Colors.white),),
                              //                             onPressed: () {
                              //                               Navigator.of(context).pop();
                              //                             },
                              //                             color: primaryColor,
                              //                           )
                              //                         ],
                              //                       );
                              //                     });
                              //
                              //               },
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //     Padding(
                              //       padding: const EdgeInsets.all(15.0),
                              //       child: Row(
                              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //         children: [
                              //           Column(
                              //             crossAxisAlignment: CrossAxisAlignment.start,
                              //             children: [
                              //               Text(
                              //                 'Title : ',
                              //                 style: TextStyle(
                              //                     color: primaryColor,
                              //                     fontSize: 16),
                              //               ),
                              //               SizedBox(
                              //                 height: 2,
                              //               ),
                              //               Text(
                              //                 'Location : ',
                              //                 style: TextStyle(
                              //                     color: primaryColor,
                              //                     fontSize: 16),
                              //               ),
                              //               SizedBox(
                              //                 height: 2,
                              //               ),
                              //               Text(
                              //                 'Job Type: ',
                              //                 style: TextStyle(
                              //                     color: primaryColor,
                              //                     fontSize: 16),
                              //               ),
                              //             ],
                              //           ),
                              //           Column(
                              //             crossAxisAlignment: CrossAxisAlignment.end,
                              //             children: [
                              //               Text(
                              //                 snapshot.data.data[index].task.title,
                              //                 style: TextStyle(
                              //                     color: Colors.black,
                              //                     fontSize: 14),
                              //               ),
                              //               SizedBox(
                              //                 height: 5,
                              //               ),
                              //               Text(
                              //                   snapshot
                              //                       .data.data[index].task.city,
                              //                   style: TextStyle(
                              //                       fontSize: 14)),
                              //               SizedBox(
                              //                 height: 5,
                              //               ),
                              //               Text(
                              //                   snapshot.data.data[index]
                              //                       .task.taskType,
                              //                   style: TextStyle(
                              //                       fontSize: 14)),
                              //             ],
                              //           )
                              //         ],
                              //       ),
                              //     ),
                              //     SizedBox(height: 12,),
                              //     Padding(
                              //       padding: const EdgeInsets.all(7.0),
                              //       child: Container(
                              //         child: Padding(
                              //           padding: const EdgeInsets.all(8.0),
                              //           child: snapshot.data.data[index].status ==
                              //                   "applied"
                              //               ? Row(
                              //                   mainAxisAlignment:
                              //                       MainAxisAlignment.end,
                              //                   children: [
                              //                     IconBox(
                              //                       child: Icon(
                              //                         Icons.message,
                              //                         color: Colors.white,
                              //                         size: 18,
                              //                       ),
                              //                       bgColor: primaryColor,
                              //                     ),
                              //                     SizedBox(
                              //                       width: 10,
                              //                     ),
                              //                   ],
                              //                 )
                              //               : Row(
                              //                   mainAxisAlignment:
                              //                       MainAxisAlignment.end,
                              //                   children: [
                              //                     Container(
                              //                       width: 90,
                              //                       height: 35,
                              //                       margin: EdgeInsets.fromLTRB(
                              //                           0, 0, 0, 5),
                              //                       decoration: BoxDecoration(
                              //                         color: Colors.green,
                              //                         borderRadius:
                              //                             BorderRadius.all(
                              //                                 Radius.circular(
                              //                                     20)),
                              //                       ),
                              //                       child: Center(
                              //                         child: InkWell(
                              //                           onTap: () {
                              //                             getRequestWithoutParam(
                              //                                 '/api/v1/volunteer-request-for-task-complete/${snapshot.data.data[index].task.id}',
                              //                                 {
                              //                                   'Content-Type':
                              //                                       "application/json",
                              //                                   "Authorization":
                              //                                       "Bearer ${token}"
                              //                                 }).then(
                              //                                 (value) async {
                              //                               SweetAlert.show(
                              //                                   context,
                              //                                   title:
                              //                                       "Your Task is completed",
                              //                                   subtitle:
                              //                                       "Please go to History ",
                              //                                   style:
                              //                                       SweetAlertStyle
                              //                                           .success,
                              //                                   onPress: (bool
                              //                                       isConfirm) {
                              //                                 if (isConfirm) {
                              //                                   // return false to keep dialog
                              //                                 }
                              //                                 return null;
                              //                               });
                              //                               setState(() {});
                              //                             });
                              //                           },
                              //                           child: Container(
                              //                             child: Center(
                              //                                 child: Text(
                              //                                     'Complete',
                              //                                     style: TextStyle(
                              //                                         fontWeight:
                              //                                             FontWeight
                              //                                                 .bold,
                              //                                         fontSize:
                              //                                             16,
                              //                                         color: Colors
                              //                                             .white))),
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                     SizedBox(
                              //                       width: 5,
                              //                     ),
                              //                     Container(
                              //                       width: 80,
                              //                       height: 35,
                              //                       margin: EdgeInsets.fromLTRB(
                              //                           0, 0, 0, 5),
                              //                       decoration: BoxDecoration(
                              //                         color: primaryColor,
                              //                         borderRadius:
                              //                             BorderRadius.all(
                              //                                 Radius.circular(
                              //                                     20)),
                              //                       ),
                              //                       child: Center(
                              //                         child: InkWell(
                              //                           onTap: () {
                              //                             Navigator.push(
                              //                               context,
                              //                               MaterialPageRoute(
                              //                                   builder: (context) => OpportunityDetails(
                              //                                       status: snapshot
                              //                                           .data
                              //                                           .data[
                              //                                               index]
                              //                                           .status,
                              //                                       role: widget
                              //                                           .role,
                              //                                       id: snapshot
                              //                                           .data
                              //                                           .data[
                              //                                               index]
                              //                                           .task
                              //                                           .id,
                              //                                       token:
                              //                                           token)),
                              //                             ).then((value) =>
                              //                                 setState(() {}));
                              //                           },
                              //                           child: Container(
                              //                             // width: 80,
                              //                             // height: 30,
                              //                             // margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                              //                             // decoration: BoxDecoration(
                              //                             //   color: primaryColor,
                              //                             //   borderRadius: BorderRadius.all(Radius.circular(20)),
                              //                             // ),
                              //                             child: Center(
                              //                                 child: Text(
                              //                                     'Details',
                              //                                     style: TextStyle(
                              //                                         fontWeight:
                              //                                             FontWeight
                              //                                                 .bold,
                              //                                         fontSize:
                              //                                             16,
                              //                                         color: Colors
                              //                                             .white))),
                              //                           ),
                              //                         ),
                              //                       ),
                              //                     ),
                              //                   ],
                              //                 ),
                              //         ),
                              //         height: 55,
                              //         width:
                              //             MediaQuery.of(context).size.width / 1.1,
                              //         decoration: BoxDecoration(
                              //           color: Colors.white,
                              //           borderRadius:
                              //               BorderRadius.all(Radius.circular(20)),
                              //           boxShadow: [
                              //             BoxShadow(
                              //               color: shadowColor.withOpacity(0.2),
                              //               spreadRadius: .1,
                              //               blurRadius: 3,
                              //               // offset: Offset(0, 1), // changes position of shadow
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
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
