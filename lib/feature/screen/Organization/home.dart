import 'dart:convert';
import 'package:crowdv_mobile_app/feature/screen/Organization/widgets/drawer.dart';
import 'package:crowdv_mobile_app/feature/screen/Organization/op_list.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:http/http.dart' as http;
import 'package:crowdv_mobile_app/widgets/category_grid.dart';
import 'package:crowdv_mobile_app/widgets/header_without_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/organization/org_profile_model.dart';
import 'create_opportunity.dart';
class OrganizationHome extends StatefulWidget {
  final dynamic id, role,data;
  OrganizationHome({this.id, this.role,this.data});
  @override
  _OrganizationHomeState createState() => new _OrganizationHomeState();
}

class _OrganizationHomeState extends State<OrganizationHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool navbarScrolled = false;
  String token;

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
  Future<Null> refreshList() async{
    await getOrgProfileApi();
  }

  Future<OrgProfileModel> getOrgProfileApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'organization/profile'),
        headers: {"Authorization": "Bearer $token"});
    var data = jsonDecode(response.body);
    print(data);
    if (response.statusCode == 200) {
      return OrgProfileModel.fromJson(data);
    } else {
      return OrgProfileModel.fromJson(data);
    }
  }

  // Future<NotificationModel> getNotifyApi() async {
  //   final response = await http.get(
  //       Uri.parse(NetworkConstants.BASE_URL + 'notifications'),
  //       headers: {"Authorization": "Bearer $token"});
  //   var data = jsonDecode(response.body.toString());
  //   print(data);
  //   if (response.statusCode == 200) {
  //     return NotificationModel.fromJson(data);
  //   } else {
  //     return NotificationModel.fromJson(data);
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: FutureBuilder<OrgProfileModel>(
          future: getOrgProfileApi(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return  OrgDrawer(
                id: widget.id,
                name: snapshot.data.data.name,
                email: snapshot.data.data.email,
                phone: snapshot.data.data.phone,
                icon: snapshot.data.data.logo,
              );
            } else {
              return Container(color: Colors.white,);
            }
          }),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        actions: [
        InkWell(
          onTap: (){
            print(widget.data['id']);
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Icon(
            Icons.notifications,
            color: Colors.black,
      ),
          ),
        ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      // extendBody: true,
      body: RefreshIndicator(
        onRefresh: refreshList,
        backgroundColor: primaryColor,
        color: Colors.white,
        child: Container(
          child: Column(
            children: [
              Container(
                height: 90,
                child: HeaderWidget(role: widget.role, id: widget.id),
              ),
              Divider(
                height: 20,
                color: Colors.black,
              ),
              Expanded(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: GridView.count(
                    // scrollDirection: Axis.horizontal,
                    crossAxisCount: 3,
                    childAspectRatio: .90,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 2.0,
                    children: <Widget>[
                      CategoryCard(
                        title: "Create Opportunity",
                        svgSrc: "assets/edit.svg",
                        press: () {
                          Get.to(OrgOpportunity());
                        },
                      ),
                      CategoryCard(
                        title: "My Opportunity",
                        svgSrc: "assets/ballot.svg",
                        press: () {
                          Get.to(OrgOpportunityList());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
