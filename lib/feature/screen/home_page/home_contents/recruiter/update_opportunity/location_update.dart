import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class LocationUpdate extends StatefulWidget {
  final List<int> eligibility;
  final dynamic token,
      id,
      title,
      category,
      type,
      description,
      date,
      time,
      etime,
      country,
      city,
      state,
      other,
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
      this.country,
      this.city,
      this.state,
      this.other,
      this.zip});

  @override
  _LocationUpdateState createState() => _LocationUpdateState();
}

class _LocationUpdateState extends State<LocationUpdate> {
  @override
  void initState() {
    countryvalue = widget.country;
    statevalue = widget.state;
    cityvalue = widget.city;
    zipController.text = widget.zip;
    super.initState();
    print(countryvalue);
    print(statevalue);
    print(cityvalue);
    getCountry();
    widget.state != null ? getState(widget.country) : "";
    widget.city != null ? getCity(widget.state) : "";
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
      print(jsonData);
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
  void update(
      String other,
      title,
      category_id,
      date,
      start_time,
      end_time,
      country,
      state,
      city,
      List<int> eligibility,
      details,
      task_type,
      zip_code) async {
    String body = json.encode({
      'title': title,
      'category_id': category_id,
      'date': date,
      'start_time': start_time,
      'end_time': end_time,
      'eligibility_id': eligibility,
      'other': other,
      'details': details,
      'task_type': task_type,
      'country_id': country,
      'state_id': state,
      'city_id': city,
      'zip_code': zip_code,
      'is_public': 'true',
    });
    try {
      Response response = await post(
          Uri.parse(
              NetworkConstants.BASE_URL + 'opportunity/update/${widget.id}'),
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
        data['error'].length != 0?
        showToast(context, data['error']['errors'].toString()):
        showToast(context, data['message']);
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
            SizedBox(
              height: 23,
            ),
            CustomSearchableDropDown(
              initialValue: [
                {
                  'parameter': 'id',
                  'value': widget.country,
                }
              ],
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
                    zipController.clear();
                    countryvalue = newVal['id'];
                    getState(countryvalue);
                    print(countryvalue);
                  });

                }
                else{
                  countryvalue = widget.country;
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            CustomSearchableDropDown(
              initialValue: [
                {
                  'parameter': 'id',
                  'value': widget.state,
                }
              ],
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
                    zipController.clear();
                    statevalue = newVal['id'];
                    print(statevalue);
                    getCity(statevalue);
                  });
                }
                else{
                  statevalue=widget.state;
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            CustomSearchableDropDown(
              initialValue: [
                {
                  'parameter': 'id',
                  'value': widget.city,
                }
              ],
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
                  zipController.clear();
                  print(cityvalue);
                }
                else{
                  cityvalue=widget.city;
                }
              },
            ),
            SizedBox(
              height: 23,
            ),
            Container(
              child: TextFormField(
                style: TextStyle(fontSize: 14),
                keyboardType: TextInputType.number,
                controller: zipController,
                decoration: ThemeHelper()
                    .textInputDecoration('Zip Code', 'Enter your zip code'),
              ),
              decoration: ThemeHelper().inputBoxDecorationShaddow(),
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
                        // print(countryvalue);
                        update(
                            widget.other,
                            widget.title,
                            widget.category,
                            widget.date,
                            widget.time,
                            widget.etime,
                            countryvalue.toString(),
                            statevalue.toString(),
                            cityvalue.toString(),
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
