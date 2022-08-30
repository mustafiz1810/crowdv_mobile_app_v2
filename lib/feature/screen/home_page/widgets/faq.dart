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
      print(data);
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
          'FAQ',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder<FaqModel>(
        future: getFaqListApi(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data.data.recruiter.length == 0) {
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
                    length: 2,
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: TabBar(
                            tabs: [
                              Tab(
                                  icon: Icon(Icons.wheelchair_pickup),
                                  child: const Text('Recruiter')),
                              Tab(
                                  icon: Icon(Icons.volunteer_activism_rounded),
                                  child: const Text('Volunteer')),
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
                                itemCount: snapshot.data.data.volunteer.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color:Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(8))
                                      ),
                                      width: 100,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width:MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                                color: Color(0xFF01A1B7),
                                                borderRadius: BorderRadius.only(topLeft:Radius.circular(8),topRight:Radius.circular(8) )
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Text(snapshot.data.data.volunteer[index].question,
                                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              snapshot.data.data.volunteer[index].answer,
                                              style: TextStyle(color:Color(0xFF003049),fontWeight: FontWeight.bold,fontSize: 14),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount:snapshot.data.data.recruiter.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color:Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(8))
                                      ),
                                      width: 100,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width:MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                                color: Color(0xFF01A1B7),
                                                borderRadius: BorderRadius.only(topLeft:Radius.circular(8),topRight:Radius.circular(8) )
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: Text(
                                                snapshot.data.data.recruiter[index].question,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              snapshot.data.data.recruiter[index].answer,
                                              style: TextStyle(color:Color(0xFF003049),fontWeight: FontWeight.bold,fontSize: 14),
                                            ),
                                          ),

                                        ],
                                      ),
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
