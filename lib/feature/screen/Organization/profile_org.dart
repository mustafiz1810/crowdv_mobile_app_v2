import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowdv_mobile_app/feature/screen/Organization/widgets/org_profile_update.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../data/models/organization/org_profile_model.dart';

class OrgProfile extends StatefulWidget {
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
    print(data);
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
              return SingleChildScrollView(
                child: Column(
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
                              imageBuilder: (context, imageProvider) =>
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
                              placeholder: (context, url) => Icon(
                                Icons.downloading_rounded,
                                size: 40,
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.image_outlined,
                                size: 40,
                              ),
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
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                snapshot.data.data.email,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 5,
                      color: Colors.black,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "User Information",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OrgProfileUpdate(
                                                  country_id: snapshot
                                                      .data.data.countryId,
                                                  state_id: snapshot
                                                      .data.data.stateId,
                                                  city_id:
                                                      snapshot.data.data.cityId,
                                                  zip: snapshot
                                                      .data.data.zipCode,
                                                  website: snapshot
                                                      .data.data.website,
                                                  facebook: snapshot
                                                      .data.data.facebook,
                                                  linkedin: snapshot
                                                      .data.data.linkedin,
                                                )),
                                      ).then((value) => setState(() {}));
                                    },
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
                                leading: Icon(Icons.person_outline_rounded),
                                title: Text("Name:"),
                                subtitle: Text(snapshot.data.data.name),
                              ),
                              ListTile(
                                leading: Icon(Icons.email_outlined),
                                title: Text("Email:"),
                                subtitle: Text(snapshot.data.data.email),
                              ),
                              ListTile(
                                leading: Icon(Icons.phone_android_rounded),
                                title: Text("Phone:"),
                                subtitle: Text(snapshot.data.data.phone),
                              ),
                              ListTile(
                                leading: Icon(Icons.location_on),
                                title: Text("Country:"),
                                subtitle:
                                    Text(snapshot.data.data.country.toString()),
                              ),
                              ListTile(
                                leading: Icon(Icons.location_on),
                                title: Text("State:"),
                                subtitle:
                                    Text(snapshot.data.data.state.toString()),
                              ),
                              ListTile(
                                leading: Icon(Icons.location_on),
                                title: Text("City:"),
                                subtitle:
                                    Text(snapshot.data.data.city.toString()),
                              ),
                              ListTile(
                                leading: Icon(Icons.http),
                                title: Text("Website:"),
                                subtitle: Text(
                                    snapshot.data.data.website != null
                                        ? snapshot.data.data.website
                                        : ""),
                              ),
                              ListTile(
                                leading: Icon(Icons.facebook_rounded),
                                title: Text("Facebook:"),
                                subtitle: Text(
                                    snapshot.data.data.facebook != null
                                        ? snapshot.data.data.facebook
                                        : ""),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
