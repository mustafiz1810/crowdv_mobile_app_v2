import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_page.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpLocation extends StatefulWidget {
  final List<int> answer;
  final dynamic title,
      category,
      type,
      description,
      date,
      time,
      etime;
  OpLocation(
      {@required
      this.answer,
      this.title,
      this.category,
      this.type,
      this.description,
      this.date,
      this.time,
      this.etime});

  @override
  _OpLocationState createState() => _OpLocationState();
}

class _OpLocationState extends State<OpLocation> {
  String token = "";

  @override
  void initState() {
    super.initState();
    getCred();
    getCountry();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
    });
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
  TextEditingController zipController = TextEditingController();
  void create(title, category_id, date, start_time, end_time,country, state,
      city, List<int> answer, details, task_type, zip_code) async {
    String body = json.encode({ 'title': title,
      'category_id': category_id,
      'date': date,
      'start_time': start_time,
      'end_time': end_time,
      'eligibility_id': answer ,
      'details': details,
      'task_type': task_type,
      'country_id': country,
      'state_id': state,
      'city_id': city,
      'zip_code': zip_code,
      'is_public': 'true',});
    print(body);
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'opportunity/store'),
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json"
          },
          body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // print(data);
        showToast(context, data['message']);
        int count = 0;
        Navigator.popUntil(context, (route) => count++ == 3);
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
        showToast(context, data['errors'].toString());
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Exception:"),
              content: Text(e.toString()),
              actions: [
                TextButton(
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
  bool isStateVisible = false;
  bool isCityVisible = false;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                          isStateVisible = true;
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
              height: 10,
            ),
            Visibility(
              visible: isStateVisible,
              child:  FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      hintText: "Division/Province/State",
                      fillColor: Colors.white,
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold),
                      filled: true,
                      contentPadding:
                      EdgeInsets.fromLTRB(20, 10, 20, 10),
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12.0),
                          borderSide:
                          BorderSide(color: Colors.black)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12.0),
                          borderSide:
                          BorderSide(color: Colors.black)),
                      errorBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                              color: Colors.red, width: 2.0)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                              color: Colors.red, width: 2.0)),
                    ),
                    child: Center(
                      child: DropdownButton(
                        hint: Text("Division/Province/State",
                            style: TextStyle(
                                fontWeight: FontWeight.bold)),
                        underline: SizedBox(),
                        iconEnabledColor: Colors.black,
                        isExpanded: true,
                        items: states.map((item) {
                          return DropdownMenuItem(
                            value: item['id'].toString(),
                            child:
                            Text(item['name'].toString()),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            city.clear();
                            cityvalue = null;
                            statevalue = newVal;
                            getCity(newVal);
                            isCityVisible = true;
                          });
                          print(statevalue);
                        },
                        value: statevalue,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: isCityVisible,
              child: FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      hintText: "City",
                      fillColor: Colors.white,
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold),
                      filled: true,
                      contentPadding:
                      EdgeInsets.fromLTRB(20, 10, 20, 10),
                      focusedBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12.0),
                          borderSide:
                          BorderSide(color: Colors.black)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12.0),
                          borderSide:
                          BorderSide(color: Colors.black)),
                      errorBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                              color: Colors.red, width: 2.0)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius:
                          BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                              color: Colors.red, width: 2.0)),
                    ),
                    child: Center(
                      child: DropdownButton(
                        hint: Text('City',
                            style: TextStyle(
                                fontWeight: FontWeight.bold)),
                        underline: SizedBox(),
                        iconEnabledColor: Colors.black,
                        isExpanded: true,
                        items: city.map((item) {
                          return DropdownMenuItem(
                            value: item['id'].toString(),
                            child:
                            Text(item['name'].toString()),
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
            ),
            SizedBox(
              height: 10,
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
            SizedBox(height: 20),
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
                        create(
                            widget.title,
                            widget.category,
                            widget.date,
                            widget.time,
                            widget.etime,
                            countryvalue.toString(),
                            statevalue.toString(),
                            cityvalue.toString(),
                            widget.answer,
                            widget.description,
                            widget.type,
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
                            "Create Opportunity",
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
    );
  }
}
