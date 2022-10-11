import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpLocation extends StatefulWidget {
  final List<int> answer;
  final dynamic title,
  eligibility,
      category,
      type,
      description,
      date,
      time,
      etime;
  OpLocation(
      {@required
      this.answer,
        this.eligibility,
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
      city, List<int> answer,eligibility, details, task_type, zip_code) async {
    String body = json.encode({ 'title': title,
      'category_id': category_id,
      'date': date,
      'start_time': start_time,
      'end_time': end_time,
      'eligibility_id': answer ,
      'other':eligibility,
      'details': details,
      'task_type': task_type,
      'country_id': country,
      'state_id': state,
      'city_id': city,
      'zip_code': zip_code,});
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
        data['error'].length != 0?
        showToast(context, data['error']['errors'].toString()):showToast(context, data['message']);
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Something went wrong"),
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
