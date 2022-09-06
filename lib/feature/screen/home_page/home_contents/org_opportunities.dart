import 'dart:convert';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/models/org_opp_model.dart';
import '../../../../utils/view_utils/common_util.dart';

class OrganizationOpportunities extends StatefulWidget {
  @override
  State<OrganizationOpportunities> createState() => _OrganizationOpportunitiesState();
}

class _OrganizationOpportunitiesState extends State<OrganizationOpportunities> {
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
  List<dynamic> banner = [];
  Future<OrgModel> getOrgOpportunityApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'organization/opportunity/list'),
        headers: {"Authorization": "Bearer ${token}"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {

      print(banner);
      return OrgModel.fromJson(data);
    } else {
      return OrgModel.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          // collapsedHeight: 150,
          title: const Text(
            'Organization Opportunity',
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
                  child: FutureBuilder<OrgModel>(
                    future: getOrgOpportunityApi(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data.data.length == 0) {
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
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data.data.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(5),
                                child:Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height / 3.3,
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: shadowColor.withOpacity(0.6),
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
                                              height: 40,
                                              child: Text(
                                                snapshot.data.data[index].description != null?snapshot.data.data[index].description:"",
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.add_link_rounded,
                                                      color: Colors.blueAccent,
                                                      size: 20,
                                                    ),
                                                    TextButton(
                                                        onPressed: () async {
                                                          String _url = snapshot.data.data[index].links;
                                                          print('launching');
                                                          try {
                                                            await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
                                                          } catch (_, __) {
                                                            showToast("Failed");
                                                          }
                                                        },
                                                        child: SizedBox(width:200,height:20,child: Text(snapshot.data.data[index].links))
                                                    ),
                                                  ],
                                                ),
                                                TextButton(
                                                    onPressed: ()  {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: Text(snapshot
                                                                  .data
                                                                  .data[index].organization.state.toUpperCase()),
                                                              content: Row(
                                                                children: [
                                                                  Flexible(child: Text("City: "+snapshot.data.data[index].organization.city)),
                                                                  SizedBox(width: 20,),
                                                                  Flexible(
                                                                    child: Text("Zip Code: "+snapshot
                                                                        .data
                                                                        .data[index].organization.zipCode),
                                                                  ),
                                                                ],
                                                              ),
                                                              actions: [
                                                                FlatButton(
                                                                  child: Text(
                                                                    "ok",
                                                                    style: TextStyle(
                                                                        color: Colors.white),
                                                                  ),
                                                                  onPressed: () {
                                                                    Navigator.of(context)
                                                                        .pop();
                                                                  },
                                                                  color: primaryColor,
                                                                )
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    child: Text("Address",style: TextStyle(decoration: TextDecoration.underline),)
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              height: 1,
                                              color: Colors.grey.withOpacity(.5),
                                              thickness: 1,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.home_repair_service_outlined,
                                                      size: 20,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      snapshot.data.data[index].organization.name,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.phone,
                                                      size: 20,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      snapshot.data.data[index].organization.phone,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.email_outlined,
                                                  size: 20,
                                                ),
                                                SizedBox(width: 5,),
                                                Text(
                                                  snapshot.data.data[index].organization.email,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
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
                        return Center(child: CircularProgressIndicator()); // loading
                      }
                    },
                  )),
            ],
          ),
        ));
  }
}
