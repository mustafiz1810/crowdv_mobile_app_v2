// To parse this JSON data, do
//
//     final opportunityDetail = opportunityDetailFromJson(jsonString);

import 'dart:convert';

OpportunityDetail opportunityDetailFromJson(String str) => OpportunityDetail.fromJson(json.decode(str));

String opportunityDetailToJson(OpportunityDetail data) => json.encode(data.toJson());

class OpportunityDetail {
  OpportunityDetail({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  Data data;

  factory OpportunityDetail.fromJson(Map<String, dynamic> json) => OpportunityDetail(
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
    this.benefits,
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
  dynamic benefits;
  String status;
  bool isPublic;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
    benefits: json["benefits"],
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
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "start_time": startTime,
    "end_time": endTime,
    "working_hours": workingHours,
    "benefits": benefits,
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
    zipCode: json["zip_code"],
    profession: json["profession"],
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
    "zip_code": zipCode,
    "profession": profession,
  };
}
