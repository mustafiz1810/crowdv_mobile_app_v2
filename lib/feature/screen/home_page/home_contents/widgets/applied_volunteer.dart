import 'dart:convert';
import 'package:crowdv_mobile_app/data/models/recruiter/apply_volunteer.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/http_request.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
                  child: FutureBuilder<ApplyVolunteer>(
                    future: getApplyApi(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
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
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot.data.data.task.title,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                                // Container(
                                                //   width: 80,
                                                //   height: 35,
                                                //   margin:
                                                //   EdgeInsets.fromLTRB(0, 0, 0, 5),
                                                //   decoration: BoxDecoration(
                                                //     color: Colors.white,
                                                //     borderRadius: BorderRadius.all(
                                                //         Radius.circular(20)),
                                                //   ),
                                                //   child: Center(
                                                //     child: Text(
                                                //         snapshot.data.data[index]
                                                //             .status,
                                                //         style: TextStyle(
                                                //             fontWeight:
                                                //             FontWeight.bold,
                                                //             fontSize: 14,
                                                //             color: Colors.deepOrange)),),
                                                // ),
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
                                                    Text(
                                                      'Name:  ',
                                                      style: TextStyle(
                                                          color: primaryColor,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                    Text(
                                                      snapshot.data.data.applyVolunteer[index].volunteers.firstName+" "+snapshot.data.data.applyVolunteer[index].volunteers.lastName,
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Email : ',
                                                      style: TextStyle(
                                                          color: primaryColor,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                    Text(snapshot.data.data.applyVolunteer[index].volunteers.email,
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 14))
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Phone Number: ',
                                                      style: TextStyle(
                                                          color: primaryColor,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                    Text(snapshot.data.data.applyVolunteer[index].volunteers.phone,
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 14))
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Gender: ',
                                                          style: TextStyle(
                                                              color: primaryColor,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: 18),
                                                        ),
                                                        Text(snapshot.data.data.applyVolunteer[index].volunteers.gender,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                fontSize: 14))
                                                      ],
                                                    ),

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
                                        left: 20,
                                        top: 139,
                                        child: Row(
                                          children: [
                                            IconBox(
                                              child: Icon(
                                                Icons.message,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                              bgColor: primaryColor,
                                            ),
                                          ],
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
                                                color: Colors.teal,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                              ),
                                              child: Center(
                                                child:  InkWell(
                                                  onTap: () {
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
                                                  },
                                                  child: Container(
                                                    child: Center(
                                                        child: Text(
                                                            'Hire',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                fontSize: 16,
                                                                color:
                                                                Colors.white))),
                                                  ),
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
                      } else {
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
                      }
                    },
                  )),
            ],
          ),
        ));
  }
}
