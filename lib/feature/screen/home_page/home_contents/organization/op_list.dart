import 'dart:convert';
import 'package:crowdv_mobile_app/data/models/organizaation/op_model.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/http_request.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sweetalert/sweetalert.dart';
import 'package:url_launcher/url_launcher.dart';
class OrgOpportunityList extends StatefulWidget {
  @override
  State<OrgOpportunityList> createState() => _OrgOpportunityListState();
}

class _OrgOpportunityListState extends State<OrgOpportunityList> {
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

  Future<OrgModel> getOrgApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL + 'organization/opportunity/list'),
        headers: {"Authorization": "Bearer ${token}"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return OrgModel.fromJson(data);
    } else {
      return OrgModel.fromJson(data);
    }
  }
  void _showErrorSnackBar() {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Oops... the URL couldn\'t be opened!'),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          // collapsedHeight: 150,
          title: const Text(
            'My Opportunity',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                  child: FutureBuilder<OrgModel>(
                    future: getOrgApi(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.data.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(5),
                              child: Container(
                                width: 350,
                                height: 150,
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                decoration: BoxDecoration(
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
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          height: 55,
                                          width: 370,
                                          decoration: BoxDecoration(
                                            color: primaryColor,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: shadowColor.withOpacity(0.2),
                                                spreadRadius: .1,
                                                blurRadius: 3,
                                                // offset: Offset(0, 1), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 20, top: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot.data.data[index].title,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                                // IconBox(
                                                //   onTap: () {
                                                //     SweetAlert.show(context,
                                                //         subtitle:
                                                //         "Do you want to delete this opportunity?",
                                                //         style: SweetAlertStyle
                                                //             .confirm,
                                                //         showCancelButton: true,
                                                //         onPress:
                                                //             (bool isConfirm) {
                                                //           if (isConfirm) {
                                                //             //Return false to keep dialog
                                                //             if (isConfirm) {
                                                //               SweetAlert.show(context,
                                                //                   subtitle:
                                                //                   "Deleting...",
                                                //                   style:
                                                //                   SweetAlertStyle
                                                //                       .loading);
                                                //               new Future.delayed(
                                                //                   new Duration(
                                                //                       seconds: 1),
                                                //                       () {
                                                //                     getRequestWithoutParam(
                                                //                         '/api/v1/opportunity/delete/${snapshot.data.data[index].id}',
                                                //                         {
                                                //                           'Content-Type':
                                                //                           "application/json",
                                                //                           "Authorization":
                                                //                           "Bearer ${token}"
                                                //                         }).then(
                                                //                             (value) async {
                                                //                           SweetAlert.show(
                                                //                               context,
                                                //                               subtitle:
                                                //                               "Success!",
                                                //                               style:
                                                //                               SweetAlertStyle
                                                //                                   .success);
                                                //                           setState(() {});
                                                //                         });
                                                //                   });
                                                //             } else {
                                                //               SweetAlert.show(context,
                                                //                   subtitle:
                                                //                   "Canceled!",
                                                //                   style:
                                                //                   SweetAlertStyle
                                                //                       .error);
                                                //             }
                                                //             return false;
                                                //           }
                                                //           return null;
                                                //         });
                                                //   },
                                                //   child: Icon(
                                                //     Icons.delete,
                                                //     color: Colors.white,
                                                //     size: 20,
                                                //   ),
                                                //   bgColor: Colors.red,
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Divider(
                                          thickness: 4,
                                          height: 10,
                                          color: Colors.white,
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 20),
                                            child: Column(
                                              children: [
                                                TextButton(
                                                  onPressed: () async {
                                                    String url = snapshot.data.data[index].links;
                                                    if(await canLaunch(url)){
                                                      await launch(url);
                                                    }else {
                                                      throw 'Could not launch $url';
                                                    }
                                                  },
                                                  child: Text(snapshot.data.data[index].links)
                                                ),
                                                // Row(
                                                //   children: [
                                                //     SizedBox(
                                                //       height: 40,
                                                //       child: Text(
                                                //         'Link:  ',
                                                //         style: TextStyle(
                                                //             color: primaryColor,
                                                //             fontWeight:
                                                //             FontWeight.bold,
                                                //             fontSize: 18),
                                                //       ),
                                                //     ),
                                                //     SizedBox(
                                                //       width: 250,
                                                //       height: 60,
                                                //       child:Link(
                                                //         child: Text(snapshot.data.data[index].links, style: TextStyle(
                                                //           decoration: TextDecoration.underline, // add add underline in text
                                                //         ),),
                                                //         url: snapshot.data.data[index].links,
                                                //         onError: _showErrorSnackBar,
                                                //       ),
                                                //
                                                //     ),
                                                //   ],
                                                // ),
                                              ],
                                            )),

                                      ],
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
                      }
                    },
                  )),
            ],
          ),
        ));
  }
}