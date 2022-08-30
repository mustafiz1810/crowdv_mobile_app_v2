import 'dart:convert';
import 'dart:ui';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../data/models/text_model.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key key}) : super(key: key);
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
          title: Text("About Us"),
          backgroundColor: primaryColor,
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height/4,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              color: Color(0xFF98c1d9)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                        height:50,
                                        width: 100,
                                        child: Image.network(snapshot.data.data.logo)
                                    ),
                                    SizedBox(width: 10,),
                                    Text(snapshot.data.data.companyName,style: TextStyle(color:Colors.white,fontSize: 24,fontWeight: FontWeight.bold),)
                                  ],
                                ),
                                SizedBox(height: 60,),
                                Divider(
                                  height: 5,
                                  thickness: 1,
                                ),
                                Text(
                                  snapshot.data.data.address,style: TextStyle(color:Colors.white,),
                                ),
                                Text(
                                  snapshot.data.data.email,style: TextStyle(color:Colors.white,),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(snapshot.data.data.termsAndConditions,
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.justify,
                          // new
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
        )
    );
  }
}
