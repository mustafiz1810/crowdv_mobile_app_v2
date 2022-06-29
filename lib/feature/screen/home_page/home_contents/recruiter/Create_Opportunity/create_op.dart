import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/recruiter/Create_Opportunity/check_box.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/recruiter/Create_Opportunity/model.dart';
import 'package:crowdv_mobile_app/utils/design_details.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:inkwell_splash/inkwell_splash.dart';

class CreateOpportunity extends StatefulWidget {
  const CreateOpportunity({Key key}) : super(key: key);

  @override
  _CreateOpportunityState createState() => _CreateOpportunityState();
}

class _CreateOpportunityState extends State<CreateOpportunity> {
  DateTime dateTime = DateTime(2022, 6, 20, 5, 30);
  TimeOfDay time=TimeOfDay(hour: 12, minute: 50) ;
  TimeOfDay _time=TimeOfDay(hour: 12, minute: 50) ;
  String _stateValue = "Alabama";
  String _typevalue ;
  List<String> _state = [
    "Alabama",
    "Alaska",
    "California",
  ];
  List<String> _type = ["Online", "Offline","Both"];
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
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Provide details of your opportunity: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 0.27,
                      color: primaryColor,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text(
                    "Title: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 0.27,
                      color: primaryColor,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: TextFormField(
                  decoration: ThemeHelper()
                      .textInputDecoration('Title', 'Enter your title'),
                ),
                decoration: ThemeHelper().inputBoxDecorationShaddow(),
              ),
              SizedBox(
                height: 25,
              ),
              // Row(
              //   children: [
              //     Text(
              //       "Select Category: ",
              //       style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //         fontSize: 18,
              //         letterSpacing: 0.27,
              //         color: primaryColor,
              //       ),
              //     )
              //   ],
              // ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: 365,
                padding:
                EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                child: Center(
                  child: DropdownButton<String>(
                    isExpanded: true,
                      value: _stateValue,
                      // elevation: 5,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                      iconEnabledColor: primaryColor,
                      items: _state.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      selectedItemBuilder: (BuildContext context) => _state
                          .map((e) => Center(
                        child: Text(
                          e,
                          style: TextStyle(
                              fontSize: 18,
                              color: primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ))
                          .toList(),
                      underline: Container(),
                      onChanged: (String value) {
                        setState(() {
                          _stateValue = value;
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
              // Container(
              //   width: 300,
              //   padding:
              //   EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              //   decoration: BoxDecoration(
              //       color: primaryColor,
              //       borderRadius: BorderRadius.circular(30)),
              //   child: Center(
              //     child: DropdownButton<String>(
              //         value: _chosenValue,
              //         // elevation: 5,
              //         style: TextStyle(
              //             color: Colors.black,
              //             fontSize: 16,
              //             fontWeight: FontWeight.w600),
              //         iconEnabledColor: Colors.white,
              //         items: _items.map<DropdownMenuItem<String>>(
              //                 (String value) {
              //               return DropdownMenuItem<String>(
              //                 value: value,
              //                 child: Text(value),
              //               );
              //             }).toList(),
              //         selectedItemBuilder: (BuildContext context) =>
              //             _items
              //                 .map((e) => Center(
              //               child: Text(
              //                 e,
              //                 style: TextStyle(
              //                     fontSize: 18,
              //                     color: Colors.white,
              //                     fontWeight: FontWeight.bold),
              //               ),
              //             ))
              //                 .toList(),
              //         underline: Container(),
              //         // hint: Text(
              //         //   "Please choose a service",
              //         //   style: TextStyle(
              //         //       fontSize: 18,
              //         //       color: Colors.white,
              //         //       fontWeight: FontWeight.bold),
              //         // ),
              //         // icon: Icon(
              //         //   Icons.arrow_downward,
              //         //   color: Colors.yellow,
              //         // ),
              //         // isExpanded: true,
              //         onChanged: (String value) {
              //           setState(() {
              //             _chosenValue = value;
              //           });
              //         }),
              //   ),
              // ),
              SizedBox(
                height: 25,
              ),
              // Row(
              //   children: [
              //     Text(
              //       "Select Task Type: ",
              //       style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //         fontSize: 18,
              //         letterSpacing: 0.27,
              //         color: primaryColor,
              //       ),
              //     )
              //   ],
              // ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: 365,
                padding:
                EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                child: Center(
                  child: DropdownButton<String>(
                    hint: Center(
                      child: Text(
                        "Select Type",
                        style: TextStyle(
                            fontSize: 18,
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
                      items: _type.map<DropdownMenuItem<String>>((String value) {
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
                                      fontSize: 18,
                                      color: primaryColor,
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
                height: 25,
              ),
              Row(
                children: [
                  Text(
                    "Description: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 0.27,
                      color: primaryColor,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: TextFormField(
                  decoration: ThemeHelper().textInputDecoration(
                      'Description', 'Street address or P.O box'),
                ),
                decoration: ThemeHelper().inputBoxDecorationShaddow(),
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Starting Date: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 0.27,
                          color: primaryColor,
                        ),
                      ),
                      InkWell(
                          onTap: () async {
                            final date = await pickDate();
                            if (date == null) return;
                            final startDate = DateTime(date.year, date.month,
                                date.day);
                            setState(() {
                              dateTime = startDate;
                              print(dateTime.toString());
                            });
                          },
                          child: getTimeBoxUI(
                              '${dateTime.year}/${dateTime.month}/${dateTime.day}',160)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Select time: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 0.27,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(
                        width: 9,
                      ),
                      InkWell(
                          onTap: () async {
                          TimeOfDay newTime=await showTimePicker(context: context, initialTime: time,
                           );
                          if(newTime == null)return;
                          setState(() {
                            time = newTime;
                            print('${time.hour}:${time.minute.toString().padLeft(2, '0')}');
                          });
                          },
                          child: getTimeBoxUI(
                              '$hours:$minutes',100)),
                      SizedBox(
                        width: 5,
                      ),
                      Text('TO',style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(
                        width: 5,
                      ),
                      InkWell(
                          onTap: () async {
                            TimeOfDay endTime=await showTimePicker(context: context, initialTime: _time,
                            );
                            if(endTime == null)return;
                            setState(() {
                              _time = endTime;
                              print(_time.toString());
                            });
                          },
                          child: getTimeBoxUI(
                              '$_hours:$_minutes',100)),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
              SizedBox(height: 40.0),
              InkWellSplash(
                onTap: (){
                  Get.to(()=>Check());
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
                          color: DesignCourseAppTheme.nearlyBlue.withOpacity(0.5),
                          offset: const Offset(-1.1, -1.1),
                          blurRadius: 1.0),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Next Page',
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

  Widget getTimeBoxUI(String text1,double width) {
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
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
}
