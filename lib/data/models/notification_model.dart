// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  NotificationModelData data;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
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

  factory NotificationModelData.fromJson(Map<String, dynamic> json) => NotificationModelData(
    list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
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
  dynamic readAt;
  DateTime createdAt;
  DateTime updatedAt;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    id: json["id"],
    type: json["type"],
    notifiableType: json["notifiable_type"],
    notifiableId: json["notifiable_id"],
    data: ListData.fromJson(json["data"]),
    readAt: json["read_at"],
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
    this.taskType,
    this.date,
    this.status,
    this.volunteer,
  });

  int opportunityId;
  String title;
  String taskType;
  DateTime date;
  String status;
  String volunteer;

  factory ListData.fromJson(Map<String, dynamic> json) => ListData(
    opportunityId: json["opportunity_id"] == null ? null : json["opportunity_id"],
    title: json["title"],
    taskType: json["task_type"] == null ? null : json["task_type"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    status: json["status"] == null ? null : json["status"],
    volunteer: json["volunteer"] == null ? null : json["volunteer"],
  );

  Map<String, dynamic> toJson() => {
    "opportunity_id": opportunityId == null ? null : opportunityId,
    "title": title,
    "task_type": taskType == null ? null : taskType,
    "date": date == null ? null : date.toIso8601String(),
    "status": status == null ? null : status,
    "volunteer": volunteer == null ? null : volunteer,
  };
}
