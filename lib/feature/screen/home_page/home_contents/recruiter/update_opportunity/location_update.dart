import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/widgets/details.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
class LocationUpdate extends StatefulWidget {
  final List<int> eligibility;
  final dynamic token,id,title,
      category,
      type,
      description,
      date,
      time,
      etime,
      city,
      state,
  zip;
  LocationUpdate(
      {@required this.token,
        this.id,
      this.title,
      this.category,
      this.type,
      this.description,
      this.date,
      this.time,
      this.etime,
      this.eligibility,
      this.city,
      this.state,
      this.zip});

  @override
  _LocationUpdateState createState() => _LocationUpdateState();
}

class _LocationUpdateState extends State<LocationUpdate> {
  @override
  void initState() {
    super.initState();
    selectedCountry=widget.state;
    selectedProvince=widget.city;
    zipController.text=widget.zip.toString();
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
  void update(String title, category_id, date, start_time, end_time, state,
      city, List<int> eligibility, details, task_type, zip_code) async {
    String body = json.encode({ 'title': title,
      'category_id': category_id,
      'date': date,
      'start_time': start_time,
      'end_time': end_time,
      'eligibility_id': eligibility ,
      'details': details,
      'task_type': task_type,
      'city': city,
      'state': state,
      'zip_code': zip_code,
      'is_public': 'true',});
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'opportunity/update/${widget.id}'),
          headers: {
            "Authorization": "Bearer ${widget.token}",
            "Content-Type": "application/json"

          },
          body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        showToast(context, data['message']);
        int count = 0;
        Navigator.popUntil(context, (route) => count++ == 3);
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
        showToast(context, data['error']['errors'].toString());
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 360,
              padding: EdgeInsets.symmetric(
                  vertical: 2,
                  horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  const BorderRadius.all(
                      Radius.circular(
                          12.0)),
                  border: Border.all(
                      color: Colors.black)),
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
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 360,
              padding: EdgeInsets.symmetric(
                  vertical: 1,
                  horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  const BorderRadius.all(
                      Radius.circular(
                          12.0)),
                  border: Border.all(
                      color: Colors.black)),
              child: Center(
                child: DropdownButton<String>(
                  hint: Center(
                    child: Text(
                      widget.city.toString(),
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
            ),
            SizedBox(height: 20),
            Container(
              height: 50,
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
                          print(widget.id.toString() +
                              "  " +
                              widget.category +
                              "  " +
                              widget.date +
                              "  " +
                              widget.time +
                              "  " +
                              widget.etime +
                              "  " +
                              selectedCountry.toString() +
                              "  " +
                              selectedProvince.toString() +
                              "  " +
                              widget.eligibility.toString() +
                              "  " +
                              widget.description +
                              "  " +
                              widget.type +
                              "  " +
                              zipController.text.toString());
                        });
                        update(
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
                            "Update Opportunity",
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
