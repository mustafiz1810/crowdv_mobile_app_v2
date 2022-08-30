import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/design_details.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProfileUpdate extends StatefulWidget {
  final dynamic token, fname, lname, email, phone, dob, prof, gender;
  ProfileUpdate(
      {@required this.token,
      this.fname,
      this.lname,
      this.email,
      this.phone,
      this.dob,
      this.prof,
      this.gender});
  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  DateTime dateTime = DateTime.now();
  String _profession;
  String _gender;
  List<String> _items = ["Business", "Student", "Service", "Self-employer"];
  List<String> _item = ["Male", "Female", "Other"];
  @override
  void initState() {
    widget.prof == null ? _profession = "Business" : _profession = widget.prof;
    widget.gender == null ? _gender = "Male" : _gender = widget.gender;
    fnameController.text = widget.fname.toString();
    lnameController.text = widget.lname.toString();
    dateTime = widget.dob;
    super.initState();
  }

  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  void update(String fname, lname,date,profession,gender) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'profile/update?type=basic'),
          headers: {
            "Authorization": "Bearer ${widget.token}"
          },
          body: {
            "first_name": fname,
            "last_name": lname,
            "dob": date,
            "profession":profession,
            "gender":gender,
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(data);
        showToast(context, data['message']);
        Navigator.pop(context);
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
                    update(
                        fnameController.text.toString(),
                        lnameController.text.toString(),
                        dateTime.toString(),
                        _profession,
                        _gender);

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
                height: 25,
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
                height: 25,
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
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          value: _profession,
                          isExpanded: true,
                          // elevation: 5,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
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
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
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
              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: "Gender",
                      hintText: "Gender",
                      fillColor: Colors.white,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      filled: true,
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          // elevation: 5,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
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
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
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
                height: 25,
              ),
              //--------------------------------here is date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Date of Birth: ",
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
        lastDate: DateTime.now(),
      );
}
