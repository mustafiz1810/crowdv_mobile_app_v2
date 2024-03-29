import 'package:cached_network_image/cached_network_image.dart';
import 'package:crowdv_mobile_app/feature/screen/home_page/home_contents/widgets/recruiter_task_details.dart';
import 'package:crowdv_mobile_app/feature/screen/profile/common_profile.dart';
import 'package:crowdv_mobile_app/utils/view_utils/colors.dart';
import 'package:crowdv_mobile_app/widgets/http_request.dart';
import 'package:crowdv_mobile_app/widgets/show_toast.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import '../../../data/models/notification_model.dart';
import 'home_contents/widgets/volunteer_task_details.dart';

class NotificationPage extends StatefulWidget {
  final dynamic id, data, token, role;
  NotificationPage({this.id, this.data, this.token, this.role});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Notifications'),
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
                      return InkWell(
                        splashColor: Colors.white,
                        onTap: () {
                          // print(widget.data[index].data.opportunityId.toString());

                          getRequest(
                              '/api/v1/mark-notification/${widget.data[index].id}',
                              null, {
                            'Content-Type': "application/json",
                            "Authorization": "Bearer ${widget.token}"
                          }).then((value) async {
                            widget.role == widget.data[index].receiverRole
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            widget.data[index].data.status ==
                                                    "Gold"
                                                ? CommonProfile(
                                                    id: widget.data[index].data
                                                        .senderId,
                                                  )
                                                : widget.role == "volunteer"
                                                    ? VolunteerTaskDetails(
                                                        role: widget.role,
                                                        id: widget.data[index]
                                                            .data.opportunityId,
                                                        friendId: widget
                                                            .data[index]
                                                            .data
                                                            .senderUid,
                                                        friendName: widget
                                                            .data[index]
                                                            .data
                                                            .senderName,
                                                        friendImage: widget
                                                            .data[index]
                                                            .data
                                                            .senderImage,
                                                        isOnline: widget
                                                            .data[index]
                                                            .data
                                                            .isOnline)
                                                    : RecruiterTaskDetails(
                                                        role: widget.role,
                                                        id: widget.data[index]
                                                            .data.opportunityId,
                                                        friendId: widget
                                                            .data[index]
                                                            .data
                                                            .senderUid,
                                                        friendName: widget
                                                            .data[index]
                                                            .data
                                                            .senderName,
                                                        friendImage: widget
                                                            .data[index]
                                                            .data
                                                            .senderImage,
                                                        isOnline: widget
                                                            .data[index]
                                                            .data
                                                            .isOnline)),
                                  )
                                : showToast(context,
                                    'You are now ${widget.role} \nPlease Change your role and try again');
                            setState(() {});
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: widget.data[index].readAt != null
                                  ? secondaryColor.withOpacity(0.4)
                                  : primaryColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  blurRadius: 1,
                                  spreadRadius: 0.1,
                                  offset: Offset(0, .5),
                                ),
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: ListTile(
                              leading: CachedNetworkImage(
                                imageUrl: widget.data[index].data.senderImage,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                placeholder: (context, url) => Icon(
                                    Icons.downloading_rounded,
                                    size: 30,
                                    color: Colors.grey),
                                errorWidget: (context, url, error) => Icon(
                                  Icons.image_outlined,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              ),
                              title: Text(
                                  widget.data[index].data.senderName.toString(),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              subtitle: Text(widget.data[index].data.title, style: TextStyle(
                                  color: Colors.white)),
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
