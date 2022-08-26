import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/design_details.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:inkwell_splash/inkwell_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';

class OrgOpportunity extends StatefulWidget {
  const OrgOpportunity({Key key}) : super(key: key);

  @override
  _OrgOpportunityState createState() => _OrgOpportunityState();
}

class _OrgOpportunityState extends State<OrgOpportunity> {
  String token = "";

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
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  void create(String title, link) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'organization/opportunity'),
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          },
          body: {
            'title': title,
            'link': link,
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // print(data);
        showToast(context, data['message']);
       Navigator.pop(context);
      } else {
        var data = jsonDecode(response.body.toString());
        showToast(context, data['errors'].toString());
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Exception:"),
              content: Text(e.toString()),
              actions: [
                TextButton(
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
          'Create Opportunity',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWellSplash(
          onTap: () {
            create(
              titleController.text.toString(),
              descriptionController.text.toString(),
            );// button pressed
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
                'Create Opportunity',
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
                height: 25,
              ),
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
                height: 25,
              ),
              Row(
                children: [
                  Text(
                    "Link: ",
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
              //--------------------------------here is link
              Container(
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  controller: descriptionController,
                  maxLines: 5,
                  maxLength: 100,
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
                      hintText: "https://link",
                      fillColor: Colors.grey.shade200),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
