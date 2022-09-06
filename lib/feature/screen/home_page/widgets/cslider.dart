import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/models/org_opp_model.dart';
import '../../../../utils/view_utils/common_util.dart';

class CarouselExample extends StatefulWidget {
  final dynamic token;
  CarouselExample({this.token});
  @override
  _CarouselExampleState createState() => _CarouselExampleState();
}

class _CarouselExampleState extends State<CarouselExample> {
  List<dynamic> banner = [];

  Future<OrgModel> getOrgOpportunityApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL +
            'organization/opportunity/list?limit=5'),
        headers: {"Authorization": "Bearer ${widget.token}"});
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      print(data);
      return OrgModel.fromJson(data);
    } else {
      return OrgModel.fromJson(data);
    }
  }

  final List<String> images = [
    'https://info.bluezonesproject.com/hs-fs/hubfs/Umpqua/Volunteer%20Banner.jpeg?width=1725&name=Volunteer%20Banner.jpeg',
    'https://i.pinimg.com/736x/2b/81/e7/2b81e72da9198c838e44048d86ba647c.jpg',
    'https://www.careinspectorate.com/images/Our_jobs_/Recruitment_banner_volunteering.jpg',
    'https://media.istockphoto.com/photos/mountain-landscape-picture-id517188688?s=612x612',
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
