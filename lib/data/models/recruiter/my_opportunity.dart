// To parse this JSON data, do
//
//     final myOpportunityModel = myOpportunityModelFromJson(jsonString);

import 'dart:convert';

MyOpportunityModel myOpportunityModelFromJson(String str) =>
    MyOpportunityModel.fromJson(json.decode(str));

String myOpportunityModelToJson(MyOpportunityModel data) =>
    json.encode(data.toJson());

class MyOpportunityModel {
  MyOpportunityModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum> data;

  factory MyOpportunityModel.fromJson(Map<String, dynamic> json) =>
      MyOpportunityModel(
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
    this.date,
    this.startTime,
    this.endTime,
    this.workingHours,
    this.locationFrom,
    this.benefits,
    this.locationTo,
    this.status,
    this.isPublic,
  });

  int id;
  String title;
  String details;
  String state;
  String city;
  String zipCode;
  String taskType;
  Category category;
  Recruiter volunteer;
  Recruiter recruiter;
  DateTime date;
  String startTime;
  String endTime;
  int workingHours;
  String locationFrom;
  dynamic benefits;
  String locationTo;
  String status;
  bool isPublic;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        details: json["details"],
        state: json["state"],
        city: json["city"],
        zipCode: json["zip_code"],
        taskType: json["task_type"],
        category: Category.fromJson(json["category"]),
        volunteer: Recruiter.fromJson(json["volunteer"]),
        recruiter: Recruiter.fromJson(json["recruiter"]),
        date: DateTime.parse(json["date"]),
        startTime: json["start_time"],
        endTime: json["end_time"],
        workingHours: json["working_hours"],
        locationFrom: json["location_from"],
        benefits: json["benefits"],
        locationTo: json["location_to"],
        status: json["status"],
        isPublic: json["is_public"],
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
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "start_time": startTime,
        "end_time": endTime,
        "working_hours": workingHours,
        "location_from": locationFrom,
        "benefits": benefits,
        "location_to": locationTo,
        "status": status,
        "is_public": isPublic,
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
    this.zipCode,
    this.profession,
  });

  int id;
  String firstName;
  String lastName;
  dynamic surName;
  String image;
  String phone;
  String email;
  String gender;
  dynamic typeOfDisability;
  String state;
  String city;
  String zipCode;
  dynamic profession;

  factory Recruiter.fromJson(Map<String, dynamic> json) => Recruiter(
        id: json["id"] == null ? null : json["id"],
        firstName: json["first_name"] == null ? null : json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        surName: json["sur_name"],
        image: json["image"] == null ? null : json["image"],
        phone: json["phone"] == null ? null : json["phone"],
        email: json["email"] == null ? null : json["email"],
        gender: json["gender"] == null ? null : json["gender"],
        typeOfDisability: json["type_of_disability"],
        state: json["state"] == null ? null : json["state"],
        city: json["city"] == null ? null : json["city"],
        zipCode: json["zip_code"] == null ? null : json["zip_code"],
        profession: json["profession"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "first_name": firstName == null ? null : firstName,
        "last_name": lastName == null ? null : lastName,
        "sur_name": surName,
        "image": image == null ? null : image,
        "phone": phone == null ? null : phone,
        "email": email == null ? null : email,
        "gender": gender == null ? null : gender,
        "type_of_disability": typeOfDisability,
        "state": state == null ? null : state,
        "city": city == null ? null : city,
        "zip_code": zipCode == null ? null : zipCode,
        "profession": profession,
      };
}
