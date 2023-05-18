import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/design_details.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
class ProfileUpdate extends StatefulWidget {
  final dynamic token, fname, lname,about, email, phone, dob, prof,institute, gender,data,disability,country,state,city,zip;
  ProfileUpdate(
      {@required this.token,
        this.fname,
        this.lname,
        this.about,
        this.email,
        this.phone,
        this.dob,
        this.prof,
        this.institute,
        this.gender,
      this.data,
      this.disability,
      this.city,
      this.country,
      this.state,
      this.zip});
  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  DateTime dateTime = DateTime.now();
  String _profession;
  String _gender;
  List<String> _items = ["Business", "Student", "Service", "Self-employer"];
  List<String> _item = ["Male", "Female", "Other"];
  List<dynamic> array = [];
  bool isVisible = false;
  void _answerQuestion(String id) {
    if (array.contains(id)) {
      array.remove(id);
    } else {
      array.add(id);
    }
  }
  @override
  void initState() {
    countryvalue = widget.country;
    statevalue = widget.state;
    cityvalue = widget.city;
    zipController.text = widget.zip;
    getCountry();
    widget.state != null ? getState(widget.country) : "";
    widget.city != null ? getCity(widget.state) : "";
    widget.prof == null ? _profession = "Business" : _profession = widget.prof;
    widget.gender == null ? _gender = "Male" : _gender = widget.gender;
    fnameController.text = widget.fname.toString();
    lnameController.text = widget.lname.toString();
    widget.about != null?descriptionController.text = widget.about.toString():descriptionController.text;
    widget.institute != null?instituteController.text = widget.institute.toString():instituteController.text;
    dateTime = widget.dob;
    array = widget.disability;
    super.initState();
  }

  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController instituteController = TextEditingController();
  TextEditingController zipController = TextEditingController();
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
  void update(String fname, lname,about_me,date,profession,institution,gender,country, state, city, zip_code,List<dynamic> disable) async {
    // String body = json.encode({
    //   "first_name": fname,
    //   "last_name": lname,
    //   "about_me":about_me,
    //   "dob": date,
    //   "profession":profession,
    //   "institution":institution,
    //   "gender":gender,
    //   'country_id': country,
    //   'state_id': state,
    //   'city_id': city,
    //   'zip_code': zip_code,
    //   'type_of_disability': disable,
    // });
    // print(body);
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'profile/update'),
          headers: {
            "Authorization": "Bearer ${widget.token}"
          },
          body: {
            "first_name": fname,
            "last_name": lname,
            "about_me":about_me,
            "dob": date,
            "profession":profession,
            "institution":institution,
            "gender":gender,
            'country_id': country,
            'state_id': state,
            'city_id': city,
            'zip_code': zip_code,
            'type_of_disability': jsonEncode(disable),
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        showToast(context, data['message']);
        Navigator.pop(context);
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
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

  @override
  Widget build(BuildContext context) {
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
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
                    print(fnameController.text.toString()+
                      lnameController.text.toString()+
                      descriptionController.text.toString()+
                      dateTime.toString()+
                      _profession+
                      instituteController.text.toString()+
                      _gender+
                      countryvalue.toString()+
                      statevalue.toString()+
                      cityvalue.toString()+
                      zipController.text.toString()+ array.toString(),);
                    update(
                        fnameController.text.toString(),
                        lnameController.text.toString(),
                        descriptionController.text.toString(),
                        dateTime.toString(),
                        _profession,
                        instituteController.text.toString(),
                        _gender,
                        countryvalue.toString(),
                        statevalue.toString(),
                        cityvalue.toString(),
                        zipController.text.toString(),
                        array,
                    );

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
                        "Update Profile",
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
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              //--------------------------------here is Fname
              Container(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: fnameController,
                  decoration: ThemeHelper()
                      .textInputDecoration('First Name', 'Update Your name'),
                ),
                decoration: ThemeHelper().inputBoxDecorationShaddow(),
              ),
              SizedBox(
                height: 15,
              ),
              //--------------------------------here is Lname
              Container(
                child: TextFormField(
                  controller: lnameController,
                  decoration: ThemeHelper()
                      .textInputDecoration('Last Name', 'Update Your name'),
                ),
                decoration: ThemeHelper().inputBoxDecorationShaddow(),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  SizedBox(width: 10,),
                  Text(
                    "About me (optional): ",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  )
                ],
              ),
              Container(
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  controller: descriptionController,
                  maxLines: 3,
                  maxLength: 50,
                  decoration: InputDecoration(
                    hintText: "Write a short description about yourself.",
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.black)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: Colors.black)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: "Profession",
                      hintText: "Profession",
                      fillColor: Colors.white,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      filled: true,
                      contentPadding: EdgeInsets.fromLTRB(20,5, 20, 5),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.black)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.black)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          BorderSide(color: Colors.red, width: 2.0)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          BorderSide(color: Colors.red, width: 2.0)),
                    ),
                    isEmpty: _profession == '',
                    child: Center(
                      child: DropdownButton<String>(
                          hint: Center(
                            child: Text(
                              "Select Profession",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,),
                            ),
                          ),
                          value: _profession,
                          isExpanded: true,
                          // elevation: 5,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,),
                          iconEnabledColor: Colors.black,
                          items: _items
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          selectedItemBuilder: (BuildContext context) => _items
                              .map((e) => Center(
                            child: Text(
                              e,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,),
                            ),
                          ))
                              .toList(),
                          underline: Container(),
                          onChanged: (String value) {
                            setState(() {
                              _profession = value;
                            });
                          }),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: instituteController,
                  decoration: ThemeHelper()
                      .textInputDecoration('Institute', 'Your institute name'),
                ),
                decoration: ThemeHelper().inputBoxDecorationShaddow(),
              ),
              SizedBox(
                height: 15,
              ),
              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: "Gender",
                      hintText: "Gender",
                      fillColor: Colors.white,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      filled: true,
                      contentPadding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.black)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.black)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          BorderSide(color: Colors.red, width: 2.0)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          BorderSide(color: Colors.red, width: 2.0)),
                    ),
                    isEmpty: _gender == '',
                    child: Center(
                      child: DropdownButton<String>(
                          isExpanded: true,
                          value: _gender,
                          hint: Center(
                            child: Text(
                              "Select Gender",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,),
                            ),
                          ),
                          // elevation: 5,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,),
                          iconEnabledColor: Colors.black,
                          items: _item
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          selectedItemBuilder: (BuildContext context) => _item
                              .map((value) => Center(
                            child: Text(
                              value,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,),
                            ),
                          ))
                              .toList(),
                          underline: Container(),
                          onChanged: (String value) {
                            setState(() {
                              _gender = value;
                            });
                          }),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 15,
              ),
            InputDecorator(
              decoration: InputDecoration(
                labelText: "Disability",
                hintText: "Disability",
                fillColor: Colors.white,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                filled: true,
                contentPadding: EdgeInsets.fromLTRB(20, 5, 10, 5),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.black)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.black)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                    BorderSide(color: Colors.red, width: 2.0)),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                    BorderSide(color: Colors.red, width: 2.0)),
              ),
              isEmpty: _gender == '',
              child: TextButton(
                onPressed: () {
                  setState(() {
                    if (isVisible == false) {
                      isVisible = true;
                    } else
                      (isVisible = false);
                  });
                },
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Disability",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
              Visibility(
                visible: isVisible,
                child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.data.length,
                itemBuilder: (context, index) {
                  return Card(
                      child:
                      new CheckboxListTile(
                          activeColor:
                          primaryColor,
                          dense: true,
                          //font change
                          title: new Text(
                            widget.data[
                            index]
                            ["title"],
                            style: TextStyle(
                                fontSize:
                                14,
                                fontWeight:
                                FontWeight
                                    .w600,
                                letterSpacing:
                                0.5),
                          ),
                          value: array.contains(widget
                              .data[
                          index]
                          ["id"]
                              .toString())
                              ? true
                              : widget.data[
                          index]
                          [
                          "is_check"],
                          onChanged:
                              (bool value) {
                            setState(() {
                              widget.data[
                              index]
                              [
                              "is_check"] = value;
                              _answerQuestion(widget
                                  .data[
                              index]
                              ["id"]
                                  .toString());
                            });
                          }));
                },
              ),),
              //--------------------------------here is disability
              // Column(
              //   children: [
              //     SizedBox(
              //       height: 10,
              //     ),
              //     SizedBox(
              //       height: 50,
              //       width: 300,
              //       child: ElevatedButton(
              //         style: ElevatedButton.styleFrom(
              //           primary: primaryColor,
              //           shape: RoundedRectangleBorder(
              //               borderRadius:
              //               BorderRadius.circular(
              //                   13)),
              //         ),
              //         onPressed: () {
              //           set(array);
              //         },
              //         child: Center(
              //           child: Text(
              //             "Save",
              //             style: GoogleFonts.kanit(
              //                 color: Colors.white,
              //                 fontSize: 16),
              //           ),
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       height: 15,
              //     ),
              //   ],
              // ),

              //--------------------------------here is location
              Column(
                children: [
                  SizedBox(
                    height: 10,
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
                        borderRadius:
                        BorderRadius.circular(
                            10),
                        border: Border.all(
                            color: Colors.black)),
                    dropDownMenuItems:
                    countries?.map((item) {
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
                          countryvalue =
                          newVal['id'];
                          getState(countryvalue);
                          print(countryvalue);
                        });
                      } else {
                        countryvalue =
                            widget.country;
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
                    label:
                    'Division/Province/State',
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(
                            10),
                        border: Border.all(
                            color: Colors.black)),
                    dropDownMenuItems:
                    states.map((item) {
                      return item['name']
                          .toString();
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
                        borderRadius:
                        BorderRadius.circular(
                            10),
                        border: Border.all(
                            color: Colors.black)),
                    dropDownMenuItems:
                    city.map((item) {
                      return item['name']
                          .toString();
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
                      style:
                      TextStyle(fontSize: 14),
                      keyboardType:
                      TextInputType.number,
                      controller: zipController,
                      decoration: ThemeHelper()
                          .textInputDecoration(
                          'Zip Code',
                          'Enter your zip code'),
                    ),
                    decoration: ThemeHelper()
                        .inputBoxDecorationShaddow(),
                  ),
                  SizedBox(height: 10),
                  // SizedBox(
                  //   height: 50,
                  //   width: 300,
                  //   child: ElevatedButton(
                  //     style:
                  //     ElevatedButton.styleFrom(
                  //       primary: primaryColor,
                  //       shape:
                  //       RoundedRectangleBorder(
                  //           borderRadius:
                  //           BorderRadius
                  //               .circular(
                  //               13)),
                  //     ),
                  //     onPressed: () {
                  //       location(
                  //           countryvalue.toString(),
                  //           statevalue.toString(),
                  //           cityvalue.toString(),
                  //           zipController.text
                  //               .toString());
                  //     },
                  //     child: Center(
                  //       child: Text(
                  //         "Save",
                  //         style: GoogleFonts.kanit(
                  //             color: Colors.white,
                  //             fontSize: 16),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              //--------------------------------here is date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Date of Birth: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.27,
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
                blurRadius: 3.0),
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
    lastDate: DateTime.now(),
  );
}