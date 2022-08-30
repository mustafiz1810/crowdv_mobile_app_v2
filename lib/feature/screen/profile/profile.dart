import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/data/models/profile_model.dart';
import 'package:crowdv_mobile_app/feature/screen/profile/profile_update_basic.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final data,
      role,
      disability,
      chosenValue,
      dropdown,
      selectedCountry,
      selectedProvince,
      zip;
  ProfilePage(
      {this.data,
      this.role,
      this.disability,
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
  bool isCheck = false;
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
  List<String> FloridaProvince = ['Jacksonville', 'Tallahassee'];
  List<String> IllinoisProvince = ['Addison', 'Algonquin', 'Alton','Arlington Heights','Aurora','Bartlett','Batavia','Belleville','Belvidere','Berwyn','Bloomington','Bolingbrook','Buffalo Grove','Chicago',];
  List<String> KansasProvince = ['Topeka', 'Wichita'];
  List<String> KentuckyProvince = ['Frankfort', 'Louisville'];
  List<String> LouisianaProvince = ['Baton Rouge', 'New Orleans'];
  List<String> provinces = [];

  List<dynamic> array = [];

  void _answerQuestion(int id) {
    if (array.contains(id)) {
      array.remove(id);
    } else {
      array.add(id);
    }
  }

  void initState() {
    super.initState();
    getCred();
    array = widget.disability;
    // print(array);
    widget.selectedCountry == null
        ? selectedCountry = "Alabama"
        : selectedCountry = widget.selectedCountry;
    widget.selectedProvince == null
        ? selectedProvince = "Birmingham"
        : selectedProvince = widget.selectedProvince;
    widget.zip == null
        ? zipController.text = ""
        : zipController.text = widget.zip;
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

  void set(List<dynamic> disable) async {
    String body = json.encode({
      'type_of_disability': disable,
    });
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'profile/update?type=service'),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          },
          body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        setState(() {});
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
        setState(() {});
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
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          elevation: 0.5,
          iconTheme: IconThemeData(color: Colors.black),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
        body: FutureBuilder<ProfileModel>(
          future: getProfileApi(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: [
                        Stack(children: [
                          Container(
                            height: 95,
                            child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              backgroundImage:
                                  NetworkImage(snapshot.data.data.image),
                              radius: 46,
                            ),
                          ),
                          Positioned(
                            top: 49,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage:NetworkImage(snapshot.data.data.membership.icon),
                              radius: 22,
                            )
                          )
                        ]),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          snapshot.data.data.firstName +
                              " " +
                              snapshot.data.data.lastName,
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 13,
                            ),
                            Text(
                              snapshot.data.data.state != null
                                  ? snapshot.data.data.state
                                  : "",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  snapshot.data.data.opportunities.toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                Text(
                                  "Opportunity",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      snapshot.data.data.rating.toString(),
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
                                Text(
                                  "Rating",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(snapshot.data.data.workingHours.toString(),
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                                Text("Working Hour",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black)),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 10,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: 10,
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
                                    icon: Icon(Icons.wheelchair_pickup_rounded),
                                    child: const Text('Disabilities')),
                                Tab(
                                    icon: Icon(Icons.phone),
                                    child: const Text('Contact')),
                              ],
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.black38,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Color(0xFFfaf9f9),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black38,
                                    blurRadius: 2,
                                    offset: Offset(
                                        1, 1), // changes position of shadow
                                  ),
                                ],
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
                                        child: SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
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
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          ProfileUpdate(
                                                                            token:
                                                                                token,
                                                                            fname:
                                                                                snapshot.data.data.firstName,
                                                                            lname:
                                                                                snapshot.data.data.lastName,
                                                                            email:
                                                                                snapshot.data.data.email,
                                                                            phone:
                                                                                snapshot.data.data.phone,
                                                                            dob:
                                                                                snapshot.data.data.dob,
                                                                            prof:
                                                                                snapshot.data.data.profession,
                                                                            gender:
                                                                                snapshot.data.data.gender,
                                                                          )),
                                                            ).then((value) =>
                                                                setState(
                                                                    () {}));
                                                          },
                                                          child: Icon(
                                                            Icons.edit,
                                                            color: Colors.black,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                                ...ListTile.divideTiles(
                                                  color: Colors.grey,
                                                  tiles: [
                                                    ListTile(
                                                      leading: Icon(Icons
                                                          .person_outline_rounded),
                                                      title: Text("Name:"),
                                                      subtitle: Text(
                                                        snapshot.data.data
                                                                .firstName
                                                                .toString() +
                                                            " " +
                                                            snapshot.data.data
                                                                .lastName,
                                                      ),
                                                    ),
                                                    ListTile(
                                                      leading: Icon(
                                                          Icons.email_outlined),
                                                      title: Text("Email:"),
                                                      subtitle: Text(snapshot
                                                          .data.data.email),
                                                    ),
                                                    ListTile(
                                                      leading: Icon(Icons
                                                          .phone_android_rounded),
                                                      title: Text("Phone:"),
                                                      subtitle: Text(snapshot
                                                          .data.data.phone),
                                                    ),
                                                    ListTile(
                                                        leading: Icon(Icons
                                                            .date_range_rounded),
                                                        title: Text(
                                                            "Date of Birth:"),
                                                        subtitle: Text(
                                                            DateFormat.yMMMd()
                                                                .format(snapshot
                                                                    .data
                                                                    .data
                                                                    .dob))),
                                                    ListTile(
                                                        leading: Icon(Icons
                                                            .work_outline_rounded),
                                                        title:
                                                            Text("Profession:"),
                                                        subtitle: Text(snapshot
                                                                    .data
                                                                    .data
                                                                    .profession !=
                                                                null
                                                            ? snapshot.data.data
                                                                .profession
                                                            : "")),
                                                    ListTile(
                                                        leading:
                                                            Icon(Icons.male),
                                                        title: Text("Gender:"),
                                                        subtitle: Text(snapshot
                                                                    .data
                                                                    .data
                                                                    .gender !=
                                                                null
                                                            ? snapshot.data.data
                                                                .gender
                                                            : "")),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 15, right: 15, top: 10),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount: widget.data.length,
                                                itemBuilder: (context, index) {
                                                  return Card(
                                                      child:
                                                          new CheckboxListTile(
                                                              activeColor:
                                                                  primaryColor,
                                                              dense: true,
                                                              //font change
                                                              title: new Text(
                                                                widget.data[
                                                                        index]
                                                                    ["title"],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    letterSpacing:
                                                                        0.5),
                                                              ),
                                                              value: array.contains(
                                                                      widget.data[
                                                                              index]
                                                                          [
                                                                          "id"])
                                                                  ? true
                                                                  : widget.data[
                                                                          index]
                                                                      [
                                                                      "is_check"],
                                                              onChanged:
                                                                  (bool value) {
                                                                setState(() {
                                                                  widget.data[
                                                                          index]
                                                                      [
                                                                      "is_check"] = value;
                                                                  _answerQuestion(
                                                                      widget.data[
                                                                              index]
                                                                          [
                                                                          "id"]);
                                                                });
                                                              }));
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              height: 50,
                                              width: 300,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary: primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              13)),
                                                ),
                                                onPressed: () {
                                                  set(array);
                                                },
                                                child: Center(
                                                  child: Text(
                                                    "Save",
                                                    style: GoogleFonts.kanit(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(18),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 20,
                                              ),
                                              FormField<String>(
                                                builder: (FormFieldState<String>
                                                    state) {
                                                  return InputDecorator(
                                                    decoration: InputDecoration(
                                                      labelText: "State",
                                                      hintText: "State",
                                                      fillColor: Colors.white,
                                                      labelStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      filled: true,
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              20, 10, 20, 10),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .black)),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .black)),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .red,
                                                                      width:
                                                                          2.0)),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .red,
                                                                      width:
                                                                          2.0)),
                                                    ),
                                                    isEmpty:
                                                        selectedCountry == '',
                                                    child: Center(
                                                      child: DropdownButton<String>(
                                                        hint: Center(
                                                          child: Text(
                                                            "Select Country",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors.black,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ),
                                                        underline: SizedBox(),
                                                        iconEnabledColor:
                                                        Colors.black,
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
                                                                            color: Colors.black,
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
                                                  );
                                                },
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              FormField<String>(
                                                builder: (FormFieldState<String>
                                                    state) {
                                                  return InputDecorator(
                                                    decoration: InputDecoration(
                                                      labelText: "City",
                                                      hintText: "City",
                                                      fillColor: Colors.white,
                                                      labelStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      filled: true,
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              20, 10, 20, 10),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .black)),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .black)),
                                                      errorBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .red,
                                                                      width:
                                                                          2.0)),
                                                      focusedErrorBorder:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12.0),
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .red,
                                                                      width:
                                                                          2.0)),
                                                    ),
                                                    isEmpty:
                                                        selectedProvince == '',
                                                    child: Center(
                                                      child: DropdownButton<
                                                          String>(
                                                        hint: Center(
                                                          child: Text(
                                                            snapshot.data.data
                                                                        .city !=
                                                                    null
                                                                ? snapshot.data
                                                                    .data.city
                                                                : "Select City",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        underline: SizedBox(),
                                                        iconEnabledColor:
                                                            Colors.black,
                                                        value: selectedProvince,
                                                        isExpanded: true,
                                                        items: provinces.map(
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
                                                                provinces
                                                                    .map((e) =>
                                                                        Center(
                                                                          child:
                                                                              Text(
                                                                            e,
                                                                            style: TextStyle(
                                                                                fontSize: 18,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ))
                                                                    .toList(),
                                                        onChanged: (province) {
                                                          setState(() {
                                                            selectedProvince =
                                                                province;
                                                            print(
                                                                selectedProvince
                                                                    .toString());
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              SizedBox(height: 20),
                                              Container(
                                                child: TextFormField(
                                                  keyboardType: TextInputType.number,
                                                  controller: zipController,
                                                  decoration: ThemeHelper()
                                                      .textInputDecoration(
                                                          'Zip Code',
                                                          'Enter your zip code'),
                                                ),
                                                decoration: ThemeHelper()
                                                    .inputBoxDecorationShaddow(),
                                              ),
                                              SizedBox(height: 35),
                                              SizedBox(
                                                height: 50,
                                                width: 300,
                                                child: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: primaryColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        13)),
                                                  ),
                                                  onPressed: () {
                                                    location(
                                                        selectedCountry,
                                                        selectedProvince,
                                                        zipController.text
                                                            .toString());
                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      "Save",
                                                      style: GoogleFonts.kanit(
                                                          color: Colors.white,
                                                          fontSize: 16),
                                                    ),
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
