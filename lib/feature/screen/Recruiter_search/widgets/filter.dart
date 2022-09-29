import 'dart:convert';
import 'package:crowdv_mobile_app/feature/screen/Recruiter_search/widgets/multi_select_dynamic.dart';
import 'package:crowdv_mobile_app/feature/screen/Recruiter_search/widgets/multi_select_static.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../../../utils/view_utils/colors.dart';
import '../search.dart';

class RecruiterFilter extends StatefulWidget {
  final List<dynamic> category;
  final List<dynamic> membership;
  RecruiterFilter({this.category, this.membership});

  @override
  _RecruiterFilterState createState() => _RecruiterFilterState();
}

class _RecruiterFilterState extends State<RecruiterFilter> {
  @override
  void initState() {
    super.initState();
    getCountry();
  }
  var countryvalue;
  var statevalue;
  var cityvalue;
  List<int> _selectedCategory = [];
  List<int> _selectedMembership = [];
  List<String> _selectedGender = [];
  List<String> _selectedProfession = [];

  int minAge = 18;
  int maxAge = 65;
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
            items: widget.category, selectedItem: _selectedCategory,title: "Category",);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedCategory = results;
      });
    }
  }

  void _showMultiMembership() async {
    final List<int> results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(
            items: widget.membership, selectedItem: _selectedMembership,title: "Membership",);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedMembership = results;
      });
    }
  }

  void _showMultiGender() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List<String> _items = [
      'Male',
      'Female',
      'Other',
    ];

    final List<String> results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectStatic(items: _items, selectedItem: _selectedGender,title: "Gender",);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedGender = results;
      });
    }
  }

  void _showMultiProfession() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List<String> _itemsProf = [
      'Business',
      'Service',
      'Student',
      'Self-Employed',
    ];

    final List<String> results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectStatic(
            items: _itemsProf, selectedItem: _selectedProfession,title: "Profession",);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedProfession = results;
      });
    }
  }

  void _reset() {
    setState(() {
      _selectedCategory.clear();
      _selectedMembership.clear();
      _selectedGender.clear();
      _selectedProfession.clear();
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
                // print(_selectedMembership.toString());
                // print(_selectedGender.toString());
                // print(_selectedProfession.toString());
                Get.to(() => SearchPage(
                  country: countryvalue.toString(),
                      state: statevalue.toString(),
                      city: cityvalue.toString(),
                      category: _selectedCategory.length == 0
                          ? null
                          : _selectedCategory,
                      membership: _selectedMembership.length == 0
                          ? null
                          : _selectedMembership,
                      gender:
                          _selectedGender.length == 0 ? null : _selectedGender,
                      profession: _selectedProfession.length == 0
                          ? null
                          : _selectedProfession,
                      min_age: minAge>maxAge?maxAge:minAge,
                      max_age: maxAge,
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
                        // display selected items
                        // Wrap(
                        //   children: _selectedItems
                        //       .map((e) => Chip(
                        //     label: Text(e.toString()),
                        //   ))
                        //       .toList(),
                        // ),
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
                              "Membership: ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              child: Row(
                                children: [
                                  const Text(
                                    'Select Membership',
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
                              onPressed: _showMultiMembership,
                            ),
                          ],
                        ),
                        // display selected items
                        // Wrap(
                        //   children: _selectedItems
                        //       .map((e) => Chip(
                        //     label: Text(e.toString()),
                        //   ))
                        //       .toList(),
                        // ),
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
                              "Gender: ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              child: Row(
                                children: [
                                  const Text(
                                    'Select Gender',
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
                              onPressed: _showMultiGender,
                            ),
                          ],
                        ),
                        // display selected items
                        Wrap(
                          children: _selectedGender
                              .map((e) => Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Chip(
                                      label: Text(e.toString()),
                                    ),
                                  ))
                              .toList(),
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
                              "Profession: ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                              child: Row(
                                children: [
                                  const Text(
                                    'Select Profession',
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
                          children: _selectedProfession
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
                              "Age range: ",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              decoration:BoxDecoration(
                                color: Color(0xFFf4f4f6),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20.0) //                 <--- border radius here
                                ),
                              ),
                              child: NumberPicker(
                                value: minAge>maxAge?maxAge:minAge,
                                minValue: 18,
                                maxValue: maxAge,
                                onChanged: (value) {
                                  setState(() => minAge = value);
                                } ,
                              ),
                            ),
                            Container(
                              decoration:BoxDecoration(
                                color: Color(0xFFf4f4f6),
                                borderRadius: BorderRadius.all(
                                    Radius.circular(20.0) //                 <--- border radius here
                                ),
                              ),
                              child: NumberPicker(
                                value: maxAge,
                                minValue: 18,
                                maxValue: 65,
                                onChanged: (value) => setState(() => maxAge = value),
                              ),
                            ),

                            // RangeSlider(
                            //   values: _currentRangeValues,
                            //   min: 0,
                            //   max: 100,
                            //   divisions: 10,
                            //   labels: RangeLabels(
                            //     _currentRangeValues.start.round().toString(),
                            //     _currentRangeValues.end.round().toString(),
                            //   ),
                            //   onChanged: (RangeValues values) {
                            //     setState(() {
                            //       _currentRangeValues = values;
                            //     });
                            //   },
                            // ),
                          ],
                        ),
                        // display selected items
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Min age: ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    minAge>maxAge?maxAge.toString():minAge.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Max age: ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    maxAge.toString(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
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
}
