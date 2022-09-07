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
    print(data);
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
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data.data.length == 0) {
                      return Container(
                        alignment: Alignment.center,
                        child: EmptyWidget(
                          image: null,
                          packageImage: PackageImage.Image_3,
                          title: 'No Opportunity',
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
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width / 1.7,
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
                                                      OpportunityDetails(
                                                          role: widget.role,
                                                          id: snapshot.data
                                                              .data[index].id,
                                                          token: token)),
                                            ).then((value) => setState(() {}));
                                          },
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
                                                  snapshot
                                                      .data.data[index].details,
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
                                                print(snapshot
                                                    .data.data[index].id);
                                                SweetAlert.show(context,
                                                    subtitle:
                                                        "Are you sure?",
                                                    style:
                                                        SweetAlertStyle.success,
                                                    showCancelButton: true,
                                                    onPress: (bool isConfirm) {
                                                  if (isConfirm) {
                                                    //Return false to keep dialog
                                                    if (isConfirm) {
                                                      SweetAlert.show(context,
                                                          subtitle:
                                                              "Copying...",
                                                          style:
                                                              SweetAlertStyle
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
                                        height: 50,
                                        width: 50,
                                        child: IconBox(
                                          child: Image.network(snapshot
                                              .data.data[index].category.icon),
                                          bgColor: Colors.white,
                                        ),
                                      ))
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
