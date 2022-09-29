import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SingleMessage extends StatefulWidget {
  final String message;
  final bool isMe;
  final DateTime time;
  SingleMessage({
     this.message,
     this.isMe,
    this.time
  });

  @override
  State<SingleMessage> createState() => _SingleMessageState();
}

class _SingleMessageState extends State<SingleMessage> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: (){
                    setState(() {
                       isVisible = !isVisible;
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.all(10),
                      constraints: BoxConstraints(maxWidth: 200),
                      decoration: BoxDecoration(
                          color: widget.isMe ? Colors.blue : Color(0xFFe9ecef),
                          borderRadius: BorderRadius.all(Radius.circular(40))
                      ),
                      child: Text(widget.message,style: TextStyle(color: widget.isMe ?Colors.white:Colors.black,fontWeight: FontWeight.w800),)
                  ),
                ),
                Visibility(
                  visible: isVisible,
                  child: Row(
                    children: [
                      Text(widget.time.hour.toString(),style: TextStyle(color: Colors.grey)),
                      Text(":"),
                      Text(widget.time.minute.toString(),style:TextStyle(color: Colors.grey,)),
                    ],
                  ),
                ),
              ],
            ),

      ],

    );
  }
}