import 'package:crowdv_mobile_app/feature/screen/Search/search.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/recruiter/Create%20Opportunity/create_op.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/service_location.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/set_category.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/upcoming.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/notification.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/widgets/drawer.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/bottom_nav_bar.dart';
import 'package:crowdv_mobile_app/widgets/category_grid.dart';
import 'package:crowdv_mobile_app/widgets/get_prefs.dart';
import 'package:crowdv_mobile_app/widgets/header_without_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'home_contents/recruiter/my_opportunities.dart';

class HomeScreen extends StatefulWidget {
  final dynamic id, role;
  HomeScreen({this.id, this.role});
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // HomeController _controller = HomeController(repository: Get.find());
  bool navbarScrolled = false;
  // // AnimationController _controller_body;
  var user;
  bool volunteer = true;
  bool recruiter = false;

  @override
  void initState() {
    getUser().then((value) {
      setState(() {
        user = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
      bottomNavigationBar: CustomBottomNavigation(),
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
      body: Stack(
        children: [
          Container(
            height: 200,
            child: HeaderWidget(),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: widget.role == 'volunteer'
                        ? GridView.count(
                            // scrollDirection: Axis.horizontal,
                            crossAxisCount: 2,
                            childAspectRatio: .90,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            children: <Widget>[
                              SizedBox(
                                child: Row(children: [
                                  const Text(
                                    "Crowd",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40,
                                        color: Colors.white),
                                  ),
                                  Center(
                                    child: Image.asset('assets/crowdv_png.png',
                                        width: 40, height: 50),
                                  ),
                                ]),
                              ),
                              SizedBox(),
                              CategoryCard(
                                title: "Upcoming Opportunity",
                                svgSrc: "assets/86.svg",
                                press: () {
                                  Get.to(() => UpcomingOpportunity());
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
                                press: () {},
                              ),
                              CategoryCard(
                                title: "Membership",
                                svgSrc: "assets/93.svg",
                                press: () {},
                              ),
                              CategoryCard(
                                title: "Certificate",
                                svgSrc: "assets/185.svg",
                                press: () {},
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
                                  Get.to(MyOpportunity());
                                },
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
          widget.role == 'volunteer'
              ? Positioned(
                  top: 10,
                  left: 250,
                  child: LiteRollingSwitch(
                    value: volunteer,
                    iconOn: Icons.accessibility,
                    iconOff: Icons.accessible,
                    colorOff: Colors.blue,
                    colorOn: secondaryColor,
                    onChanged: (val) {
                      volunteer = val;
                      print(volunteer);
                    },
                    animationDuration: Duration(milliseconds: 1600),
                    textOn: "Volunteer",
                    textOff: "Recruiter",
                  ),
                )
              : Positioned(
                  top: 10,
                  left: 250,
                  child: LiteRollingSwitch(
                    value: recruiter,
                    iconOn: Icons.accessibility,
                    iconOff: Icons.accessible,
                    colorOff: Colors.blue,
                    colorOn: secondaryColor,
                    onChanged: (val) {
                      recruiter = val;
                      print(recruiter);
                    },
                    animationDuration: Duration(milliseconds: 1600),
                    textOn: "Volunteer",
                    textOff: "Recruiter",
                  ),
                ),
        ],
      ),
    );
  }
}
