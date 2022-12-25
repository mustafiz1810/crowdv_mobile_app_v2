import 'package:crowdv_mobile_app/feature/screen/Subscription/Payment/payment_controller.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BasicPage extends StatefulWidget {
  const BasicPage({Key key}) : super(key: key);

  @override
  _BasicPageState createState() => _BasicPageState();
}

class _BasicPageState extends State<BasicPage> {
  var obj = PaymentController();
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
                          child: Text("Explore CrowdV Premium",
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
                              "Explore CrowdV Premium and enjoy your benefits as a recruiter ",
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
              child: InkWell(
                onTap: () => obj.makePayment(amount: '5', currency: 'USD'),
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
                          "assets/crown.png",
                          height: 60,
                          width: 60,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Go Premium",
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 26,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text("Try CrowdV Premium from Jan to June 2022",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 22,
                            )),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("At only",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 18,
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            Text("200 Tk",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                  fontSize: 20,
                                )),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
