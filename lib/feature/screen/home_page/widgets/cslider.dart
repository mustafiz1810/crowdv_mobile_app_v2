import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
class CarouselExample extends StatefulWidget {
  @override
  _CarouselExampleState createState() => _CarouselExampleState();
}

class _CarouselExampleState extends State<CarouselExample> {
  List<String> banner = [];
  @override
  void initState() {
    // for(Map map in widget.data){
    //   banner.add(map['banner']);
    // }
    // print(banner);
    setState((){});
    super.initState();
  }

  final List<String> images = [
    'https://info.bluezonesproject.com/hs-fs/hubfs/Umpqua/Volunteer%20Banner.jpeg?width=1725&name=Volunteer%20Banner.jpeg',
    'https://i.pinimg.com/736x/2b/81/e7/2b81e72da9198c838e44048d86ba647c.jpg',
    'https://www.careinspectorate.com/images/Our_jobs_/Recruitment_banner_volunteering.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150.0,
      width: double.infinity,
      child: Carousel(
        dotSpacing: 15.0,
        dotSize: 4.0,
        dotIncreasedColor: Colors.white,
        dotBgColor: Colors.transparent,
        indicatorBgPadding: 10.0,
        dotPosition: DotPosition.bottomCenter,
        images: images
            .map((item) => Container(
                  child: Image.network(
                    item,
                    fit: BoxFit.fill,
                  ),
                ))
            .toList(),
        autoplayDuration: const Duration(seconds: 4),
      ),
    );
  }
}
