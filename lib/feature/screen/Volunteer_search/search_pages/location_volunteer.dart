import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../../../data/models/volunteer/task_search_location.dart';
import '../../home_page/home_contents/widgets/details.dart';

class VolunteerLocation extends StatefulWidget {
  final dynamic token,role, state,city;
  VolunteerLocation({this.token,this.role, this.state,this.city});
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<VolunteerLocation> {
  Future<LocationWiseTask> getLocTaskApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL +
            'location-wise-task-search?state=${widget.state}&city=${widget.city}'),
        headers: {"Authorization": "Bearer ${widget.token}"});
    var data = jsonDecode(response.body.toString());
    print(data);
    if (response.statusCode == 200) {
      return LocationWiseTask.fromJson(data);
    } else {
      return LocationWiseTask.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder<LocationWiseTask>(
                  future: getLocTaskApi(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.data.data.length == 0) {
                        return Container(
                          alignment: Alignment.center,
                          child: EmptyWidget(
                            image: null,
                            packageImage: PackageImage.Image_3,
                            title: 'No Opportunity',
                            subTitle: 'No  Opportunity available',
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
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(5),
                              child: InkWell(
                                onTap: () {
                                  print(
                                    snapshot.data.data[index].status,
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OpportunityDetails(
                                            status:
                                            snapshot.data.data[index].status,
                                            role: widget.role,
                                            id: snapshot.data.data[index].id,
                                            token: widget.token)),
                                  ).then((value) => setState(() {}));
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height / 3.3,
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: shadowColor.withOpacity(0.6),
                                        spreadRadius: -1,
                                        blurRadius: 4,
                                        // offset: Offset(0, 1), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(23.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data.data[index].title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              width: 200,
                                              height: 50,
                                              child: Text(
                                                snapshot.data.data[index].details,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 25,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on_rounded,
                                                  color: Colors.blueAccent,
                                                  size: 20,
                                                ),
                                                Text(
                                                  snapshot.data.data[index].city !=
                                                      null
                                                      ? snapshot
                                                      .data.data[index].city
                                                      : "",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.blueAccent,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Divider(
                                              height: 5,
                                              color: Colors.grey.withOpacity(.5),
                                              thickness: 1,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .watch_later_outlined,
                                                          color: Colors.black,
                                                          size: 15,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          snapshot.data.data[index].datumStartTime,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          "-",
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          snapshot.data.data[index]
                                                              .datumEndTime,
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.calendar_today,
                                                          size: 15,
                                                        ),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(snapshot
                                                            .data.data[index].date.toString()),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                // Stack(
                                                //   children: [
                                                //     Container(
                                                //       width:80,
                                                //       child: Row(
                                                //         children: [
                                                //           CircleAvatar(
                                                //           backgroundImage: AssetImage("assets/avater.png"),
                                                //           backgroundColor: Colors.black12,
                                                //           radius: 20,
                                                //   ),
                                                //         ],
                                                //       ),
                                                //     ),
                                                //     Positioned(
                                                //       left: 25,
                                                //       child: CircleAvatar(
                                                //       backgroundImage: AssetImage("assets/avater.png"),
                                                //       backgroundColor: Colors.black12,
                                                //       radius: 20,
                                                //     ),)
                                                //   ]
                                                // ),
                                                Container(
                                                  width: 80,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(20)),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                        snapshot.data.data[index]
                                                            .status,
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 14,
                                                            color:
                                                            Colors.deepOrange)),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                          top: 20,
                                          right: 20,
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            child: IconBox(
                                              child:CachedNetworkImage(
                                                imageUrl: snapshot
                                                    .data.data[index].category.icon,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                        ),
                                                      ),
                                                    ),
                                                placeholder: (context, url) =>
                                                    Icon(Icons.downloading_rounded,size: 40,),
                                                errorWidget: (context, url, error)
                                                => Icon(Icons.image_outlined,size: 40,),
                                              ) ,
                                              bgColor: Colors.white,
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                    } else if (snapshot.connectionState == ConnectionState.none) {
                      return Text('Error'); // error
                    } else {
                      return Center(child: CircularProgressIndicator()); // loading
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}
