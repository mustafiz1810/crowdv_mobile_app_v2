import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdv_mobile_app/data/models/recruiter/my_opportunity.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/widgets/applied_volunteer.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/widgets/recruiter_task_details.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/http_request.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sweetalert/sweetalert.dart';

class MyOpportunity extends StatefulWidget {
  final dynamic role;
  MyOpportunity({this.role});
  @override
  State<MyOpportunity> createState() => _MyOpportunityState();
}

class _MyOpportunityState extends State<MyOpportunity> {
  String token = "";
  String uid;
  bool isRead;
  @override
  void initState() {
    getCred();
    super.initState();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
      uid = pref.getString("uid");
    });
  }

  Future<MyOpportunityModel> getOpportunityApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'opportunity'),
        headers: {"Authorization": "Bearer ${token}"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      print(data);
      return MyOpportunityModel.fromJson(data);
    } else {
      return MyOpportunityModel.fromJson(data);
    }
  }

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
                  child: FutureBuilder<MyOpportunityModel>(
                future: getOpportunityApi(),
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
                        shrinkWrap: true,
                        itemCount: snapshot.data.data.length,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 240,
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
                                  StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('Users')
                                          .doc(snapshot
                                              .data.data[index].volunteer.uid)
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
                                                print(snapshot.data
                                                    .docs[index]['is_read']);
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
                                                      RecruiterTaskDetails(
                                                        isRead: isRead,
                                                          role: widget.role,
                                                          id: snapshot.data
                                                              .data[index].id,
                                                          friendId: snapshot
                                                          .data
                                                          .data[index]
                                                          .volunteer
                                                          .uid,
                                                          friendName: snapshot
                                                              .data
                                                              .data[index]
                                                              .volunteer
                                                              .firstName,
                                                          friendImage: snapshot
                                                              .data
                                                              .data[index]
                                                              .volunteer
                                                              .image,
                                                          isOnline: snapshot
                                                              .data
                                                              .data[index]
                                                              .volunteer
                                                              .isOnline)),
                                            ).then((value) => setState(() {}));
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 260,
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
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                            .city.name
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.blueAccent,
                                                            fontWeight:
                                                                FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                      snapshot.data.data[index].expiredAt,
                                                      style: TextStyle(fontSize: 12.0)),
                                                ],
                                              ),
                                            ],
                                          ),
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
                                            snapshot.data.data[index].status ==
                                                    'Hired'||snapshot.data.data[index].status ==
                                                'Done'
                                                ?  Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                Container(
                                                width: 70,
                                          height: 35,
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                              BorderRadius
                                                  .circular(6)),
                                          child: Center(
                                            child: Text(
                                                "Done",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight
                                                        .bold,
                                                    fontSize: 15,
                                                    color: Colors
                                                        .white)),
                                          ),
                                        ),
                                        Text(
                                            "Request Is Pending",
                                            style: TextStyle(
                                                fontWeight:
                                                FontWeight.bold,
                                                fontSize: 14,
                                                color:
                                                Colors.grey)),
                                      ],
                                    )
                                                : Row(
                                                    children: [
                                                      IconBox(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        AppliedVolunteer(
                                                                          token:
                                                                              token,
                                                                          id: snapshot
                                                                              .data
                                                                              .data[index]
                                                                              .id,
                                                                        )),
                                                          ).then((value) =>
                                                              setState(() {}));
                                                        },
                                                        child: Icon(
                                                          Icons.person_pin,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                        bgColor: primaryColor,
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      IconBox(
                                                        onTap: () {
                                                          SweetAlert.show(
                                                              context,
                                                              subtitle:
                                                                  "Are you sure?",
                                                              style:
                                                                  SweetAlertStyle
                                                                      .confirm,
                                                              showCancelButton:
                                                                  true,
                                                              onPress: (bool
                                                                  isConfirm) {
                                                            if (isConfirm) {
                                                              //Return false to keep dialog
                                                              if (isConfirm) {
                                                                // SweetAlert.show(context,
                                                                //     subtitle:
                                                                //         "Deleting...",
                                                                //     style:
                                                                //         SweetAlertStyle
                                                                //             .loading);
                                                                new Future
                                                                        .delayed(
                                                                    new Duration(
                                                                        seconds:
                                                                            1),
                                                                    () {
                                                                  getRequestWithoutParam(
                                                                      '/api/v1/opportunity/delete/${snapshot.data.data[index].id}',
                                                                      {
                                                                        'Content-Type':
                                                                            "application/json",
                                                                        "Authorization":
                                                                            "Bearer ${token}"
                                                                      }).then(
                                                                      (value) async {
                                                                    SweetAlert.show(
                                                                        context,
                                                                        subtitle:
                                                                            "Success!",
                                                                        style: SweetAlertStyle
                                                                            .success);
                                                                    setState(
                                                                        () {});
                                                                  });
                                                                });
                                                              } else {
                                                                SweetAlert.show(
                                                                    context,
                                                                    subtitle:
                                                                        "Canceled!",
                                                                    style: SweetAlertStyle
                                                                        .error);
                                                              }
                                                              return false;
                                                            }
                                                            return null;
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.delete,
                                                          color: Colors.white,
                                                          size: 18,
                                                        ),
                                                        bgColor: Colors.red,
                                                      ),
                                                    ],
                                                  ),
                                            IconBox(
                                              onTap: () {
                                                SweetAlert.show(context,
                                                    subtitle: "Are you sure?",
                                                    style:
                                                        SweetAlertStyle.confirm,
                                                    showCancelButton: true,
                                                    onPress: (bool isConfirm) {
                                                  if (isConfirm) {
                                                    //Return false to keep dialog
                                                    if (isConfirm) {
                                                      SweetAlert.show(context,
                                                          subtitle:
                                                              "Copying...",
                                                          style: SweetAlertStyle
                                                              .loading);
                                                      new Future.delayed(
                                                          new Duration(
                                                              seconds: 1), () {
                                                        postRequest(
                                                            '/api/v1/copy-opportunity/${snapshot.data.data[index].id}', {
                                                          "Authorization":
                                                              "Bearer ${token}"
                                                        }, {}).then(
                                                            (value) async {
                                                          SweetAlert.show(
                                                              context,
                                                              subtitle:
                                                                  "Success!",
                                                              style:
                                                                  SweetAlertStyle
                                                                      .success);
                                                          setState(() {});
                                                        });
                                                      });
                                                    } else {
                                                      SweetAlert.show(context,
                                                          subtitle: "Canceled!",
                                                          style: SweetAlertStyle
                                                              .error);
                                                    }
                                                    return false;
                                                  }
                                                  return null;
                                                });
                                              },
                                              child: Icon(
                                                Icons.copy,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                              bgColor: Colors.blue,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      top: 20,
                                      right: 20,
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        child:CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: CachedNetworkImage(
                                            imageUrl: snapshot.data.data[index].category.icon,
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
                                      ),)
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
