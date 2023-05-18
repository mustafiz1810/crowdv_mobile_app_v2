import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/data/models/recruiter/category_model.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/design_details.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../../../../../data/models/recruiter/eligiblity_model.dart';


class OpportunityUpdate extends StatefulWidget {
  final dynamic token,
      id,
      title,
      category,
      type,
      description,
      date,
      timeh,
      timem,
      etimeh,
      etimem,
      slug,
      eligibility,
      other,
      country,
      city,
      state,
      zip,
      charge,
      chargeType;
  OpportunityUpdate(
      {@required this.token,
      this.id,
      this.title,
      this.category,
      this.type,
      this.description,
      this.date,
      this.timeh,
      this.timem,
      this.etimeh,
      this.etimem,
      this.slug,
      this.eligibility,
      this.other,
      this.country,
      this.city,
      this.state,
      this.zip,
      this.charge,
      this.chargeType});
  @override
  _OpportunityUpdateState createState() => _OpportunityUpdateState();
}

class _OpportunityUpdateState extends State<OpportunityUpdate> {
  DateTime dateTime = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  TimeOfDay _time = TimeOfDay.now();
  String _typevalue;
  List<String> _type = ["Online", "Offline", "Both"];
  List<int> tempArray = [];
  Future myFuture;
  void _answerQuestion(int id) {
    if(tempArray.contains(id)){
      tempArray.remove(id);
      print(tempArray);
    }else{
      tempArray.add(id);
      print(tempArray);
    }

  }

  Future<EligibilityModel> getEligibilityApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL +
            'category-wise-eligibility/academic'),
        headers: {"Authorization": "Bearer ${widget.token}"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return EligibilityModel.fromJson(data);
    } else {
      return EligibilityModel.fromJson(data);
    }
  }
  Future<CategoryModel> getAllCategory() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'categories'),
        headers: {"Authorization": "Bearer ${widget.token}"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return CategoryModel.fromJson(data);
    } else {
      return CategoryModel.fromJson(data);
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
      zip_code,
      charge) async {
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
      'charge': charge,
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
        print(body);
        showToast(context, data['message']);
        Navigator.pop(context);
      } else {
        var data = jsonDecode(response.body.toString());
        print(body);
        data['error'].length != 0
            ? showToast(context, data['error']['errors'].toString())
            : showToast(context, data['message']);
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
  TextEditingController zipController = TextEditingController();
  @override
  void initState() {
    for (Map map in widget.eligibility) {
      tempArray.add(map['id']);
    }
    othersController.text = widget.other.toString();
    myFuture = getEligibilityApi();
    titleController.text = widget.title.toString();
    chargeController.text = widget.charge.toString();
    descriptionController.text = widget.description.toString();
    _typevalue = widget.type.toString();
    dateTime = widget.date;
    time = TimeOfDay(hour: widget.timeh, minute: widget.timem);
    _time = TimeOfDay(hour: widget.etimeh, minute: widget.etimem);
    _selectedIndex = widget.category;
    if (widget.charge != 0) {
      chargeVisible = true;
      id = 2;
    } else {
      chargeVisible = false;
      id = 1;
    }
    countryvalue = widget.country;
    statevalue = widget.state;
    cityvalue = widget.city;
    zipController.text = widget.zip;
    getCountry();
    widget.state != null ? getState(widget.country) : "";
    widget.city != null ? getCity(widget.state) : "";
    super.initState();
  }

  // Default Radio Button Selected Item When App Starts.
  String radioButtonItem = 'free';
  bool chargeVisible;
  bool eligibilityVisible = false;
  // Group Value for Radio Button.
  int id;
  bool isVisible = false;
  var dropdownvalue;
  int _selectedIndex;
  String tileName;
  TextEditingController titleController = TextEditingController();
  TextEditingController chargeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController othersController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    final _hours = _time.hour.toString().padLeft(2, '0');
    final _minutes = _time.minute.toString().padLeft(2, '0');
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        // collapsedHeight: 150,
        title: const Text(
          'Update Opportunity',
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
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //--------------------------------here is title
              Container(
                child: TextFormField(
                  controller: titleController,
                  decoration: ThemeHelper()
                      .textInputDecoration('Title', 'Enter your title'),
                ),
                decoration: ThemeHelper().inputBoxDecorationShaddow(),
              ),
              SizedBox(
                height: 10,
              ),
              //--------------------------------here is category
              InkWell(
                onTap: () {
                  setState(() {
                    if (isVisible == false) {
                      isVisible = true;
                    } else
                      (isVisible = false);
                  });
                },
                child: Container(
                  width: 340,
                  height: 50,
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                  child: Center(
                    child: tileName != null
                        ? Text(
                            tileName,
                            style: TextStyle(
                                fontSize: 16,
                                color: primaryColor,
                                fontWeight: FontWeight.bold),
                          )
                        : Text(
                            widget.slug.toString().toUpperCase(),
                            style: TextStyle(
                                fontSize: 16,
                                color: primaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 2.0)
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              Visibility(
                visible: isVisible,
                child: FutureBuilder<CategoryModel>(
                  future: getAllCategory(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                        child: Column(
                          children: [
                            Card(
                              child: ListView.builder(
                                physics: ClampingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data.data.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Card(
                                      shadowColor: Colors.black,
                                      child: ListTile(
                                        title: Text(
                                          snapshot.data.data[index].name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        selected:
                                            snapshot.data.data[index].id ==
                                                _selectedIndex,
                                        onTap: () {
                                          setState(() {
                                            _selectedIndex =
                                                snapshot.data.data[index].id;
                                            tileName =
                                                snapshot.data.data[index].name;
                                            // sslug =
                                            //     snapshot.data.data[index].slug;
                                            isVisible = false;
                                            print(_selectedIndex.toString());
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              //--------------------------------here is task type
              Container(
                width: 340,
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                child: Center(
                  child: DropdownButton<String>(
                      hint: Center(
                        child: Text(
                          "Select Type",
                          style: TextStyle(
                              fontSize: 16,
                              color: primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      value: _typevalue,
                      // elevation: 5,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                      iconEnabledColor: primaryColor,
                      isExpanded: true,
                      items:
                          _type.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      selectedItemBuilder: (BuildContext context) => _type
                          .map((e) => Center(
                                child: Text(
                                  e,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
                          .toList(),
                      underline: Container(),
                      onChanged: (String value) {
                        setState(() {
                          _typevalue = value;
                        });
                      }),
                ),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 2.0)
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    if (eligibilityVisible == false) {
                      eligibilityVisible = true;
                    } else
                      (eligibilityVisible = false);
                  });
                },
                child: Container(
                  width: 365,
                  height: 50,
                  padding: EdgeInsets.symmetric(
                      vertical: 2, horizontal: 15),
                  child: Center(
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Select Eligibility",
                          style: TextStyle(
                              fontSize: 16,
                              color: primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: primaryColor,
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 2.0)
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              Visibility(
                  visible: eligibilityVisible,
                  child: FutureBuilder<EligibilityModel>(
                    future: myFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data.data.length,
                                itemBuilder: (context, index) {
                                  return Column(children: <Widget>[
                                    Card(
                                        child: new CheckboxListTile(
                                            activeColor: primaryColor,
                                            dense: true,
                                            //font change
                                            title: new Text(
                                              snapshot.data.data[index].title,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.5),
                                            ),
                                            value:  tempArray.contains(
                                                snapshot.data.data[index].id)
                                                ?true:snapshot.data.data[index].isChecked,
                                            onChanged: (bool value) {
                                              setState(() {
                                                snapshot.data.data[index].isChecked = value;
                                                _answerQuestion(
                                                    snapshot.data.data[index].id);
                                              });
                                            })),
                                  ]);
                                },
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              //--------------------------------here is discription
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: TextFormField(
                                    textInputAction: TextInputAction.done,
                                    controller: othersController,
                                    maxLines: 3,
                                    maxLength: 100,
                                    decoration: InputDecoration(
                                        hintText: "Type your eligibility",
                                        hintStyle: TextStyle(
                                            fontSize: 14
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.white),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey.shade200),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  )
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Charge: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.27,
                      color: primaryColor,
                    ),
                  ),
                  Radio(
                    value: 1,
                    groupValue: id,
                    onChanged: (val) {
                      setState(() {
                        chargeController.clear();
                        radioButtonItem = 'free';
                        chargeVisible = false;
                        id = 1;
                      });
                    },
                  ),
                  Text(
                    'Free',
                    style: new TextStyle(fontSize: 16.0),
                  ),
                  Radio(
                    value: 2,
                    groupValue: id,
                    onChanged: (val) {
                      setState(() {
                        radioButtonItem = 'paid';
                        chargeVisible = true;
                        id = 2;
                      });
                    },
                  ),
                  Text(
                    'Paid',
                    style: new TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Visibility(
                visible: chargeVisible,
                child: Container(
                  child: TextFormField(
                    controller: chargeController,
                    keyboardType: TextInputType.number,
                    decoration:
                        ThemeHelper().textInputDecoration('Enter your amount'),
                  ),
                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              //--------------------------------here is discription
              Container(
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  controller: descriptionController,
                  maxLines: 5,
                  maxLength: 200,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                      hintText:
                          "Example: Preffered cake shops,Text on the cake.",
                      fillColor: Colors.grey.shade200),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              //--------------------------------here is date
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Starting Date: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.27,
                          color: primaryColor,
                        ),
                      ),
                      InkWell(
                          onTap: () async {
                            final date = await pickDate();
                            if (date == null) return;
                            final startDate =
                                DateTime(date.year, date.month, date.day);
                            setState(() {
                              dateTime = startDate;
                            });
                          },
                          child: getTimeBoxUI(
                              '${dateTime.year}/${dateTime.month}/${dateTime.day}',
                              160)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 6.0),
              //--------------------------------here is time
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Select time: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 0.27,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(
                        width: 9,
                      ),
                      InkWell(
                          onTap: () async {
                            TimeOfDay newTime = await showTimePicker(
                              context: context,
                              initialTime: time,
                            );
                            if (newTime == null) return;
                            setState(() {
                              time = newTime;
                              print(
                                  '${time.hour}:${time.minute.toString().padLeft(2, '0')}');
                            });
                          },
                          child: getTimeBoxUI('$hours:$minutes', 80)),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '-',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                          onTap: () async {
                            TimeOfDay endTime = await showTimePicker(
                              context: context,
                              initialTime: _time,
                            );
                            if (endTime == null) return;
                            setState(() {
                              _time = endTime;
                              print(_time.toString());
                            });
                          },
                          child: getTimeBoxUI('$_hours:$_minutes', 80)),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
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
                    border: Border.all(color: Colors.black)),
                dropDownMenuItems: countries?.map((item) {
                  return item['name'];
                })?.toList() ??
                    [],
                onChanged: (newVal) {
                  if (newVal != null) {
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
                  } else {
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
                    border: Border.all(color: Colors.black)),
                dropDownMenuItems: states.map((item) {
                  return item['name'].toString();
                }).toList() ??
                    [],
                onChanged: (newVal) {
                  if (newVal != null) {
                    setState(() {
                      city.clear();
                      cityvalue = null;
                      zipController.clear();
                      statevalue = newVal['id'];
                      print(statevalue);
                      getCity(statevalue);
                    });
                  } else {
                    statevalue = widget.state;
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
                    border: Border.all(color: Colors.black)),
                dropDownMenuItems: city.map((item) {
                  return item['name'].toString();
                }).toList() ??
                    [],
                onChanged: (newVal) {
                  if (newVal != null) {
                    cityvalue = newVal['id'];
                    zipController.clear();
                    print(cityvalue);
                  } else {
                    cityvalue = widget.city;
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
                          update(
                              widget.other,
                              titleController.text,
                              _selectedIndex.toString(),
                              dateTime.toString(),
                              '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                              '${_time.hour}:${_time.minute.toString().padLeft(2, '0')}',
                              countryvalue.toString(),
                              statevalue.toString(),
                              cityvalue.toString(),
                              tempArray,
                              descriptionController.text,
                              _typevalue.toString(),
                              zipController.text.toString(),
                            chargeController.text);
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
              ),
              // InkWell(
              //   onTap: () {
              //     if (time.hour < _time.hour && time.hour != _time.hour) {
              //       Get.to(() => EligibilityUpdate(
              //             // slug: sslug.toString(),
              //             title: titleController.text,
              //             category: _selectedIndex.toString(),
              //             type: _typevalue.toString(),
              //             description: descriptionController.text,
              //             date: dateTime.toString(),
              //             time:
              //                 '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
              //             etime:
              //                 '${_time.hour}:${_time.minute.toString().padLeft(2, '0')}',
              //             // eligibility: eligibility,
              //             other: widget.other,
              //             country: widget.country,
              //             city: widget.city,
              //             state: widget.state,
              //             zip: widget.zip,
              //             id: widget.id,
              //             token: widget.token,
              //             charge: chargeController.text,
              //           ));
              //     } else
              //       (showToast(context ,"End time must be greater than start time"));
              //   },
              //   child: Container(
              //     height: 48,
              //     decoration: BoxDecoration(
              //       color: primaryColor,
              //       borderRadius: const BorderRadius.all(
              //         Radius.circular(16.0),
              //       ),
              //       boxShadow: <BoxShadow>[
              //         BoxShadow(
              //             color:
              //                 DesignCourseAppTheme.nearlyBlue.withOpacity(0.5),
              //             offset: const Offset(-1.1, -1.1),
              //             blurRadius: 1.0),
              //       ],
              //     ),
              //     child: Center(
              //       child: Text(
              //         'Next',
              //         textAlign: TextAlign.left,
              //         style: TextStyle(
              //           fontWeight: FontWeight.w600,
              //           fontSize: 18,
              //           letterSpacing: 0.0,
              //           color: DesignCourseAppTheme.nearlyWhite,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTimeBoxUI(String text1, double width) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: DesignCourseAppTheme.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: DesignCourseAppTheme.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 2.0),
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
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
}
