import 'dart:convert';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/data/models/profile_model.dart';
import 'package:crowdv_mobile_app/feature/screen/profile/profile_update_basic.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/header_without_logo.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final disability, chosenValue, dropdown, selectedCountry, selectedProvince,zip;
  ProfilePage(
      {this.disability,
      this.chosenValue,
      this.dropdown,
      this.selectedProvince,
      this.selectedCountry,
      this.zip});
  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  String token = "";
  String disability;
  String _profession;
  String _gender;
  String selectedCountry;
  String selectedProvince;
  List<String> countries = [
    'Alabama',
    'Alaska',
    'California',
    'Connecticut',
    'Delaware',
    'Florida',
    'Illinois',
    'Kansas',
    'Kentucky',
    'Louisiana'
  ];
  List<String> AlabamaProvince = ['Birmingham', 'Montgomery'];
  List<String> AlaskaProvince = [
    'Anchorage',
    'Juneau',
  ];
  List<String> CaliforniaProvince = ['Los Angeles', 'Sacramento'];
  List<String> ConnecticutProvince = ['Bridgeport', 'Hartford'];
  List<String> DelawareProvince = ['Dover', 'Wilmington'];
  List<String> FloridaProvince = ['Anchorage', 'Juneau', 'California'];
  List<String> IllinoisProvince = ['Anchorage', 'Juneau', 'California'];
  List<String> KansasProvince = ['Anchorage', 'Juneau', 'California'];
  List<String> KentuckyProvince = ['Anchorage', 'Juneau', 'California'];
  List<String> LouisianaProvince = ['Anchorage', 'Juneau', 'California'];
  List<String> provinces = [];
  List<String> _disability = ["Blind"];
  List<String> _items = ["Business", "Student", "Service", "Self-employer"];
  List<String> _item = ["Male", "female"];
  @override
  void initState() {
    super.initState();
    getCred();
    widget.disability == null
        ? disability = "Blind"
        : disability = widget.disability;
    widget.chosenValue == null
        ? _profession = "Business"
        : _profession = widget.chosenValue;
    widget.dropdown == null ? _gender = "Male" : _gender = widget.dropdown;
    widget.selectedCountry == "unknown"
        ? selectedCountry = "Alabama"
        : selectedCountry = widget.selectedCountry;
    widget.selectedProvince == "unknown"
        ? selectedProvince = "Birmingham"
        : selectedProvince = widget.selectedProvince;
    widget.zip==null?zipController.text="12345":zipController.text=widget.zip;
    print(zipController.text);
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
    });
  }

  Future<ProfileModel> getProfileApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'profile'),
        headers: {"Authorization": "Bearer $token"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return ProfileModel.fromJson(data);
    } else {
      return ProfileModel.fromJson(data);
    }
  }

  void set(String gender, disable, prof) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'profile/update?type=service'),
          headers: {
            "Authorization": "Bearer $token"
          },
          body: {
            'gender': gender,
            'type_of_disability': disable,
            'profession': prof,
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        showToast(context, data['message']);
      } else {
        var data = jsonDecode(response.body.toString());
        showToast(context, data['message'].toString());
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Exception:"),
              content: Text(e.toString()),
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

  void location(String state, city, zip_code) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'profile/update?type=contacts'),
          headers: {
            "Authorization": "Bearer $token"
          },
          body: {
            'state': state,
            'city': city,
            'zip_code': zip_code,
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        showToast(context, data['message']);
      } else {
        var data = jsonDecode(response.body.toString());
        showToast(context, data['message'].toString());
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Exception:"),
              content: Text(e.toString()),
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

  TextEditingController zipController = TextEditingController();
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
        body: FutureBuilder<ProfileModel>(
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
                        height: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          color: primaryColor,
                        ),
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
                                  border:
                                      Border.all(width: 5, color: Colors.white),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 20,
                                      offset: const Offset(5, 5),
                                    ),
                                  ],
                                ),
                                child: Image.network(snapshot.data.data.image),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                snapshot.data.data.firstName +
                                    " " +
                                    snapshot.data.data.lastName,
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                snapshot.data.data.email,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
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
                  Expanded(
                    child: DefaultTabController(
                      length: 3,
                      child: CustomScrollView(
                        slivers: <Widget>[
                          SliverToBoxAdapter(
                            child: TabBar(
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
                          ),
                          SliverFillRemaining(
                            child: Column(
                              children: [
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.only(left: 5, right: 5),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0, bottom: 4.0),
                                              alignment: Alignment.topLeft,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "User Information",
                                                    style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  IconBox(
                                                    child: Icon(
                                                      Icons.create,
                                                      color: Colors.white,
                                                    ),
                                                    bgColor: Colors.lightBlue,
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ProfileUpdate(
                                                                  token: token,
                                                                  fname: snapshot
                                                                      .data
                                                                      .data
                                                                      .firstName,
                                                                  lname: snapshot
                                                                      .data
                                                                      .data
                                                                      .lastName,
                                                                  email: snapshot
                                                                      .data
                                                                      .data
                                                                      .email,
                                                                  phone: snapshot
                                                                      .data
                                                                      .data
                                                                      .phone,
                                                                  dob: snapshot
                                                                      .data
                                                                      .data
                                                                      .dob,
                                                                )),
                                                      ).then((value) =>
                                                          setState(() {}));
                                                    },
                                                  ),
                                                ],
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
                                                                      horizontal:
                                                                          12,
                                                                      vertical:
                                                                          4),
                                                              leading: Icon(
                                                                  Icons.person),
                                                              title:
                                                                  Text("Name:"),
                                                              subtitle: Text(
                                                                snapshot
                                                                        .data
                                                                        .data
                                                                        .firstName
                                                                        .toString() +
                                                                    " " +
                                                                    snapshot
                                                                        .data
                                                                        .data
                                                                        .lastName,
                                                              ),
                                                            ),
                                                            ListTile(
                                                              leading: Icon(
                                                                  Icons.email),
                                                              title: Text(
                                                                  "Email:"),
                                                              subtitle: Text(
                                                                  snapshot
                                                                      .data
                                                                      .data
                                                                      .email),
                                                            ),
                                                            ListTile(
                                                              leading: Icon(
                                                                  Icons.phone),
                                                              title: Text(
                                                                  "Phone:"),
                                                              subtitle: Text(
                                                                  snapshot
                                                                      .data
                                                                      .data
                                                                      .phone),
                                                            ),
                                                            ListTile(
                                                                leading: Icon(
                                                                    Icons
                                                                        .person),
                                                                title: Text(
                                                                    "Date of Birth:"),
                                                                subtitle: Text(DateFormat
                                                                        .yMMMd()
                                                                    .format(snapshot
                                                                        .data
                                                                        .data
                                                                        .dob))),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            snapshot.data.data.role ==
                                                    "recruiter"
                                                ? Container(
                                                    width: 300,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5,
                                                            horizontal: 15),
                                                    decoration: BoxDecoration(
                                                        color: primaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                    child: Center(
                                                      child: DropdownButton<
                                                              String>(
                                                          hint: Center(
                                                              child: Text(
                                                            "Disability:  " +
                                                                snapshot
                                                                    .data
                                                                    .data
                                                                    .typeOfDisability
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )),
                                                          value: disability,
                                                          // elevation: 5,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          iconEnabledColor:
                                                              Colors.white,
                                                          items: _disability.map<
                                                                  DropdownMenuItem<
                                                                      String>>(
                                                              (String value) {
                                                            return DropdownMenuItem<
                                                                String>(
                                                              value: value,
                                                              child:
                                                                  Text(value),
                                                            );
                                                          }).toList(),
                                                          selectedItemBuilder:
                                                              (BuildContext context) =>
                                                                  _disability
                                                                      .map((e) =>
                                                                          Center(
                                                                            child:
                                                                                Text(
                                                                              e,
                                                                              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ))
                                                                      .toList(),
                                                          underline:
                                                              Container(),
                                                          onChanged:
                                                              (String value) {
                                                            setState(() {
                                                              disability =
                                                                  value;
                                                            });
                                                          }),
                                                    ),
                                                  )
                                                : Container(),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: 300,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 15),
                                              decoration: BoxDecoration(
                                                  color: secondaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: Center(
                                                child: DropdownButton<String>(
                                                    hint: Center(
                                                      child: Text(
                                                        _profession,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    value: _profession,
                                                    // elevation: 5,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    iconEnabledColor:
                                                        Colors.white,
                                                    items: _items.map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                    selectedItemBuilder:
                                                        (BuildContext
                                                                context) =>
                                                            _items
                                                                .map(
                                                                    (e) =>
                                                                        Center(
                                                                          child:
                                                                              Text(
                                                                            e,
                                                                            style: TextStyle(
                                                                                fontSize: 18,
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.bold),
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
                                                        _profession = value;
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
                                                  color: primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: Center(
                                                child: DropdownButton<String>(
                                                    value: _gender,
                                                    hint: Center(
                                                      child: Text(
                                                        _gender,
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    // elevation: 5,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    iconEnabledColor:
                                                        Colors.white,
                                                    items: _item.map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                    selectedItemBuilder:
                                                        (BuildContext
                                                                context) =>
                                                            _item
                                                                .map(
                                                                    (value) =>
                                                                        Center(
                                                                          child:
                                                                              Text(
                                                                            value,
                                                                            style: TextStyle(
                                                                                fontSize: 18,
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ))
                                                                .toList(),
                                                    underline: Container(),
                                                    onChanged: (String value) {
                                                      setState(() {
                                                        _gender = value;
                                                      });
                                                    }),
                                              ),
                                            ),
                                            SizedBox(height: 70),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                SizedBox.fromSize(
                                                  size: Size(70,
                                                      70), // button width and height
                                                  child: ClipOval(
                                                    child: Material(
                                                      color:
                                                          primaryColor, // button color
                                                      child: InkWell(
                                                        splashColor:
                                                            secondaryColor, // splash color
                                                        onTap: () {
                                                          set(
                                                              _gender,
                                                              disability,
                                                              _profession);
                                                        }, // button pressed
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.save,
                                                              color:
                                                                  Colors.white,
                                                            ), // icon
                                                            Text(
                                                              "Save",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
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
                                        padding: EdgeInsets.all(18),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 360,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2,
                                                    horizontal: 15),
                                                decoration: BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: Center(
                                                  child: DropdownButton<String>(
                                                    hint: Center(
                                                      child: Text(
                                                        "selectedCountry",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    underline: SizedBox(),
                                                    iconEnabledColor:
                                                        Colors.white,
                                                    value: selectedCountry,
                                                    isExpanded: true,
                                                    items: countries
                                                        .map((String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                    selectedItemBuilder:
                                                        (BuildContext
                                                                context) =>
                                                            countries
                                                                .map(
                                                                    (e) =>
                                                                        Center(
                                                                          child:
                                                                              Text(
                                                                            e,
                                                                            style: TextStyle(
                                                                                fontSize: 18,
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ))
                                                                .toList(),
                                                    onChanged: (country) {
                                                      if (country ==
                                                          'Alabama') {
                                                        provinces =
                                                            AlabamaProvince;
                                                      } else if (country ==
                                                          'Alaska') {
                                                        provinces =
                                                            AlaskaProvince;
                                                      } else if (country ==
                                                          'California') {
                                                        provinces =
                                                            CaliforniaProvince;
                                                      } else if (country ==
                                                          'Connecticut') {
                                                        provinces =
                                                            ConnecticutProvince;
                                                      } else if (country ==
                                                          'Delaware') {
                                                        provinces =
                                                            DelawareProvince;
                                                      } else if (country ==
                                                          'Florida') {
                                                        provinces =
                                                            FloridaProvince;
                                                      } else if (country ==
                                                          'Illinois') {
                                                        provinces =
                                                            IllinoisProvince;
                                                      } else if (country ==
                                                          'Kansas') {
                                                        provinces =
                                                            KansasProvince;
                                                      } else if (country ==
                                                          'Kentucky') {
                                                        provinces =
                                                            KentuckyProvince;
                                                      } else if (country ==
                                                          'Louisiana') {
                                                        provinces =
                                                            LouisianaProvince;
                                                      } else {
                                                        provinces = [];
                                                      }
                                                      setState(() {
                                                        selectedProvince = null;
                                                        selectedCountry =
                                                            country;
                                                        print(selectedCountry
                                                            .toString());
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                width: 360,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 1,
                                                    horizontal: 15),
                                                decoration: BoxDecoration(
                                                    color: secondaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: Center(
                                                  child: DropdownButton<String>(
                                                    hint: Center(
                                                      child: Text(
                                                        'selectedProvince',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                    underline: SizedBox(),
                                                    iconEnabledColor:
                                                        Colors.white,
                                                    value: selectedProvince,
                                                    isExpanded: true,
                                                    items: provinces
                                                        .map((String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                    selectedItemBuilder:
                                                        (BuildContext
                                                                context) =>
                                                            provinces
                                                                .map(
                                                                    (e) =>
                                                                        Center(
                                                                          child:
                                                                              Text(
                                                                            e,
                                                                            style: TextStyle(
                                                                                fontSize: 18,
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ))
                                                                .toList(),
                                                    onChanged: (province) {
                                                      setState(() {
                                                        selectedProvince =
                                                            province;
                                                        print(selectedProvince
                                                            .toString());
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Container(
                                                child: TextFormField(
                                                  controller: zipController,
                                                  decoration: ThemeHelper()
                                                      .textInputDecoration(
                                                          'Zip Code',
                                                          'Enter your zip code'),
                                                ),
                                                decoration: ThemeHelper()
                                                    .inputBoxDecorationShaddow(),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  SizedBox.fromSize(
                                                    size: Size(70,
                                                        70), // button width and height
                                                    child: ClipOval(
                                                      child: Material(
                                                        color:
                                                            primaryColor, // button color
                                                        child: InkWell(
                                                          splashColor:
                                                              secondaryColor, // splash color
                                                          onTap: () {
                                                            location(
                                                                selectedCountry,
                                                                selectedProvince,
                                                                zipController
                                                                    .text
                                                                    .toString());
                                                          }, // button pressed
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Icon(
                                                                Icons.save,
                                                                color: Colors
                                                                    .white,
                                                              ), // icon
                                                              Text(
                                                                "Save",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
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
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
