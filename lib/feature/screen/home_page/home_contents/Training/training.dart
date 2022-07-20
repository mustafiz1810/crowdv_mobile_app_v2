import 'dart:convert';
import 'package:crowdv_mobile_app/data/models/volunteer/training_model.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/Training/widget/videos_screen.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

var videoList = [
  {
    'name': 'Big Buck Bunny',
    'media_url':
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'thumb_url': 'https://peach.blender.org/wp-content/uploads/bbb-splash.png',
    "description":
        "Big Buck Bunny tells the story of a giant rabbit with a heart bigger than himself. When one sunny day three rodents rudely harass him, something snaps... and the rabbit ain't no bunny anymore! In the typical cartoon tradition he prepares the nasty rodents a comical revenge.\n\nLicensed under the Creative Commons Attribution license\nhttp://www.bigbuckbunny.org",
  },
  {
    'name': 'Elephant Dream',
    'media_url':
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    'thumb_url': 'https://peach.blender.org/wp-content/uploads/its-a-trap.png',
    "description":
        "Big Buck Bunny tells the story of a giant rabbit with a heart bigger than himself. When one sunny day three rodents rudely harass him, something snaps... and the rabbit ain't no bunny anymore! In the typical cartoon tradition he prepares the nasty rodents a comical revenge.\n\nLicensed under the Creative Commons Attribution license\nhttp://www.bigbuckbunny.org",
  },
  {
    'name': 'Big Bunny',
    'media_url':
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    'thumb_url':
        'https://m.media-amazon.com/images/M/MV5BMzIwZTBhNDUtNmM5NC00OTNjLTk0MGMtZDA0MGVjYzVmZDEyXkEyXkFqcGdeQXVyNDgyODgxNjE@._V1_.jpg',
    "description":
        "Big Buck Bunny tells the story of a giant rabbit with a heart bigger than himself. When one sunny day three rodents rudely harass him, something snaps... and the rabbit ain't no bunny anymore! In the typical cartoon tradition he prepares the nasty rodents a comical revenge.\n\nLicensed under the Creative Commons Attribution license\nhttp://www.bigbuckbunny.org",
  },
];

class Training extends StatefulWidget {
  @override
  State<Training> createState() => _TrainingState();
}

class _TrainingState extends State<Training> {
  // String token = "";
  //
  // @override
  // void initState() {
  //   getCred();
  //   super.initState();
  // }
  //
  // void getCred() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   setState(() {
  //     token = pref.getString("user");
  //   });
  // }

  // Future<TrainingModel> getTrainingApi() async {
  //   final response = await http.get(
  //       Uri.parse(NetworkConstants.BASE_URL + 'training/list'),
  //       headers: {"Authorization": "Bearer ${token}"});
  //   var data = jsonDecode(response.body.toString());
  //   if (response.statusCode == 200) {
  //     return TrainingModel.fromJson(data);
  //   } else {
  //     return TrainingModel.fromJson(data);
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        // collapsedHeight: 150,
        title: const Text(
          'Training',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: ListView(
        children: videoList
            .map((e) => GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VideoScreen(
                            name: e['name'], mediaUrl: e['media_url'],details: e['description'],)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 7,
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 10,),
                                Text(
                                  "Title: " + e['name'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                    height: 50,
                                    width: 150,
                                    child: Text(e['description'])
                                )
                              ],
                            ),
                            Container(
                                height: MediaQuery.of(context).size.height / 6,
                                width: MediaQuery.of(context).size.width / 3,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: NetworkImage(e['thumb_url']),
                                  fit: BoxFit.cover,
                                )),
                                child: Center(
                                  child: IconBox(
                                    child: Icon(
                                      Icons.play_circle_outline_sharp,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      )),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
