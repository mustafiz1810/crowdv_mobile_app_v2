import 'package:crowdv_mobile_app/feature/screen/profile/common_profile.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/http_request.dart';
import 'package:crowdv_mobile_app/widgets/icon_box.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:inkwell_splash/inkwell_splash.dart';
import '../../../data/models/notification_model.dart';
import 'home_contents/widgets/applied_volunteer.dart';

class NotificationPage extends StatefulWidget {
  final dynamic id,data, token,role;
  NotificationPage({this.id,this.data, this.token,this.role});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification list'),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(child: FutureBuilder<NotificationModel>(
              builder: (context, snapshot) {
                if (widget.data.length == 0) {
                  return Container(
                    alignment: Alignment.center,
                    child: EmptyWidget(
                      image: null,
                      packageImage: PackageImage.Image_1,
                      title: 'Empty',
                      subTitle: 'Notification Empty',
                      titleTextStyle: TextStyle(
                        fontSize: 22,
                        color: Color(0xff9da9c7),
                        fontWeight: FontWeight.w500,
                      ),
                      subtitleTextStyle: TextStyle(
                        fontSize: 14,
                        color: Color(0xffabb8d6),
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: widget.data.length,
                    itemBuilder: (context, index) {
                      return InkWellSplash(
                        splashColor: Colors.white,
                        onTap: (){
                          // print(widget.data[index].data.opportunityId.toString());
                          getRequest(
                              '/api/v1/mark-notification/${widget.data[index].id}',
                              null, {
                            'Content-Type': "application/json",
                            "Authorization": "Bearer ${widget.token}"
                          }).then((value) async {
                            widget.data[index].data.opportunityId != null && widget.data[index].data.status != "hired" ?Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  AppliedVolunteer(
                                    token:
                                    widget.token,
                                    id: widget.data[index].data.opportunityId,
                                  )),
                            ):Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CommonProfile(id: widget.data[index].data.volunteerId,)),
                            );
                            setState(() {});
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            height: 90,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: widget.data[index].readAt.toString() == null?Color(0xFFe5e5e5):Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 1,
                                  spreadRadius: 0.2,
                                  offset: Offset(0, .5),
                                ),
                              ],
                              borderRadius:
                              BorderRadius.all(Radius.circular(20)),
                            ),
                            child: ListTile(
                              leading: IconBox(
                                child: Icon(
                                  Icons.notifications,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                bgColor: primaryColor,
                              ),
                              title: Row(
                                children: [
                                  Text(widget.data[index].data.volunteer != null?widget.data[index].data.volunteer:"",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black)),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(widget.data[index].data.status != null?widget.data[index].data.status:"",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black)),
                                ],
                              ),
                              trailing: Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                    color: widget.data[index].readAt == null?Color(0xFF1d4e89):Colors.white,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                              ),
                              subtitle: Text(widget.data[index].data.title),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
