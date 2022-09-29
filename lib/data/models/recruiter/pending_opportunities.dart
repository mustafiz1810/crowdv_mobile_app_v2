// To parse this JSON data, do
//
//     final pendingOpportunity = pendingOpportunityFromJson(jsonString);

import 'dart:convert';

PendingOpportunity pendingOpportunityFromJson(String str) => PendingOpportunity.fromJson(json.decode(str));

String pendingOpportunityToJson(PendingOpportunity data) => json.encode(data.toJson());

class PendingOpportunity {
  PendingOpportunity({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum> data;

  factory PendingOpportunity.fromJson(Map<String, dynamic> json) => PendingOpportunity(
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
    this.title,
    this.details,
    this.country,
    this.state,
    this.city,
    this.taskType,
    this.status,
    this.categoryName,
    this.recruiterName,
    this.date,
    this.startTime,
    this.endTime,
    this.categoryIcon,
    this.isApplied,
  });

  int id;
  String title;
  String details;
  String country;
  String state;
  String city;
  String taskType;
  String status;
  String categoryName;
  String recruiterName;
  String date;
  String startTime;
  String endTime;
  String categoryIcon;
  bool isApplied;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    details: json["details"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    taskType: json["task_type"],
    status: json["status"],
    categoryName: json["category_name"],
    recruiterName: json["recruiter_name"],
    date: json["date"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    categoryIcon: json["category_icon"],
    isApplied: json["is_applied"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "details": details,
    "country": country,
    "state": state,
    "city": city,
    "task_type": taskType,
    "status": status,
    "category_name": categoryName,
    "recruiter_name": recruiterName,
    "date": date,
    "start_time": startTime,
    "end_time": endTime,
    "category_icon": categoryIcon,
    "is_applied": isApplied,
  };
}
