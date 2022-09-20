import 'dart:convert';
import 'package:crowdv_mobile_app/feature/screen/Recruiter_search/widgets/multi_select_dynamic.dart';
import 'package:crowdv_mobile_app/feature/screen/Recruiter_search/widgets/multi_select_static.dart';
import 'package:crowdv_mobile_app/feature/screen/Volunteer_search/search_volunteer.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import '../../../../utils/view_utils/colors.dart';

class VolunteerFilter extends StatefulWidget {
  final List<dynamic> category;

  VolunteerFilter({this.category});

  @override
  _VolunteerFilterState createState() => _VolunteerFilterState();
}

class _VolunteerFilterState extends State<VolunteerFilter> {
  // DateTime dateTime = null;
  @override
  void initState() {
    super.initState();
    getCountry();
  }

  var countryvalue;
  var statevalue;
  var cityvalue;
  List<int> _selectedCategory = [];
  List<String> _selectedType = [];
  String selectedCountry;
  String selectedProvince;
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

  void _showMultiCategory() async {
    final List<int> results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(
            items: widget.category, selectedItem: _selectedCategory);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedCategory = results;
      });
    }
  }

  void _showMultiProfession() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List<String> _itemsType = [
      "Online",
      "Offline",
    ];

    final List<String> results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectStatic(
            items: _itemsType, selectedItem: _selectedType);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedType = results;
      });
    }
  }

  void _reset() {
    setState(() {
      _selectedCategory.clear();
      _selectedType.clear();
    });
  }

  bool isStateVisible = false;
  bool isCityVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Filter",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: OutlinedButton(
              onPressed: () {
                // print(selectedCountry);
                // print(selectedProvince);
                // print(_selectedCategory.toString());
                // print(_selectedType.toString());
                Get.to(() => VolunteerSearchPage(
                      country: countryvalue.toString(),
                      state: statevalue.toString(),
                      city: cityvalue.toString(),
                      category: _selectedCategory,
                      taskType: _selectedType,
                    ));
              },
              child: Text(
                'Done',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(width: 1.0, color: primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFe9ecef),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Location: ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FormField<String>(
                          builder: (FormFieldState<String> state) {
                            return InputDecorator(
                              decoration: InputDecoration(
                                hintText: "Country",
                                fillColor: Colors.white,
                                labelStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                filled: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(20, 10, 20, 10),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 2.0)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 2.0)),
                              ),
                              child: Center(
                                child: DropdownButton(
                                  hint: Text('Country',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  underline: SizedBox(),
                                  iconEnabledColor: Colors.black,
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
                      ],
                    ),
                  )),
              SizedBox(
                height: 15,
              ),
              Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Category: ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              child: Row(
                                children: [
                                  const Text(
                                    'Select Category',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                              onPressed: _showMultiCategory,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
              SizedBox(
                height: 15,
              ),
              Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Task Type: ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              child: Row(
                                children: [
                                  const Text(
                                    'Select task type',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: Colors.grey,
                                  )
                                ],
                              ),
                              onPressed: _showMultiProfession,
                            ),
                          ],
                        ),
                        // display selected items
                        Wrap(
                          children: _selectedType
                              .map((e) => Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Chip(
                                      label: Text(e),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  )),
              // SizedBox(
              //   height: 15,
              // ),
              // Container(
              //     color: Colors.white,
              //     child: Padding(
              //       padding: const EdgeInsets.all(10.0),
              //       child: Row(
              //         children: [
              //           Text(
              //             "Starting Date: ",
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold,
              //               fontSize: 18,
              //               letterSpacing: 0.27,
              //               color: primaryColor,
              //             ),
              //           ),
              //           InkWell(
              //               onTap: () async {
              //                 final date = await pickDate();
              //                 if (date == null) return;
              //                 final startDate =
              //                 DateTime(date.year, date.month, date.day);
              //                 setState(() {
              //                   dateTime = startDate;
              //                 });
              //               },
              //               child: getTimeBoxUI(
              //                   '${dateTime.year}/${dateTime.month}/${dateTime.day}',
              //                   160)),
              //         ],
              //       ),
              //     )),
              SizedBox(
                height: 15,
              ),
              Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Row(
                            children: [
                              const Text(
                                'Reset',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.repeat,
                                size: 16,
                              )
                            ],
                          ),
                          onPressed: _reset,
                        ),
                      ],
                    ),
                  )),

              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Widget getTimeBoxUI(String text1, double width) {
  //   return Padding(
  //     padding: const EdgeInsets.all(2.0),
  //     child: Container(
  //       width: width,
  //       decoration: BoxDecoration(
  //         color: DesignCourseAppTheme.nearlyWhite,
  //         borderRadius: const BorderRadius.all(Radius.circular(16.0)),
  //         boxShadow: <BoxShadow>[
  //           BoxShadow(
  //               color: DesignCourseAppTheme.grey.withOpacity(0.2),
  //               offset: const Offset(1.1, 1.1),
  //               blurRadius: 8.0),
  //         ],
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.only(
  //             left: 10.0, right: 10.0, top: 12.0, bottom: 12.0),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: <Widget>[
  //             Text(
  //               text1,
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 fontWeight: FontWeight.bold,
  //                 fontSize: 16,
  //                 letterSpacing: 0.27,
  //                 color: DesignCourseAppTheme.nearlyBlack,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  // Future<DateTime> pickDate() => showDatePicker(
  //   context: context,
  //   initialDate: dateTime,
  //   firstDate: DateTime.now(),
  //   lastDate: DateTime(2100),
  // );
}
