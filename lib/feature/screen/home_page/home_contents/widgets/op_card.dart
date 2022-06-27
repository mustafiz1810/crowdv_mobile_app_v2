import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/widgets/details.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/route_manager.dart';

class OpportunityCard extends StatelessWidget {
  OpportunityCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20),
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
        child: NameCard(),
      ),
    );
  }
}

class NameCard extends StatelessWidget {
  const NameCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Heading',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Container(
                    width: 80,
                    height: 35,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Center(
                        child: Text('Status',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.white))),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 1,
              height: 10,
              color: primaryColor,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Opportunity details..',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Location : ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text('Los Angeles',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14))
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Job Type: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text('Offline',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => OpportunityDetails());
                          },
                          child: Container(
                            // width: 80,
                            // height: 30,
                            // margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                            // decoration: BoxDecoration(
                            //   color: primaryColor,
                            //   borderRadius: BorderRadius.all(Radius.circular(20)),
                            // ),
                            child: Center(
                                child: Text('Details...',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: primaryColor))),
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
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
    );
  }
}
