// This widget will draw header section of all page. Wich you will get with the project source code.

import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/material.dart';

class HeaderLogo extends StatefulWidget {
  final double _height;
  const HeaderLogo(this._height);

  @override
  _HeaderLogoState createState() =>
      _HeaderLogoState(_height);
}

class _HeaderLogoState extends State<HeaderLogo> {
  double _height;

  _HeaderLogoState(this._height);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      child: Stack(
        children: [
          ClipPath(
            child: Container(
              height: 210,
              decoration: BoxDecoration(
                color: primaryColor
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
            top: 150,
              right: 152,
              child: Container(
                height: 100,
                width: 100,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      width: 5, color: Colors.white),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 20,
                      offset: const Offset(5, 5),
                    ),
                  ],
                ),
                child:Image.asset('assets/crowdv_jpg.jpg')
              ))
          // Visibility(
          //   visible: _showIcon,
          //   child: Container(
          //     height: _height - 40,
          //     child: Center(
          //       child: Container(
          //         margin: EdgeInsets.all(20),
          //         padding: EdgeInsets.only(
          //           left: 5.0,
          //           top: 20.0,
          //           right: 5.0,
          //           bottom: 20.0,
          //         ),
          //         decoration: BoxDecoration(
          //           // borderRadius: BorderRadius.circular(20),
          //           borderRadius: BorderRadius.only(
          //             topLeft: Radius.circular(100),
          //             topRight: Radius.circular(100),
          //             bottomLeft: Radius.circular(60),
          //             bottomRight: Radius.circular(60),
          //           ),
          //           border: Border.all(width: 5, color: Colors.white),
          //         ),
          //         child: Icon(
          //           _icon,
          //           color: Colors.white,
          //           size: 40.0,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}


