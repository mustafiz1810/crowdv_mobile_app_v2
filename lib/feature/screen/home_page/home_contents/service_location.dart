import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceLocation extends StatefulWidget {
  final country,state,city,zip;
  ServiceLocation({this.country,this.state,this.city,this.zip});

  @override
  _ServiceLocationState createState() => _ServiceLocationState();
}

class _ServiceLocationState extends State<ServiceLocation> {
  String token = "";

  @override
  void initState() {
    widget.country == null?countryvalue =widget.country:countryvalue = widget.country.toString();
    widget.state == null?statevalue =widget.state:statevalue = widget.state.toString();
    widget.city == null?cityvalue =widget.city:cityvalue = widget.city.toString();
    widget.zip != null
        ? zipController.text = widget.zip
        : zipController.text = "";
    super.initState();
    getCred();
    getCountry();
    widget.state != null?getState(widget.country):"";
    widget.city != null?getCity(widget.state):"";
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
    });
  }

  TextEditingController zipController = TextEditingController();
  void set(String country,state, city, zip_code) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'set-location'),
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          },
          body: {
            'service_country_id': country,
            'service_state_id': state,
            'service_city_id': city,
            'service_zip_code': zip_code,
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        showToast(context, data['message']);
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
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

  List countries = [];
  Future getCountry() async {
    var baseUrl = NetworkConstants.BASE_URL + 'countries';

    Response response = await get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      setState(() {
        countries = jsonData['data'];
      });
    }
  }
  List states = [];
  Future getState(countryId) async {
    var baseUrl = NetworkConstants.BASE_URL + 'get-state-by-country/$countryId';

    Response response = await get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      setState(() {
        states = jsonData['data'];
      });
    }
  }
  List city = [];
  Future getCity(stateId) async {
    var baseUrl = NetworkConstants.BASE_URL + 'get-city-by-state/$stateId';

    Response response = await get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      setState(() {
        city = jsonData['data'];
      });
    }
  }
  var countryvalue;
  var statevalue;
  var cityvalue;
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
                height: 23,
              ),
              FormField<String>(
                builder: (FormFieldState<String>
                state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      hintText: "Country",
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
                    child: Center(
                      child: DropdownButton(
                        hint: Text('Country',style:TextStyle(fontWeight: FontWeight.bold)),
                        underline: SizedBox(),
                        iconEnabledColor:
                        Colors.black,
                        isExpanded: true,
                        items: countries.map((item) {
                          return DropdownMenuItem(
                            value: item['id'].toString(),
                            child: Text(item['name'].toString()),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            states.clear();
                            statevalue = null;
                            city.clear();
                            cityvalue = null;
                            countryvalue = newVal;
                            getState(newVal);
                          });
                          print(countryvalue);
                        },
                        value: countryvalue,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 23,
              ),
              FormField<String>(
                builder: (FormFieldState<String>
                state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      hintText: "Division/Province/State",
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
                    child: Center(
                      child: DropdownButton(
                        hint: Text("Division/Province/State",
                            style: TextStyle(
                                fontWeight: FontWeight.bold)),
                        underline: SizedBox(),
                        iconEnabledColor:
                        Colors.black,
                        isExpanded: true,
                        items: states.map((item) {
                          return DropdownMenuItem(
                            value: item['id'].toString(),
                            child: Text(item['name'].toString()),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            city.clear();
                            cityvalue = null;
                            statevalue = newVal;
                            getCity(newVal);
                          });
                          print(statevalue);
                        },
                        value: statevalue,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 23,
              ),
              FormField<String>(
                builder: (FormFieldState<String>
                state) {
                  return InputDecorator(
                    decoration: InputDecoration(
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
                    child: Center(
                      child: DropdownButton(
                        hint: Text('City',style:TextStyle(fontWeight: FontWeight.bold)),
                        underline: SizedBox(),
                        iconEnabledColor:
                        Colors.black,
                        isExpanded: true,
                        items: city.map((item) {
                          return DropdownMenuItem(
                            value: item['id'].toString(),
                            child: Text(item['name'].toString()),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            cityvalue = newVal;
                          });
                          print(cityvalue);
                        },
                        value: cityvalue,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 23,
              ),
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
                          set(
                            countryvalue.toString(),
                              statevalue.toString(),
                              cityvalue.toString(),
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