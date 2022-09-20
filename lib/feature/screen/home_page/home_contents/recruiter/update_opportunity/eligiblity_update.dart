import 'dart:convert';
import 'package:crowdv_mobile_app/data/models/recruiter/eligiblity_model.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/recruiter/update_opportunity/location_update.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/design_details.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:inkwell_splash/inkwell_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EligibilityUpdate extends StatefulWidget {
  final dynamic token,id ,title, category, type, description, date, time, etime, slug,eligibility,country,city,state,zip;
  EligibilityUpdate(
      {@required this.token,
        this.id,
      this.title,
        this.category,
        this.type,
        this.description,
        this.date,
        this.time,
        this.etime,
        this.slug,
      this.eligibility,
        this.country,
      this.city,this.state,this.zip});
  @override
  _EligibilityUpdateState createState() => _EligibilityUpdateState();
}
class _EligibilityUpdateState extends State<EligibilityUpdate> {
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
            'category-wise-eligibility/${widget.slug}'),
        headers: {"Authorization": "Bearer ${widget.token}"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return EligibilityModel.fromJson(data);
    } else {
      return EligibilityModel.fromJson(data);
    }
  }

  @override
  void initState() {
    super.initState();
    tempArray = widget.eligibility;
    myFuture = getEligibilityApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          // collapsedHeight: 150,
          title: const Text(
            'Eligibility',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: primaryColor,
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 20.0, left: 40, right: 40),
          child: InkWellSplash(
            onTap: () {
              // getItems();
              Get.to(() => LocationUpdate(
                eligibility: tempArray,
                title: widget.title,
                category: widget.category,
                type: widget.type,
                description: widget.description,
                date: widget.date,
                time: widget.time,
                etime: widget.etime,
                country:widget.country,
                city:widget.city,
                state:widget.state,
                zip: widget.zip,
                id:widget.id,
                token: widget.token,
              ));
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
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Text(
                      "Please select eligibility, ",
                      style: TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Expanded(child: FutureBuilder<EligibilityModel>(
                future: myFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
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
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )),
            ],
          ),
        ));
  }
}
