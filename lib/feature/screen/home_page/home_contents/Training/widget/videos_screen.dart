import 'dart:convert';
import 'package:better_player/better_player.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/Training/test.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class VideoScreen extends StatefulWidget {
  final String token, name, mediaUrl, details;
  final int id;
  VideoScreen({this.id, this.token, this.name, this.mediaUrl, this.details});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
 var videoIndex =0;
 void _videoPlay(int id, int optionId, String opName) {

   setState(() {
     videoIndex = videoIndex + 1;
   });
   // print(optionId);
 }
  BetterPlayerController _betterPlayerController;
  GlobalKey _betterPlayerKey = GlobalKey();
  @override
  void initState() {
    print(widget.mediaUrl.toString());
    var betterPlayerConfiguration = BetterPlayerConfiguration(
      controlsConfiguration: BetterPlayerControlsConfiguration(
        enableSkips: false,
      ),
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
      eventListener: _onPlayerEvent,
    );

    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, widget.mediaUrl);
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);
    super.initState();
  }

  void train(duration, total) async {
    try {
      Response response = await post(
          Uri.parse(
              NetworkConstants.BASE_URL + 'track-video-info/${widget.id}'),
          headers: {
            "Authorization": "Bearer ${widget.token}"
          },
          body: {
            'duration': duration,
            'total_duration': total,
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(duration + "   /" + total);
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

  void _onPlayerEvent(BetterPlayerEvent event) {
    if (_checkIfCanProcessPlayerEvent(event)) {
      Duration progress = event.parameters['progress'];
      Duration duration = event.parameters['duration'];
      if (progress == duration) {
        print(duration);
        setState(() {
          train(progress.toString(), duration.toString());
        });
      }
    }
  }

  bool _checkIfCanProcessPlayerEvent(BetterPlayerEvent event) {
    return event.betterPlayerEventType == BetterPlayerEventType.progress &&
        event.parameters != null &&
        event.parameters['progress'] != null &&
        event.parameters['duration'] != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        // collapsedHeight: 150,
        title: const Text(
          'Videos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Color(0xFF415a77),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(
                key: _betterPlayerKey,
                controller: _betterPlayerController,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(
                    top: 5, left: 20.0, right: 20.0, bottom: 20.0),
                child: Column(
                  children: [
                    SizedBox(
                        child: Text(
                      "Title: " + widget.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    )),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {},
                          child: Row(
                            children: [
                              Icon(Icons.arrow_back_ios_rounded),
                              SizedBox(
                                width: 5,
                              ),
                              Text("Privious Lesson"),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                          },
                          child: Row(
                            children: [
                              Text("Next Lesson"),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.arrow_forward_ios_rounded),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.fiber_manual_record_rounded,
                          size: 12,
                          color: Colors.lightBlue,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Details",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.details,
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
