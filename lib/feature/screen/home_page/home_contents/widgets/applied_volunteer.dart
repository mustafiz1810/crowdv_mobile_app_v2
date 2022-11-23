import 'dart:convert';
import 'package:crowdv_mobile_app/data/models/recruiter/apply_volunteer.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/widgets/chat.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/http_request.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:sweetalert/sweetalert.dart';
import '../../../../../widgets/show_toast.dart';
import '../../../profile/common_profile.dart';

class AppliedVolunteer extends StatefulWidget {
  final dynamic id, token;
  AppliedVolunteer({this.id, this.token});
  @override
  State<AppliedVolunteer> createState() => _AppliedVolunteerState();
}

class _AppliedVolunteerState extends State<AppliedVolunteer> {
  Future<ApplyVolunteer> getApplyApi() async {
    final response = await http.get(
        Uri.parse(
            NetworkConstants.BASE_URL + 'apply-volunteer-list/${widget.id}'),
        headers: {"Authorization": "Bearer ${widget.token}"});
    var data = jsonDecode(response.body.toString());
    print(data);
    if (response.statusCode == 200) {
      return ApplyVolunteer.fromJson(data);
    } else {
      return ApplyVolunteer.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          // collapsedHeight: 150,
          title: const Text(
            'Applied Volunteer',
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
                  child: FutureBuilder<ApplyVolunteer>(
                future: getApplyApi(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data.data.applyVolunteer.length == 0) {
                      return Container(
                        alignment: Alignment.center,
                        child: EmptyWidget(
                          image: null,
                          packageImage: PackageImage.Image_3,
                          title: 'Empty',
                          subTitle: 'No volunteer applied',
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
                        itemCount: snapshot.data.data.applyVolunteer.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 10, right: 15),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
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
                                        left: 5,
                                        right: 5,
                                        top: 10,
                                        bottom: 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Get.to(() => CommonProfile(
                                              id: snapshot
                                                  .data
                                                  .data
                                                  .applyVolunteer[index]
                                                  .volunteers
                                                  .id,
                                            ));
                                          },
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: Colors.blue,
                                                backgroundImage: NetworkImage(
                                                    "https://system.getcrowdv.com/images/user.jpg"),
                                                radius: 25,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              SizedBox(
                                                width: 120,
                                                child: Text(
                                                  snapshot
                                                      .data
                                                      .data
                                                      .applyVolunteer[index]
                                                      .volunteers
                                                      .name,
                                                  style: TextStyle(
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            IconBox(
                                              onTap: () {
                                                SweetAlert.show(context,
                                                    subtitle: "Are you sure?",
                                                    style:
                                                    SweetAlertStyle.confirm,
                                                    showCancelButton: true,
                                                    onPress: (bool isConfirm) {
                                                      if (isConfirm) {
                                                        SweetAlert.show(context,
                                                            subtitle: "Loading...",
                                                            style: SweetAlertStyle
                                                                .loading);
                                                        //Return false to keep dialog
                                                        if (isConfirm) {
                                                          new Future.delayed(
                                                              new Duration(
                                                                  seconds: 1), () {
                                                            getRequestWithoutParam(
                                                                '/api/v1/opportunity/reject/${snapshot.data.data.applyVolunteer[index].id}',
                                                                {
                                                                  'Content-Type':
                                                                  "application/json",
                                                                  "Authorization":
                                                                  "Bearer ${widget.token}"
                                                                }).then(
                                                                    (value) async {
                                                                  setState(() {});
                                                                  Navigator.pop(
                                                                      context);
                                                                  showToast(context,
                                                                      'Volunteer Rejected');
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
                                              bgColor:
                                              Colors.red,
                                              borderColor: Colors.white,
                                              child:
                                              Icon(
                                                Icons.clear,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 8,
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
                                                              subtitle: "Loading",
                                                              style: SweetAlertStyle
                                                                  .loading);
                                                          new Future.delayed(
                                                              new Duration(
                                                                  seconds: 1), () {
                                                            getRequestWithoutParam(
                                                                '/api/v1/opportunity/hired/${snapshot.data.data.applyVolunteer[index].id}',
                                                                {
                                                                  'Content-Type':
                                                                  "application/json",
                                                                  "Authorization":
                                                                  "Bearer ${widget.token}"
                                                                }).then(
                                                                    (value) async {
                                                                  setState(() {});
                                                                  int count = 0;
                                                                  Navigator.popUntil(
                                                                      context,
                                                                          (route) =>
                                                                      count++ == 2);
                                                                  showToast(context,
                                                                      'Volunteer Hired');
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
                                              bgColor:
                                              Colors.green,
                                              borderColor: Colors.white,
                                              child:
                                              Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size:18,
                                              ),
                                            ),
                                          ],
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
                                              snapshot
                                                  .data
                                                  .data
                                                  .applyVolunteer[index]
                                                  .volunteers
                                                  .profession,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                snapshot
                                                    .data
                                                    .data
                                                    .applyVolunteer[index]
                                                    .volunteers
                                                    .gender,
                                                style: TextStyle(fontSize: 14)),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                snapshot
                                                        .data
                                                        .data
                                                        .applyVolunteer[index]
                                                        .volunteers
                                                        .state +
                                                    ", " +
                                                    snapshot
                                                        .data
                                                        .data
                                                        .applyVolunteer[index]
                                                        .volunteers
                                                        .city,
                                                style: TextStyle(fontSize: 14)),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                    snapshot
                                                        .data
                                                        .data
                                                        .applyVolunteer[index]
                                                        .volunteers
                                                        .rating
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 14)),
                                                Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                  size: 14,
                                                )
                                              ],
                                            ),
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
