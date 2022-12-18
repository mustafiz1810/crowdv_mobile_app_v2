import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/material.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({Key key}) : super(key: key);

  @override
  _PremiumPageState createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Subscription",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.black),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: primaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Explore CrowdV Basic",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 22,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                              "You can cancel anytime in between your subscription but it will end at the end of the subscription duration period. ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black38,
                                fontSize: 18,
                              )),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Divider(
                          height: 5,
                          thickness: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Image.asset(
                                  "assets/cancel.png",
                                  height: 60,
                                  width: 50,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Cancel Subscription",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red,
                                          fontSize: 18,
                                        )),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        "You can cancel your subscription at any time to a free Basic membership. You’ll enjoy your benefits through the end of the billing term, though, and the next payment won’t be processed.",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black26,
                                          fontSize: 14,
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          height: 5,
                          thickness: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              top: 40,
              left: 30,
              right: 30,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(-1, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 15, bottom: 10, left: 20, right: 20),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/silverC.png",
                        fit: BoxFit.fill,
                        height: 60,
                        width: 60,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Go Basic",
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: 26,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text("Switch to CrowdV free basic membership",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 22,
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width/1.2,
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          children: [
                            Text("Your Premium subscription will be expired at",
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 14,
                                )),
                            Text("31th July 2023",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 16,
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
