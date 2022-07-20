import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchCard extends StatelessWidget {
  final String svgSrc;
  final String title;
  final Function press;
  const SearchCard({
    Key key,
    this.svgSrc,
    this.title,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0,left: 2,right: 2),
      child: Container(
        // padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 0),
              blurRadius: 15,
              spreadRadius: -13,
              color: kShadowColor,
            ),
          ],
        ),
        child: Material(
          borderRadius: BorderRadiusDirectional.circular(13),
          elevation: 4,
          color: Colors.white,
          child: InkWell(
            onTap: press,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: <Widget>[
                  Spacer(),
                  Container(
                    height: 45,
                    width: 80,
                    child: SvgPicture.asset(
                      svgSrc,
                    ),
                  ),
                  Spacer(),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme.titleSmall
                        .copyWith(fontSize: 15),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}