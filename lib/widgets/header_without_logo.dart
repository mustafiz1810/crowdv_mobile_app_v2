// This widget will draw header section of all page. Wich you will get with the project source code.

import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatefulWidget {
  // final  color;
  // const HeaderWidget(this.color);

  @override
  _HeaderWidgetState createState() =>
      _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  // final color;
  //
  //
  // _HeaderWidgetState(this.color);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      child: Stack(
        children: [
          ClipPath(
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                  color: primaryColor,
              ),
            ),
            // clipper: ShapeClipper([
            //   // Offset(width / 5, _height),
            //   // Offset(width / 2, _height - 40),
            //   // Offset(width / 5 * 4, _height - 80),
            //   // Offset(width, _height - 20)
            // ]),
          ),
          Positioned(
              top: 30,
              right: 220,
              child: Row(children: [
                const Text(
                  "Crowd",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.white),
                ),
                Center(
                  child: Image.asset('assets/crowdv_png.png',
                      width: 40, height: 50),
                ),
              ]))

        ],
      ),
    );
  }
}


