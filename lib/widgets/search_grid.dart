import 'package:cached_network_image/cached_network_image.dart';
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
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 0),
              blurRadius: 2,
              spreadRadius: -1,
              color: kShadowColor,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
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
                    child: CachedNetworkImage(
                      imageUrl: svgSrc,
                      imageBuilder:
                          (context, imageProvider) =>
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider,
                              ),
                            ),
                          ),
                      placeholder: (context, url) =>
                          Icon(Icons.downloading_rounded,size: 40,),
                      errorWidget: (context, url, error)
                      => Icon(Icons.image_outlined,size: 40,),
                    ),
                  ),
                  Spacer(),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        .copyWith(fontSize: 11),
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
