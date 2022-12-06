import 'dart:convert';
import 'dart:ui';

import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../data/models/text_model.dart';

class TermsCondition extends StatelessWidget {
  const TermsCondition({Key key}) : super(key: key);
  Future<TextModel> getAboutApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'settings'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return TextModel.fromJson(data);
    } else {
      return TextModel.fromJson(data);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Terms & Conditions"),
        backgroundColor: primaryColor,
      ),
        body: FutureBuilder<TextModel>(
      future: getAboutApi(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Icon(
                            Icons.description_outlined,
                            color: Colors.blue,
                            size: 50,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Terms & Conditions",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Last update: December 6 2022",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(snapshot.data.data.termsAndConditions,
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.left,
                    // new
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    )
    );
  }
}
