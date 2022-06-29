import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Check extends StatelessWidget {
  const Check({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter DropDownButton',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String token = "";
  List categoryItemlist = [];
  @override
  void initState() {
    super.initState();
    getCred();
    getAllCategory();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
    });
  }

  Future getAllCategory() async {
    http.Response response = await http
        .get(Uri.parse(NetworkConstants.BASE_URL + 'categories'), headers: {
      "Authorization": "Bearer $token",
      'Accept': "application/json"
    });

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        categoryItemlist = jsonData['data'];
        print(jsonData);
      });
    }
  }

  var dropdownvalue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DropDown List"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton(
              hint: Text('hooseNumber'),
              items: categoryItemlist.map((item) {
                return DropdownMenuItem(
                  value: item['data']['id'].toString(),
                  child: Text(item['data']['name'].toString()),
                );
              }).toList(),
              onChanged: (newVal) {
                setState(() {
                  dropdownvalue = newVal;
                  print(token.toString());
                });
              },
              value: dropdownvalue,
            ),
          ],
        ),
      ),
    );
  }
}
