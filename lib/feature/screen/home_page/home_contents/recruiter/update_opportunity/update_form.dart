import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/data/models/recruiter/category_model.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/recruiter/update_opportunity/eligiblity_update.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/design_details.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/route_manager.dart';
import 'package:inkwell_splash/inkwell_splash.dart';
import 'package:http/http.dart' as http;

import '../../../../../../utils/view_utils/common_util.dart';

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

  List<int> eligibility = [];
  @override
  void initState() {
    for (Map map in widget.eligibility) {
      eligibility.add(map['id']);
    }
    titleController.text = widget.title.toString();
    chargeController.text = widget.charge.toString();
    descriptionController.text = widget.description.toString();
    _typevalue = widget.type.toString();
    dateTime = widget.date;
    time = TimeOfDay(hour: widget.timeh, minute: widget.timem);
    _time = TimeOfDay(hour: widget.etimeh, minute: widget.etimem);
    _selectedIndex = widget.category;
    sslug = widget.slug;
    if (widget.charge != 0) {
      chargeVisible = true;
      id = 2;
    } else {
      chargeVisible = false;
      id = 1;
    }
    super.initState();
  }

  // Default Radio Button Selected Item When App Starts.
  String radioButtonItem = 'free';
  bool chargeVisible;
  // Group Value for Radio Button.
  int id;
  bool isVisible = false;
  var dropdownvalue;
  int _selectedIndex;
  String tileName, sslug;
  TextEditingController titleController = TextEditingController();
  TextEditingController chargeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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
              InkWellSplash(
                onTap: () {
                  setState(() {
                    if (isVisible == false) {
                      isVisible = true;
                    } else
                      (isVisible = false);
                  });
                },
                child: Container(
                  width: 365,
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
                    borderRadius: BorderRadius.circular(30),
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
                                            sslug =
                                                snapshot.data.data[index].slug;
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
                width: 365,
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
                  borderRadius: BorderRadius.circular(30),
                ),
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
              SizedBox(height: 20.0),
              InkWellSplash(
                onTap: () {
                  if (time.hour < _time.hour && time.hour != _time.hour) {
                    Get.to(() => EligibilityUpdate(
                          slug: sslug.toString(),
                          title: titleController.text,
                          category: _selectedIndex.toString(),
                          type: _typevalue.toString(),
                          description: descriptionController.text,
                          date: dateTime.toString(),
                          time:
                              '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
                          etime:
                              '${_time.hour}:${_time.minute.toString().padLeft(2, '0')}',
                          eligibility: eligibility,
                          other: widget.other,
                          country: widget.country,
                          city: widget.city,
                          state: widget.state,
                          zip: widget.zip,
                          id: widget.id,
                          token: widget.token,
                          charge: chargeController.text,
                        ));
                  } else
                    (showToast("End time must be greater than start time"));
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(16.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color:
                              DesignCourseAppTheme.nearlyBlue.withOpacity(0.5),
                          offset: const Offset(-1.1, -1.1),
                          blurRadius: 1.0),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Next',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        letterSpacing: 0.0,
                        color: DesignCourseAppTheme.nearlyWhite,
                      ),
                    ),
                  ),
                ),
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
