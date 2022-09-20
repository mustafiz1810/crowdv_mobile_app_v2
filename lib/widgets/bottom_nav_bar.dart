import 'package:crowdv_mobile_app/feature/screen/History/history.dart';
import 'package:crowdv_mobile_app/feature/screen/History/recruiter_history.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_page.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CustomBottomNavigation extends StatefulWidget {
  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  String token,role;
  int id;
  List<String> banner;
  @override
  void initState() {
    getCred();
    super.initState();
  }
  void getCred() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("user");
      role = pref.getString("role");
      id = pref.getInt("id");
      banner = pref.getStringList("banner");

    });
  }
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
                            id: id,
                            role: role,
                        banner: banner,)),
                    (Route<dynamic> route) => false);
          case 1:
            role=='volunteer'?
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
