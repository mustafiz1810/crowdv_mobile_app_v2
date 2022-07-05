import 'dart:convert';
import 'package:crowdv_mobile_app/data/models/volunteer/history_model.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:crowdv_mobile_app/widgets/sample_card.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VolunteerHistory extends StatefulWidget {
  @override
  _VolunteerHistoryState createState() => _VolunteerHistoryState();
}

class _VolunteerHistoryState extends State<VolunteerHistory> {
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

  Future<VolunteerHistoryModel> getVHistoryApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'volunteer/task/history'),
        headers: {"Authorization": "Bearer ${token}"});
    var data = jsonDecode(response.body.toString());
    showToast(context, data['message']);
    if (response.statusCode == 200) {
      return VolunteerHistoryModel.fromJson(data);
    } else {
      return VolunteerHistoryModel.fromJson(data);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('History'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                  child: FutureBuilder<VolunteerHistoryModel>(
                    future: getVHistoryApi(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10,right: 10),
                              child: Container(
                                width: 350,
                                height: 240,
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                decoration: BoxDecoration(
                                  // image: DecorationImage(
                                  //   fit: BoxFit.cover,
                                  //   image: AssetImage("assets/undraw_pilates_gpdb.png"),
                                  // ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: shadowColor.withOpacity(0.4),
                                      spreadRadius: .1,
                                      blurRadius: 2,
                                      // offset: Offset(0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text('Heading',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                              Container(
                                                width: 80,
                                                height: 35,
                                                margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                                decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                                ),
                                                child: Center(child: Text('Details',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.white))),
                                              )
                                            ],
                                          ),
                                        ),
                                        Divider(thickness: 1,height: 10,color: primaryColor,),
                                        Padding(
                                            padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text('Opportunity details..',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text('Location : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                                    Text('Los Angeles',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)                )
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text('Job Type: ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                                                    Text('Offline',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)                )
                                                  ],
                                                ),
                                              ],
                                            )

                                        ),
                                      ],
                                    ),
                                    Positioned(
                                        top: 150,
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(
                                            height: 83,
                                            width: 342,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(Radius.circular(20)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: shadowColor.withOpacity(0.2),
                                                  spreadRadius: .1,
                                                  blurRadius: 3,
                                                  // offset: Offset(0, 1), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                          ),
                                        )),
                                    Positioned(
                                        right: 10,
                                        top: 195,
                                        child: Row(
                                          children: [
                                            IconBox(
                                              child: Icon(
                                                Icons.message_rounded,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              bgColor: primaryColor,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            IconBox(
                                              child: Icon(
                                                Icons.report,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              bgColor: Colors.redAccent,
                                            ),
                                          ],
                                        )),
                                    Positioned(
                                        left: 10,
                                        top: 170,
                                        child: Row(
                                          children: [
                                            Column(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: AssetImage('assets/crowdv_jpg.jpg'),
                                                  radius: 30,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Mustafizur Rahman",
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 16, fontWeight: FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    RatingBar.builder(
                                                      itemSize: 20,
                                                      initialRating: 3,
                                                      minRating: 1,
                                                      direction: Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemPadding:
                                                      EdgeInsets.symmetric(horizontal: 4.0),
                                                      itemBuilder: (context, _) => Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      onRatingUpdate: (rating) {
                                                        print(rating);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  )),
            ],
          ),
        )
    );
  }
}
