import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Question extends StatelessWidget {
  final String questionText;

  Question(this.questionText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      child: Container(
        child: Text(
          questionText,
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(fontSize:24,color: Colors.black,fontWeight: FontWeight.bold),
          ),
        ),
      ), //Text
    ); //Container
  }
}