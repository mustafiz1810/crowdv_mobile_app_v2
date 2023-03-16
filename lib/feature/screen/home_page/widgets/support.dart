import 'package:crowdv_mobile_app/data/models/text_model.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../../../data/models/text_model.dart';

class SupportPage extends StatelessWidget {
  Future<TextModel> getAboutApi() async {
    final response =
        await http.get(Uri.parse(NetworkConstants.BASE_URL + 'settings'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      print(data);
      return TextModel.fromJson(data);
    } else {
      return TextModel.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Help Line'),
      ),
      body: FutureBuilder<TextModel>(
        future: getAboutApi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.data == null) {
              return Container(
                alignment: Alignment.center,
                child: EmptyWidget(
                  image: null,
                  packageImage: PackageImage.Image_3,
                  title: 'Empty',
                  titleTextStyle: TextStyle(
                    fontSize: 22,
                    color: Color(0xff9da9c7),
                    fontWeight: FontWeight.w500,
                  ),
                  subtitleTextStyle: TextStyle(
                    fontSize: 14,
                    color: Color(0xffabb8d6),
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.headset),
                          SizedBox(width: 10,),
                          Text(
                            'Contact Us',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            "Phone :",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () => launch('tel:${snapshot.data.data.phoneNumber}'),
                            child: Text(
                              snapshot.data.data.phoneNumber,
                              style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            "Email :",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 16),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () => launch('mailto:${snapshot.data.data.email}'),
                            child: Text(
                              snapshot.data.data.email,
                              style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Name',
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Message',
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: primaryColor, //background color
                            onPrimary: Colors.black,
                            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),//ripple color
                          ),
                        onPressed: () {},
                        child: Text('Submit',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.none) {
            return Text('Error'); // error
          } else {
            return Center(child: CircularProgressIndicator()); // loading
          }
        },
      ),
    );
  }
}
