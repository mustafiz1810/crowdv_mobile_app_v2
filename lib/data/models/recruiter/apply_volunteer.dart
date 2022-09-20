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
    this.image,
    this.gender,
    this.country,
    this.state,
    this.city,
    this.zipCode,
    this.profession,
    this.role,
    this.rating,
    this.review,
  });

  int id;
  String name;
  String image;
  String gender;
  String country;
  String state;
  String city;
  String zipCode;
  String profession;
  String role;
  int rating;
  dynamic review;

  factory Volunteers.fromJson(Map<String, dynamic> json) => Volunteers(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    gender: json["gender"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    zipCode: json["zip_code"],
    profession: json["profession"],
    role: json["role"],
    rating: json["rating"],
    review: json["review"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "gender": gender,
    "country": country,
    "state": state,
    "city": city,
    "zip_code": zipCode,
    "profession": profession,
    "role": role,
    "rating": rating,
    "review": review,
  };
}

class Task {
  Task({
    this.id,
    this.title,
    this.details,
    this.country,
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
  City country;
  City state;
  City city;
  String zipCode;
  String taskType;
  String category;
  String date;
  String startTime;
  String endTime;
  int workingHours;
  String status;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json["id"],
    title: json["title"],
    details: json["details"],
    country: City.fromJson(json["country"]),
    state: City.fromJson(json["state"]),
    city: City.fromJson(json["city"]),
    zipCode: json["zip_code"],
    taskType: json["task_type"],
    category: json["category"],
    date: json["date"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    workingHours: json["working_hours"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "details": details,
    "country": country.toJson(),
    "state": state.toJson(),
    "city": city.toJson(),
    "zip_code": zipCode,
    "task_type": taskType,
    "category": category,
    "date": date,
    "start_time": startTime,
    "end_time": endTime,
    "working_hours": workingHours,
    "status": status,
  };
}

class City {
  City({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory City.fromJson(Map<String, dynamic> json) => City(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
