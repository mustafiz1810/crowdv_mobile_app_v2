import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/design_details.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProfileUpdate extends StatefulWidget {
  final dynamic token, fname, lname, email, phone, dob;
  ProfileUpdate({
    @required this.token,
    this.fname,
    this.lname,
    this.email,
    this.phone,
    this.dob,
  });
  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    fnameController.text = widget.fname.toString();
    lnameController.text = widget.lname.toString();
    emailController.text = widget.email.toString();
    phoneController.text = widget.phone.toString();
    dateTime = widget.dob;
    super.initState();
  }

  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  void update(String fname, lname, email, phone, date) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'profile/update?type=basic'),
          headers: {
            "Authorization": "Bearer ${widget.token}"
          },
          body: {
            "first_name": fname,
            "last_name": lname,
            "email": email,
            "phone": phone,
            "dob": date,
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
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //--------------------------------here is Fname
              Container(
                child: TextFormField(
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
              //--------------------------------here is email
              Container(
                child: TextFormField(
                  controller: emailController,
                  decoration: ThemeHelper()
                      .textInputDecoration('Email', 'Update Your email'),
                ),
                decoration: ThemeHelper().inputBoxDecorationShaddow(),
              ),
              SizedBox(
                height: 25,
              ),
              //--------------------------------here is phone
              Container(
                child: TextFormField(
                  controller: phoneController,
                  decoration: ThemeHelper()
                      .textInputDecoration('Phone', 'Update Your phone'),
                ),
                decoration: ThemeHelper().inputBoxDecorationShaddow(),
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
              SizedBox(height: 20.0),
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
                              fnameController.text.toString(),
                              lnameController.text.toString(),
                              emailController.text.toString(),
                              phoneController.text.toString(),
                              dateTime.toString());
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
              )
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
