import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/message_textfield.dart';
import 'package:crowdv_mobile_app/widgets/single_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatUi extends StatefulWidget {
  final String uid, friendName,friendImage;
  final String friendId ;
  final bool isOnline;
  ChatUi({
    this.uid,
    this.friendId,
    this.friendName,
    this.friendImage,
    this.isOnline,
});

  @override
  _ChatUiState createState() => _ChatUiState();
}

class _ChatUiState extends State<ChatUi> {
 bool inRoom = false;
  @override
  void initState() {
    print(widget.uid);
    setState(() {
      inRoom = true;
    });
    FirebaseFirestore.instance.collection('Users').doc(widget.friendId).collection('messages').doc(widget.uid).set({
      'is_read':true,
    });
    super.initState();
  }

  final List<String> entries = <String>['How are you?', 'Hello', 'Hi'];
  final List<int> colorCodes = <int>[600, 500, 100];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            FirebaseFirestore.instance.collection('Users').doc(widget.friendId).collection('messages').doc(widget.uid).set({
              'is_read':true,
            });
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(widget.friendImage),
              backgroundColor: Colors.white,
            ),
            SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.friendName,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.clip,
                ),
                Text(
                  widget.isOnline == true?"Online":"Offline",
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.isOnline == true?Colors.green:Colors.grey,
                  ),
                )
              ],
            )
          ],
        ),
        backgroundColor: primaryColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)
                )
            ),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Users").doc(widget.uid).collection('messages').doc(widget.friendId).collection('chats').orderBy("date",descending: true).snapshots(),
                builder: (context,AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    if(snapshot.data.docs.length < 1){
                      return Center(
                        child: Text("Say Hi"),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        reverse: true,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context,index){
                          bool isMe = snapshot.data.docs[index]['senderId'] == widget.uid;
                          return SingleMessage(time:DateTime.fromMicrosecondsSinceEpoch(snapshot.data.docs[index]['date'].microsecondsSinceEpoch),message: snapshot.data.docs[index]['message'], isMe: isMe);
                        });
                  }
                  return Center(
                      child: CircularProgressIndicator()
                  );
                }),
          )),
          MessageTextField(widget.uid, widget.friendId,inRoom),
        ],
      ),
    );
  }
}
