// To parse this JSON data, do
//
//     final applyVolunteer = applyVolunteerFromJson(jsonString);

import 'dart:convert';

ApplyVolunteer applyVolunteerFromJson(String str) => ApplyVolunteer.fromJson(json.decode(str));

String applyVolunteerToJson(ApplyVolunteer data) => json.encode(data.toJson());

class ApplyVolunteer {
  ApplyVolunteer({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  Data data;

  factory ApplyVolunteer.fromJson(Map<String, dynamic> json) => ApplyVolunteer(
    success: json["success"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.task,
    this.applyVolunteer,
    this.applyVolunteersCount,
    this.status,
  });

  Task task;
  List<ApplyVolunteerElement> applyVolunteer;
  int applyVolunteersCount;
  String status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    task: Task.fromJson(json["task"]),
    applyVolunteer: List<ApplyVolunteerElement>.from(json["apply_volunteer"].map((x) => ApplyVolunteerElement.fromJson(x))),
    applyVolunteersCount: json["apply_volunteers_count"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "task": task.toJson(),
    "apply_volunteer": List<dynamic>.from(applyVolunteer.map((x) => x.toJson())),
    "apply_volunteers_count": applyVolunteersCount,
    "status": status,
  };
}

class ApplyVolunteerElement {
  ApplyVolunteerElement({
    this.id,
    this.taskId,
    this.title,
    this.details,
    this.city,
    this.taskStatus,
    this.status,
    this.categoryIcon,
    this.volunteers,
  });

  int id;
  int taskId;
  String title;
  String details;
  String city;
  String taskStatus;
  String status;
  String categoryIcon;
  Volunteers volunteers;

  factory ApplyVolunteerElement.fromJson(Map<String, dynamic> json) => ApplyVolunteerElement(
    id: json["id"],
    taskId: json["task_id"],
    title: json["title"],
    details: json["details"],
    city: json["city"],
    taskStatus: json["task_status"],
    status: json["status"],
    categoryIcon: json["category_icon"],
    volunteers: Volunteers.fromJson(json["volunteers"]),
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
    "volunteers": volunteers.toJson(),
  };
}

class Volunteers {
  Volunteers({
    this.id,
    this.name,
    this.phone,
  });

  int id;
  String name;
  String phone;

  factory Volunteers.fromJson(Map<String, dynamic> json) => Volunteers(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
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
    this.category,
    this.date,
    this.startTime,
    this.endTime,
    this.workingHours,
    this.status,
  });

  int id;
  String title;
  String details;
  String state;
  String city;
  String zipCode;
  String taskType;
  String category;
  DateTime date;
  String startTime;
  String endTime;
  int workingHours;
  String status;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["id"],
    title: json["title"],
    details: json["details"],
    state: json["state"],
    city: json["city"],
    zipCode: json["zip_code"],
    taskType: json["task_type"],
    category: json["category"],
    date: DateTime.parse(json["date"]),
    startTime: json["start_time"],
    endTime: json["end_time"],
    workingHours: json["working_hours"],
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
    "category": category,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "start_time": startTime,
    "end_time": endTime,
    "working_hours": workingHours,
    "status": status,
  };
}
