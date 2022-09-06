import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:flutter/material.dart';
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
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data.data.logo,
                            imageBuilder:
                                (context, imageProvider) =>
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.contain,
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
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                "User Information",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight:
                                  FontWeight.w700,
                                  fontSize: 16,
                                ),
                                textAlign:
                                TextAlign.left,
                              ),
                            ],
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
                              ListTile(
                                leading: Icon(Icons.location_on),
                                title: Text("State:"),
                                subtitle: Text(snapshot
                                    .data.data.state.toString()),
                              ),
                              ListTile(
                                leading: Icon(Icons.location_on),
                                title: Text("City:"),
                                subtitle: Text(snapshot
                                    .data.data.city.toString()),
                              ),
                              ListTile(
                                leading: Icon(Icons.http),
                                title: Text("Website:"),
                                subtitle: Text(snapshot
                                    .data.data.website),
                              ),
                              ListTile(
                                leading: Icon(Icons.facebook_rounded),
                                title: Text("Facebook:"),
                                subtitle: Text(snapshot
                                    .data.data.facebook),
                              ),

                            ],
                          ),
                        ],
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
