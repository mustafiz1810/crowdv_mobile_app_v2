import 'package:crowdv_mobile_app/feature/screen/Recruiter_search/widgets/multi_select_dynamic.dart';
import 'package:crowdv_mobile_app/feature/screen/Recruiter_search/widgets/multi_select_static.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
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
  List<int> _selectedCategory = [];
  List<int> _selectedMembership = [];
  List<String> _selectedGender = [];
  List<String> _selectedProfession = [];
  String selectedCountry;
  String selectedProvince;

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

  void _showMultiMembership() async {
    final List<int> results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(
            items: widget.membership, selectedItem: _selectedMembership);
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
        return MultiSelectStatic(items: _items, selectedItem: _selectedGender);
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
            items: _itemsProf, selectedItem: _selectedProfession);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedProfession = results;
      });
    }
  }

  void _reset(){
    setState(() {
      _selectedCategory.clear();
      _selectedMembership.clear();
      _selectedGender.clear();
      _selectedProfession.clear();
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
  List<String> AlaskaProvince = ['Anchorage', 'Juneau'];
  List<String> CaliforniaProvince = ['Los Angeles', 'Sacramento'];
  List<String> ConnecticutProvince = ['Bridgeport', 'Hartford'];
  List<String> DelawareProvince = ['Dover', 'Wilmington'];
  List<String> FloridaProvince = ['Jacksonville', 'Tallahassee'];
  List<String> IllinoisProvince = ['Addison', 'Algonquin', 'Alton','Arlington Heights','Aurora','Bartlett','Batavia','Belleville','Belvidere','Berwyn','Bloomington','Bolingbrook','Buffalo Grove','Chicago',];
  List<String> KansasProvince = ['Topeka', 'Wichita'];
  List<String> KentuckyProvince = ['Frankfort', 'Louisville'];
  List<String> LouisianaProvince = ['Baton Rouge', 'New Orleans'];
  List<String> provinces = [];

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
                print(selectedCountry);
                print(selectedProvince);
                print(_selectedCategory.toString());
                print(_selectedMembership.toString());
                print(_selectedGender.toString());
                print(_selectedProfession.toString());
                Get.to(() => SearchPage(
                      state: selectedCountry,
                      city: selectedProvince,
                      category: _selectedCategory,
                      membership: _selectedMembership,
                      gender: _selectedGender,
                      profession: _selectedProfession,
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
                        DropdownButton<String>(
                          hint: Center(
                            child: Text(
                              "Select State",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          underline: SizedBox(),
                          iconEnabledColor: Colors.black,
                          value: selectedCountry,
                          isExpanded: true,
                          items: countries.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          selectedItemBuilder: (BuildContext context) => countries
                              .map((e) => Center(
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (country) {
                            if (country == 'Alabama') {
                              provinces = AlabamaProvince;
                            } else if (country == 'Alaska') {
                              provinces = AlaskaProvince;
                            } else if (country == 'California') {
                              provinces = CaliforniaProvince;
                            } else if (country == 'Connecticut') {
                              provinces = ConnecticutProvince;
                            } else if (country == 'Delaware') {
                              provinces = DelawareProvince;
                            } else if (country == 'Florida') {
                              provinces = FloridaProvince;
                            } else if (country == 'Illinois') {
                              provinces = IllinoisProvince;
                            } else if (country == 'Kansas') {
                              provinces = KansasProvince;
                            } else if (country == 'Kentucky') {
                              provinces = KentuckyProvince;
                            } else if (country == 'Louisiana') {
                              provinces = LouisianaProvince;
                            } else {
                              provinces = [];
                            }
                            setState(() {
                              selectedProvince = null;
                              selectedCountry = country;
                              print(selectedCountry.toString());
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DropdownButton<String>(
                          hint: Center(
                            child: Text(
                              "Select City",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          underline: SizedBox(),
                          iconEnabledColor: Colors.black,
                          value: selectedProvince,
                          isExpanded: true,
                          items: provinces.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          selectedItemBuilder: (BuildContext context) => provinces
                              .map((e) => Center(
                                    child: Text(
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
                              selectedProvince = province;
                              print(selectedProvince.toString());
                            });
                          },
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
