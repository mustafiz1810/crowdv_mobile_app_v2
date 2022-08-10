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
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class OpportunityDetails extends StatefulWidget {
  final dynamic status, role, id, token;
  OpportunityDetails({this.status, this.role, this.id, this.token});
  @override
  _OpportunityDetailsState createState() => _OpportunityDetailsState();
}

class _OpportunityDetailsState extends State<OpportunityDetails>
    with TickerProviderStateMixin {
  var eligibility;
  final double infoHeight = 364.0;

  Future<OpportunityDetail> getDetailsApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'opportunity/view/${widget.id}'),
        headers: {"Authorization": "Bearer ${widget.token}"});
    var data = jsonDecode(response.body.toString());
    print(data);
    eligibility = data['data']['eligibility'];
    if (response.statusCode == 200) {
      return OpportunityDetail.fromJson(data);
    } else {
      return OpportunityDetail.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;
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
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
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
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            snapshot.data.data.title.toUpperCase(),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              letterSpacing: 0.40,
                              color: DesignCourseAppTheme.nearlyBlack,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text(
                                'Starts from:',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.27,
                                  color: Colors.black,
                                ),
                              ),
                              getTimeBoxUI(DateFormat.yMMMd()
                                  .format(snapshot.data.data.date)),
                              // Row(
                              //   children: [
                              //     getTimeBoxUI(snapshot.data.data.startTime.hour
                              //             .toString() +
                              //         ":" +
                              //         snapshot.data.data.startTime.minute
                              //             .toString()),
                              //     Text(
                              //       '-',
                              //       textAlign: TextAlign.left,
                              //       style: TextStyle(
                              //         fontWeight: FontWeight.bold,
                              //         fontSize: 16,
                              //         letterSpacing: 0.27,
                              //         color: primaryColor,
                              //       ),
                              //     ),
                              //     getTimeBoxUI(
                              //         snapshot.data.data.endTime.hour.toString() +
                              //             ":" +
                              //             snapshot.data.data.endTime.minute
                              //                 .toString()),
                              //
                              //   ],
                              // ),
                            ],
                          ),
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
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: TabBarView(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 5, right: 5),
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
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Job Type',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Nunito Sans',
                                                                fontSize: 18,
                                                                letterSpacing:
                                                                    0.27,
                                                                color: DesignCourseAppTheme
                                                                    .nearlyBlack,
                                                              ),
                                                            ),
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
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          'Eligibility',
                                                          textAlign:
                                                              TextAlign.left,
                                                          style:
                                                              GoogleFonts.lato(
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
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            shrinkWrap: true,
                                                            itemCount: snapshot
                                                                .data
                                                                .data
                                                                .eligibility
                                                                .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return ListTile(
                                                                leading: Icon(Icons
                                                                    .double_arrow_sharp),
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
                                                              Radius.circular(
                                                                  12))),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Details',
                                                          textAlign:
                                                              TextAlign.left,
                                                          style:
                                                              GoogleFonts.lato(
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
                                                          snapshot.data.data
                                                              .details,
                                                          textAlign:
                                                              TextAlign.justify,
                                                          style:
                                                              GoogleFonts.lato(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                            letterSpacing: 0.27,
                                                            color:
                                                                DesignCourseAppTheme
                                                                    .grey,
                                                          ),
                                                          maxLines: 5,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            child: Text("2"),
                                          ),
                                          Container(
                                            child: SingleChildScrollView(
                                              child: Text("3"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: primaryColor,
                    height: MediaQuery.of(context).size.height / 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 60,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13)),
                              ),
                              onPressed: () {},
                              child: Icon(
                                Icons.add_to_drive,
                                color: Colors.black,
                              )),
                        ),
                        SizedBox(
                          height: 50,
                          width: 240,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13)),
                            ),
                            onPressed: () {},
                            child: Text(

                              "Apply Now",
                              style: GoogleFonts.kanit(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ),
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
                  fontFamily: 'Nunito Sans',
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
