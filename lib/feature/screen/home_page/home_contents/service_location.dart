import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ServiceLocation extends StatefulWidget {
  final country,state ,city, zip;
  ServiceLocation({this.country ,this.state,this.city, this.zip});

  @override
  _ServiceLocationState createState() => _ServiceLocationState();
}

class _ServiceLocationState extends State<ServiceLocation> {
  String token = "";
  @override
  void initState() {
    print(widget.state);
    super.initState();
    getCred();
    getCountry();
    widget.state != null ? getState(widget.country) : "";
    widget.city != null ? getCity(widget.state) : "";
    zipController.text = widget.zip.toString();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
    });
  }
  TextEditingController zipController = TextEditingController();
  void set(String country, state, city, zip_code) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'set-location'),
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          },
          body: {
            'service_country_id': country,
            'service_state_id': state,
            'service_city_id': city,
            'service_zip_code': zip_code,
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        showToast(context, data['message']);
        setState(() {});
      } else {
        var data = jsonDecode(response.body.toString());
        showToast(context, data['message'].toString());
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
        child: SingleChildScrollView(
          child: Column(
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
                    countryvalue=null;
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
                    statevalue=null;
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
                    cityvalue=null;
                  }
                },
              ),
              SizedBox(
                height: 10,
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
              SizedBox(height: 50),
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
                          set(
                              countryvalue.toString(),
                              statevalue.toString(),
                              cityvalue.toString(),
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
                              "Set Location",
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
      ),
    );
  }
}
