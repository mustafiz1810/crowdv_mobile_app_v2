import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldHeadline extends StatefulWidget {

  final String text;
  final Color textColor;

  TextFieldHeadline({@required this.text, @required this.textColor});

  @override
  State<StatefulWidget> createState() => _TextFieldHeadlineState();
}
class _TextFieldHeadlineState extends State<TextFieldHeadline>{

  ThemeData theme;


  @override
  Widget build(BuildContext context) {

    theme = Theme.of(context);

    return Text(
      widget.text,
      style: GoogleFonts.poppins(
        color: widget.textColor
      ),
    );
  }

}