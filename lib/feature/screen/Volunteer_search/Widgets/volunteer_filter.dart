import 'dart:convert';
import 'package:crowdv_mobile_app/feature/screen/Recruiter_search/widgets/multi_select_dynamic.dart';
import 'package:crowdv_mobile_app/feature/screen/Recruiter_search/widgets/multi_select_static.dart';
import 'package:crowdv_mobile_app/feature/screen/Volunteer_search/search_volunteer.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../../../utils/view_utils/colors.dart';

class VolunteerFilter extends StatefulWidget {
  final List<dynamic> category;
  final List<dynamic> membership;
  VolunteerFilter({this.category,this.membership});

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
  int minAge = 0;
  int maxAge = 100;
  var countryvalue;
  var statevalue;
  var cityvalue;
  List<int> _selectedCategory = [];
  List<String> _selectedType = [];
  List<int> _selectedMembership = [];
  List<String> _selectedGender = [];
  List<String> _selectedProfession = [];
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

  void _showMultiType() async {
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
            items: _itemsType, selectedItem: _selectedType,title: "Task Type",);
      },
    );


    // Update UI
    if (results != null) {
      setState(() {
        _selectedType = results;
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
                      taskType: _selectedType.length == 0
                          ? null
                          : _selectedType,
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
                        CustomSearchableDropDown(
                          items: countries,
                          label: 'Select Country',
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.black
                              )
                          ),
                          dropDownMenuItems:  countries?.map((item) {
                            return item['name'];
                          })?.toList() ??
                              [],
                          onChanged: (newVal) {
                            if(newVal!=null)
                            {
                              setState(() {
                                states.clear();
                                statevalue = null;
                                city.clear();
                                cityvalue = null;
                                countryvalue = newVal['id'];
                                getState(countryvalue);
                                countryvalue != null?isStateVisible = true:isStateVisible = false;
                                print(isStateVisible);
                              });

                            }
                            else{
                              countryvalue=null;
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: isStateVisible,
                          child: CustomSearchableDropDown(
                            items: states,
                            label: 'Division/Province/State',
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.black
                                )
                            ),
                            dropDownMenuItems: states.map((item) {
                              return item['name'].toString();
                            }).toList() ??
                                [],
                            onChanged: (newVal)  {
                              if(newVal!=null)
                              {
                                setState(() {
                                  city.clear();
                                  cityvalue = null;
                                  statevalue = newVal['id'];
                                  getCity(statevalue);
                                  statevalue != null?isCityVisible = true:isCityVisible = false;
                                  print(statevalue);
                                });
                              }
                              else{
                                statevalue=null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: isCityVisible,
                          child: CustomSearchableDropDown(
                            items: city,
                            label: 'City',
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.black
                                )
                            ),
                            dropDownMenuItems: city.map((item) {
                              return item['name'].toString();
                            }).toList() ??
                                [],
                            onChanged: (newVal) {
                              if(newVal!=null)
                              {
                                cityvalue = newVal['id'];
                                print(cityvalue);
                              }
                              else{
                                cityvalue=null;
                              }
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
                              onPressed: _showMultiType,
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
                                minValue: 0,
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
                                minValue: 0,
                                maxValue: 100,
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
