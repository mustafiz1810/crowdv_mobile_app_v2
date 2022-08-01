import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  final String questionText;

  Question(this.questionText);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      margin: EdgeInsets.all(10),
      child: Text(
       "Q# "+questionText,
        style: TextStyle(fontSize: 18,color: Colors.white),
        textAlign: TextAlign.center,
      ), //Text
    ); //Container
  }
}