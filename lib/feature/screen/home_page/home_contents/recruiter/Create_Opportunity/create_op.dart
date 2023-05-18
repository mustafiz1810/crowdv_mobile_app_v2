import 'dart:convert';
import 'package:crowdv_mobile_app/common/theme_helper.dart';
import 'package:crowdv_mobile_app/data/models/recruiter/category_model.dart';
import 'package:crowdv_mobile_app/data/models/recruiter/eligiblity_model.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/design_details.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:time_interval_picker/time_interval_picker.dart';

class CreateOpportunity extends StatefulWidget {
  final token;
  const CreateOpportunity({Key key ,this.token}) : super(key: key);

  @override
  _CreateOpportunityState createState() => _CreateOpportunityState();
}

class _CreateOpportunityState extends State<CreateOpportunity> {
  final _formKey = GlobalKey<FormState>();
  DateTime dateTime = DateTime.now();
  String _typevalue;
  List<String> _type = ["Online", "Offline", "Both"];
  String radioButtonItem = 'free';
  bool chargeVisible = false;
  bool eligibilityVisible = false;
  int id = 1;
  List<int> tempArray = [];
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
  bool isVisible = false;
  int _selectedIndex;
  DateTime startT;
  DateTime endT;
  String tileName, slug;
  TextEditingController titleController = TextEditingController();
  TextEditingController chargeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Future myFuture;
  @override
  void initState() {
    super.initState();
    getCountry();
    myFuture = getEligibilityApi();
  }

  List countries = [];
  Future getCountry() async {
    var baseUrl = NetworkConstants.BASE_URL + 'countries';

    Response response = await get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      setState(() {
        countries = jsonData['data'];
      });
    }
  }

  List states = [];
  Future getState(countryId) async {
    var baseUrl = NetworkConstants.BASE_URL + 'get-state-by-country/$countryId';

    Response response = await get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      setState(() {
        states = jsonData['data'];
      });
    }
  }

  List city = [];
  Future getCity(stateId) async {
    var baseUrl = NetworkConstants.BASE_URL + 'get-city-by-state/$stateId';

    Response response = await get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      setState(() {
        city = jsonData['data'];
      });
    }
  }

  var countryvalue;
  var statevalue;
  var cityvalue;
  TextEditingController zipController = TextEditingController();

  Future<EligibilityModel> getEligibilityApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL +
            'category-wise-eligibility/academic'),
        headers: {"Authorization": "Bearer ${widget.token}"});
    var data = jsonDecode(response.body.toString());
    print(data);
    if (response.statusCode == 200) {

      return EligibilityModel.fromJson(data);
    } else {
      return EligibilityModel.fromJson(data);
    }
  }

  Future<CategoryModel> getAllCategory() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'categories'),
        headers: {"Authorization": "Bearer ${widget.token}"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return CategoryModel.fromJson(data);
    } else {
      return CategoryModel.fromJson(data);
    }
  }
  void create(
      title,
      category_id,
      date,
      start_time,
      end_time,
      country,
      state,
      city,
      List<int> answer,
      eligibility,
      details,
      task_type,
      zip_code,
      charge) async {
    String body = json.encode({
      'title': title,
      'category_id': category_id,
      'date': date,
      'start_time': start_time,
      'end_time': end_time,
      'eligibility_id': answer,
      'other': eligibility,
      'details': details,
      'task_type': task_type,
      'country_id': country,
      'state_id': state,
      'city_id': city,
      'zip_code': zip_code,
      'charge': charge
    });
    print(body);
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'opportunity/store'),
          headers: {
            "Authorization": "Bearer ${widget.token}",
            "Content-Type": "application/json"
          },
          body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        // print(data);
        showToast(context, data['message']);
        Navigator.pop(context);
      } else {
        var data = jsonDecode(response.body.toString());
        print(data);
        data['error'].length != 0
            ? showToast(context, data['error']['errors'].toString())
            : showToast(context, data['message']);
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text("Something went wrong"),
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
                                            print(slug.toString());
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
                            width: 340,
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
                  TextButton(
                    onPressed: () {
                      setState(() {
                        if (eligibilityVisible == false) {
                          eligibilityVisible = true;
                        } else
                          (eligibilityVisible = false);
                      });
                    },
                    child: Container(
                      width: 365,
                      height: 50,
                      padding: EdgeInsets.symmetric(
                          vertical: 2, horizontal: 15),
                      child: Center(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Select Eligibility",
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
                  Visibility(
                      visible: eligibilityVisible,
                      child: FutureBuilder<EligibilityModel>(
                        future: myFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
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
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      )
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
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomSearchableDropDown(
                    items: countries,
                    label: 'Select Country',
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black)),
                    dropDownMenuItems: countries?.map((item) {
                      return item['name'];
                    })?.toList() ??
                        [],
                    onChanged: (newVal) {
                      if (newVal != null) {
                        setState(() {
                          states.clear();
                          statevalue = null;
                          city.clear();
                          cityvalue = null;
                          countryvalue = newVal['id'];
                          getState(countryvalue);
                        });
                      } else {
                        countryvalue = null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomSearchableDropDown(
                    items: states,
                    label: 'Division/Province/State',
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black)),
                    dropDownMenuItems: states.map((item) {
                      return item['name'].toString();
                    }).toList() ??
                        [],
                    onChanged: (newVal) {
                      if (newVal != null) {
                        setState(() {
                          city.clear();
                          cityvalue = null;
                          statevalue = newVal['id'];
                          getCity(statevalue);
                          print(statevalue);
                        });
                      } else {
                        statevalue = null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomSearchableDropDown(
                    items: city,
                    label: 'City',
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black)),
                    dropDownMenuItems: city.map((item) {
                      return item['name'].toString();
                    }).toList() ??
                        [],
                    onChanged: (newVal) {
                      if (newVal != null) {
                        cityvalue = newVal['id'];
                        print(cityvalue);
                      } else {
                        cityvalue = null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: zipController,
                      decoration: ThemeHelper()
                          .textInputDecoration('Zip Code', 'Enter your zip code'),
                    ),
                    decoration: ThemeHelper().inputBoxDecorationShaddow(),
                  ),
                  SizedBox(height: 20),
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
                              if (_formKey.currentState.validate()) {
                                create(
                                  titleController.text,
                                  _selectedIndex.toString(),
                                  dateTime.toString(),
                                  '${startT.hour}:${startT.minute.toString().padLeft(2, '0')}',
                                  '${endT.hour}:${endT.minute.toString().padLeft(2, '0')}',
                                  countryvalue.toString(),
                                  statevalue.toString(),
                                  cityvalue.toString(),
                                  tempArray,
                                  othersController.text.toString(),
                                  descriptionController.text,
                                  _typevalue.toString(),
                                  zipController.text.toString(),
                                  chargeController.text,);
                              };
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
                                  "Create Opportunity",
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
