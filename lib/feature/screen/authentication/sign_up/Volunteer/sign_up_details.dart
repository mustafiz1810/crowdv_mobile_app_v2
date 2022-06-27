import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/feature/screen/authentication/sign_in/sign_in.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_page.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/design_details.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/header_widget.dart';
import 'package:crowdv_mobile_app/widgets/progres_hud.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../../../../widgets/show_toast.dart';

class VolunteerDetails extends StatefulWidget {
  final dynamic fname, lname, email, phone, password, check;
  VolunteerDetails(
      {@required this.fname,
      this.lname,
      this.email,
      this.phone,
      this.password,
      this.check});
  @override
  State<StatefulWidget> createState() {
    return _VolunteerDetailsState();
  }
}

class _VolunteerDetailsState extends State<VolunteerDetails> {
  final formKey = GlobalKey<FormState>();
  DateTime dateTime = DateTime(2022, 6, 20);
  String _chosenValue;
  String _dropdown;
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
  List<String> _items = [
    "Business",
    "Student",
    "Service",
    "Entrepreneur/Self-employer"
  ];
  List<String> _item = ["Male", "Female"];
  final _formKey = GlobalKey<FormState>();
  TextEditingController aptController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  double _headerHeight = 200;
  void signup(String fname, lname, email, phone, state, city, apt, street, zip,
      gender, dob, password, profession, check) async {
    try {
      Response response =
          await post(Uri.parse(NetworkConstants.BASE_URL + 'volunteer'), body: {
        'first_name': fname,
        'last_name': lname,
        'sur_name': lname,
        'email': email,
        'phone': phone,
        'state': state,
        'city': city,
        'building': apt,
        'street_address': street,
        'zip_code': zip,
        'gender': gender,
        'dob': dob,
        'password': password,
        'profession': profession,
        'terms_and_conditions': '1',
      });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        setState(() {
          isApiCallProcess = false;
        });
        showToast(context, data['message']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false);
      } else {
        var data = jsonDecode(response.body.toString());
        showToast(context, data['message']);
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
  // @override
  // void initState() {
  //   _getStateList();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _signup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _signup(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderLogo(
                  _headerHeight), //let's create a common header widget
            ),
            Container(
              margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 155,
                        ),
                        Container(
                          width: 360,
                          padding:
                          EdgeInsets.symmetric(vertical: 1, horizontal: 15),
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: DropdownButton<String>(
                                hint: Center(
                                  child: Text(
                                    'Select Occupation',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                value: _chosenValue,
                                // elevation: 5,
                                isExpanded: true,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                                iconEnabledColor: Colors.white,
                                items: _items.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                selectedItemBuilder: (BuildContext context) =>
                                    _items
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
                                underline: Container(),
                                // hint: Text(
                                //   "Please choose a service",
                                //   style: TextStyle(
                                //       fontSize: 18,
                                //       color: Colors.white,
                                //       fontWeight: FontWeight.bold),
                                // ),
                                // icon: Icon(
                                //   Icons.arrow_downward,
                                //   color: Colors.yellow,
                                // ),
                                // isExpanded: true,
                                onChanged: (String value) {
                                  setState(() {
                                    _chosenValue = value;
                                  });
                                }),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 360,
                          padding:
                          EdgeInsets.symmetric(vertical: 1, horizontal: 15),
                          decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: DropdownButton<String>(
                                hint: Center(
                                  child: Text(
                                    'Select Gender',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                value: _dropdown,
                                // elevation: 5,
                                isExpanded: true,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                                iconEnabledColor: Colors.white,
                                items: _item.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                selectedItemBuilder: (BuildContext context) =>
                                    _item
                                        .map((e) => Center(
                                      child: Text(
                                        e,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                    ))
                                        .toList(),
                                underline: Container(),
                                // hint: Text(
                                //   "Please choose a service",
                                //   style: TextStyle(
                                //       fontSize: 18,
                                //       color: Colors.white,
                                //       fontWeight: FontWeight.bold),
                                // ),
                                // icon: Icon(
                                //   Icons.arrow_downward,
                                //   color: Colors.yellow,
                                // ),
                                // isExpanded: true,
                                onChanged: (String value) {
                                  setState(() {
                                    _dropdown = value;
                                  });
                                }),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: 360,
                          padding:
                          EdgeInsets.symmetric(vertical: 1, horizontal: 15),
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(30)),
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
                              selectedItemBuilder: (BuildContext context) =>
                                  countries
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
                          padding:
                          EdgeInsets.symmetric(vertical: 1, horizontal: 15),
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
                              selectedItemBuilder: (BuildContext context) =>
                                  provinces
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
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            children: [
                              Text(
                                "Date Of Birth: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.27,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: 70),
                              InkWell(
                                  onTap: () async {
                                    final date = await pickDate();
                                    if (date == null) return;
                                    final newDateTime = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                    );
                                    setState(() {
                                      dateTime = newDateTime;
                                    });
                                  },
                                  child: getTimeBoxUI(
                                      '${dateTime.year}/${dateTime.month}/${dateTime.day}')),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          child: TextFormField(
                            controller: aptController,
                            decoration: ThemeHelper().textInputDecoration(
                                "Apt/Floor",
                                "Apt,Suite,Unit,Building,Floor,etc"),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: TextFormField(
                            controller: streetController,
                            decoration: ThemeHelper().textInputDecoration(
                                'Street', 'Street address or P.O box'),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 5.0),
                        Container(
                          child: TextFormField(
                            controller: zipController,
                            decoration: ThemeHelper().textInputDecoration(
                                'Zip Code', 'Enter your zip code'),
                          ),
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          decoration:
                              ThemeHelper().buttonBoxDecoration(context),
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle(),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              child: Text(
                                "Submit".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  isApiCallProcess = true;
                                  print(widget.fname.toString() +
                                      widget.lname.toString() +
                                      widget.email.toString() +
                                      widget.phone.toString() +
                                      selectedCountry.toString() +
                                      selectedProvince.toString() +
                                      aptController.text.toString() +
                                      streetController.text.toString() +
                                      zipController.text.toString() +
                                      _dropdown.toString() +
                                      dateTime.toString() +
                                      widget.password.toString() +
                                      _chosenValue.toString() +
                                      widget.check.toString());
                                });
                                signup(
                                    widget.fname.toString(),
                                    widget.lname.toString(),
                                    widget.email.toString(),
                                    widget.phone.toString(),
                                    selectedCountry.toString(),
                                    selectedProvince.toString(),
                                    aptController.text.toString(),
                                    streetController.text.toString(),
                                    zipController.text.toString(),
                                    _dropdown.toString(),
                                    dateTime.toString(),
                                    widget.password.toString(),
                                    _chosenValue.toString(),
                                    widget.check.toString());
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTimeBoxUI(String text1) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          color: DesignCourseAppTheme.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: DesignCourseAppTheme.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, top: 12.0, bottom: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.27,
                  color: DesignCourseAppTheme.nearlyBlack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );
//   //=============================================================================== Api Calling here
//
// //CALLING STATE API HERE
// // Get State information by API
//   List statesList;
//   String _myState;
//
//   String stateInfoUrl = 'http://cleanions.bestweb.my/api/location/get_state';
//   Future<String> _getStateList() async {
//     await http.post(Uri.parse(stateInfoUrl), headers: {
//       'Content-Type': 'application/x-www-form-urlencoded'
//     }, body: {
//       "api_key": '25d55ad283aa400af464c76d713c07ad',
//     }).then((response) {
//       var data = json.decode(response.body);
//
// //      print(data);
//       setState(() {
//         statesList = data['state'];
//       });
//     });
//   }
//
//   // Get State information by API
//   List citiesList;
//   String _myCity;
//
//   String cityInfoUrl =
//       'http://cleanions.bestweb.my/api/location/get_city_by_state_id';
//   Future<String> _getCitiesList() async {
//     await http.post(Uri.parse(cityInfoUrl), headers: {
//       'Content-Type': 'application/x-www-form-urlencoded'
//     }, body: {
//       "api_key": '25d55ad283aa400af464c76d713c07ad',
//       "state_id": _myState,
//     }).then((response) {
//       var data = json.decode(response.body);
//
//       setState(() {
//         citiesList = data['cities'];
//       });
//     });
//   }
}
