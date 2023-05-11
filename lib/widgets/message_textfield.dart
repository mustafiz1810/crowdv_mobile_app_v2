import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class MessageTextField extends StatefulWidget {
  final String currentId;
  final String friendId;
  final bool inRoom;

  MessageTextField(this.currentId,this.friendId,this.inRoom);

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  TextEditingController _controller = TextEditingController();
  String message;


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      height: 61,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100.0),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 3),
                      blurRadius: 5,
                      color: Color(0xFFe9ecef))
                ],
              ),
              child: Row(
                children: <Widget>[
                  // IconButton(icon: Icon(Icons.face), onPressed: () {}),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          filled: true,
                          hintText: "Type Something...",
                          hintStyle: TextStyle(fontSize: 12),
                          border: InputBorder.none),
                    ),
                  ),
                  // IconButton(
                  //   icon: Icon(Icons.photo_camera),
                  //   onPressed: () {},
                  // ),
                  // IconButton(
                  //   icon: Icon(Icons.attach_file),
                  //   onPressed: () {},
                  // )
                ],
              ),
            ),
          ),
          SizedBox(width: 15),
          GestureDetector(
            onTap:()async{
              String message = _controller.text;
              if (message.isEmpty) return;
              _controller.clear();
              await FirebaseFirestore.instance.collection('Users').doc(widget.currentId).collection('messages').doc(widget.friendId).collection('chats').add({
                "senderId":widget.currentId,
                "receiverId":widget.friendId,
                "message":message,
                "type":"text",
                "date":DateTime.now(),
              }).then((value) {
                FirebaseFirestore.instance.collection('Users').doc(widget.currentId).collection('messages').doc(widget.friendId).set({
                  'is_read' : false,
                });
              });

              await FirebaseFirestore.instance.collection('Users').doc(widget.friendId).collection('messages').doc(widget.currentId).collection("chats").add({
                "senderId":widget.currentId,
                "receiverId":widget.friendId,
                "message":message,
                "type":"text",
                "date":DateTime.now(),

              }).then((value){
                if(widget.inRoom == true) return;
                FirebaseFirestore.instance.collection('Users').doc(widget.friendId).collection('messages').doc(widget.currentId).set({
                  'is_read':false,
                });
              });
            },
            child: Semantics(
              label: "Send Message",
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: Icon(Icons.send,color: Colors.white,),
              ),
            ),
          )
        ],
      ),

    );
  }
}