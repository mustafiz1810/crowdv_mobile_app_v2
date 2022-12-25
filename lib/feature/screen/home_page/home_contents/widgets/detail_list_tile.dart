import 'package:crowdv_mobile_app/utils/design_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListCard extends StatelessWidget {
  final String title;
  final String text;
  const ListCard({
    Key key,
    this.title,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context)
          .size
          .width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.all(
              Radius.circular(12))),
      child: Padding(
        padding:
        const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment
              .spaceBetween,
          children: [
            Text(
              title,
              textAlign: TextAlign.left,
            ),
            SizedBox(
              width: 20,
            ),
            Flexible(
              child: Text(
                text,
                textAlign:
                TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
