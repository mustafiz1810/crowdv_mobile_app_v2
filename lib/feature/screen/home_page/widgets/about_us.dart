import 'dart:convert';
import 'dart:ui';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../../data/models/text_model.dart';
import '../../../../utils/view_utils/common_util.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key key}) : super(key: key);
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
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 2.3,
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
                                        snapshot.data.data.companyName,
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
                                        height: 40,
                                        child: Text(snapshot.data.data.tagLine
                                            .toString()),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.add_link_rounded,
                                                color: Colors.blueAccent,
                                                size: 20,
                                              ),
                                              TextButton(
                                                  onPressed: () async {
                                                    String _url = snapshot
                                                        .data.data.webAddress;
                                                    print('launching');
                                                    try {
                                                      await canLaunch(_url)
                                                          ? await launch(_url)
                                                          : throw 'Could not launch $_url';
                                                    } catch (_, __) {
                                                      showToast("Failed");
                                                    }
                                                  },
                                                  child: SizedBox(
                                                      width: 200,
                                                      height: 20,
                                                      child: Text(snapshot.data
                                                          .data.webAddress))),
                                            ],
                                          ),
                                          InkWell(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text("Address"),
                                                        content: Row(
                                                          children: [
                                                            Flexible(
                                                                child: Text(
                                                                    snapshot
                                                                        .data
                                                                        .data
                                                                        .address)),
                                                          ],
                                                        ),
                                                        actions: [
                                                          FlatButton(
                                                            child: Text(
                                                              "ok",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            color: primaryColor,
                                                          )
                                                        ],
                                                      );
                                                    });
                                              },
                                              child: Text(
                                                "Address",
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline),
                                              ))
                                        ],
                                      ),
                                      Divider(
                                        height: 1,
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
                                          Row(
                                            children: [
                                              Icon(
                                                Icons
                                                    .home_repair_service_outlined,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                snapshot.data.data.companyName,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.phone,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                snapshot.data.data.phoneNumber,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.email_outlined,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            snapshot.data.data.email,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Column(children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.facebook_rounded,
                                              color: Colors.blueAccent,
                                              size: 20,
                                            ),
                                            InkWell(
                                              onTap: ()async{
                                                String _url = snapshot
                                                    .data.data.facebook;
                                                print('launching');
                                                try {
                                                  await canLaunch(_url)
                                                      ? await launch(_url)
                                                      : throw 'Could not launch $_url';
                                                } catch (_, __) {
                                                  showToast("Failed");
                                                }
                                              },
                                              child: SizedBox(
                                                  width: 200,
                                                  height: 20,
                                                  child: Text(snapshot.data
                                                      .data.facebook)),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.add_link_rounded,
                                              color: Colors.lightBlueAccent,
                                              size: 20,
                                            ),
                                            InkWell(
                                              onTap: ()async{
                                                String _url = snapshot
                                                    .data.data.twitter;
                                                print('launching');
                                                try {
                                                  await canLaunch(_url)
                                                      ? await launch(_url)
                                                      : throw 'Could not launch $_url';
                                                } catch (_, __) {
                                                  showToast("Failed");
                                                }
                                              },
                                              child: SizedBox(
                                                  width: 200,
                                                  height: 20,
                                                  child: Text(snapshot.data
                                                      .data.twitter)),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.add_link_rounded,
                                              color: Colors.deepPurpleAccent,
                                              size: 20,
                                            ),
                                            InkWell(
                                              onTap: ()async{
                                                String _url = snapshot
                                                    .data.data.instagram;
                                                print('launching');
                                                try {
                                                  await canLaunch(_url)
                                                      ? await launch(_url)
                                                      : throw 'Could not launch $_url';
                                                } catch (_, __) {
                                                  showToast("Failed");
                                                }
                                              },
                                              child: SizedBox(
                                                  width: 200,
                                                  height: 20,
                                                  child: Text(snapshot.data
                                                      .data.instagram)),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.add_link_rounded,
                                              color: Colors.red,
                                              size: 20,
                                            ),
                                            InkWell(
                                              onTap: ()async{
                                                String _url = snapshot
                                                    .data.data.youtube;
                                                print('launching');
                                                try {
                                                  await canLaunch(_url)
                                                      ? await launch(_url)
                                                      : throw 'Could not launch $_url';
                                                } catch (_, __) {
                                                  showToast("Failed");
                                                }
                                              },
                                              child: SizedBox(
                                                  width: 200,
                                                  height: 20,
                                                  child: Text(snapshot.data
                                                      .data.youtube)),
                                            )
                                          ],
                                        ),
                                      ],),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          snapshot.data.data.aboutUs,
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
        ));
  }
}
