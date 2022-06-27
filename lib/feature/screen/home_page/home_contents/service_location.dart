import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../../Search/search_pages/location.dart';

class ServiceLocation extends StatefulWidget {
  const ServiceLocation({Key key}) : super(key: key);

  @override
  _ServiceLocationState createState() => _ServiceLocationState();
}

class _ServiceLocationState extends State<ServiceLocation> {
  String _chosenValue = "Alabama";
  String _dropdown = "Bridgeport";
  List<String> _state = [
    "Alabama",
    "Alaska",
    "California",
  ];
  List<String> _city = ["Bridgeport", "Hartford"];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
            Container(
              width: 360,
              child: Center(
                child: DropdownButton<String>(
                    value: _chosenValue,
                    // elevation: 5,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                    iconEnabledColor: Colors.white,
                    items: _state.map<DropdownMenuItem<String>>(
                            (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    selectedItemBuilder: (BuildContext context) =>
                        _state
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
                        _chosenValue = value;
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
            SizedBox(
              height: 5,
            ),
            Container(
              width: 360,
              child: Center(
                child: DropdownButton<String>(
                    value: _dropdown,
                    // elevation: 5,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                    iconEnabledColor: Colors.white,
                    items: _city.map<DropdownMenuItem<String>>(
                            (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    selectedItemBuilder: (BuildContext context) =>
                        _city
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
            SizedBox(height: 10),
            Container(
              child: TextFormField(
                decoration: ThemeHelper().textInputDecoration(
                    'Zip Code', 'Enter your zip code'),
              ),
              decoration: ThemeHelper().inputBoxDecorationShaddow(),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox.fromSize(
                  size: Size(120, 50), // button width and height
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    color: primaryColor, // button color
                    child: InkWell(
                      splashColor: secondaryColor, // splash color
                      onTap: () {
                      }, // button pressed
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5,),// icon
                          Text(
                            "Save",
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),
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
