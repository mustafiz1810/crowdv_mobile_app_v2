import 'dart:convert';
import 'package:crowdv_mobile_app/data/models/recruiter/my_opportunity.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/widgets/applied_volunteer.dart';
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
    getCred();
    super.initState();
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
                            child: Column(
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
                                  padding: const EdgeInsets.all(15.0),
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
                                      child:  Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            snapshot.data.data[index].status ==
                                                'Hired'
                                                ? IconBox(
                                              child: Icon(
                                                Icons.message,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                              bgColor: primaryColor,
                                            )
                                                : Row(
                                              children: [
                                                IconBox(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AppliedVolunteer(
                                                                token: token,
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
                                                    size: 20,
                                                  ),
                                                  bgColor: primaryColor,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                IconBox(
                                                  onTap: () {
                                                    SweetAlert.show(context,
                                                        subtitle:
                                                        "Do you want to delete this opportunity?",
                                                        style: SweetAlertStyle
                                                            .confirm,
                                                        showCancelButton: true,
                                                        onPress:
                                                            (bool isConfirm) {
                                                          if (isConfirm) {
                                                            //Return false to keep dialog
                                                            if (isConfirm) {
                                                              // SweetAlert.show(context,
                                                              //     subtitle:
                                                              //         "Deleting...",
                                                              //     style:
                                                              //         SweetAlertStyle
                                                              //             .loading);
                                                              new Future.delayed(
                                                                  new Duration(
                                                                      seconds: 1),
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
                                                                              style:
                                                                              SweetAlertStyle
                                                                                  .success);
                                                                          setState(() {});
                                                                        });
                                                                  });
                                                            } else {
                                                              SweetAlert.show(context,
                                                                  subtitle:
                                                                  "Canceled!",
                                                                  style:
                                                                  SweetAlertStyle
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
                                                    size: 20,
                                                  ),
                                                  bgColor: Colors.red,
                                                ),
                                              ],
                                            ),
                                            Container(
                                              width: 80,
                                              height: 45,
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
                                        ),
                                      )
                                  ),
                                )
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
