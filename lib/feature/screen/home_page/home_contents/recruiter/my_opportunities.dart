import 'dart:convert';
import 'package:crowdv_mobile_app/data/models/recruiter/my_opportunity.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/widgets/applied_volunteer.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/widgets/details.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../../widgets/show_toast.dart';

class MyOpportunity extends StatefulWidget {
  final dynamic role;
  MyOpportunity({this.role});
  @override
  State<MyOpportunity> createState() => _MyOpportunityState();
}

class _MyOpportunityState extends State<MyOpportunity> {
  String token = "";

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

  Future<MyOpportunityModel> getOpportunityApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'opportunity'),
        headers: {"Authorization": "Bearer ${token}"});
    var data = jsonDecode(response.body.toString());
    showToast(context, data['message']);
    if (response.statusCode == 200) {
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
                  child: FutureBuilder<MyOpportunityModel>(
                future: getOpportunityApi(),
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
                                              margin:
                                                  EdgeInsets.fromLTRB(0, 0, 0, 5),
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
                                                          color: Colors.deepOrange)),),
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
                                                  width:250,
                                                  height: 40,
                                                  child: Text(
                                                    snapshot
                                                        .data.data[index].details,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10,),
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
                                                Text(snapshot.data.data[index].city,
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
                                                Text(snapshot.data.data[index].taskType,
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
                                                      'Category: ',
                                                      style: TextStyle(
                                                          color: primaryColor,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                    Text(snapshot.data.data[index].category.name,
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
                                // ---------------------------------------Icons
                                Positioned(
                                    left: 20,
                                    top: 195,
                                    child:snapshot.data.data[index].status=='Hired'?Row(
                                      children: [
                                        IconBox(
                                          child: Icon(
                                            Icons.message,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          bgColor: primaryColor,
                                        )
                                      ],
                                    ): Row(
                                      children: [
                                        IconBox(
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          bgColor: Colors.blueAccent,
                                        ),
                                        SizedBox(width: 10,),
                                        IconBox(
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          bgColor: Colors.red,
                                        ),
                                        SizedBox(width: 10,),
                                       IconBox(
                                         onTap: (){Get.to(()=>AppliedVolunteer(token:token,id:snapshot.data.data[index].id,));},
                                         child: Icon(
                                           Icons.person_pin,
                                           color: Colors.white,
                                           size: 20,
                                         ),
                                         bgColor: primaryColor,
                                       ),
                                      ],
                                    )),
                                // -----------------------------------Notification
                                snapshot.data.data[index].status=='Hired'?SizedBox():Positioned(
                                  top: 195,
                                  left: 125,
                                  child: Container(
                                    padding: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 12,
                                      minHeight: 12,
                                    ),
                                    child: Text(
                                      '1',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                // -----------------------------Detail
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
                                            child:  InkWell(
                                              onTap: () {
                                                Get.to(() =>
                                                    OpportunityDetails(role: widget.role,id:snapshot.data.data[index].id,token:token));
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
                                                    child: Text(
                                                        'Details',
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
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )),
            ],
          ),
        ));
  }
}
