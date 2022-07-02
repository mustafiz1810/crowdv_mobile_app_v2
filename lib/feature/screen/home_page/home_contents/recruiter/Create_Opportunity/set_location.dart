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
  final dynamic title,
      category,
      type,
      description,
      date,
      time,
      etime,
      eligibility;
  OpLocation(
      {@required this.title,
      this.category,
      this.type,
      this.description,
      this.date,
      this.time,
      this.etime,
      this.eligibility});

  @override
  _OpLocationState createState() => _OpLocationState();
}

class _OpLocationState extends State<OpLocation> {
  String token = "";

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
  String selectedCountry;
  String selectedProvince;
  TextEditingController zipController = TextEditingController();
  void create(String title, category_id, date, start_time, end_time, state,
      city, eligibility, details, task_type, zip_code) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'opportunity/store'),
          headers: {
            "Authorization": "Bearer $token"
          },
          body: {
            'title': title,
            'category_id': category_id,
            'date': date,
            'start_time': start_time,
            'end_time': end_time,
            'location_from': 'uttara',
            'location_to': 'airport',
            'eligibility_id': eligibility,
            'details': details,
            'task_type': task_type,
            'city': city,
            'state': state,
            'zip_code': zip_code,
            'working_hours': '10',
            'is_public': 'true',
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        setState(() {
          isApiCallProcess = false;
        });
        showToast(context, data['message']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false);
      } else {
        var data = jsonDecode(response.body.toString());
        showToast(context, data['errors'].toString());
      }
    } catch (e) {
      setState(() {
        isApiCallProcess = false;
      });
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

  bool isApiCallProcess = false;
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
            Container(
              width: 360,
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(30)),
              child: Center(
                child: DropdownButton<String>(
                  hint: Center(
                    child: Text(
                      'Select State',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  underline: SizedBox(),
                  iconEnabledColor: Colors.white,
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
                                  color: Colors.white,
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
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: 360,
              padding: EdgeInsets.symmetric(vertical: 1, horizontal: 15),
              decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.circular(30)),
              child: Center(
                child: DropdownButton<String>(
                  hint: Center(
                    child: Text(
                      'Select City',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  underline: SizedBox(),
                  iconEnabledColor: Colors.white,
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
                                  color: Colors.white,
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
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: TextFormField(
                controller: zipController,
                decoration: ThemeHelper()
                    .textInputDecoration('Zip Code', 'Enter your zip code'),
              ),
              decoration: ThemeHelper().inputBoxDecorationShaddow(),
            ),
            SizedBox(
              height: 20,
            ),
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
                        setState(() {
                          print(widget.title+"  "+
                              widget.category+"  "+
                              widget.date+"  "+
                              widget.time+"  "+
                              widget.etime+"  "+
                              selectedCountry.toString()+"  "+
                              selectedProvince.toString()+"  "+
                              widget.eligibility+"  "+
                              widget.description+"  "+
                              widget.type+"  "+
                              zipController.text.toString());
                        });
                        create(
                            widget.title,
                            widget.category,
                            widget.date,
                            widget.time,
                            widget.etime,
                            selectedCountry.toString(),
                            selectedProvince.toString(),
                            widget.eligibility,
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
