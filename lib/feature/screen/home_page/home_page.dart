import 'dart:convert';
import 'package:crowdv_mobile_app/data/models/notification_model.dart';
import 'package:crowdv_mobile_app/feature/screen/Recruiter_search/search.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/certificate.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/organization/create_opportunity.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/organization/op_list.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/recruiter/Create_Opportunity/create_op.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/service_location.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/set_category.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/upcoming.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/volunteer_opportunities.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/widgets/applied_volunteer.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/notification.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/widgets/cslider.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/widgets/drawer.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/utils/view_utils/common_util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:crowdv_mobile_app/widgets/bottom_nav_bar.dart';
import 'package:crowdv_mobile_app/widgets/category_grid.dart';
import 'package:crowdv_mobile_app/widgets/header_without_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/ac_model.dart';
import '../../../widgets/http_request.dart';
import '../Volunteer_search/search_volunteer.dart';
import 'home_contents/Training/training_list.dart';
import 'home_contents/org_opportunities.dart';
import 'home_contents/recruiter/my_opportunities.dart';

class HomeScreen extends StatefulWidget {
  final dynamic id, role;
  HomeScreen({this.id, this.role});
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool navbarScrolled = false;
  String token;
  int count;
  var profileComplete;

  @override
  void initState() {
    getCred();
    super.initState();
    getAcApi();

    //Foreground State
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification.title);
        print(message.notification.body);
      }
    });

    //app open but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null) {
        print(message.notification.title);
        print(message.notification.body);
        print(message.data['opportunity_id']);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AppliedVolunteer(
                    id: message.data['opportunity_id'],
                    token: token,
                  )),
        );
      }
    });

    //when app is terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print(message.notification.title);
        print(message.notification.body);
        print(message.data['opportunity_id']);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AppliedVolunteer(
                    id: message.data['opportunity_id'],
                    token: token,
                  )),
        );
      }
    });
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
    });
  }
  Future<Null> refreshList() async{
    await getAcApi();
    await getNotifyApi();
    setState(() {});
  }

  Future<AccountModel> getAcApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'profile'),
        headers: {"Authorization": "Bearer $token"});
    var data = jsonDecode(response.body);
    profileComplete = data["data"]["is_complete"];
    if (response.statusCode == 200) {
      return AccountModel.fromJson(data);
    } else {
      return AccountModel.fromJson(data);
    }
  }

  Future<NotificationModel> getNotifyApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'notifications'),
        headers: {"Authorization": "Bearer $token"});
    var data = jsonDecode(response.body.toString());
    print(data);
    if (response.statusCode == 200) {
      return NotificationModel.fromJson(data);
    } else {
      return NotificationModel.fromJson(data);
    }
  }


  final List users = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: FutureBuilder<AccountModel>(
          future: getAcApi(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return  NavDrawer(
                id: widget.id,
                role: snapshot.data.data.role,
                fname: snapshot.data.data.firstName,
                lname: snapshot.data.data.lastName,
                email: snapshot.data.data.email,
                image: snapshot.data.data.image,
                disability: snapshot.data.data.typeOfDisability,
                prof: snapshot.data.data.profession,
                gender: snapshot.data.data.gender,
                state: snapshot.data.data.state,
                city: snapshot.data.data.city,
                zip: snapshot.data.data.zipCode,
              );
            } else {
              return Container();
            }
          }),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.only(
              top: 16,
              right: 16,
            ),
            child: FutureBuilder<NotificationModel>(
                future: getNotifyApi(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Stack(
                      children: <Widget>[
                        InkWell(
                            child: Icon(
                              Icons.notifications,
                              color: Colors.black,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NotificationPage(
                                            data: snapshot.data.data.list,
                                            token: token,
                                        role:widget.role,
                                          ))).then((value) {
                                setState(() {});
                              });
                            }),
                        snapshot.data.data.count != 0
                            ? Positioned(
                                right: 0,
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
                                    snapshot.data.data.count.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    );
                  } else {
                    return Icon(
                      Icons.notifications,
                      color: Colors.black,
                    );
                  }
                }),
          )
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        role: widget.role,
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.search,
          color: Colors.black,
        ),
        onPressed: () {
          widget.role == "volunteer"
              ? Get.to(() => VolunteerSearchPage())
              : Get.to(() => SearchPage());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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

              widget.role == "volunteer"?Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: CarouselExample(
                  ),
                ),
              ):Container(),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      widget.role == 'organization'
                          ? Expanded(
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
                            )
                          : Expanded(
                              child: widget.role == 'volunteer'
                                  ? GridView.count(
                                      // scrollDirection: Axis.horizontal,
                                      crossAxisCount: 3,
                                      childAspectRatio: .90,
                                      crossAxisSpacing: 2.0,
                                      mainAxisSpacing: 2.0,
                                      children: <Widget>[
                                        CategoryCard(
                                          title: "Upcoming Opportunity",
                                          svgSrc: "assets/bulb_svg.svg",
                                          press: () {
                                            Get.to(() => UpcomingOpportunity(
                                                  role: widget.role,
                                                ));
                                          },
                                        ),
                                        CategoryCard(
                                          title: "Organization Opportunity",
                                          svgSrc: "assets/home-heart-line.svg",
                                          press: () {
                                            Get.to(() => OrganizationOpportunities());
                                          },
                                        ),
                                        CategoryCard(
                                          title: "My Opportunity",
                                          svgSrc: "assets/list-check.svg",
                                          press: () {
                                            Get.to(VolunteerMyOpportunity(
                                              role: widget.role,
                                            ));
                                          },
                                        ),
                                        CategoryCard(
                                          title: "Set category",
                                          svgSrc: "assets/microsoft-line.svg",
                                          press: () async {
                                            getRequestWithoutParam(
                                                '/api/v1/get-category', {
                                              "Authorization": "Bearer ${token}"
                                            }).then((value) async {
                                              print(value["data"]["category"]);
                                              List<String> category = [];

                                              for (Map map in value["data"]
                                                  ["category"]) {
                                                // where the widget.eligibility is came from previous widget which seems a list of map in your code
                                                category.add(map["name"]);
                                              }
                                              print(category);
                                              setState(() {});
                                              Get.to(() => SetCategory(category));
                                            });
                                          },
                                        ),
                                        CategoryCard(
                                          title: "Service Location",
                                          svgSrc: "assets/home-location-alt.svg",
                                          press: () async {
                                            getRequestWithoutParam(
                                                '/api/v1/get-category', {
                                              "Authorization": "Bearer ${token}"
                                            }).then((value) async {
                                              print(
                                                  value["data"]['service_state']);
                                              Get.to(() => ServiceLocation(
                                                    country: value['data']
                                                        ['service_state'],
                                                    city: value['data']
                                                        ['service_city'],
                                                    zip: value['data']
                                                        ['service_zip_code'],
                                                  ));
                                            });
                                          },
                                        ),
                                        CategoryCard(
                                          title: "Training",
                                          svgSrc: "assets/e-learning.svg",
                                          press: () {
                                            Get.to(() => TrainingList());
                                          },
                                        ),
                                        // CategoryCard(
                                        //   title: "Membership",
                                        //   svgSrc: "assets/93.svg",
                                        //   press: () {},
                                        // ),
                                        CategoryCard(
                                          title: "Certificate",
                                          svgSrc: "assets/diploma.svg",
                                          press: () {
                                            Get.to(() => Certificate());
                                          },
                                        ),
                                      ],
                                    )
                                  : GridView.count(
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
                                            profileComplete == 100
                                                ? Get.to(CreateOpportunity())
                                                : showToast(
                                                    "Please complete your profile");
                                          },
                                        ),
                                        CategoryCard(
                                          title: "My Opportunity",
                                          svgSrc: "assets/ballot.svg",
                                          press: () {
                                            Get.to(MyOpportunity(
                                              role: widget.role,
                                            ));
                                          },
                                        ),
                                      ],
                                    ),
                            ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 2,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
