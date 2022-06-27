import 'dart:convert';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/data/models/volunteer/profile.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/header_without_logo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  String token = "";
  String _chosenValue;
  String _dropdown;
  String _stateValue;
  String _cityvalue;
  List<String> _state = [
    "Alabama",
    "Alaska",
    "California",
  ];
  List<String> _city = ["Bridgeport", "Hartford"];
  List<String> _items = ["Business", "Student", "Service", "Self-employer"];
  List<String> _item = ["Male", "Female"];
  @override
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

  Future<ProfileModel> getProfileApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'volunteer/profile'),
        headers: {"Authorization": "Bearer $token"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return ProfileModel.fromJson(data);
    } else {
      return ProfileModel.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile Page",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: primaryColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder<ProfileModel>(
            future: getProfileApi(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 120,
                          child: HeaderWidget(120),
                        ),
                        Positioned(
                          top: 25,
                          child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              children: [
                                Container(
                                  height: 100,
                                  width: 100,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        width: 5, color: Colors.white),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 20,
                                        offset: const Offset(5, 5),
                                      ),
                                    ],
                                  ),
                                  child: Image.network(
                                    snapshot.data.data.the0.image,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  snapshot.data.data.the0.firstName +
                                      " " +
                                      snapshot.data.data.the0.lastName,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  snapshot.data.data.the0.email,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    TabBar(
                      tabs: [
                        Tab(
                            icon: Icon(Icons.info_rounded),
                            child: const Text('Basic Info')),
                        Tab(
                            icon: Icon(Icons.handshake),
                            child: const Text('Service')),
                        Tab(
                            icon: Icon(Icons.phone),
                            child: const Text('Contact')),
                      ],
                      unselectedLabelColor: Colors.black38,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BubbleTabIndicator(
                        indicatorHeight: 70.0,
                        indicatorColor: primaryColor,
                        indicatorRadius: 5,
                        tabBarIndicatorSize: TabBarIndicatorSize.tab,
                        // Other flags
                        // indicatorRadius: 1,
                        insets: EdgeInsets.all(2),
                        // padding: EdgeInsets.all(10)
                      ),
                    ),
                    SizedBox(
                      height: 380,
                      child: TabBarView(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, bottom: 4.0),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "User Information",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Card(
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            ...ListTile.divideTiles(
                                              color: Colors.grey,
                                              tiles: [
                                                ListTile(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 4),
                                                  leading: Icon(Icons.person),
                                                  title: Text("Name:"),
                                                  subtitle: Text(
                                                    snapshot.data.data.the0
                                                            .firstName +
                                                        " " +
                                                        snapshot.data.data.the0
                                                            .lastName,
                                                  ),
                                                ),
                                                ListTile(
                                                  leading: Icon(Icons.email),
                                                  title: Text("Email:"),
                                                  subtitle: Text(snapshot
                                                      .data.data.the0.email),
                                                ),
                                                ListTile(
                                                  leading: Icon(Icons.phone),
                                                  title: Text("Phone:"),
                                                  subtitle:
                                                      Text("99--99876-56"),
                                                ),
                                                ListTile(
                                                  leading: Icon(Icons.person),
                                                  title: Text("Date of Birth:"),
                                                  subtitle: Text(
                                                      DateFormat.yMMMd().format(
                                                          snapshot.data.data
                                                              .the0.dob)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 300,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 15),
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: DropdownButton<String>(
                                        hint: Center(
                                          child: Text(
                                            "Profession:  " +
                                                snapshot
                                                    .data.data.the0.profession
                                                    .toString(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        value: _chosenValue,
                                        // elevation: 5,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                        iconEnabledColor: Colors.white,
                                        items: _items
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        selectedItemBuilder:
                                            (BuildContext context) => _items
                                                .map((e) => Center(
                                                      child: Text(
                                                        e,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ))
                                                .toList(),
                                        underline: Container(),
                                        // hint: Text(
                                        //   "Please choose a service",
                                        //   style: TextStyle(
                                        //       fontSize: 18,
                                        //       color: Colors.white,
                                        //       fontWeight: FontWeight.bold),
                                        // ),
                                        // icon: Icon(
                                        //   Icons.arrow_downward,
                                        //   color: Colors.yellow,
                                        // ),
                                        // isExpanded: true,
                                        onChanged: (String value) {
                                          setState(() {
                                            _chosenValue = value;
                                          });
                                        }),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 300,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 15),
                                  decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: DropdownButton<String>(
                                        value: _dropdown,
                                        hint: Center(
                                          child: Text(
                                            "Gender:    " +
                                                snapshot.data.data.the0.gender
                                                    .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        // elevation: 5,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                        iconEnabledColor: Colors.white,
                                        items: _item
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        selectedItemBuilder:
                                            (BuildContext context) => _item
                                                .map((e) => Center(
                                                      child: Text(
                                                        e,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ))
                                                .toList(),
                                        underline: Container(),
                                        // hint: Text(
                                        //   "Please choose a service",
                                        //   style: TextStyle(
                                        //       fontSize: 18,
                                        //       color: Colors.white,
                                        //       fontWeight: FontWeight.bold),
                                        // ),
                                        // icon: Icon(
                                        //   Icons.arrow_downward,
                                        //   color: Colors.yellow,
                                        // ),
                                        // isExpanded: true,
                                        onChanged: (String value) {
                                          setState(() {
                                            _dropdown = value;
                                          });
                                        }),
                                  ),
                                ),
                                SizedBox(height: 70),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox.fromSize(
                                      size: Size(
                                          70, 70), // button width and height
                                      child: ClipOval(
                                        child: Material(
                                          color: primaryColor, // button color
                                          child: InkWell(
                                            splashColor:
                                                secondaryColor, // splash color
                                            onTap: () {}, // button pressed
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.save,
                                                  color: Colors.white,
                                                ), // icon
                                                Text(
                                                  "Save",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ), // text
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 360,
                                  child: Center(
                                    child: DropdownButton<String>(
                                        value: _stateValue,
                                        hint: Center(
                                          child: Text(
                                            "State:  " +
                                                snapshot.data.data.the0.state,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        // elevation: 5,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                        iconEnabledColor: Colors.white,
                                        items: _state
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        selectedItemBuilder:
                                            (BuildContext context) => _state
                                                .map((e) => Center(
                                                      child: Text(
                                                        e,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ))
                                                .toList(),
                                        underline: Container(),
                                        // hint: Text(
                                        //   "Please choose a service",
                                        //   style: TextStyle(
                                        //       fontSize: 18,
                                        //       color: Colors.white,
                                        //       fontWeight: FontWeight.bold),
                                        // ),
                                        // icon: Icon(
                                        //   Icons.arrow_downward,
                                        //   color: Colors.yellow,
                                        // ),
                                        // isExpanded: true,
                                        onChanged: (String value) {
                                          setState(() {
                                            _stateValue = value;
                                          });
                                        }),
                                  ),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 2),
                                          blurRadius: 2.0)
                                    ],
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                // Container(
                                //   width: 300,
                                //   padding:
                                //   EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                //   decoration: BoxDecoration(
                                //       color: primaryColor,
                                //       borderRadius: BorderRadius.circular(30)),
                                //   child: Center(
                                //     child: DropdownButton<String>(
                                //         value: _chosenValue,
                                //         // elevation: 5,
                                //         style: TextStyle(
                                //             color: Colors.black,
                                //             fontSize: 16,
                                //             fontWeight: FontWeight.w600),
                                //         iconEnabledColor: Colors.white,
                                //         items: _items.map<DropdownMenuItem<String>>(
                                //                 (String value) {
                                //               return DropdownMenuItem<String>(
                                //                 value: value,
                                //                 child: Text(value),
                                //               );
                                //             }).toList(),
                                //         selectedItemBuilder: (BuildContext context) =>
                                //             _items
                                //                 .map((e) => Center(
                                //               child: Text(
                                //                 e,
                                //                 style: TextStyle(
                                //                     fontSize: 18,
                                //                     color: Colors.white,
                                //                     fontWeight: FontWeight.bold),
                                //               ),
                                //             ))
                                //                 .toList(),
                                //         underline: Container(),
                                //         // hint: Text(
                                //         //   "Please choose a service",
                                //         //   style: TextStyle(
                                //         //       fontSize: 18,
                                //         //       color: Colors.white,
                                //         //       fontWeight: FontWeight.bold),
                                //         // ),
                                //         // icon: Icon(
                                //         //   Icons.arrow_downward,
                                //         //   color: Colors.yellow,
                                //         // ),
                                //         // isExpanded: true,
                                //         onChanged: (String value) {
                                //           setState(() {
                                //             _chosenValue = value;
                                //           });
                                //         }),
                                //   ),
                                // ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: 360,
                                  child: Center(
                                    child: DropdownButton<String>(
                                        value: _cityvalue,
                                        hint: Center(
                                          child: Text(
                                            "City:  " +
                                                snapshot.data.data.the0.city
                                                    .toString(),
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        // elevation: 5,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                        iconEnabledColor: Colors.white,
                                        items: _city
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                        selectedItemBuilder:
                                            (BuildContext context) => _city
                                                .map((e) => Center(
                                                      child: Text(
                                                        e,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ))
                                                .toList(),
                                        underline: Container(),
                                        // hint: Text(
                                        //   "Please choose a service",
                                        //   style: TextStyle(
                                        //       fontSize: 18,
                                        //       color: Colors.white,
                                        //       fontWeight: FontWeight.bold),
                                        // ),
                                        // icon: Icon(
                                        //   Icons.arrow_downward,
                                        //   color: Colors.yellow,
                                        // ),
                                        // isExpanded: true,
                                        onChanged: (String value) {
                                          setState(() {
                                            _cityvalue = value;
                                          });
                                        }),
                                  ),
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0, 2),
                                          blurRadius: 2.0)
                                    ],
                                    color: secondaryColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  child: TextFormField(
                                    decoration: ThemeHelper()
                                        .textInputDecoration(
                                            snapshot.data.data.the0.zipCode, 'Enter your zip code'),
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: TextFormField(
                                    decoration: ThemeHelper()
                                        .textInputDecoration(snapshot.data.data.the0.streetAddress,
                                            'Street address or P.O box'),
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                SizedBox(height: 5.0),
                                Container(
                                  child: TextFormField(
                                    decoration: ThemeHelper()
                                        .textInputDecoration(snapshot.data.data.the0.building,
                                            "Apt,Suite,Unit,Building,Floor,etc"),
                                  ),
                                  decoration:
                                      ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                SizedBox(height: 20.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox.fromSize(
                                      size: Size(
                                          70, 70), // button width and height
                                      child: ClipOval(
                                        child: Material(
                                          color: primaryColor, // button color
                                          child: InkWell(
                                            splashColor:
                                                secondaryColor, // splash color
                                            onTap: () {}, // button pressed
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.save,
                                                  color: Colors.white,
                                                ), // icon
                                                Text(
                                                  "Save",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ), // text
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          )),
        ],
      ),
    );
  }
}
