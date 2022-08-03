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
    this.status,
    this.task,
    this.volunteers,
    this.recruiter,
  });

  int id;
  String status;
  Task task;
  Recruiter volunteers;
  Recruiter recruiter;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    status: json["status"],
    task: Task.fromJson(json["task"]),
    volunteers: Recruiter.fromJson(json["volunteers"]),
    recruiter: Recruiter.fromJson(json["recruiter"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "task": task.toJson(),
    "volunteers": volunteers.toJson(),
    "recruiter": recruiter.toJson(),
  };
}

class Recruiter {
  Recruiter({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
  });

  int id;
  String firstName;
  String lastName;
  String phone;

  factory Recruiter.fromJson(Map<String, dynamic> json) => Recruiter(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "phone": phone,
  };
}

class Task {
  Task({
    this.id,
    this.title,
    this.details,
    this.state,
    this.city,
    this.zipCode,
    this.taskType,
    this.status,
  });

  int id;
  String title;
  String details;
  String state;
  String city;
  String zipCode;
  String taskType;
  String status;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["id"],
    title: json["title"],
    details: json["details"],
    state: json["state"],
    city: json["city"],
    zipCode: json["zip_code"],
    taskType: json["task_type"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "details": details,
    "state": state,
    "city": city,
    "zip_code": zipCode,
    "task_type": taskType,
    "status": status,
  };
}
