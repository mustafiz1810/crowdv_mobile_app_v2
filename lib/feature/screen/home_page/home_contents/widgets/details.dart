import 'dart:convert';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:crowdv_mobile_app/data/models/recruiter/opportunity_detail.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/recruiter/update_opportunity/update_form.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/design_details.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/http_request.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../profile/common_profile.dart';

class OpportunityDetails extends StatefulWidget {
  final dynamic  role, id, token;
  OpportunityDetails({this.role, this.id, this.token});
  @override
  _OpportunityDetailsState createState() => _OpportunityDetailsState();
}

class _OpportunityDetailsState extends State<OpportunityDetails> {
  var eligibility;
  final double infoHeight = 364.0;

  Future<OpportunityDetail> getDetailsApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'opportunity/view/${widget.id}'),
        headers: {"Authorization": "Bearer ${widget.token}"});
    var data = jsonDecode(response.body.toString());
    print(widget.id);
    eligibility = data['data']['eligibility'];
    if (response.statusCode == 200) {
      return OpportunityDetail.fromJson(data);
    } else {
      return OpportunityDetail.fromJson(data);
    }
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
      body: FutureBuilder<OpportunityDetail>(
        future: getDetailsApi(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: Color(0xFFe9ecef),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 5,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.blue,
                                backgroundImage: NetworkImage(
                                    snapshot.data.data.recruiter.image),
                                radius: 25,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              InkWell(
                                onTap: (){
                                  Get.to(()=>CommonProfile(id: snapshot.data.data.recruiter.id,));
                                },
                                child: Text(
                                  snapshot.data.data.recruiter.firstName +
                                      " " +
                                      snapshot.data.data.recruiter.lastName,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    snapshot.data.data.recruiter.profileRating
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  )
                                ],
                              ),
                            ],
                          ),
                          VerticalDivider(
                            width: 5,
                            color: Colors.grey.withOpacity(.5),
                            thickness: 2,
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),

                                    child: Center(child: Text(snapshot.data.data.taskType,style: TextStyle(color: Colors.white),)),
                                  )
                                ],
                              ),
                              SizedBox(height: 10,),
                              Container(
                                height: 50,
                                width: 50,
                                child: IconBox(
                                  child: Image.network(snapshot
                                      .data.data.category.icon),
                                  bgColor: Colors.white,
                                ),
                              ),
                              Text(snapshot.data.data.category.name)
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DefaultTabController(
                        length: 3,
                        child: CustomScrollView(
                          slivers: <Widget>[
                            SliverToBoxAdapter(
                              child: TabBar(
                                tabs: [
                                  Tab(child: const Text('Details')),
                                  Tab(child: const Text('Location')),
                                  Tab(child: const Text('Contact')),
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
                              ),
                            ),
                            SliverFillRemaining(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TabBarView(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 5, right: 5),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(12))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text("Title",
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.lato(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 18,
                                                        letterSpacing: 0.27,
                                                        color:
                                                        DesignCourseAppTheme
                                                            .nearlyBlack,
                                                      ),),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        snapshot.data.data.title,
                                                        textAlign: TextAlign.right,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(12))),
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.all(15.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Starts from',
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.lato(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 18,
                                                        letterSpacing: 0.27,
                                                        color:
                                                        DesignCourseAppTheme
                                                            .nearlyBlack,
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.calendar_today,
                                                          size: 15,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(DateFormat.yMMMd()
                                                            .format(snapshot.data.data.date)),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(12))),
                                              child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Duration',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: GoogleFonts.lato(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          letterSpacing: 0.27,
                                                          color:
                                                              DesignCourseAppTheme
                                                                  .nearlyBlack,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .watch_later_outlined,
                                                            color: Colors.black,
                                                            size: 15,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            snapshot.data.data.dataStartTime,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            "-",
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            snapshot.data.data.dataEndTime,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(12))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      'Eligibility',
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.lato(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        letterSpacing: 0.27,
                                                        color:
                                                            DesignCourseAppTheme
                                                                .nearlyBlack,
                                                      ),
                                                    ),
                                                    ListView.builder(
                                                        physics:
                                                            ClampingScrollPhysics(),
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        shrinkWrap: true,
                                                        itemCount: snapshot
                                                            .data
                                                            .data
                                                            .eligibility
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return ListTile(
                                                            leading: Icon(
                                                              Icons
                                                                  .fiber_manual_record_rounded,
                                                              size: 12,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            title: Text(snapshot
                                                                .data
                                                                .data
                                                                .eligibility[
                                                                    index]
                                                                .title),
                                                          );
                                                        }),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(12))),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Details',
                                                      textAlign: TextAlign.left,
                                                      style: GoogleFonts.lato(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        letterSpacing: 0.27,
                                                        color:
                                                            DesignCourseAppTheme
                                                                .nearlyBlack,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      snapshot
                                                          .data.data.details,
                                                      textAlign:
                                                          TextAlign.justify,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        letterSpacing: 0.27,
                                                        color:
                                                            DesignCourseAppTheme
                                                                .grey,
                                                      ),
                                                      maxLines: 5,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'State',
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.lato(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    letterSpacing: 0.27,
                                                    color: DesignCourseAppTheme
                                                        .nearlyBlack,
                                                  ),
                                                ),
                                                Text(
                                                  snapshot.data.data.state,
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
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'City',
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.lato(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    letterSpacing: 0.27,
                                                    color: DesignCourseAppTheme
                                                        .nearlyBlack,
                                                  ),
                                                ),
                                                Text(
                                                  snapshot.data.data.city,
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
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Zip Code',
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.lato(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    letterSpacing: 0.27,
                                                    color: DesignCourseAppTheme
                                                        .nearlyBlack,
                                                  ),
                                                ),
                                                Text(
                                                  snapshot.data.data.zipCode !=
                                                          null
                                                      ? snapshot
                                                          .data.data.zipCode
                                                      : "",
                                                  textAlign: TextAlign.left,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    )),
                                    widget.role == 'volunteer'
                                        ? Container(
                                            child: Column(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12))),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Name',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: GoogleFonts.lato(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          letterSpacing: 0.27,
                                                          color:
                                                              DesignCourseAppTheme
                                                                  .nearlyBlack,
                                                        ),
                                                      ),
                                                      Text(snapshot
                                                              .data
                                                              .data
                                                              .recruiter
                                                              .firstName +
                                                          " " +
                                                          snapshot
                                                              .data
                                                              .data
                                                              .recruiter
                                                              .lastName),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12))),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Email',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: GoogleFonts.lato(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          letterSpacing: 0.27,
                                                          color:
                                                              DesignCourseAppTheme
                                                                  .nearlyBlack,
                                                        ),
                                                      ),
                                                      Text(snapshot.data.data
                                                          .recruiter.email),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                12))),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Phone',
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: GoogleFonts.lato(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          letterSpacing: 0.27,
                                                          color:
                                                              DesignCourseAppTheme
                                                                  .nearlyBlack,
                                                        ),
                                                      ),
                                                      Text(snapshot.data.data
                                                          .recruiter.phone),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ))
                                        : snapshot.data.data.status == 'Pending'
                                            ? Container(
                                                child: Center(
                                                    child: Text(
                                                  "No Volunteer Hired",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )),
                                              )
                                            : Container(
                                                child: Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    12))),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Name',
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                              letterSpacing:
                                                                  0.27,
                                                              color: DesignCourseAppTheme
                                                                  .nearlyBlack,
                                                            ),
                                                          ),
                                                          Text(snapshot
                                                                  .data
                                                                  .data
                                                                  .volunteer
                                                                  .firstName +
                                                              " " +
                                                              snapshot
                                                                  .data
                                                                  .data
                                                                  .volunteer
                                                                  .lastName),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    12))),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Email',
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                              letterSpacing:
                                                                  0.27,
                                                              color: DesignCourseAppTheme
                                                                  .nearlyBlack,
                                                            ),
                                                          ),
                                                          Text(snapshot
                                                              .data
                                                              .data
                                                              .volunteer
                                                              .email),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    12))),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            'Phone',
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: GoogleFonts
                                                                .lato(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                              letterSpacing:
                                                                  0.27,
                                                              color: DesignCourseAppTheme
                                                                  .nearlyBlack,
                                                            ),
                                                          ),
                                                          Text(snapshot
                                                              .data
                                                              .data
                                                              .volunteer
                                                              .phone),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: widget.role == 'recruiter' &&
                            snapshot.data.data.status == "Pending"
                        ? SizedBox(
                            height: 50,
                            width: 240,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OpportunityUpdate(
                                            token: widget.token,
                                            id: snapshot.data.data.id,
                                            title: snapshot.data.data.title,
                                            category:
                                                snapshot.data.data.category.id,
                                            type: snapshot.data.data.taskType,
                                            description:
                                                snapshot.data.data.details,
                                            date: snapshot.data.data.date,
                                            timeh: snapshot.data.data.startTime.hour,
                                            timem: snapshot
                                                .data.data.startTime.minute,
                                            etimeh:
                                                snapshot.data.data.endTime.hour,
                                            etimem: snapshot
                                                .data.data.endTime.minute,
                                            slug: snapshot
                                                .data.data.category.slug,
                                            eligibility: eligibility,
                                            city: snapshot.data.data.city,
                                            state: snapshot.data.data.state,
                                            zip: snapshot.data.data.zipCode,
                                          )),
                                ).then((value) => setState(() {}));
                              },
                              child: Text(
                                "Update",
                                style: GoogleFonts.kanit(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          )
                        : widget.role == 'volunteer' &&
                                snapshot.data.data.applyStatus == 0
                            ? SizedBox(
                                height: 50,
                                width: 240,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: primaryColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(13)),
                                  ),
                                  onPressed: () {
                                    getRequestWithoutParam(
                                        '/api/v1/volunteer/apply-task/${widget.id}',
                                        {
                                          'Content-Type': "application/json",
                                          "Authorization":
                                              "Bearer ${widget.token}"
                                        }).then((value) async {
                                      Navigator.pop(context);
                                      showToast(context, 'Opportunity Applied');
                                    });
                                  },
                                  child: Text(
                                    "Apply Now",
                                    style: GoogleFonts.kanit(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              )
                            : Container(),
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

  Widget getTimeBoxUI(String text1) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            // boxShadow: <BoxShadow>[
            //   BoxShadow(
            //       color: DesignCourseAppTheme.grey.withOpacity(0.2),
            //       offset: const Offset(1.1, 1.1),
            //       blurRadius: 2.0),
            // ],
            border: Border.all(color: Colors.black)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.27,
                  color: DesignCourseAppTheme.nearlyBlack,
                ),
              ),
              // Text(
              //   txt2,
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 14,
              //     letterSpacing: 0.27,
              //     color:primaryColor,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
