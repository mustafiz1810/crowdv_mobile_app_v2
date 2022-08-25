// To parse this JSON data, do
//
//     final volunteerOpportunity = volunteerOpportunityFromJson(jsonString);

import 'dart:convert';

VolunteerOpportunity volunteerOpportunityFromJson(String str) => VolunteerOpportunity.fromJson(json.decode(str));

String volunteerOpportunityToJson(VolunteerOpportunity data) => json.encode(data.toJson());

class VolunteerOpportunity {
  VolunteerOpportunity({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum> data;

  factory VolunteerOpportunity.fromJson(Map<String, dynamic> json) => VolunteerOpportunity(
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
    this.city,
    this.taskType,
    this.status,
    this.categoryName,
    this.recruiterName,
    this.date,
    this.startTime,
    this.endTime,
    this.categoryIcon,
  });

  int id;
  String title;
  String details;
  String city;
  String taskType;
  String status;
  String categoryName;
  String recruiterName;
  String date;
  String startTime;
  String endTime;
  String categoryIcon;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    details: json["details"],
    city: json["city"],
    taskType: json["task_type"],
    status: json["status"],
    categoryName: json["category_name"],
    recruiterName: json["recruiter_name"],
    date: json["date"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    categoryIcon: json["category_icon"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "details": details,
    "city": city,
    "task_type": taskType,
    "status": status,
    "category_name": categoryName,
    "recruiter_name": recruiterName,
    "date": date,
    "start_time": startTime,
    "end_time": endTime,
    "category_icon": categoryIcon,
  };
}
