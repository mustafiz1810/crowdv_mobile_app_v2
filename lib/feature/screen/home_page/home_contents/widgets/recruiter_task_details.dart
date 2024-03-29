import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/data/models/recruiter/opportunity_detail.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/recruiter/update_opportunity/update_form.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/widgets/chat.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/design_details.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/http_request.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';
import '../../../profile/common_profile.dart';

class RecruiterTaskDetails extends StatefulWidget {
  final dynamic role, id, friendId, friendName, friendImage, isOnline;
  final bool isRead;
  RecruiterTaskDetails(
      {this.role,
      this.id,
      this.friendId,
      this.friendName,
      this.friendImage,
      this.isOnline,
      this.isRead});
  @override
  _RecruiterTaskDetailsState createState() => _RecruiterTaskDetailsState();
}

class _RecruiterTaskDetailsState extends State<RecruiterTaskDetails>
    with TickerProviderStateMixin {
  TextEditingController reviewController = TextEditingController();
  TextEditingController reportController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TabController _tabController;
  var eligibility;
  String uid;
  String token;
  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
      print(token);
      uid = pref.getString("uid");
    });
  }

  void rate(int rating, int id) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'recruiter/rating/$id'),
          headers: {
            "Authorization": "Bearer ${token}",
            "Accept": "application/json"
          },
          body: {
            'rating': rating.toString(),
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        showToast(context, data['message']);
      } else {
        var data = jsonDecode(response.body.toString());
        showToast(context, data['message']);
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(e.toString()),
              actions: [
                FlatButton(
                  child: Text("Try Again"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  void review(String review, int id) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'recruiter/review/$id'),
          headers: {
            "Authorization": "Bearer ${token}"
          },
          body: {
            'remark': review,
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        int count = 0;
        Navigator.popUntil(context, (route) => count++ == 3);
        setState(() {});
        showToast(context, data['message']);
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
        showToast(context, data['error']['errors']);
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(e.toString()),
              actions: [
                FlatButton(
                  child: Text("Try Again"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  void report(String report, details, int id) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'recruiter/report/$id'),
          headers: {
            "Authorization": "Bearer ${token}"
          },
          body: {
            'remarks': report,
            'details': details,
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        int count = 0;
        Navigator.popUntil(context, (route) => count++ == 3);
        setState(() {});
        showToast(context, data['message']);
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
        showToast(context, data['message']);
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(e.toString()),
              actions: [
                FlatButton(
                  child: Text("Try Again"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  Future<OpportunityDetail> getDetailsApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'opportunity/view/${widget.id}'),
        headers: {"Authorization": "Bearer $token"});
    var data = jsonDecode(response.body.toString());
    eligibility = data['data']['eligibility'];
    if (response.statusCode == 200) {
      return OpportunityDetail.fromJson(data);
    } else {
      return OpportunityDetail.fromJson(data);
    }
  }
  void submit(){
    Navigator.popUntil(context, (route) => count++ == 3);
    showToast(context, "Opportunity completed");
  }

  @override
  void initState() {
    getCred();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  int count = 0;
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              CachedNetworkImage(
                                imageUrl: snapshot.data.data.recruiter.image,
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
                                height: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => CommonProfile(
                                        id: snapshot.data.data.recruiter.id,
                                      ));
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
                                    child: Center(
                                        child: Text(
                                      snapshot.data.data.taskType,
                                      style: TextStyle(color: Colors.white),
                                    )),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: CachedNetworkImage(
                                    imageUrl: snapshot.data.data.category.icon,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                        ),
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
                                Tab(child: const Text('Volunteer')),
                                Tab(child: const Text('Location')),
                                Tab(child: const Text('Details')),
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
                                    snapshot.data.data.status == 'Pending'
                                        ? snapshot.data.data.applyInvite
                                                    .length !=
                                                0
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(
                                                          20.0) //                 <--- border radius here
                                                      ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    shrinkWrap: true,
                                                    itemCount: snapshot
                                                        .data
                                                        .data
                                                        .applyInvite
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.5),
                                                                  spreadRadius:
                                                                      -1,
                                                                  blurRadius: 4,
                                                                  offset: Offset(
                                                                      -1,
                                                                      0), // changes position of shadow
                                                                ),
                                                              ],
                                                            ),
                                                            child: snapshot
                                                                        .data
                                                                        .data
                                                                        .applyInvite[
                                                                            index]
                                                                        .status ==
                                                                    "applied"
                                                                ? ListTile(
                                                                    minVerticalPadding:
                                                                        20,
                                                                    leading:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Get.to(() =>
                                                                            CommonProfile(
                                                                              id: snapshot.data.data.applyInvite[index].volunteerId,
                                                                            ));
                                                                      },
                                                                      child:
                                                                          CircleAvatar(
                                                                        backgroundImage: NetworkImage(snapshot
                                                                            .data
                                                                            .data
                                                                            .applyInvite[index]
                                                                            .volunteerImage),
                                                                        radius:
                                                                            20,
                                                                      ),
                                                                    ),
                                                                    title:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Get.to(() =>
                                                                            CommonProfile(
                                                                              id: snapshot.data.data.applyInvite[index].volunteerId,
                                                                            ));
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        snapshot
                                                                            .data
                                                                            .data
                                                                            .applyInvite[index]
                                                                            .volunteerName,
                                                                        style: TextStyle(
                                                                            overflow:
                                                                                TextOverflow.ellipsis),
                                                                      ),
                                                                    ),
                                                                    subtitle:
                                                                        Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                            snapshot.data.data.applyInvite[index].location,
                                                                            style: TextStyle(fontSize: 14)),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(top: 8.0),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Container(
                                                                                height: 32,
                                                                                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(5)),
                                                                                child: TextButton(
                                                                                    onPressed: () {
                                                                                      SweetAlert.show(context, cancelButtonColor: Colors.red, confirmButtonColor: Colors.green, subtitle: "Are you sure?", style: SweetAlertStyle.confirm, showCancelButton: true, onPress: (bool isConfirm) {
                                                                                        if (isConfirm) {
                                                                                          //Return false to keep dialog
                                                                                          if (isConfirm) {
                                                                                            SweetAlert.show(context, subtitle: "Loading", style: SweetAlertStyle.loading);
                                                                                            new Future.delayed(new Duration(seconds: 1), () {
                                                                                              getRequestWithoutParam('/api/v1/opportunity/hired/${snapshot.data.data.applyInvite[index].id}', {
                                                                                                'Content-Type': "application/json",
                                                                                                "Authorization": "Bearer $token"
                                                                                              }).then((value) async {
                                                                                                showToast(context, 'Volunteer Accepted');
                                                                                                Navigator.pop(context);
                                                                                                setState(() {});
                                                                                              });
                                                                                            });
                                                                                          } else {
                                                                                            SweetAlert.show(context, subtitle: "Canceled!", style: SweetAlertStyle.error);
                                                                                          }
                                                                                          return false;
                                                                                        }
                                                                                        return null;
                                                                                      });
                                                                                    },
                                                                                    child: Text(
                                                                                      "Confirm",
                                                                                      style: TextStyle(color: Colors.white),
                                                                                    )),
                                                                              ),
                                                                              SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              Container(
                                                                                height: 32,
                                                                                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(5)),
                                                                                child: TextButton(
                                                                                    onPressed: () {
                                                                                      SweetAlert.show(context, cancelButtonColor: Colors.red, confirmButtonColor: Colors.green, subtitle: "Are you sure?", style: SweetAlertStyle.confirm, showCancelButton: true, onPress: (bool isConfirm) {
                                                                                        if (isConfirm) {
                                                                                          SweetAlert.show(context, subtitle: "Loading...", style: SweetAlertStyle.loading);
                                                                                          //Return false to keep dialog
                                                                                          if (isConfirm) {
                                                                                            new Future.delayed(new Duration(seconds: 1), () {
                                                                                              getRequestWithoutParam('/api/v1/opportunity/reject/${snapshot.data.data.applyInvite[index].id}', {
                                                                                                'Content-Type': "application/json",
                                                                                                "Authorization": "Bearer $token"
                                                                                              }).then((value) async {
                                                                                                showToast(context, 'Volunteer Declined');
                                                                                                Navigator.pop(context);
                                                                                                setState(() {});
                                                                                              });
                                                                                            });
                                                                                          } else {
                                                                                            SweetAlert.show(context, subtitle: "Canceled!", style: SweetAlertStyle.error);
                                                                                          }
                                                                                          return false;
                                                                                        }
                                                                                        return null;
                                                                                      });
                                                                                    },
                                                                                    child: Text(
                                                                                      "Decline",
                                                                                      style: TextStyle(color: Colors.white),
                                                                                    )),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : ListTile(
                                                                    leading:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Get.to(() =>
                                                                            CommonProfile(
                                                                              id: snapshot.data.data.applyInvite[index].volunteerId,
                                                                            ));
                                                                      },
                                                                      child:
                                                                          CircleAvatar(
                                                                        backgroundImage: NetworkImage(snapshot
                                                                            .data
                                                                            .data
                                                                            .applyInvite[index]
                                                                            .volunteerImage),
                                                                        radius:
                                                                            20,
                                                                      ),
                                                                    ),
                                                                    title:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Get.to(() =>
                                                                            CommonProfile(
                                                                              id: snapshot.data.data.applyInvite[index].volunteerId,
                                                                            ));
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        snapshot
                                                                            .data
                                                                            .data
                                                                            .applyInvite[index]
                                                                            .volunteerName,
                                                                        style: TextStyle(
                                                                            overflow:
                                                                                TextOverflow.ellipsis),
                                                                      ),
                                                                    ),
                                                                    subtitle: Text(
                                                                        snapshot
                                                                            .data
                                                                            .data
                                                                            .applyInvite[
                                                                                index]
                                                                            .location
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14)),
                                                                    trailing:
                                                                        Container(
                                                                      width: 80,
                                                                      height:
                                                                          30,
                                                                      margin: EdgeInsets
                                                                          .fromLTRB(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              5),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .black12,
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(20)),
                                                                      ),
                                                                      child: Center(
                                                                          child: Text(
                                                                              "Declined",
                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black38))),
                                                                    ),
                                                                  )),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(
                                                          20.0) //                 <--- border radius here
                                                      ),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                  "No one applied or invited.",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                )),
                                              )
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      20.0) //                 <--- border radius here
                                                  ),
                                            ),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 40,
                                                  ),
                                                  Container(
                                                    height: 95,
                                                    child: InkWell(
                                                      onTap: () {
                                                        Get.to(
                                                            () => CommonProfile(
                                                                  id: snapshot
                                                                      .data
                                                                      .data
                                                                      .volunteer
                                                                      .id,
                                                                ));
                                                      },
                                                      child: CachedNetworkImage(
                                                        imageUrl: snapshot
                                                            .data
                                                            .data
                                                            .volunteer
                                                            .image,
                                                        imageBuilder: (context,
                                                                imageProvider) =>
                                                            Container(
                                                          width: 95.0,
                                                          height: 95.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            image: DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover),
                                                          ),
                                                        ),
                                                        placeholder: (context,
                                                                url) =>
                                                            Icon(
                                                                Icons
                                                                    .downloading_rounded,
                                                                size: 40,
                                                                color: Colors
                                                                    .grey),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(
                                                          Icons.image_outlined,
                                                          size: 40,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            snapshot
                                                                    .data
                                                                    .data
                                                                    .volunteer
                                                                    .firstName +
                                                                " " +
                                                                snapshot
                                                                    .data
                                                                    .data
                                                                    .volunteer
                                                                    .lastName,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 22,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .location_on_rounded,
                                                        size: 13,
                                                      ),
                                                      Text(
                                                        snapshot.data.data
                                                            .volunteer.state
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      widget.friendId != null &&
                                                                  snapshot
                                                                          .data
                                                                          .data
                                                                          .status ==
                                                                      'Hired' ||
                                                              snapshot.data.data
                                                                      .status ==
                                                                  'invitation' ||
                                                              snapshot.data.data
                                                                      .status ==
                                                                  'Done'
                                                          ? Column(
                                                              children: [
                                                                Badge(
                                                                  elevation: 0,
                                                                  position: BadgePosition
                                                                      .topEnd(
                                                                          end:
                                                                              -4,
                                                                          top:
                                                                              -4),
                                                                  padding:
                                                                      EdgeInsetsDirectional
                                                                          .only(
                                                                              end: 0),
                                                                  badgeColor: Colors
                                                                      .transparent,
                                                                  badgeContent: Icon(
                                                                      Icons
                                                                          .fiber_manual_record,
                                                                      size:
                                                                          17.0,
                                                                      color: widget.isRead ==
                                                                              false
                                                                          ? Colors
                                                                              .lightBlue
                                                                          : Colors
                                                                              .transparent),
                                                                  child:
                                                                      Semantics(
                                                                        label:"Chat Button",
                                                                        child: IconBox(
                                                                    child: Icon(
                                                                        Icons
                                                                            .forum,
                                                                        color:
                                                                            primaryColor,
                                                                        size: 25,
                                                                    ),
                                                                    onTap: () {
                                                                        Get.to(() => ChatUi(
                                                                            uid:
                                                                                uid,
                                                                            friendId: widget
                                                                                .friendId,
                                                                            friendName: widget
                                                                                .friendName,
                                                                            friendImage: widget
                                                                                .friendImage,
                                                                            isOnline:
                                                                                widget.isOnline));
                                                                    },
                                                                    bgColor: Colors
                                                                          .white,
                                                                  ),
                                                                      ),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Text(
                                                                  "Chat",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black),
                                                                )
                                                              ],
                                                            )
                                                          : Column(
                                                              children: [
                                                                Text(
                                                                    snapshot
                                                                        .data
                                                                        .data
                                                                        .volunteer
                                                                        .city,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black)),
                                                                Text("City",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black)),
                                                              ],
                                                            ),
                                                      Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                snapshot.data.data.volunteer.profileRating.toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              Icon(
                                                                Icons.star,
                                                                color: Colors
                                                                    .amber,
                                                                size: 16,
                                                              )
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 17),
                                                            child: Text(
                                                              "Rating",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                              snapshot
                                                                  .data
                                                                  .data
                                                                  .volunteer
                                                                  .gender,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black)),
                                                          SizedBox(
                                                            height: 17,
                                                          ),
                                                          Text("Gender",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black)),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )),
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
                                                ),
                                                Text(
                                                  snapshot.data.data.state.name
                                                      .toString(),
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
                                                ),
                                                Text(
                                                  snapshot.data.data.city.name
                                                      .toString(),
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
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Title",
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Flexible(
                                                      child: Text(
                                                        snapshot
                                                            .data.data.title,
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            snapshot.data.data.type != "free"
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10.0),
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          12))),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "Charge",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                            ),
                                                            SizedBox(
                                                              width: 20,
                                                            ),
                                                            Flexible(
                                                              child: Text(
                                                                snapshot.data
                                                                    .data.charge
                                                                    .toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
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
                                                        Text(snapshot.data.data
                                                            .dateFormat
                                                            .toString()),
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
                                                            snapshot.data.data
                                                                .dataStartTime,
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
                                                            snapshot.data.data
                                                                .dataEndTime,
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
                                                                  Colors.grey,
                                                            ),
                                                            title: Text(snapshot
                                                                .data
                                                                .data
                                                                .eligibility[
                                                                    index]
                                                                .title
                                                                .toString()),
                                                            subtitle: snapshot
                                                                            .data
                                                                            .data
                                                                            .otherEligibility !=
                                                                        null &&
                                                                    snapshot
                                                                            .data
                                                                            .data
                                                                            .eligibility[
                                                                                index]
                                                                            .title ==
                                                                        "Others"
                                                                ? Text(snapshot
                                                                    .data
                                                                    .data
                                                                    .otherEligibility)
                                                                : SizedBox(),
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
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  snapshot.data.data.status != "Completed"
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: snapshot.data.data.status == "Pending"
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OpportunityUpdate(
                                                  token: token,
                                                  id: snapshot.data.data.id,
                                                  title:
                                                      snapshot.data.data.title,
                                                  category: snapshot
                                                      .data.data.category.id,
                                                  type: snapshot
                                                      .data.data.taskType,
                                                  description: snapshot
                                                      .data.data.details,
                                                  date: snapshot.data.data.date,
                                                  timeh: snapshot
                                                      .data.data.startTime.hour,
                                                  timem: snapshot.data.data
                                                      .startTime.minute,
                                                  etimeh: snapshot
                                                      .data.data.endTime.hour,
                                                  etimem: snapshot
                                                      .data.data.endTime.minute,
                                                  slug: snapshot
                                                      .data.data.category.slug,
                                                  eligibility: eligibility,
                                                  other: snapshot.data.data
                                                      .otherEligibility,
                                                  country: snapshot
                                                      .data.data.country.id,
                                                  city: snapshot
                                                      .data.data.city.id,
                                                  state: snapshot
                                                      .data.data.state.id,
                                                  zip: snapshot
                                                      .data.data.zipCode,
                                                  charge:
                                                      snapshot.data.data.charge,
                                                  chargeType:
                                                      snapshot.data.data.type,
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
                              : snapshot.data.data.status == "Done"
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.2,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.red.shade500,
                                              // shape: RoundedRectangleBorder(
                                              //     borderRadius:
                                              //     BorderRadius.circular(13)),
                                            ),
                                            onPressed: () {
                                              SweetAlert.show(context,
                                                  cancelButtonColor: Colors.red,
                                                  confirmButtonColor:
                                                      Colors.green,
                                                  title: "Are you sure?",
                                                  style:
                                                      SweetAlertStyle.confirm,
                                                  showCancelButton: true,
                                                  onPress: (bool isConfirm) {
                                                if (isConfirm) {
                                                  //Return false to keep dialog
                                                  if (isConfirm) {
                                                    new Future.delayed(
                                                        new Duration(
                                                            seconds: 1), () {
                                                      getRequestWithoutParam(
                                                          '/api/v1/cancel-task-complete/${widget.id}',
                                                          {
                                                            'Content-Type':
                                                                "application/json",
                                                            "Authorization":
                                                                "Bearer $token"
                                                          }).then(
                                                          (value) async {
                                                        showToast(context,
                                                            'Request Canceled');
                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      });
                                                    });
                                                  } else {
                                                    SweetAlert.show(context,
                                                        subtitle: "Canceled!",
                                                        style: SweetAlertStyle
                                                            .error);
                                                  }
                                                  return false;
                                                }
                                                return null;
                                              });
                                            },
                                            child: Text(
                                              "Cancel",
                                              style: GoogleFonts.kanit(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        SizedBox(
                                          height: 50,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.2,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.green,
                                            ),
                                            onPressed: () {
                                              SweetAlert.show(context,
                                                  cancelButtonColor: Colors.red,
                                                  confirmButtonColor:
                                                      Colors.green,
                                                  subtitle: "Are you sure?",
                                                  style:
                                                      SweetAlertStyle.confirm,
                                                  showCancelButton: true,
                                                  onPress: (bool isConfirm) {
                                                if (isConfirm) {
                                                  //Return false to keep dialog
                                                  if (isConfirm) {
                                                    new Future.delayed(
                                                        new Duration(
                                                            seconds: 1), () {
                                                      getRequestWithoutParam(
                                                          '/api/v1/recruiter-task-complete/${widget.id}',
                                                          {
                                                            'Content-Type':
                                                                "application/json",
                                                            "Authorization":
                                                                "Bearer ${token}"
                                                          }).then(
                                                          (value) async {
                                                        SweetAlert.show(context,
                                                            cancelButtonColor:
                                                                Colors.red,
                                                            confirmButtonColor:
                                                                Colors.green,
                                                            title:
                                                                "Your Task is completed",
                                                            subtitle:
                                                                "Please leave a rating ",
                                                            style:
                                                                SweetAlertStyle
                                                                    .success,
                                                            showCancelButton:
                                                                true,
                                                            onPress: (bool
                                                                isConfirm) {
                                                          if (isConfirm) {
                                                            if (isConfirm) {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      false,
                                                                  builder:
                                                                      (context) {
                                                                    return Dialog(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(15))),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            350,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                            Radius.circular(15),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            TabBar(
                                                                              controller: _tabController,
                                                                              unselectedLabelColor: Colors.grey,
                                                                              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color.fromRGBO(142, 142, 142, 1)),
                                                                              labelColor: Colors.blue,
                                                                              labelStyle: TextStyle(
                                                                                fontSize: 16,
                                                                                fontWeight: FontWeight.w600,
                                                                              ),
                                                                              tabs: [
                                                                                Tab(
                                                                                  child: Text(
                                                                                    "Review",
                                                                                  ),
                                                                                ),
                                                                                Tab(
                                                                                  child: Text(
                                                                                    "Report",
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Expanded(
                                                                              child: TabBarView(
                                                                                controller: _tabController,
                                                                                children: [
                                                                                  SingleChildScrollView(
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.all(8.0),
                                                                                      child: Column(
                                                                                        children: [
                                                                                          CachedNetworkImage(
                                                                                              imageUrl: snapshot.data.data.volunteer.image,
                                                                                              imageBuilder: (context, imageProvider) => Container(
                                                                                                    width: 80.0,
                                                                                                    height: 80.0,
                                                                                                    decoration: BoxDecoration(
                                                                                                      shape: BoxShape.circle,
                                                                                                      image: DecorationImage(image: imageProvider, fit: BoxFit.fitHeight),
                                                                                                    ),
                                                                                                  )),
                                                                                          Text(
                                                                                            snapshot.data.data.volunteer.firstName,
                                                                                            textAlign: TextAlign.center,
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.all(5.0),
                                                                                            child: Text(
                                                                                              'Rate ${snapshot.data.data.volunteer.firstName} and tell him what you think.',
                                                                                              style: TextStyle(fontSize: 16),
                                                                                            ),
                                                                                          ),
                                                                                          RatingBar.builder(
                                                                                            itemSize: 35,
                                                                                            minRating: 1,
                                                                                            direction: Axis.horizontal,
                                                                                            itemCount: 5,
                                                                                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                                                                              itemBuilder: (context, index) => Semantics(
                                                                                                label: (index+1).toString(),
                                                                                                child: Icon(
                                                                                                  Icons.star,
                                                                                                  color: Colors.amber,
                                                                                                ),
                                                                                              ),
                                                                                            onRatingUpdate: (rating) {
                                                                                              rate(rating.toInt(), widget.id);
                                                                                            },
                                                                                          ),
                                                                                          SizedBox(
                                                                                            height: 10,
                                                                                          ),
                                                                                          TextFormField(
                                                                                              controller: reviewController,
                                                                                              keyboardType: TextInputType.multiline,
                                                                                              textInputAction: TextInputAction.done,
                                                                                              maxLines: null,
                                                                                              textAlign: TextAlign.center,
                                                                                              decoration: InputDecoration(
                                                                                                hintText: "Share your experience",
                                                                                                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.black)),
                                                                                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.black)),
                                                                                              )),
                                                                                          FlatButton(
                                                                                            child: new Text(
                                                                                              'Save review',
                                                                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                                                                            ),
                                                                                            onPressed: () {
                                                                                              reviewController.text != '' ? review(reviewController.text.toString(), widget.id) : submit();
                                                                                              setState(() {});
                                                                                            },
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: [
                                                                                            Icon(
                                                                                              Icons.warning_rounded,
                                                                                              color: Colors.red,
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 5,
                                                                                            ),
                                                                                            Text('Report to admin'),
                                                                                          ],
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                        TextFormField(
                                                                                          textInputAction: TextInputAction.done,
                                                                                          controller: reportController,
                                                                                          decoration: ThemeHelper().textInputDecoration('Subject'),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                        Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            SizedBox(
                                                                                              width: 5,
                                                                                            ),
                                                                                            Text('Details'),
                                                                                          ],
                                                                                        ),
                                                                                        TextFormField(
                                                                                          textInputAction: TextInputAction.done,
                                                                                          controller: detailsController,
                                                                                          maxLines: 4,
                                                                                          decoration: ThemeHelper().textInputDecoration(),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          height: 10,
                                                                                        ),
                                                                                        FlatButton(
                                                                                          child: new Text('Save report', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                                                                          onPressed: () {
                                                                                            reportController.text != '' ? report(reportController.text.toString(), detailsController.text.toString(), widget.id) : submit();
                                                                                          },
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });
                                                            } else {
                                                              SweetAlert.show(
                                                                  context,
                                                                  subtitle:
                                                                      "Canceled!",
                                                                  style:
                                                                      SweetAlertStyle
                                                                          .error);
                                                            }
                                                            return false;
                                                          }
                                                          Navigator.popUntil(
                                                              context,
                                                              (route) =>
                                                                  count++ == 1);
                                                          return null;
                                                        });
                                                      });
                                                    });
                                                  } else {
                                                    SweetAlert.show(context,
                                                        subtitle: "Canceled!",
                                                        style: SweetAlertStyle
                                                            .error);
                                                  }
                                                  return false;
                                                }
                                                return null;
                                              });
                                            },
                                            child: Text(
                                              "Complete",
                                              style: GoogleFonts.kanit(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width /
                                          2.2,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.red.shade500,
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius:
                                          //     BorderRadius.circular(13)),
                                        ),
                                        onPressed: () {
                                          getRequestWithoutParam(
                                              '/api/v1/cancel-hiring/${snapshot.data.data.applyId}',
                                              {
                                                'Content-Type':
                                                    "application/json",
                                                "Authorization": "Bearer $token"
                                              }).then((value) async {
                                            Navigator.pop(context);
                                            showToast(context,
                                                'Application Cancelled');
                                          });
                                        },
                                        child: Text(
                                          "Cancel",
                                          style: GoogleFonts.kanit(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Container(
                            color: Colors.white,
                            width: 300,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "The opportunity is completed",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.done,
                                      color: Colors.green,
                                      size: 20,
                                    ))
                              ],
                            ),
                          )),
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
