// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  NotificationModelData data;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        success: json["success"],
        message: json["message"],
        data: NotificationModelData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class NotificationModelData {
  NotificationModelData({
    this.list,
    this.count,
  });

  List<ListElement> list;
  int count;

  factory NotificationModelData.fromJson(Map<String, dynamic> json) =>
      NotificationModelData(
        list: List<ListElement>.from(
            json["list"].map((x) => ListElement.fromJson(x))),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "list": List<dynamic>.from(list.map((x) => x.toJson())),
        "count": count,
      };
}

class ListElement {
  ListElement({
    this.id,
    this.type,
    this.notifiableType,
    this.notifiableId,
    this.data,
    this.readAt,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  String type;
  String notifiableType;
  int notifiableId;
  ListData data;
  String readAt;
  DateTime createdAt;
  DateTime updatedAt;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        id: json["id"],
        type: json["type"],
        notifiableType: json["notifiable_type"],
        notifiableId: json["notifiable_id"],
        data: ListData.fromJson(json["data"]),
        readAt: json["read_at"] ,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "notifiable_type": notifiableType,
        "notifiable_id": notifiableId,
        "data": data.toJson(),
        "read_at": readAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class ListData {
  ListData({
    this.opportunityId,
    this.title,
    this.status,
    this.volunteer,
    this.volunteerId,
  });

  int opportunityId;
  String title;
  String status;
  String volunteer;
  int volunteerId;

  factory ListData.fromJson(Map<String, dynamic> json) => ListData(
        opportunityId: json["opportunity_id"],
        title: json["title"],
        status: json["status"],
        volunteer: json["volunteer"],
        volunteerId: json["volunteer_id"] == null ? null : json["volunteer_id"],
      );

  Map<String, dynamic> toJson() => {
        "opportunity_id": opportunityId,
        "title": title,
        "status": status,
        "volunteer": volunteer,
        "volunteer_id": volunteerId == null ? null : volunteerId,
      };
}
