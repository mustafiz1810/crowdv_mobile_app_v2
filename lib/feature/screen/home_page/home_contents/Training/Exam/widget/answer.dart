import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/material.dart';

class Answer extends StatefulWidget {
  final Function selectHandler;
  final String answerText;

  Answer(this.selectHandler, this.answerText);

  @override
  State<Answer> createState() => _AnswerState();
}

class _AnswerState extends State<Answer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
          ),
          onPressed: widget.selectHandler,
          child: Text(widget.answerText,style: TextStyle(color: primaryColor),),
        ),//RaisedButton
      ),
    ); //Container
  }
}