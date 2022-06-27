import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/widgets/op_card.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/sample_card.dart';
import 'package:flutter/material.dart';

class UpcomingOpportunity extends StatefulWidget {
  @override
  _UpcomingOpportunityState createState() => _UpcomingOpportunityState();
}

class _UpcomingOpportunityState extends State<UpcomingOpportunity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('Upcoming Opportunity'),
        ),
        body: Column(
          children: [OpportunityCard()],
        ));
  }
}
