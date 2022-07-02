import 'package:crowdv_mobile_app/data/models/recruiter/category_model.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Check extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<Check> {
  List<dynamic> _category = List();
  @override
  void initState() {
    super.initState();
    getCred();
    getAllCategory();
  }

  String token = "";
  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
    });
  }

  Future<CategoryModel> getAllCategory() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'categories'),
        headers: {"Authorization": "Bearer ${token}"});
    var data = jsonDecode(response.body.toString());
    setState(() {
      _category = data['data'];
    });
    showToast(context, data['message']);
    if (response.statusCode == 200) {
      return CategoryModel.fromJson(data);
    } else {
      return CategoryModel.fromJson(data);
    }
  }

  var dropdownvalue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dropdown #API"),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                  child: FutureBuilder<CategoryModel>(
                future: getAllCategory(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      width: 365,
                      padding:
                          EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                      child: Center(
                        child: DropdownButton(
                          hint: Center(
                            child: Text(
                              "Select Category",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          iconEnabledColor: primaryColor,
                          isExpanded: true,
                          underline: Container(),
                          items: _category.map((item) {
                            return DropdownMenuItem(
                              value: item['id'].toString(),
                              child: Text(item['name'].toString()),
                            );
                          }).toList(),
                          onChanged: (newVal) {
                            setState(() {
                              dropdownvalue = newVal;
                              print(dropdownvalue.toString());
                            });
                          },
                          value: dropdownvalue,
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
                        borderRadius: BorderRadius.circular(30),
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
