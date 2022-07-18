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
  final dynamic token,id ,title, category, type, description, date, time, etime, slug,eligibility,city,state,zip;
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
      this.city,this.state,this.zip});
  @override
  _EligibilityUpdateState createState() => _EligibilityUpdateState();
}

class _EligibilityUpdateState extends State<EligibilityUpdate> {
  Map<String, bool> numbers = {
    '1': false,
    '2': false,
    '3': false,
    '4': false,
    '5': false,
    '6': false,
    '7': false,
  };

  var holder_1 = [];

  getItems() {
    numbers.forEach((key, value) {
      if (value == true) {
        holder_1.add(key);
      }
    });

    // Printing all selected items on Terminal screen.
    print(holder_1);
    // Here you will get all your selected Checkbox items.

    // Clear array after use.
    holder_1.clear();
  }


  @override
  void initState() {
    super.initState();
    _selectedIndex=widget.eligibility;
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

  int _selectedIndex;
  bool isSelected = false;
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
              getItems();
              Get.to(() => LocationUpdate(
                eligibility: _selectedIndex.toString(),
                title: widget.title,
                category: widget.category,
                type: widget.type,
                description: widget.description,
                date: widget.date,
                time: widget.time,
                etime: widget.etime,
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
              Expanded(
                  child: FutureBuilder<EligibilityModel>(
                    future: getEligibilityApi(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.data.length,
                          itemBuilder: (context, index) {
                            final post = snapshot.data.data[index];
                            return Column(children: <Widget>[
                              Card(
                                child: ListTile(
                                  trailing: isSelected
                                      ? Icon(
                                    Icons.check_circle,
                                    color: primaryColor,
                                  )
                                      : Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.grey,
                                  ),
                                  selected:
                                  snapshot.data.data[index].id == _selectedIndex,
                                  onTap: () {
                                    setState(() {
                                      isSelected=true;
                                      _selectedIndex = snapshot.data.data[index].id;
                                      print(_selectedIndex.toString());
                                    });
                                  },
                                  title: Text("Title:   "+snapshot.data.data[index].title,style: TextStyle(fontWeight: FontWeight.bold),),
                                  subtitle: Text("Details:   "+snapshot.data.data[index].details,style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ),
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
