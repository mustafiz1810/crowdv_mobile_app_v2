import 'package:crowdv_mobile_app/feature/screen/Search/search.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/certificate.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/organization/create_opportunity.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/organization/op_list.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/recruiter/Create_Opportunity/create_op.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/service_location.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/set_category.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/Training/training_video_list.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/upcoming.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/volunteer_opportunities.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/notification.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/widgets/drawer.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/bottom_nav_bar.dart';
import 'package:crowdv_mobile_app/widgets/category_grid.dart';
import 'package:crowdv_mobile_app/widgets/header_without_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'home_contents/Training/training_list.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(id: widget.id, role: widget.role),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        // collapsedHeight: 150,
        title: const Text(
          'Home Page',
          style: TextStyle(color: Colors.white),
        ),
        // ),
        // centerTitle: true,
        backgroundColor: primaryColor,
        // pinned: true,
        // floating: true,
        // forceElevated: innerBoxIsScrolled,
        actions: [
          Container(
            margin: EdgeInsets.only(
              top: 16,
              right: 16,
            ),
            child: Stack(
              children: <Widget>[
                InkWell(
                    child: Icon(Icons.notifications),
                    onTap: () {
                      Get.to(() => NotificationPage());
                    }),
                Positioned(
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
                      '5',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        role: widget.role,
      ),
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: Icon(Icons.search),
        onPressed: () {
          Get.to(() => SearchPage());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // extendBody: true,
      body: Container(
        child: Column(
          children: [
            Container(
              height: 100,
              child: HeaderWidget(role: widget.role, id: widget.id),
            ),
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
                              crossAxisCount: 2,
                              childAspectRatio: .90,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              children: <Widget>[
                                CategoryCard(
                                  title: "Create Opportunity",
                                  svgSrc: "assets/471.svg",
                                  press: () {
                                    Get.to(OrgOpportunity());
                                  },
                                ),
                                CategoryCard(
                                  title: "My Opportunity",
                                  svgSrc: "assets/457.svg",
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
                                    crossAxisCount: 2,
                                    childAspectRatio: .90,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                    children: <Widget>[
                                      CategoryCard(
                                        title: "Upcoming Opportunity",
                                        svgSrc: "assets/86.svg",
                                        press: () {
                                          Get.to(() => UpcomingOpportunity(
                                                role: widget.role,
                                              ));
                                        },
                                      ),
                                      CategoryCard(
                                        title: "My Opportunity",
                                        svgSrc: "assets/457.svg",
                                        press: () {
                                          Get.to(VolunteerMyOpportunity(
                                            role: widget.role,
                                          ));
                                        },
                                      ),
                                      CategoryCard(
                                        title: "Set category",
                                        svgSrc: "assets/162.svg",
                                        press: () {
                                          Get.to(() => SetCategory());
                                        },
                                      ),
                                      CategoryCard(
                                        title: "Service Location",
                                        svgSrc: "assets/214.svg",
                                        press: () {
                                          Get.to(() => ServiceLocation());
                                        },
                                      ),
                                      CategoryCard(
                                        title: "Training",
                                        svgSrc: "assets/179.svg",
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
                                        svgSrc: "assets/185.svg",
                                        press: () {
                                          Get.to(() => Certificate());
                                        },
                                      ),
                                    ],
                                  )
                                : GridView.count(
                                    // scrollDirection: Axis.horizontal,
                                    crossAxisCount: 2,
                                    childAspectRatio: .90,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                    children: <Widget>[
                                      CategoryCard(
                                        title: "Create Opportunity",
                                        svgSrc: "assets/471.svg",
                                        press: () {
                                          Get.to(CreateOpportunity());
                                        },
                                      ),
                                      CategoryCard(
                                        title: "My Opportunity",
                                        svgSrc: "assets/457.svg",
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
          ],
        ),
      ),
    );
  }
}
