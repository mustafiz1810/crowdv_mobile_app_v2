// To parse this JSON data, do
//
//     final myOpportunityModel = myOpportunityModelFromJson(jsonString);

import 'dart:convert';

MyOpportunityModel myOpportunityModelFromJson(String str) => MyOpportunityModel.fromJson(json.decode(str));

String myOpportunityModelToJson(MyOpportunityModel data) => json.encode(data.toJson());

class MyOpportunityModel {
  MyOpportunityModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum> data;

  factory MyOpportunityModel.fromJson(Map<String, dynamic> json) => MyOpportunityModel(
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
    this.state,
    this.city,
    this.zipCode,
    this.taskType,
    this.category,
    this.volunteer,
    this.recruiter,
    this.eligibility,
    this.date,
    this.startTime,
    this.endTime,
    this.workingHours,
    this.locationFrom,
    this.benefits,
    this.locationTo,
    this.status,
  });

  int id;
  String title;
  String details;
  String state;
  String city;
  String zipCode;
  String taskType;
  Category category;
  Volunteer volunteer;
  Recruiter recruiter;
  Eligibility eligibility;
  DateTime date;
  String startTime;
  DateTime endTime;
  int workingHours;
  String locationFrom;
  dynamic benefits;
  String locationTo;
  String status;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    details: json["details"],
    state: json["state"],
    city: json["city"],
    zipCode: json["zip_code"],
    taskType: json["task_type"],
    category: Category.fromJson(json["category"]),
    volunteer: Volunteer.fromJson(json["volunteer"]),
    recruiter: Recruiter.fromJson(json["recruiter"]),
    eligibility: Eligibility.fromJson(json["eligibility"]),
    date: DateTime.parse(json["date"]),
    startTime: json["start_time"],
    endTime: DateTime.parse(json["end_time"]),
    workingHours: json["working_hours"],
    locationFrom: json["location_from"],
    benefits: json["benefits"],
    locationTo: json["location_to"],
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
    "category": category.toJson(),
    "volunteer": volunteer.toJson(),
    "recruiter": recruiter.toJson(),
    "eligibility": eligibility.toJson(),
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "start_time": startTime,
    "end_time": "${endTime.year.toString().padLeft(4, '0')}-${endTime.month.toString().padLeft(2, '0')}-${endTime.day.toString().padLeft(2, '0')}",
    "working_hours": workingHours,
    "location_from": locationFrom,
    "benefits": benefits,
    "location_to": locationTo,
    "status": status,
  };
}

class Category {
  Category({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class Eligibility {
  Eligibility({
    this.id,
    this.title,
  });

  int id;
  String title;

  factory Eligibility.fromJson(Map<String, dynamic> json) => Eligibility(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}

class Recruiter {
  Recruiter({
    this.id,
    this.firstName,
    this.lastName,
    this.surName,
    this.image,
    this.phone,
    this.email,
    this.gender,
    this.typeOfDisability,
    this.state,
    this.city,
    this.building,
    this.streetAddress,
  });

  int id;
  String firstName;
  String lastName;
  String surName;
  String image;
  String phone;
  String email;
  String gender;
  String typeOfDisability;
  String state;
  String city;
  String building;
  String streetAddress;

  factory Recruiter.fromJson(Map<String, dynamic> json) => Recruiter(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    surName: json["sur_name"],
    image: json["image"],
    phone: json["phone"],
    email: json["email"],
    gender: json["gender"],
    typeOfDisability: json["type_of_disability"],
    state: json["state"],
    city: json["city"],
    building: json["building"],
    streetAddress: json["street_address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "sur_name": surName,
    "image": image,
    "phone": phone,
    "email": email,
    "gender": gender,
    "type_of_disability": typeOfDisability,
    "state": state,
    "city": city,
    "building": building,
    "street_address": streetAddress,
  };
}

class Volunteer {
  Volunteer({
    this.id,
    this.firstName,
    this.lastName,
    this.surName,
    this.image,
    this.phone,
    this.email,
    this.gender,
    this.profession,
    this.isAvailable,
  });

  dynamic id;
  dynamic firstName;
  dynamic lastName;
  dynamic surName;
  dynamic image;
  dynamic phone;
  dynamic email;
  dynamic gender;
  dynamic profession;
  dynamic isAvailable;

  factory Volunteer.fromJson(Map<String, dynamic> json) => Volunteer(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    surName: json["sur_name"],
    image: json["image"],
    phone: json["phone"],
    email: json["email"],
    gender: json["gender"],
    profession: json["profession"],
    isAvailable: json["is_available"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "sur_name": surName,
    "image": image,
    "phone": phone,
    "email": email,
    "gender": gender,
    "profession": profession,
    "is_available": isAvailable,
  };
}
