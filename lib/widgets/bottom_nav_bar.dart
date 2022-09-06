import 'package:crowdv_mobile_app/feature/screen/History/history.dart';
import 'package:crowdv_mobile_app/feature/screen/History/recruiter_history.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_page.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CustomBottomNavigation extends StatefulWidget {
  final dynamic role,id;
  CustomBottomNavigation({this.role,this.id});
  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  // var user;

  // @override
  // void initState() {
  //   getUser().then((value) {
  //     setState(() {
  //       user = value;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 14,
      unselectedFontSize: 14,
      selectedItemColor: primaryColor,
      elevation: 10,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        switch (index) {
          case 0:
            return Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) =>
                        HomeScreen(
                            id: widget.id,
                            role: widget.role)),
                    (Route<dynamic> route) => false);
          case 1:
            widget.role=='volunteer'?
             Get.to(VolunteerHistory()):Get.to(RecruiterHistory());
        }
      },
      selectedLabelStyle: TextStyle(
        color: primaryColor,
      ),
      unselectedLabelStyle: TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.w500,
      ),
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.history,
          ),
          label: 'History',
          backgroundColor: grayColor,
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(
        //     Icons.shopping_cart_outlined,
        //     color: primaryColor,
        //   ),
        //   label: 'Cart',
        // ),
        // BottomNavigationBarItem(
        //   icon: Icon(
        //     Icons.message_outlined,
        //     color: primaryColor,
        //   ),
        //   label: 'Message',
        // ),
        // BottomNavigationBarItem(
        //   icon: Icon(
        //     Icons.shopping_bag,
        //     color: primaryColor,
        //   ),
        //   label: 'Order',
        // ),
      ],
    );
  }
}
