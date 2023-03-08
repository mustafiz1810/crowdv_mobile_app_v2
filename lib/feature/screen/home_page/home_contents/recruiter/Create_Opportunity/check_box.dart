import 'dart:convert';
import 'package:crowdv_mobile_app/data/models/recruiter/eligiblity_model.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/recruiter/Create_Opportunity/set_location.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/design_details.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:inkwell_splash/inkwell_splash.dart';
import 'package:http/http.dart' as http;

class CheckBox extends StatefulWidget {
  final dynamic token,title, category, type, description, date, time, etime, slug,charge;
  CheckBox(
      {@required
      this.token,
      this.title,
      this.category,
      this.type,
      this.description,
      this.date,
      this.time,
      this.etime,
      this.slug,this.charge});
  @override
  _CheckBoxState createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  List<int> tempArray = [];
 Future myFuture;
 var index =0;
  var arr;
  TextEditingController othersController = TextEditingController();
  void _answerQuestion(int id) {
    if(tempArray.contains(id)){
      tempArray.remove(id);
      print(tempArray);
    }else{
      // arr = {
      //   index.toString() : id,
      // };
      tempArray.add(id);
      print(tempArray);
      // setState(() {
      //   index += 1;
      // });
    }

  }

  Future<EligibilityModel> getEligibilityApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL +
            'category-wise-eligibility/${widget.slug}'),
        headers: {"Authorization": "Bearer ${widget.token}"});
    var data = jsonDecode(response.body.toString());
    print(data);
    if (response.statusCode == 200) {
      return EligibilityModel.fromJson(data);
    } else {
      return EligibilityModel.fromJson(data);
    }
  }
  @override
  void initState() {
    super.initState();
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
          child: InkWell(
            onTap: () {
              // getItems();
              Get.to(() => OpLocation(
                eligibility:othersController.text.toString(),
                    answer: tempArray,
                    title: widget.title,
                    category: widget.category,
                    type: widget.type,
                    description: widget.description,
                    date: widget.date,
                    time: widget.time,
                    etime: widget.etime,
                charge: widget.charge,
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
              Expanded(child: FutureBuilder<EligibilityModel>(
                future: myFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data.data.length,
                            itemBuilder: (context, index) {
                              return Column(children: <Widget>[
                                Card(child: new CheckboxListTile(
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
                                        value: snapshot.data.data[index].isChecked,
                                        onChanged: (bool value) {
                                          setState(() {
                                            snapshot.data.data[index].isChecked = value;
                                            _answerQuestion(snapshot.data.data[index].id);
                                          });
                                        })),
                              ]);
                            },
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          //--------------------------------here is discription
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: TextFormField(
                                textInputAction: TextInputAction.done,
                                controller: othersController,
                                maxLines: 3,
                                maxLength: 100,
                                decoration: InputDecoration(
                                  hintText: "Enter your eligibility",
                                    hintStyle: TextStyle(
                                      fontSize: 14
                                    ),
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
                              ),
                            ),
                          ),
                        ],
                      ),
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
