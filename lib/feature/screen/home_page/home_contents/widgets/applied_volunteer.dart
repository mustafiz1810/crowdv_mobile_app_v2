import 'dart:convert';
import 'package:crowdv_mobile_app/data/models/recruiter/apply_volunteer.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/widgets/chat.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/http_request.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:sweetalert/sweetalert.dart';
import '../../../../../widgets/show_toast.dart';

class AppliedVolunteer extends StatefulWidget {
  final dynamic id,token;
  AppliedVolunteer({this.id,this.token});
  @override
  State<AppliedVolunteer> createState() => _AppliedVolunteerState();
}

class _AppliedVolunteerState extends State<AppliedVolunteer> {

  Future<ApplyVolunteer> getApplyApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'apply-volunteer-list/${widget.id}'),
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
                                padding: const EdgeInsets.all(5),
                                child: Container(
                                  width: 350,
                                  height: 180,
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
                                            height: 35,
                                            width: 370,
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:Radius.circular(20)),
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
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20, right: 20, top: 5),
                                              child: Text(
                                                snapshot.data.data.task.title,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
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
                                                      Text(
                                                        'Name:  ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 16),
                                                      ),
                                                      Text(
                                                        snapshot.data.data.applyVolunteer[index].volunteers.name,
                                                        style: TextStyle(
                                                            fontSize: 14),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Phone Number: ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 16),
                                                      ),
                                                      Text(snapshot.data.data.applyVolunteer[index].volunteers.phone,
                                                          style: TextStyle(
                                                              fontSize: 14))
                                                    ],
                                                  ),

                                                ],
                                              )),
                                        ],
                                      ),
                                      Positioned(
                                          top: 130,
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Container(
                                              height: 40,
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
                                          right: 18,
                                          top: 139.5,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 80,
                                                height: 30,
                                                margin:
                                                EdgeInsets.fromLTRB(0, 0, 0, 5),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20)),
                                                ),
                                                child: Center(
                                                  child:  InkWell(
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
                                                                              '/api/v1/opportunity/reject/${snapshot.data.data.applyVolunteer[index].id}',
                                                                              {
                                                                                'Content-Type':
                                                                                "application/json",
                                                                                "Authorization":
                                                                                "Bearer ${widget.token}"
                                                                              }).then((value) async {
                                                                            setState(() {});
                                                                            showToast(context,
                                                                                'Volunteer Rejected');
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
                                                    child: Text(
                                                        'Reject',
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize: 16,
                                                            color:
                                                            Colors.white)),
                                                  ),),
                                              ),
                                              SizedBox(width: 5,),
                                              Container(
                                                width: 80,
                                                height: 30,
                                                margin:
                                                EdgeInsets.fromLTRB(0, 0, 0, 5),
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(20)),
                                                ),
                                                child: Center(
                                                  child:  InkWell(
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
                                                                              '/api/v1/opportunity/hired/${snapshot.data.data.applyVolunteer[index].id}',
                                                                              {
                                                                                'Content-Type':
                                                                                "application/json",
                                                                                "Authorization":
                                                                                "Bearer ${widget.token}"
                                                                              }).then((value) async {
                                                                            Navigator.pop(context);
                                                                            showToast(context,
                                                                                'Volunteer Hired');
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
                                                    child: Text(
                                                        'Hire',
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontSize: 16,
                                                            color:
                                                            Colors.white)),
                                                  ),),
                                              ),
                                            ],
                                          )),
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
                  )),
            ],
          ),
        ));
  }
}
