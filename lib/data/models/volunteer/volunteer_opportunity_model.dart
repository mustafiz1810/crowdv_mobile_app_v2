// To parse this JSON data, do
//
//     final volunteerOpportunityModel = volunteerOpportunityModelFromJson(jsonString);

import 'dart:convert';

VolunteerOpportunityModel volunteerOpportunityModelFromJson(String str) => VolunteerOpportunityModel.fromJson(json.decode(str));

String volunteerOpportunityModelToJson(VolunteerOpportunityModel data) => json.encode(data.toJson());

class VolunteerOpportunityModel {
  VolunteerOpportunityModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum> data;

  factory VolunteerOpportunityModel.fromJson(Map<String, dynamic> json) => VolunteerOpportunityModel(
    success: json["success"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.taskId,
    this.title,
    this.details,
    this.city,
    this.taskStatus,
    this.status,
    this.categoryIcon,
  });

  int id;
  int taskId;
  String title;
  String details;
  String city;
  String taskStatus;
  String status;
  String categoryIcon;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    taskId: json["task_id"],
    title: json["title"],
    details: json["details"],
    city: json["city"],
    taskStatus: json["task_status"],
    status: json["status"],
    categoryIcon: json["category_icon"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "task_id": taskId,
    "title": title,
    "details": details,
    "city": city,
    "task_status": taskStatus,
    "status": status,
    "category_icon": categoryIcon,
  };
}
