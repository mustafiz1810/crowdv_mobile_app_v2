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
import 'package:getwidget/getwidget.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key key}) : super(key: key);
  Future<TextModel> getAboutApi() async {
    final response =
        await http.get(Uri.parse(NetworkConstants.BASE_URL + 'settings'));
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
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
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
                            child: Padding(
                              padding: const EdgeInsets.all(23.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    snapshot.data.data.companyName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: 200,
                                    height: 40,
                                    child: Text(
                                        snapshot.data.data.tagLine.toString()),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          GFIconButton(
                                            size: GFSize.SMALL,
                                            color: Colors.blue.withOpacity(0.2),
                                            onPressed: () async {
                                              String _url =
                                                  snapshot.data.data.webAddress;
                                              print('launching');
                                              try {
                                                await canLaunch(_url)
                                                    ? await launch(_url)
                                                    : throw 'Could not launch $_url';
                                              } catch (_, __) {
                                                showToast("Failed");
                                              }
                                            },
                                            icon: Image.asset(
                                                "assets/icons8-website-48.png"),
                                            shape: GFIconButtonShape.circle,
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
                                              child: Text(
                                                "Website",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                    decoration: TextDecoration
                                                        .underline),
                                              )),
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
                                                            child: Text(snapshot
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
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context)
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
                                                decoration:
                                                    TextDecoration.underline),
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
                                    children: [
                                      Text(
                                        "Name :",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16),
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
                                      Text(
                                        "Phone :",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16),
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
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Email :",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        snapshot.data.data.email,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(
                                    height: 4,
                                    color: Colors.grey.withOpacity(.5),
                                    thickness: 1,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            GFIconButton(
                                              onPressed: () async {
                                                String _url =
                                                    snapshot.data.data.facebook;
                                                print('launching');
                                                try {
                                                  await canLaunch(_url)
                                                      ? await launch(_url)
                                                      : throw 'Could not launch $_url';
                                                } catch (_, __) {
                                                  showToast("Failed");
                                                }
                                              },
                                              icon: Icon(Icons.facebook),
                                              shape: GFIconButtonShape.circle,
                                              size: GFSize.SMALL,
                                            ),
                                            TextButton(
                                                onPressed: () async {
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
                                                child: Text(
                                                  "Facebook",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      decoration: TextDecoration
                                                          .underline),
                                                )),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            GFIconButton(
                                              size: GFSize.SMALL,
                                              onPressed: () async {
                                                String _url =
                                                    "https://www.linkedin.com/company/crowdvsquad/";
                                                print('launching');
                                                try {
                                                  await canLaunch(_url)
                                                      ? await launch(_url)
                                                      : throw 'Could not launch $_url';
                                                } catch (_, __) {
                                                  showToast("Failed");
                                                }
                                              },
                                              icon: Image.asset(
                                                  "assets/icons8-linkedin-48.png"),
                                              shape: GFIconButtonShape.circle,
                                            ),
                                            TextButton(
                                                onPressed: () async {
                                                  String _url =
                                                      "https://www.linkedin.com/company/crowdvsquad/";
                                                  print('launching');
                                                  try {
                                                    await canLaunch(_url)
                                                        ? await launch(_url)
                                                        : throw 'Could not launch $_url';
                                                  } catch (_, __) {
                                                    showToast("Failed");
                                                  }
                                                },
                                                child: Text(
                                                  "Linkedin",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      decoration: TextDecoration
                                                          .underline),
                                                )),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            GFIconButton(
                                              size: GFSize.SMALL,
                                              color: Colors.lightBlueAccent,
                                              onPressed: () async {
                                                String _url =
                                                    snapshot.data.data.twitter;
                                                print('launching');
                                                try {
                                                  await canLaunch(_url)
                                                      ? await launch(_url)
                                                      : throw 'Could not launch $_url';
                                                } catch (_, __) {
                                                  showToast("Failed");
                                                }
                                              },
                                              icon: Image.asset(
                                                  "assets/twitter.png"),
                                              shape: GFIconButtonShape.circle,
                                            ),
                                            TextButton(
                                                onPressed: () async {
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
                                                child: Text(
                                                  "Twitter",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      decoration: TextDecoration
                                                          .underline),
                                                )),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            GFIconButton(
                                              size: GFSize.SMALL,
                                              color: Colors.white,
                                              boxShadow: BoxShadow(
                                                color: Colors.black26,
                                                blurRadius:
                                                    3.0, // soften the shadow
                                                spreadRadius:
                                                    1.0, //extend the shadow
                                                offset: Offset(
                                                  0.0, // Move to right 10  horizontally
                                                  0.1, // Move to bottom 10 Vertically
                                                ),
                                              ),
                                              onPressed: () async {
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
                                              icon: Image.asset(
                                                  "assets/Insta.png"),
                                              shape: GFIconButtonShape.circle,
                                            ),
                                            TextButton(
                                                onPressed: () async {
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
                                                child: Text(
                                                  "Instagram",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      decoration: TextDecoration
                                                          .underline),
                                                )),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            GFIconButton(
                                              size: GFSize.SMALL,
                                              color: Colors.white,
                                              boxShadow: BoxShadow(
                                                color: Colors.black26,
                                                blurRadius:
                                                    3.0, // soften the shadow
                                                spreadRadius:
                                                    1.0, //extend the shadow
                                                offset: Offset(
                                                  0.0, // Move to right 10  horizontally
                                                  0.1, // Move to bottom 10 Vertically
                                                ),
                                              ),
                                              onPressed: () async {
                                                String _url =
                                                    snapshot.data.data.youtube;
                                                print('launching');
                                                try {
                                                  await canLaunch(_url)
                                                      ? await launch(_url)
                                                      : throw 'Could not launch $_url';
                                                } catch (_, __) {
                                                  showToast("Failed");
                                                }
                                              },
                                              icon: Image.asset(
                                                "assets/youtube.png",
                                                height: 30,
                                                width: 30,
                                              ),
                                              shape: GFIconButtonShape.circle,
                                            ),
                                            TextButton(
                                                onPressed: () async {
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
                                                child: Text(
                                                  "YouTube",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      decoration: TextDecoration
                                                          .underline),
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          snapshot.data.data.aboutUs,
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.left,
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
