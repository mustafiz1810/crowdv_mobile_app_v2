import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowdv_mobile_app/data/models/recruiter/Volunteer_Category.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/widgets/chat.dart';
import 'package:crowdv_mobile_app/utils/constants.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../../../data/models/volunteer/task_search_category.dart';
import '../../home_page/home_contents/widgets/details.dart';

class VolunteerCategory extends StatefulWidget {
  final dynamic token, role, categoryId;
  VolunteerCategory({this.token, this.role, this.categoryId});
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<VolunteerCategory> {
  Future<CategorywiseTask> getCateTaskApi() async {
    final response = await http.get(
        Uri.parse(NetworkConstants.BASE_URL +
            'task-search?category_id=${widget.categoryId}'),
        headers: {"Authorization": "Bearer ${widget.token}"});
    var data = jsonDecode(response.body.toString());
    print(data);
    if (response.statusCode == 200) {
      return CategorywiseTask.fromJson(data);
    } else {
      return CategorywiseTask.fromJson(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Category'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
