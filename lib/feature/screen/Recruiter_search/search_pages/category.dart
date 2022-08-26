import 'dart:convert';
import 'package:crowdv_mobile_app/data/models/recruiter/Volunteer_Category.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/widgets/chat.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class Category extends StatefulWidget {
  final dynamic token,categoryId;
  Category({this.token,this.categoryId});
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<Category> {

  Future<CategoryVolunteer> getCateVolunteerApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'category-wise-volunteer-search?category_id=${widget.categoryId}'),
        headers: {"Authorization": "Bearer ${widget.token}"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return CategoryVolunteer.fromJson(data);
    } else {
      return CategoryVolunteer.fromJson(data);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('Category'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: FutureBuilder<CategoryVolunteer>(
                    future: getCateVolunteerApi(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data.data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 10, right: 10),
                              child: Container(
                                width: 350,
                                height: 200,
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                decoration: BoxDecoration(
                                  // image: DecorationImage(
                                  //   fit: BoxFit.cover,
                                  //   image: AssetImage("assets/undraw_pilates_gpdb.png"),
                                  // ),
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: shadowColor.withOpacity(0.4),
                                      spreadRadius: .1,
                                      blurRadius: 2,
                                      // offset: Offset(0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child:  Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 20, top: 10,bottom: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                snapshot.data.data[index].firstName+" "+snapshot.data.data[index].lastName,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              ),
                                              snapshot.data.data[index].isOnline == true ?Icon(
                                                Icons
                                                    .fiber_manual_record_rounded,
                                                size: 12,
                                                color:
                                                Colors.green,
                                              ):Icon(
                                                Icons
                                                    .fiber_manual_record_rounded,
                                                size: 12,
                                                color:
                                                Colors.grey,
                                              ),
                                            ],
                                          ),
                                          IconBox(
                                            child: Icon(
                                              Icons.message_rounded,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            onTap: (){
                                              Get.to(() => ChatUi());
                                            },
                                            bgColor: primaryColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      thickness: 1,
                                      height: 5,
                                      color: primaryColor,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Email : ',
                                                style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 15),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                'Phone : ',
                                                style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 15),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                'Location: ',
                                                style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 15),
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Text(
                                                'Rating: ',
                                                style: TextStyle(
                                                    color: primaryColor,
                                                    fontSize: 15),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                snapshot.data.data[index].email,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  snapshot
                                                      .data.data[index].phone,
                                                  style: TextStyle(
                                                      fontSize: 14)),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  snapshot
                                                      .data
                                                      .data[index].state+", "+ snapshot
                                                      .data
                                                      .data[index].city,
                                                  style: TextStyle(
                                                      fontSize: 14)),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  snapshot
                                                      .data
                                                      .data[index].rating.toString(),
                                                  style: TextStyle(
                                                      fontSize: 14))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Container(
                          alignment: Alignment.center,
                          child: EmptyWidget(
                            image: null,
                            packageImage: PackageImage.Image_1,
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
                      }
                    },
                  )),
            ],
          ),
        ),
    );
  }
}
