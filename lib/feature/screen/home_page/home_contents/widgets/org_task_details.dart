import 'dart:convert';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/design_details.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../data/models/organization/org_opportunity_details.dart';
import '../../../../../utils/view_utils/common_util.dart';

class OrganizationTaskDetails extends StatefulWidget {
  final dynamic id;
  OrganizationTaskDetails({this.id});
  @override
  OrganizationTaskDetailsState createState() => OrganizationTaskDetailsState();
}

class OrganizationTaskDetailsState extends State<OrganizationTaskDetails>
    with TickerProviderStateMixin {
  TabController _tabController;
  String token;
  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
      print(token);
    });
  }

  Future<OrganizationOpDetails> getDetailsApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'organization/opportunity/view/${widget.id}'),
        headers: {"Authorization": "Bearer $token"});
    var data = jsonDecode(response.body.toString());
    print(data);
    if (response.statusCode == 200) {
      return OrganizationOpDetails.fromJson(data);
    } else {
      return OrganizationOpDetails.fromJson(data);
    }
  }

  @override
  void initState() {
    getCred();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Opportunity Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder<OrganizationOpDetails>(
        future: getDetailsApi(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: Color(0xFFe9ecef),
              child: Column(
                children: [
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: -2,
                          blurRadius: 5,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                CachedNetworkImage(
                                  imageUrl: snapshot.data.data.organization.logo,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                        width: 60.0,
                                        height: 60.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                  placeholder: (context, url) => Icon(
                                      Icons.downloading_rounded,
                                      size: 40,
                                      color: Colors.grey),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.image_outlined,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  snapshot.data.data.organization.name,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 5,
                            color: Colors.grey.withOpacity(.5),
                            thickness: 2,
                          ),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: SizedBox(
                             child:Text(
                               snapshot.data.data.title,
                               style: TextStyle(
                                   fontSize: 16,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.black),
                             )
                           ),
                         )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DefaultTabController(
                        length: 2,
                        child: CustomScrollView(
                          slivers: <Widget>[
                            SliverToBoxAdapter(
                                child: TabBar(
                                  tabs: [
                                    Tab(child: const Text('Opportunity Details')),
                                    Tab(child: const Text('Organization')),
                                  ],
                                  unselectedLabelColor: Colors.black,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicator: BubbleTabIndicator(
                                    indicatorHeight: 45.0,
                                    indicatorColor: primaryColor,
                                    indicatorRadius: 5,
                                    tabBarIndicatorSize: TabBarIndicatorSize.tab,
                                    // Other flags
                                    // indicatorRadius: 1,
                                    insets: EdgeInsets.all(2),
                                    // padding: EdgeInsets.all(10)
                                  ),
                                )),
                            SliverFillRemaining(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TabBarView(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 5, right: 5),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(12))),
                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: <Widget>[

                                                    Container(
                                                      child: Image.network(snapshot.data.data.banner),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width:
                                              MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(12))),
                                              child: Padding(
                                                  padding: const EdgeInsets.all(15.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .start,
                                                    children: [
                                                      Text(
                                                        'Apply',
                                                        textAlign: TextAlign.left,
                                                      ),
                                                      TextButton(
                                                          onPressed: () async {
                                                            String _url = snapshot
                                                                .data
                                                                .data
                                                                .links;
                                                            print('launching');
                                                            try {
                                                              await canLaunch(_url)
                                                                  ? await launch(_url)
                                                                  : throw 'Could not launch $_url';
                                                            } catch (_, __) {
                                                              showToast("Failed");
                                                            }
                                                          },
                                                          child: SizedBox(
                                                              width: 220,
                                                              height: 20,
                                                              child: Text(
                                                                snapshot
                                                                    .data
                                                                    .data
                                                                    .links,
                                                                style: TextStyle(
                                                                    overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                              ))),
                                                    ],
                                                  )),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width:
                                              MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(12))),
                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Details',
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      snapshot.data.data.description,
                                                      textAlign: TextAlign.justify,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        letterSpacing: 0.27,
                                                        color:
                                                        DesignCourseAppTheme.grey,
                                                      ),
                                                      maxLines: 5,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(12))),
                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Email',
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      snapshot.data.data.organization.email,
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(12))),
                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Phone',
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      snapshot.data.data.organization.phone,
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(12))),
                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                        height: 30,
                                                        width: 30,
                                                        child: Image.asset("assets/icons8-website-48.png")),
                                                    TextButton(
                                                        onPressed: () async {
                                                          String _url = snapshot
                                                              .data
                                                              .data
                                                              .organization.website;
                                                          print('launching');
                                                          try {
                                                            await canLaunch(_url)
                                                                ? await launch(_url)
                                                                : throw 'Could not launch $_url';
                                                          } catch (_, __) {
                                                            showToast("Failed");
                                                          }
                                                        },
                                                        child: SizedBox(
                                                            width: 200,
                                                            height: 20,
                                                            child: Text(
                                                              snapshot
                                                                  .data
                                                                  .data
                                                                  .links,
                                                              style: TextStyle(
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                            ))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(12))),
                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                        height: 30,
                                                        width: 30,
                                                        child: Image.asset("assets/icons8-facebook-48.png")),
                                                    TextButton(
                                                        onPressed: () async {
                                                          String _url = snapshot
                                                              .data
                                                              .data
                                                              .organization.facebook;
                                                          print('launching');
                                                          try {
                                                            await canLaunch(_url)
                                                                ? await launch(_url)
                                                                : throw 'Could not launch $_url';
                                                          } catch (_, __) {
                                                            showToast("Failed");
                                                          }
                                                        },
                                                        child: SizedBox(
                                                            width: 200,
                                                            height: 20,
                                                            child: Text(
                                                              snapshot
                                                                  .data
                                                                  .data
                                                                  .links,
                                                              style: TextStyle(
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                            ))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context).size.width,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(12))),
                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                        height: 30,
                                                        width: 30,
                                                        child: Image.asset("assets/icons8-linkedin-48.png")),
                                                    TextButton(
                                                        onPressed: () async {
                                                          String _url = snapshot
                                                              .data
                                                              .data
                                                              .organization.linkedin;
                                                          print('launching');
                                                          try {
                                                            await canLaunch(_url)
                                                                ? await launch(_url)
                                                                : throw 'Could not launch $_url';
                                                          } catch (_, __) {
                                                            showToast("Failed");
                                                          }
                                                        },
                                                        child: SizedBox(
                                                            width: 200,
                                                            height: 20,
                                                            child: Text(
                                                              snapshot
                                                                  .data
                                                                  .data
                                                                  .links,
                                                              style: TextStyle(
                                                                  overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                            ))),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
