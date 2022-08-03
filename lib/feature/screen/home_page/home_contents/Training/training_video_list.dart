import 'dart:convert';
import 'package:crowdv_mobile_app/data/models/volunteer/video_list_model.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/Training/test.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/Training/widget/videos_screen.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TrainingVideo extends StatefulWidget {
  final id;
  TrainingVideo({this.id});
  @override
  State<TrainingVideo> createState() => _TrainingVideoState();
}

class _TrainingVideoState extends State<TrainingVideo> {
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

  Future<VideoListModel> getVideoListApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL +
            'video-list-under-training/${widget.id}'),
        headers: {"Authorization": "Bearer ${token}"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return VideoListModel.fromJson(data);
    } else {
      return VideoListModel.fromJson(data);
    }
  }

  void train(int id, String name, mediaUrl, details) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'track-video-info/$id'),
          headers: {
            "Authorization": "Bearer $token"
          },
          body: {
            'duration': "3",
            'total_duration': "3",
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        showToast(context, data['message']);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoScreen(
                id: id,
                token:token,
                    name: name,
                    mediaUrl: mediaUrl,
                    details: details,
                  )),
        );
      } else {
        var data = jsonDecode(response.body.toString());
        showToast(context, data['message']);
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(e.toString()),
              content: Text(name + id.toString() + mediaUrl + details),
              actions: [
                FlatButton(
                  child: Text("Try Again"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            // onPressed: isDisabled == true
            //     ? null
            //     :
            //     () {
            //   Get.to(() => Test());
            // },
            onPressed: () {
              Get.to(() => Test(
                    trainingId: widget.id,
                  ));
            },
            child: Text("Take the test"),
          ),
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        // collapsedHeight: 150,
        title: const Text(
          'Training video',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder<VideoListModel>(
              future: getVideoListApi(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.data.videos.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          train(
                              snapshot.data.data.videos[index].id,
                              snapshot.data.data.videos[index].title,
                              snapshot.data.data.videos[index].video,
                              snapshot.data.data.videos[index].details);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 7,
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: 150,
                                          height: 18,
                                          child: Text(
                                            "Title: " +
                                                snapshot.data.data.videos[index]
                                                    .title,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                            height: 50,
                                            width: 150,
                                            child: Text("Details:  " +
                                                snapshot.data.data.videos[index]
                                                    .details))
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height / 6,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/128-1282287_health-safety-induction-training-videos-online-video-logo.png'))),
                                  ),
                                ],
                              ),
                            )),
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
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
