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
    this.status,
  });

  Task task;
  List<ApplyVolunteerElement> applyVolunteer;
  String status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    task: Task.fromJson(json["task"]),
    applyVolunteer: List<ApplyVolunteerElement>.from(json["apply_volunteer"].map((x) => ApplyVolunteerElement.fromJson(x))),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "task": task.toJson(),
    "apply_volunteer": List<dynamic>.from(applyVolunteer.map((x) => x.toJson())),
    "status": status,
  };
}

class ApplyVolunteerElement {
  ApplyVolunteerElement({
    this.volunteers,
  });

  Volunteers volunteers;

  factory ApplyVolunteerElement.fromJson(Map<String, dynamic> json) => ApplyVolunteerElement(
    volunteers: Volunteers.fromJson(json["volunteers"]),
  );

  Map<String, dynamic> toJson() => {
    "volunteers": volunteers.toJson(),
  };
}

class Volunteers {
  Volunteers({
    this.id,
    this.firstName,
    this.lastName,
    this.image,
    this.phone,
    this.email,
    this.gender,
    this.profession,
  });

  int id;
  String firstName;
  String lastName;
  String image;
  String phone;
  String email;
  String gender;
  dynamic profession;

  factory Volunteers.fromJson(Map<String, dynamic> json) => Volunteers(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    image: json["image"],
    phone: json["phone"],
    email: json["email"],
    gender: json["gender"],
    profession: json["profession"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "image": image,
    "phone": phone,
    "email": email,
    "gender": gender,
    "profession": profession,
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
