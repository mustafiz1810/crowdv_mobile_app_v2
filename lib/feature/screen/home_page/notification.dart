import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<String> notify = ['Job Accepted', 'Job on going', 'Job completed'];
  List<IconData> icon = [
    Icons.check_box_outlined,
    Icons.watch_later_outlined,
    Icons.check_box
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification list'),
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: notify.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Container(
                      height: 100,
                      margin: const EdgeInsets.only(
                        top: 10,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: <Color>[
                            Colors.white,
                            Colors.white,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 5,
                            spreadRadius: 0.5,
                            offset: Offset(1, 1),
                          ),
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: ListTile(
                        trailing: Container(
                          color: Colors.transparent,
                          height: 200,
                          width: 100,
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/avater.png'),
                                backgroundColor: Colors.transparent,
                              ),
                              Text('Jhon doe')
                            ],
                          ),
                        ),
                        leading: IconBox(
                          child: Icon(
                            icon[index],
                            color: Colors.white,
                            size: 25,
                          ),
                          bgColor: primaryColor,
                        ),
                        title: Text(notify[index].toString(),
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor)),
                        subtitle: Text('massage detail'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
