import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowdv_mobile_app/data/models/volunteer/video_list_model.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/Training/widget/videos_screen.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/bottom_nav_bar.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
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
  String role = "";
  // RandomColor _randomColor = RandomColor();
  @override
  void initState() {
    print(token);
    getCred();
    super.initState();
  }

  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
      role = pref.getString("role");
    });
  }

  Future<VideoListModel> getVideoListApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL +
            'video-list-under-training/${widget.id}'),
        headers: {"Authorization": "Bearer ${token}"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      print(data);
      return VideoListModel.fromJson(data);
    } else {
      return VideoListModel.fromJson(data);
    }
  }

  void train(bool isWatched,int length,int index,int id, String name, mediaUrl, details, videos,trainingId) async {
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
                isWatched:isWatched,
                length: length,
                index:index,
                    id: id,
                    token: token,
                    name: name,
                    mediaUrl: mediaUrl,
                    details: details,
                trainingId:trainingId,
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
      bottomNavigationBar: CustomBottomNavigation(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        // collapsedHeight: 150,
        title: const Text(
          'Training videos',
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
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.data.videos.length == 0) {
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
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.data.videos.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            train(
                              snapshot.data.data.videos[index].isWatched,
                                snapshot.data.data.videos.length,
                              snapshot.data.data.videos.indexOf(snapshot.data.data.videos[index]),
                                snapshot.data.data.videos[index].id,
                                snapshot.data.data.videos[index].title,
                                snapshot.data.data.videos[index].video,
                                snapshot.data.data.videos[index].details,
                                snapshot.data.data.videos, widget.id,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0,1),
                                      spreadRadius: .5,
                                      blurRadius: 3,
                                      color: Colors.grey
                                  )
                                ]
                              ),
                              // color: _randomColor.randomColor(colorHue: ColorHue.random,colorSaturation: ColorSaturation.monochrome,colorBrightness: ColorBrightness.veryLight),
                              height: MediaQuery.of(context).size.height / 4,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      height: 140,
                                      width: MediaQuery.of(context).size.width,
                                      child: Stack(
                                        children:[
                                          Center(
                                            child: CachedNetworkImage(
                                              imageUrl: snapshot.data.data.videos[index].thumbnail,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.fill,),
                                                    ),
                                                  ),
                                              placeholder: (context, url) =>
                                                  Icon(Icons.downloading_rounded,size: 100,),
                                              errorWidget: (context, url, error)
                                              => Icon(Icons.image_outlined,size: 100,),
                                            ),
                                          ),
                                          snapshot.data.data.videos[index].watchedStatus.isEmpty == false?
                                          Container(
                                            height: 30,
                                            width: 80,
                                            decoration: BoxDecoration(
                                                color: Colors.black38,
                                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10))
                                            ),
                                            child: Center(child: Text(snapshot.data.data.videos[index].watchedStatus,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
                                          )
                                              :Container(),
                                          Center(child: Container(
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: Colors.black38,
                                            ),
                                          )),
                                          Center(child: Icon(Icons.play_arrow,size: 70,color: Colors.white,))
                                        ]

                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0,right: 8,top: 2),
                                    child: SizedBox(
                                      height: 38,
                                        child: Text(
                                          snapshot.data.data.videos[index].title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),),
                                  )
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
