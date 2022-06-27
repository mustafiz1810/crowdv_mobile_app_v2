import 'package:crowdv_mobile_app/feature/screen/History/history.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_page.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation({
    Key key,
  }) : super(key: key);

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
      elevation: 20,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        switch (index) {
          case 0:
            return Get.to(HomeScreen());
          case 1:
            return Get.to(History());
          // case 1:
          //   if (user == null)
          //     Get.to(SignIn());
          //   else
          //     Get.to(AccountPage());
          //   return 0;
        // Get.to(showModalBottomSheet(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return Container(
        //         height: 600,
        //         child: SingleChildScrollView(
        //           child: Column(
        //             children: [
        //               Container(
        //                 padding: EdgeInsets.symmetric(
        //                     horizontal: 15, vertical: 10),
        //                 child: Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                   children: [
        //                     GestureDetector(
        //                       onTap: () => Navigator.pop(context),
        //                       child: Icon(
        //                         Icons.arrow_back,
        //                         color: Color(0xff1F2937),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.only(left: 40),
        //                 child: Row(
        //                   children: [
        //                     Icon(Icons.phone),
        //                     Text("     "),
        //                     Text(
        //                       '01911-716625',
        //                       style: TextStyle(fontWeight: FontWeight.bold),
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.only(left: 80),
        //                 child: Row(
        //                   children: [
        //                     Text(
        //                       "Support 24/7 time",
        //                     )
        //                   ],
        //                 ),
        //               )
        //             ],
        //           ),
        //         ),
        //       );
        //     }));
        //   case 2:
        //     if (user == null)
        //       Get.to(SignIn());
        //     else
        //       Get.to(cartPageView());
        //     return 0;
        //   case 3:
        //     Get.to(OrderPage());
        //     return 0;
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
