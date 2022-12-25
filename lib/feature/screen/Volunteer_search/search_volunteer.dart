import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowdv_mobile_app/data/models/volunteer/task_search_category.dart';
import 'package:crowdv_mobile_app/feature/screen/Volunteer_search/Widgets/volunteer_filter.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/widgets/recruiter_task_details.dart';
import 'package:crowdv_mobile_app/widgets/bottom_nav_bar.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/http_request.dart';
import '../../../widgets/icon_box.dart';
import '../home_page/home_contents/widgets/volunteer_task_details.dart';

class VolunteerSearchPage extends StatefulWidget {
  final List<int> category;
  final List<String> taskType;
  final List<int> membership;
  final List<String> gender;
  final List<String> profession;
  final int min_age;
  final int max_age;
  final String country,state, city;

  VolunteerSearchPage(
      {this.category, this.taskType,this.country, this.state, this.city,this.membership,
        this.min_age,
        this.max_age,
        this.gender,
        this.profession,});

  @override
  State<StatefulWidget> createState() {
    return _VolunteerSearchPageState();
  }
}

class _VolunteerSearchPageState extends State<VolunteerSearchPage> {
  String token = "";
  String role = "";
  TextEditingController recruiterController = TextEditingController();

  @override
  void initState() {
    print(widget.city);
    print(widget.state);
    print(widget.country);
    // print(widget.category);
    // print(widget.taskType);
    // print(widget.gender);
    // print(widget.profession);
    // print(widget.membership);
    // print(widget.min_age);
    // print(widget.max_age);
    // print(recruiterController.text.toString());

    getCred();
    super.initState();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
      role = pref.getString("role");
    });
  }

  Future<CategorywiseTask> getCateTaskApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL +
            'task-search?'
                'state_id=${widget.state}&'
                'city_id=${widget.city}&'
                'category_id=${widget.category}&'
                'gender=${widget.gender}&'
                'membership_id=${widget.membership}&'
                'search=${recruiterController.text.toString()}&'
                'profession=${widget.profession}&'
                'country_id=${widget.country}&'
                'task_type=${widget.taskType}&'
                'min_age=${widget.min_age}&'
                'max_age=${widget.max_age}'),
        headers: {"Authorization": "Bearer $token"});
    var data = jsonDecode(response.body.toString());
    print(data);
    if (response.statusCode == 200) {
      return CategorywiseTask.fromJson(data);
    } else {
      return CategorywiseTask.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: OutlinedButton(
              onPressed: () async {
                getRequest('/api/v1/search-filter', null, {
                  'Content-Type': "application/json",
                  "Authorization": "Bearer $token"
                }).then((value) async {
                  print(value["data"]);
                  Get.to(() =>
                      VolunteerFilter(category: value["data"]["categories"],membership: value["data"]["memberships"]));
                });
              },
              child: Text(
                'Filter',
                style: TextStyle(color: Colors.white),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(width: 1.0, color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
            child: Container(
              child: TextFormField(
                controller: recruiterController,
                onTap: () => print('TextField onTap'),
                decoration: InputDecoration(
                  suffixIcon: Container(
                    margin: EdgeInsets.all(1),
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    child: IntrinsicHeight(
                      child: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              getCateTaskApi();
                            });
                          }),
                    ),
                  ),
                  hintText: "Search",
                  fillColor: Colors.black12,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  filled: true,
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.white)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.white)),
                ),
              ),
            ),
          ),
          Expanded(
              child: FutureBuilder<CategorywiseTask>(
            future: getCateTaskApi(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data.data.length == 0) {
                  return Container(
                    alignment: Alignment.center,
                    child: EmptyWidget(
                      image: null,
                      packageImage: PackageImage.Image_3,
                      title: 'No Opportunities',
                      titleTextStyle: TextStyle(
                        fontSize: 22,
                        color: Color(0xff9da9c7),
                        fontWeight: FontWeight.w500,
                      ),
                      subtitleTextStyle: TextStyle(
                        fontSize: 14,
                        color: Color(0xffabb8d6),
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: 15, top: 10, right: 15),
                        child: InkWell(
                          onTap: () {
                            print(
                              snapshot.data.data[index].status,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VolunteerTaskDetails(
                                      role: role,
                                      id: snapshot.data.data[index].id,)),
                            ).then((value) => setState(() {}));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 3.3,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: shadowColor.withOpacity(0.6),
                                  spreadRadius: -1,
                                  blurRadius: 3,
                                  // offset: Offset(0, 1), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(23.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:260,
                                        child: Text(
                                          snapshot.data.data[index].title,
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        width: 200,
                                        height: 50,
                                        child: Text(
                                          snapshot.data.data[index].details,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_rounded,
                                            color: Colors.blueAccent,
                                            size: 20,
                                          ),
                                          Text(
                                            snapshot.data.data[index].city.name.toString(),
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.blueAccent,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                        height: 5,
                                        color: Colors.grey.withOpacity(.5),
                                        thickness: 1,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.watch_later_outlined,
                                                    color: Colors.black,
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    snapshot.data.data[index]
                                                        .datumStartTime,
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
                                                    snapshot.data.data[index]
                                                        .datumEndTime,
                                                  ),
                                                ],
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
                                                  Text(snapshot
                                                      .data.data[index].dateFormat.toString()),
                                                ],
                                              )
                                            ],
                                          ),
                                          Container(
                                            height: 30,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: shadowColor
                                                      .withOpacity(0.6),
                                                  spreadRadius: -1,
                                                  blurRadius: 2,
                                                  // offset: Offset(0, 1), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  snapshot.data.data[index]
                                                      .taskType,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                      color: Colors.blue,
                                                      fontSize: 10),
                                                ),
                                                SizedBox(
                                                  width: 1,
                                                ),
                                                Icon(
                                                  Icons.work_outline_rounded,
                                                  color: Colors.blue,
                                                  size: 14,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                    top: 20,
                                    right: 20,
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      child: IconBox(
                                        child: CachedNetworkImage(
                                          imageUrl: snapshot
                                              .data.data[index].category.icon,
                                          imageBuilder:
                                              (context, imageProvider) =>
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
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(
                                            Icons.image_outlined,
                                            size: 40,
                                          ),
                                        ),
                                        bgColor: Colors.white,
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              } else if (snapshot.connectionState == ConnectionState.none) {
                return Text('Error'); // error
              } else {
                return Center(child: CircularProgressIndicator()); // loading
              }
            },
          )),
        ],
      ),
    );
  }
}
