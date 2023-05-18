import 'dart:convert';
import 'package:crowdv_mobile_app/data/models/volunteer/certificate_model.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/utils/view_utils/common_util.dart';
import 'package:crowdv_mobile_app/widgets/http_request.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sweetalert/sweetalert.dart';
import 'package:url_launcher/url_launcher.dart';

class Certificate extends StatefulWidget {
  const Certificate({Key key}) : super(key: key);

  @override
  _CertificateState createState() => _CertificateState();
}

class _CertificateState extends State<Certificate> {
  String token = "";

  @override
  void initState() {
    getCred();
    super.initState();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
    });
  }

  Future<CertificateModel> getCertificateApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'test-wise-get-certificate'),
        headers: {"Authorization": "Bearer ${token}"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return CertificateModel.fromJson(data);
    } else {
      return CertificateModel.fromJson(data);
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(10.0),
        child: new Row(
          children: [
            CircularProgressIndicator(),
            Container(
                margin: EdgeInsets.only(left: 7), child: Text("Sending...")),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Certificates'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder<CertificateModel>(
              future: getCertificateApi(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.data.length == 0) {
                    return Container(
                      alignment: Alignment.center,
                      child: EmptyWidget(
                        image: null,
                        packageImage: PackageImage.Image_3,
                        title: 'Empty',
                        subTitle: 'Pass a test to claim',
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
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 8, bottom: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.6),
                                    offset: const Offset(0, 1),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                                child: Stack(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        AspectRatio(
                                          aspectRatio: 1.6,
                                          child: Image.asset(
                                            "assets/crowd certificate.png",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Container(
                                          color: Color(0xFFFFFFFF),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 16,
                                                            top: 8,
                                                            bottom: 8),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          snapshot
                                                              .data
                                                              .data[index]
                                                              .test
                                                              .title
                                                              .toString(),
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Score :  ',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.8)),
                                                            ),
                                                            Text(
                                                              snapshot
                                                                  .data
                                                                  .data[index]
                                                                  .totalScore
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.8)),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              'Remark : ',
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.8)),
                                                            ),
                                                            Text(
                                                              snapshot
                                                                  .data
                                                                  .data[index]
                                                                  .result
                                                                  .toUpperCase(),
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          0.8)),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 16,
                                                    top: 25,
                                                    bottom: 10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(32.0),
                                                        ),
                                                        onTap: () async {
                                                          showLoaderDialog(
                                                              context);
                                                          getRequest(
                                                              '/api/v1/certificate-send-to-email/${snapshot.data.data[index].test.id}',
                                                              null, {
                                                            'Content-Type':
                                                                "application/json",
                                                            "Authorization":
                                                                "Bearer ${token}"
                                                          }).then(
                                                              (value) async {
                                                            Navigator.pop(
                                                                context);
                                                            SweetAlert.show(
                                                                context,
                                                                title:
                                                                    "Email Send",
                                                                subtitle:
                                                                    "Certificate send to your email",
                                                                style:
                                                                    SweetAlertStyle
                                                                        .success,
                                                                onPress: (bool
                                                                    isConfirm) {
                                                              if (isConfirm) {
                                                                // return false to keep dialog
                                                              }
                                                              return null;
                                                            });
                                                          });
                                                        },
                                                        child: Container(
                                                          width: 40,
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            color: Colors.white,
                                                            boxShadow: <
                                                                BoxShadow>[
                                                              BoxShadow(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.6),
                                                                offset:
                                                                    const Offset(
                                                                        0, 1),
                                                                blurRadius: 5,
                                                              ),
                                                            ],
                                                          ),
                                                          child: Center(
                                                            child: Icon(
                                                              Icons
                                                                  .outgoing_mail,
                                                              color: HexColor(
                                                                  '#54D3C2'),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5.0),
                                                      child: Text(
                                                        'send to email',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.8)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(32.0),
                                          ),
                                          onTap: () async {
                                            getRequest(
                                                '/api/v1/download/certificate/${snapshot.data.data[index].test.id}',
                                                null, {
                                              'Content-Type':
                                                  "application/json",
                                              "Authorization": "Bearer ${token}"
                                            }).then((value) async {

                                              String _url =
                                                  value['data']['file_path'];

                                              try {
                                                await canLaunch(_url)
                                                    ? await launch(_url)
                                                    : throw 'Could not launch $_url';
                                                showToast("Launched");
                                              } catch (_, __) {
                                                showToast("Failed");
                                              }
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: Colors.white,
                                                boxShadow: <BoxShadow>[
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.6),
                                                    offset: const Offset(0, 1),
                                                    blurRadius: 5,
                                                  ),
                                                ],
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.download,
                                                  color: HexColor('#54D3C2'),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ));
                        // return Padding(
                        //   padding: const EdgeInsets.all(5),
                        //   child: Container(
                        //     width: MediaQuery.of(context).size.width / 1.1,
                        //     height: MediaQuery.of(context).size.height / 4.1,
                        //     margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                        //     decoration: BoxDecoration(
                        //       // image: DecorationImage(
                        //       //   fit: BoxFit.cover,
                        //       //   image: AssetImage("assets/undraw_pilates_gpdb.png"),
                        //       // ),
                        //       color: Colors.white,
                        //       borderRadius: BorderRadius.all(Radius.circular(20)),
                        //       boxShadow: [
                        //         BoxShadow(
                        //           color: shadowColor.withOpacity(0.4),
                        //           spreadRadius: .1,
                        //           blurRadius: 2,
                        //           // offset: Offset(0, 1), // changes position of shadow
                        //         ),
                        //       ],
                        //     ),
                        //     child: Column(
                        //       children: [
                        //         Padding(
                        //           padding: const EdgeInsets.only(
                        //               left: 20, right: 20, top: 15),
                        //           child: Row(
                        //             mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //             children: [
                        //               SizedBox(
                        //                 width: 280,
                        //                 child: Text(
                        //                   "Volunteer Certification",
                        //                   style: TextStyle(
                        //                       color: primaryColor,
                        //                       fontWeight: FontWeight.bold,
                        //                       fontSize: 17),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //         Divider(
                        //           thickness: 2,
                        //           height: 5,
                        //           color: primaryColor,
                        //         ),
                        //         Padding(
                        //             padding: const EdgeInsets.only(
                        //                 left: 20, right: 20, top: 5),
                        //             child: Column(
                        //               children: [
                        //                 Row(
                        //                   children: [
                        //                     Text(
                        //                       'Test:  ',
                        //                       style: TextStyle(
                        //                           color: primaryColor,
                        //                           fontWeight: FontWeight.bold,
                        //                           fontSize: 16),
                        //                     ),
                        //                     SizedBox(
                        //                       width: 200,
                        //                       child: Text(
                        //                         snapshot.data.data[index].test.title
                        //                             .toString(),
                        //                         overflow: TextOverflow.ellipsis,
                        //                         style: TextStyle(
                        //                             fontWeight: FontWeight.bold,
                        //                             fontSize: 16),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //                 Row(
                        //                   children: [
                        //                     Text(
                        //                       'Candidate :  ',
                        //                       style: TextStyle(
                        //                           color: primaryColor,
                        //                           fontWeight: FontWeight.bold,
                        //                           fontSize: 16),
                        //                     ),
                        //                     Text(
                        //                       snapshot.data.data[index].user
                        //                           .firstName +
                        //                           " " +
                        //                           snapshot.data.data[index].user
                        //                               .lastName,
                        //                       style: TextStyle(
                        //                           fontWeight: FontWeight.bold,
                        //                           fontSize: 16),
                        //                     ),
                        //                   ],
                        //                 ),
                        //                 Row(
                        //                   children: [
                        //                     Text(
                        //                       'Score :  ',
                        //                       style: TextStyle(
                        //                           color: primaryColor,
                        //                           fontWeight: FontWeight.bold,
                        //                           fontSize: 16),
                        //                     ),
                        //                     Text(
                        //                       snapshot.data.data[index].totalScore
                        //                           .toString(),
                        //                       style: TextStyle(
                        //                           fontWeight: FontWeight.bold,
                        //                           fontSize: 16),
                        //                     ),
                        //                   ],
                        //                 ),
                        //                 Row(
                        //                   children: [
                        //                     Text(
                        //                       'Remark : ',
                        //                       style: TextStyle(
                        //                           color: primaryColor,
                        //                           fontWeight: FontWeight.bold,
                        //                           fontSize: 16),
                        //                     ),
                        //                     Text(
                        //                         snapshot.data.data[index].result
                        //                             .toUpperCase(),
                        //                         style: TextStyle(
                        //                             fontWeight: FontWeight.bold,
                        //                             fontSize: 14))
                        //                   ],
                        //                 ),
                        //                 Row(
                        //                   mainAxisAlignment:
                        //                   MainAxisAlignment.end,
                        //                   children: [
                        //                     IconBox(
                        //                       child: Icon(
                        //                         Icons.outgoing_mail,
                        //                         color: Colors.white,
                        //                       ),
                        //                       bgColor: Colors.blue,
                        //                       onTap: () async {
                        //                         showLoaderDialog(context);
                        //                         getRequest(
                        //                             '/api/v1/certificate-send-to-email/${snapshot.data.data[index].test.id}',
                        //                             null, {
                        //                           'Content-Type':
                        //                           "application/json",
                        //                           "Authorization":
                        //                           "Bearer ${token}"
                        //                         }).then((value) async {
                        //                           Navigator.pop(context);
                        //                           SweetAlert.show(context,
                        //                               title: "Email Send",
                        //                               subtitle:
                        //                               "Certificate send to your email",
                        //                               style:
                        //                               SweetAlertStyle.success,
                        //                               onPress: (bool isConfirm) {
                        //                                 if (isConfirm) {
                        //                                   // return false to keep dialog
                        //                                 }
                        //                                 return null;
                        //                               });
                        //                         });
                        //                       },
                        //                     ),
                        //                     SizedBox(
                        //                       width: 5,
                        //                     ),
                        //                     IconBox(
                        //                       child: Icon(
                        //                         Icons.download,
                        //                         color: Colors.white,
                        //                       ),
                        //                       bgColor: primaryColor,
                        //                       onTap: () async {
                        //                         getRequest(
                        //                             '/api/v1/download/certificate/${snapshot.data.data[index].test.id}',
                        //                             null, {
                        //                           'Content-Type':
                        //                           "application/json",
                        //                           "Authorization":
                        //                           "Bearer ${token}"
                        //                         }).then((value) async {
                        //                           print(
                        //                               value['data']['file_path']);
                        //                           String _url =
                        //                           value['data']['file_path'];
                        //                           print('launching');
                        //                           try {
                        //                             await canLaunch(_url)
                        //                                 ? await launch(_url)
                        //                                 : throw 'Could not launch $_url';
                        //                             showToast("Launched");
                        //                           } catch (_, __) {
                        //                             showToast("Failed");
                        //                           }
                        //                         });
                        //                       },
                        //                     )
                        //                   ],
                        //                 )
                        //               ],
                        //             )),
                        //       ],
                        //     ),
                        //   ),
                        // );
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
