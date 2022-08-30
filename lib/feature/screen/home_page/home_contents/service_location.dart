import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceLocation extends StatefulWidget {
  final country,city,zip;
  ServiceLocation({this.country,this.city,this.zip});

  @override
  _ServiceLocationState createState() => _ServiceLocationState();
}

class _ServiceLocationState extends State<ServiceLocation> {
  String token = "";

  @override
  void initState() {
    widget.country != null?selectedCountry=widget.country:selectedCountry="Alabama";
    // widget.city != null ? selectedProvince=widget.city:selectedProvince="Birmingham";
    widget.zip != null ? zipController.text=widget.zip:zipController.text="";
    super.initState();
    getCred();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
    });
  }

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
  String selectedCountry;
  String selectedProvince;
  TextEditingController zipController = TextEditingController();
  void set(String state, city, zip_code) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'set-location'),
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          },
          body: {
            'service_state': state,
            'service_city': city,
            'service_zip_code': zip_code,
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        // collapsedHeight: 150,
        title: const Text(
          'Set Location',
          style: TextStyle(color: Colors.white),
        ),
        // ),
        // centerTitle: true,
        backgroundColor: primaryColor,
        // pinned: true,
        // floating: true,
        // forceElevated: innerBoxIsScrolled,
      ),
      body: Container(
        padding: EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: "State",
                      hintText: "State",
                      fillColor: Colors.white,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      filled: true,
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.black)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.black)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          BorderSide(color: Colors.red, width: 2.0)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          BorderSide(color: Colors.red, width: 2.0)),
                    ),
                    isEmpty: selectedCountry == '',
                    child:  Center(
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
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: "City",
                      hintText: "City",
                      fillColor: Colors.white,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      filled: true,
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.black)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.black)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          BorderSide(color: Colors.red, width: 2.0)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          BorderSide(color: Colors.red, width: 2.0)),
                    ),
                    isEmpty: selectedProvince == '',
                    child:  Center(
                      child: DropdownButton<String>(
                        hint: Center(
                          child: Text(
                            widget.city != null?widget.city:"Select City",
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
                                            color: Colors.black,
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
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox.fromSize(
                    size: Size(250, 50), // button width and height
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      color: primaryColor, // button color
                      child: InkWell(
                        splashColor: secondaryColor, // splash color
                        onTap: () {
                          // setState(() {
                          //   print(selectedCountry.toString() +
                          //       "  " +
                          //       selectedProvince.toString() +
                          //       "  " +
                          //       zipController.text.toString());
                          // });
                          set(
                              selectedCountry.toString(),
                              selectedProvince.toString(),
                              zipController.text.toString());
                        }, // button pressed
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.create,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ), // icon
                            Text(
                              "Set Location",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ), // text
                          ],
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
    );
  }
}
