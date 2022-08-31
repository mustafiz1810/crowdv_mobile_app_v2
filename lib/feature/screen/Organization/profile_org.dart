import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/data/models/profile_model.dart';
import 'package:crowdv_mobile_app/feature/screen/profile/profile_update_basic.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/organization/org_profile_model.dart';

class OrgProfile extends StatefulWidget {
  final data,
      role,
      disability,
      chosenValue,
      dropdown,
      selectedCountry,
      selectedProvince,
      zip;
  OrgProfile(
      {this.data,
        this.role,
        this.disability,
        this.chosenValue,
        this.dropdown,
        this.selectedProvince,
        this.selectedCountry,
        this.zip});
  @override
  State<StatefulWidget> createState() {
    return _OrgProfileState();
  }
}

class _OrgProfileState extends State<OrgProfile> {
  String token = "";

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

  Future<OrgProfileModel> getOrgProfileApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'organization/profile'),
        headers: {"Authorization": "Bearer $token"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return OrgProfileModel.fromJson(data);
    } else {
      return OrgProfileModel.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Profile Page",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          elevation: 0.5,
          iconTheme: IconThemeData(color: Colors.black),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
        body: FutureBuilder<OrgProfileModel>(
          future: getOrgProfileApi(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                              borderRadius: BorderRadius.all(Radius.circular(100))
                          ),
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data.data.logo,
                            imageBuilder:
                                (context, imageProvider) =>
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                    ),
                                  ),
                                ),
                            placeholder: (context, url) =>
                                Icon(Icons.downloading_rounded,size: 40,),
                            errorWidget: (context, url, error)
                            => Icon(Icons.image_outlined,size: 40,),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          snapshot.data.data.name,
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.email_outlined,
                              size: 13,
                            ),
                            SizedBox(width: 5,),
                            Text(
                              snapshot.data.data.email,
                              style:
                              TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 10,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding:
                    EdgeInsets.only(left: 5, right: 5),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                    "User Information",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight:
                                      FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                    textAlign:
                                    TextAlign.left,
                                  ),
                                  TextButton(
                                      // onPressed: () {
                                      //   Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder:
                                      //             (context) =>
                                      //             ProfileUpdate(
                                      //               token:
                                      //               token,
                                      //               fname:
                                      //               snapshot.data.data.firstName,
                                      //               lname:
                                      //               snapshot.data.data.lastName,
                                      //               email:
                                      //               snapshot.data.data.email,
                                      //               phone:
                                      //               snapshot.data.data.phone,
                                      //               dob:
                                      //               snapshot.data.data.dob,
                                      //               prof:
                                      //               snapshot.data.data.profession,
                                      //               gender:
                                      //               snapshot.data.data.gender,
                                      //             )),
                                      //   ).then((value) =>
                                      //       setState(
                                      //               () {}));
                                      // },
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                      ))
                                ],
                              ),
                            ),
                            ...ListTile.divideTiles(
                              color: Colors.grey,
                              tiles: [
                                ListTile(
                                  leading: Icon(Icons
                                      .person_outline_rounded),
                                  title: Text("Name:"),
                                  subtitle: Text(
                                    snapshot.data.data
                                        .name
                                  ),
                                ),
                                ListTile(
                                  leading: Icon(
                                      Icons.email_outlined),
                                  title: Text("Email:"),
                                  subtitle: Text(snapshot
                                      .data.data.email),
                                ),
                                ListTile(
                                  leading: Icon(Icons
                                      .phone_android_rounded),
                                  title: Text("Phone:"),
                                  subtitle: Text(snapshot
                                      .data.data.phone),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
