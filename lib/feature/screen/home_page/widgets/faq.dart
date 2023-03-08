import 'dart:convert';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../data/models/faq_model.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/widgets/custom_expansion_tile.dart' as custom;
class Faq extends StatefulWidget {
  const Faq({Key key}) : super(key: key);

  @override
  _FaqState createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  String token = "";
  // RandomColor _randomColor = RandomColor();
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

  Future<FaqModel> getFaqListApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL +
            'faq'),
        headers: {"Authorization": "Bearer ${token}"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return FaqModel.fromJson(data);
    } else {
      return FaqModel.fromJson(data);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        // collapsedHeight: 150,
        title: const Text(
          "FAQ'S",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder<FaqModel>(
        future: getFaqListApi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.success == false) {
              return Container(
                alignment: Alignment.center,
                child: EmptyWidget(
                  image: null,
                  packageImage: PackageImage.Image_3,
                  title: 'Empty',
                  subTitle: 'No videos available',
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
              return Container(
                color: Color(0xFFe9ecef),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child:DefaultTabController(
                    length:4,
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: TabBar(
                            isScrollable: true,
                            tabs: [
                              Tab(
                                  icon: Icon(Icons.login),
                                  child:  Text(snapshot.data.data.signupAndLogin[0].label)),
                              Tab(
                                  icon: Icon(Icons.question_answer),
                                  child:  Text(snapshot.data.data.generalQuestions[0].label)),
                              Tab(
                                  icon: Icon(Icons.library_books),
                                  child: Text(snapshot.data.data.testAndTraining[0].label)),
                              Tab(
                                  icon: Icon(Icons.card_membership_rounded),
                                  child:Text(snapshot.data.data.membershipBenefitsAndCertificates[0].label)),
                            ],
                            unselectedLabelColor: Colors.black38,
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BubbleTabIndicator(
                              indicatorHeight: 70.0,
                              indicatorColor: primaryColor,
                              indicatorRadius: 5,
                              tabBarIndicatorSize: TabBarIndicatorSize.tab,
                              insets: EdgeInsets.all(2),
                            ),
                          ),
                        ),
                        SliverFillRemaining(
                          child: TabBarView(
                            children: [
                              ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data.data.signupAndLogin.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color:Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(8))
                                        ),
                                        width: 100,
                                        child:custom.ExpansionTile(
                                          headerBackgroundColor: Color(0xFF01A1B7),
                                          iconColor: Colors.white,
                                          title: Text(snapshot.data.data.signupAndLogin[index].question,
                                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),
                                          ),
                                          children: <Widget>[
                                            ListTile(
                                              title:  Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Text(
                                                  snapshot.data.data.signupAndLogin[index].answer,
                                                  style: TextStyle(color:Color(0xFF003049),fontWeight: FontWeight.bold,fontSize: 14),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                    ),
                                  );

                                },
                              ),
                              ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount:snapshot.data.data.generalQuestions.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color:Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(8))
                                        ),
                                        width: 100,
                                        child:custom.ExpansionTile(
                                          headerBackgroundColor: Color(0xFF01A1B7),
                                          iconColor: Colors.white,
                                          title: Text(snapshot.data.data.generalQuestions[index].question,
                                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),
                                          ),
                                          children: <Widget>[
                                            ListTile(
                                              title:  Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Text(
                                                  snapshot.data.data.generalQuestions[index].answer,
                                                  style: TextStyle(color:Color(0xFF003049),fontWeight: FontWeight.bold,fontSize: 14),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                    ),
                                  );
                                },
                              ),
                              ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount:snapshot.data.data.testAndTraining.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color:Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(8))
                                        ),
                                        width: 100,
                                        child:custom.ExpansionTile(
                                          headerBackgroundColor: Color(0xFF01A1B7),
                                          iconColor: Colors.white,
                                          title: Text(snapshot.data.data.testAndTraining[index].question,
                                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),
                                          ),
                                          children: <Widget>[
                                            ListTile(
                                              title:  Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Text(
                                                  snapshot.data.data.testAndTraining[index].answer,
                                                  style: TextStyle(color:Color(0xFF003049),fontWeight: FontWeight.bold,fontSize: 14),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                    ),
                                  );
                                },
                              ),
                              ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount:snapshot.data.data.membershipBenefitsAndCertificates.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color:Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(8))
                                        ),
                                        width: 100,
                                        child:custom.ExpansionTile(
                                          headerBackgroundColor: Color(0xFF01A1B7),
                                          iconColor: Colors.white,
                                          title: Text(snapshot.data.data.membershipBenefitsAndCertificates[index].question,
                                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),
                                          ),
                                          children: <Widget>[
                                            ListTile(
                                              title:  Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Text(
                                                  snapshot.data.data.membershipBenefitsAndCertificates[index].answer,
                                                  style: TextStyle(color:Color(0xFF003049),fontWeight: FontWeight.bold,fontSize: 14),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
