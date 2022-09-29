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
    this.expiredAt,
    this.city,
    this.taskStatus,
    this.status,
    this.categoryIcon,
    this.volunteers,
    this.recruiter,
  });

  int id;
  int taskId;
  String title;
  String details;
  String expiredAt;
  String city;
  String taskStatus;
  String status;
  String categoryIcon;
  Volunteers volunteers;
  Recruiter recruiter;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    taskId: json["task_id"],
    title: json["title"],
    details: json["details"],
    expiredAt: json["expired_at"],
    city: json["city"],
    taskStatus: json["task_status"],
    status: json["status"],
    categoryIcon: json["category_icon"],
    volunteers: Volunteers.fromJson(json["volunteers"]),
    recruiter: Recruiter.fromJson(json["recruiter"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "task_id": taskId,
    "title": title,
    "details": details,
    "expired_at": expiredAt,
    "city": city,
    "task_status": taskStatus,
    "status": status,
    "category_icon": categoryIcon,
    "volunteers": volunteers.toJson(),
    "recruiter": recruiter.toJson(),
  };
}

class Recruiter {
  Recruiter({
    this.id,
    this.firstName,
    this.lastName,
    this.image,
    this.phone,
    this.email,
    this.uid,
    this.isOnline,
  });

  int id;
  String firstName;
  String lastName;
  String image;
  String phone;
  String email;
  String uid;
  bool isOnline;

  factory Recruiter.fromJson(Map<String, dynamic> json) => Recruiter(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    image: json["image"],
    phone: json["phone"],
    email: json["email"],
    uid: json["uid"],
    isOnline: json["is_online"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "image": image,
    "phone": phone,
    "email": email,
    "uid": uid,
    "is_online": isOnline,
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
    this.uid,
    this.isOnline,
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
  String uid;
  bool isOnline;

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
    uid: json["uid"],
    isOnline: json["is_online"],
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
    "uid": uid,
    "is_online": isOnline,
  };
}
