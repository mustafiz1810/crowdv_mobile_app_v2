import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/data/models/recruiter/category_model.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/recruiter/Create_Opportunity/check_box.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/design_details.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/utils/view_utils/common_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:time_interval_picker/time_interval_picker.dart';

class CreateOpportunity extends StatefulWidget {
  const CreateOpportunity({Key key}) : super(key: key);

  @override
  _CreateOpportunityState createState() => _CreateOpportunityState();
}

class _CreateOpportunityState extends State<CreateOpportunity> {
  final _formKey = GlobalKey<FormState>();
  DateTime dateTime = DateTime.now();
  String _typevalue;
  List<String> _type = ["Online", "Offline", "Both"];
  String token = "";
  String radioButtonItem = 'free';
  bool chargeVisible = false;
  int id = 1;
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

  Future<CategoryModel> getAllCategory() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'categories'),
        headers: {"Authorization": "Bearer ${token}"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return CategoryModel.fromJson(data);
    } else {
      return CategoryModel.fromJson(data);
    }
  }

  bool isVisible = false;
  var dropdownvalue;
  int _selectedIndex;
  DateTime startT;
  DateTime endT;
  String tileName, slug;
  TextEditingController titleController = TextEditingController();
  TextEditingController chargeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // final hours = time.hour.toString().padLeft(2, '0');
    // final minutes = time.minute.toString().padLeft(2, '0');
    // final _hours = _time.hour.toString().padLeft(2, '0');
    // final _minutes = _time.minute.toString().padLeft(2, '0');
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        // collapsedHeight: 150,
        title: const Text(
          'Create Opportunity',
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
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //--------------------------------here is title
                  Container(
                    child: TextFormField(
                      controller: titleController,
                      decoration: ThemeHelper()
                          .textInputDecoration('Title', 'Enter your title'),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Tittle can't be empty";
                        }
                        return null;
                      },
                    ),
                    decoration: ThemeHelper().inputBoxDecorationShaddow(),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  //--------------------------------here is category
                  FormField<bool>(
                    builder: (state) {
                      return Column(
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 15),
                              child: Center(
                                child: tileName != null
                                    ? Text(
                                        tileName,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "Select Category",
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
                          Container(
                            child: Text(
                              state.errorText ?? '',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Theme.of(context).errorColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          )
                        ],
                      );
                    },
                    validator: (value) {
                      if (tileName == null) {
                        return 'Category can not be empty';
                      } else {
                        return null;
                      }
                    },
                  ),
                  Visibility(
                    visible: isVisible,
                    child: FutureBuilder<CategoryModel>(
                      future: getAllCategory(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Column(
                              children: [
                                Card(
                                  child: ListView.builder(
                                    physics: ClampingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.data.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                            snapshot.data.data[index].name,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600)),
                                        selected:
                                            snapshot.data.data[index].id ==
                                                _selectedIndex,
                                        onTap: () {
                                          setState(() {
                                            _selectedIndex =
                                                snapshot.data.data[index].id;
                                            tileName =
                                                snapshot.data.data[index].name;
                                            slug =
                                                snapshot.data.data[index].slug;
                                            isVisible = false;
                                            print(_selectedIndex.toString());
                                          });
                                        },
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
                  //--------------------------------here is task type
                  FormField<bool>(
                    builder: (state) {
                      return Column(
                        children: <Widget>[
                          Container(
                            width: 365,
                            padding: EdgeInsets.symmetric(
                                vertical: 1, horizontal: 15),
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
                                  items: _type.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  selectedItemBuilder: (BuildContext context) =>
                                      _type
                                          .map((e) => Center(
                                                child: Text(
                                                  e,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              state.errorText ?? '',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Theme.of(context).errorColor,
                                fontSize: 12,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          )
                        ],
                      );
                    },
                    validator: (value) {
                      if (_typevalue == null) {
                        return 'Task type can not be empty';
                      } else {
                        return null;
                      }
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Charge: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            letterSpacing: 0.27,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child:RadioListTile(
                            title: Text(
                              'Free',
                              style: new TextStyle(fontSize: 16.0),
                            ),
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
                      ),
                      Expanded(
                          flex: 2,
                          child: RadioListTile(
                            title: Text(
                              'Paid',
                              style: new TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
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
                      ),
                    ],
                  ),
                  Visibility(
                    visible: chargeVisible,
                    child: Container(
                      child: TextFormField(
                        controller: chargeController,
                        keyboardType: TextInputType.number,
                        decoration: ThemeHelper()
                            .textInputDecoration('Enter your amount'),
                      ),
                      decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //--------------------------------here is discription
                  Container(
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      controller: descriptionController,
                      maxLines: 5,
                      maxLength: 200,
                      decoration: InputDecoration(
                        errorStyle: TextStyle(
                            fontWeight: FontWeight.bold
                        ),
                          hintText: "Details",
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
                      validator: (val) {
                        if (val.isEmpty) {
                          return "Description can't be empty";
                        }
                        return null;
                      },
                    ),
                  ),
                  //--------------------------------here is date
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
                    child: Row(
                      children: [
                        Text(
                          "Date: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            letterSpacing: 0.27,
                            color: primaryColor,
                          ),
                        ),
                        SizedBox(
                          width: 30,
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
                  ),
                  //--------------------------------here is time
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "Start Time",
                              style:  TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                letterSpacing: 0.27,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "End Time",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                letterSpacing: 0.27,
                                color: primaryColor,
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TimeIntervalPicker(
                          endLimit: null,
                          startLimit: null,
                          onChanged: (DateTime startTime, DateTime endTime,
                              bool isAllDay) {
                            setState(() {
                              startT = startTime;
                              endT = endTime;
                            });
                          },
                        ),
                      ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       "TIME: ",
                      //       style: TextStyle(
                      //         fontWeight: FontWeight.bold,
                      //         fontSize: 16,
                      //         letterSpacing: 0.27,
                      //         color: primaryColor,
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 30,
                      //     ),
                      //     InkWell(
                      //         onTap: () async {
                      //           TimeOfDay newTime = await showTimePicker(
                      //             initialEntryMode: TimePickerEntryMode.input,
                      //             context: context,
                      //             initialTime: time,
                      //           );
                      //           if (newTime == null) return;
                      //           setState(() {
                      //             time = newTime;
                      //             print(
                      //                 '${time.hour}:${time.minute.toString().padLeft(2, '0')}');
                      //           });
                      //         },
                      //         child: getTimeBoxUI('$hours:$minutes', 80)),
                      //     SizedBox(
                      //       width: 5,
                      //     ),
                      //     Text(
                      //       '-',
                      //       style: TextStyle(fontWeight: FontWeight.bold),
                      //     ),
                      //     SizedBox(
                      //       width: 5,
                      //     ),
                      //     InkWell(
                      //         onTap: () async {
                      //           TimeOfDay endTime = await showTimePicker(
                      //             context: context,
                      //             initialTime: _time,
                      //           );
                      //           if (endTime == null) return;
                      //           setState(() {
                      //             _time = endTime;
                      //             print(_time.toString());
                      //           });
                      //         },
                      //         child: getTimeBoxUI('$_hours:$_minutes', 80)),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 15,
                      // ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Get.to(() => CheckBox(
                                token: token,
                                slug: slug.toString(),
                                title: titleController.text,
                                category: _selectedIndex.toString(),
                                type: _typevalue.toString(),
                                description: descriptionController.text,
                                date: dateTime.toString(),
                                time:
                                    '${startT.hour}:${startT.minute.toString().padLeft(2, '0')}',
                                etime:
                                    '${endT.hour}:${endT.minute.toString().padLeft(2, '0')}',
                                charge: chargeController.text,
                              ));
                        };
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
                                color: DesignCourseAppTheme.nearlyBlue
                                    .withOpacity(0.5),
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
                  ),
                ],
              ),
            ),
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
                offset: const Offset(0, 1),
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
