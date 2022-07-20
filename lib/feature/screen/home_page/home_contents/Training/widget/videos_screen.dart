import 'package:better_player/better_player.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/material.dart';

class VideoScreen extends StatefulWidget {
  final String name, mediaUrl, details;
  VideoScreen({this.name, this.mediaUrl, this.details});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  BetterPlayerController _betterPlayerController;
  GlobalKey _betterPlayerKey = GlobalKey();
  bool isDisabled = true;

  @override
  void initState() {
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

  void _onPlayerEvent(BetterPlayerEvent event) {
    if (_checkIfCanProcessPlayerEvent(event)) {
      Duration progress = event.parameters['progress'];
      Duration duration = event.parameters['duration'];
      setState(() {
        if(progress==duration){
          isDisabled = false;
        }
      });
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
      bottomNavigationBar:  Padding(
        padding: const EdgeInsets.all(20.0),
        child: ElevatedButton(
          onPressed: isDisabled == true
              ? null
              : () {
            print("Clicked");
          },
          child: Text("Take the test"),
        ),
      ),
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
