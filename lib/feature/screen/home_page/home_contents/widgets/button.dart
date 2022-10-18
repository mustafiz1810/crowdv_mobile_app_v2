import 'package:flutter/material.dart';

import '../../../../../utils/view_utils/colors.dart';

class Button extends StatelessWidget {
  const Button({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 120,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius:
        BorderRadius.circular(
            10.0),
      ),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment
            .spaceAround,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const Text(""),
          const Text(
            "Complete",
            style: TextStyle(
                fontSize: 14.0,
                fontWeight:
                FontWeight
                    .w400,
                color:
                Colors.white),
          ),
          Container(
              padding:
              const EdgeInsets
                  .all(3.0),
              decoration:
              const BoxDecoration(
                  shape: BoxShape
                      .circle,
                  color: Colors
                      .white70),
              child: const Icon(
                Icons
                    .arrow_right_alt_outlined,
                size: 14.0,
                color:
                Colors.black,
              ))
        ],
      ),
    );
  }
}
