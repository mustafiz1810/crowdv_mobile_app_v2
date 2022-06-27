import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/utils/design_details.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/material.dart';

class CreateOpportunity extends StatefulWidget {
  const CreateOpportunity({Key key}) : super(key: key);

  @override
  _CreateOpportunityState createState() => _CreateOpportunityState();
}

class _CreateOpportunityState extends State<CreateOpportunity> {
  DateTime _dateTime = DateTime(2022, 6, 20, 5, 30);
  DateTime dateTime = DateTime(2022, 6, 20, 5, 30);
  String _stateValue = "Alabama";
  String _cityvalue = "Bridgeport";
  List<String> _state = [
    "Alabama",
    "Alaska",
    "California",
  ];
  List<String> _city = ["Bridgeport", "Hartford"];
  @override
  Widget build(BuildContext context) {
    final _hours = _dateTime.hour.toString().padLeft(2, '0');
    final _minutes = _dateTime.minute.toString().padLeft(2, '0');
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
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
            Row(
              children: [
                Text(
                  "Select Category: ",
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
              width: 365,
              child: Center(
                child: DropdownButton<String>(
                    value: _stateValue,
                    // elevation: 5,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                    iconEnabledColor: Colors.white,
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
                color: primaryColor,
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
            Row(
              children: [
                Text(
                  "Select Task Type: ",
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
              width: 365,
              child: Center(
                child: DropdownButton<String>(
                    value: _cityvalue,
                    // elevation: 5,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                    iconEnabledColor: Colors.white,
                    items: _city.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    selectedItemBuilder: (BuildContext context) => _city
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
                        _cityvalue = value;
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
                color: secondaryColor,
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
                      "Starting Date & time: ",
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

                          final time = await pickTime();
                          if (time == null) return;
                          final startDateTime = DateTime(date.year, date.month,
                              date.day, time.hour, time.minute);
                          setState(() {
                            _dateTime = startDateTime;
                            print(_dateTime.toString());
                          });
                        },
                        child: getTimeBoxUI(
                            '${_dateTime.year}/${_dateTime.month}/${_dateTime.day} $_hours:$_minutes')),
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
                      "Ending Date & time: ",
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
                          final date = await pickDate();
                          if (date == null) return;

                          final time = await pickTime();
                          if (time == null) return;
                          final newDateTime = DateTime(date.year, date.month,
                              date.day, time.hour, time.minute);
                          setState(() {
                            dateTime = newDateTime;
                            print(dateTime.toString());
                          });
                        },
                        child: getTimeBoxUI(
                            '${dateTime.year}/${dateTime.month}/${dateTime.day}   $hours:$minutes')),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Container(
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
          ],
        ),
      ),
    );
  }

  Widget getTimeBoxUI(String text1) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        width: 160,
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
  Future<TimeOfDay> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute));
}
