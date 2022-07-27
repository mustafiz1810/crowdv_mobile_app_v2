import 'dart:convert';

import 'package:better_player/better_player.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/Training/test.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';

class VideoScreen extends StatefulWidget {
  final String token, name, mediaUrl, details;
  final int id;
  VideoScreen({this.id,this.token,this.name, this.mediaUrl, this.details});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  BetterPlayerController _betterPlayerController;
  GlobalKey _betterPlayerKey = GlobalKey();

  @override
  void initState() {
    print(widget.mediaUrl.toString());
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
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
  void train( duration, total) async {
    try {
      Response response = await post(
          Uri.parse(NetworkConstants.BASE_URL + 'track-video-info/${widget.id}'),
          headers: {
            "Authorization": "Bearer ${widget.token}"
          },
          body: {
            'duration': duration,
            'total_duration': total,
          });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(duration+"   /"+total);
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
        if(progress==duration){
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
        backgroundColor: primaryColor,
        title: Text(widget.name),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(
                key: _betterPlayerKey,
                controller: _betterPlayerController,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20)),
              height: MediaQuery.of(context).size.height / 14,
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height / 4.5,
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Title: " + widget.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20)),
              height: MediaQuery.of(context).size.height / 3,
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height / 4.5,
                      width: MediaQuery.of(context).size.width,
                      child: Text(widget.details))),
            ),
          )
        ],
      ),
    );
  }
}
