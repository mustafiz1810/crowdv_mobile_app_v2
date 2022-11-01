// To parse this JSON data, do
//
//     final volunteerHistoryModel = volunteerHistoryModelFromJson(jsonString);

import 'dart:convert';

VolunteerHistoryModel volunteerHistoryModelFromJson(String str) => VolunteerHistoryModel.fromJson(json.decode(str));

String volunteerHistoryModelToJson(VolunteerHistoryModel data) => json.encode(data.toJson());

class VolunteerHistoryModel {
  VolunteerHistoryModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum> data;

  factory VolunteerHistoryModel.fromJson(Map<String, dynamic> json) => VolunteerHistoryModel(
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
    this.zipCode,
    this.taskType,
    this.dateFormat,
    this.date,
    this.datumStartTime,
    this.startTime,
    this.datumEndTime,
    this.endTime,
    this.workingHours,
    this.benefits,
    this.isPublic,
    this.status,
    this.applyStatus,
    this.category,
    this.eligibility,
    this.volunteer,
    this.recruiter,
  });

  int id;
  String title;
  String details;
  City country;
  City state;
  City city;
  String zipCode;
  String taskType;
  String dateFormat;
  DateTime date;
  String datumStartTime;
  DateTime startTime;
  String datumEndTime;
  DateTime endTime;
  int workingHours;
  dynamic benefits;
  bool isPublic;
  String status;
  bool applyStatus;
  Category category;
  List<dynamic> eligibility;
  Recruiter volunteer;
  Recruiter recruiter;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    details: json["details"],
    country: City.fromJson(json["country"]),
    state: City.fromJson(json["state"]),
    city: City.fromJson(json["city"]),
    zipCode: json["zip_code"],
    taskType: json["task_type"],
    dateFormat: json["date_format"],
    date: DateTime.parse(json["date"]),
    datumStartTime: json["start_time"],
    startTime: DateTime.parse(json["startTime"]),
    datumEndTime: json["end_time"],
    endTime: DateTime.parse(json["endTime"]),
    workingHours: json["working_hours"],
    benefits: json["benefits"],
    isPublic: json["is_public"],
    status: json["status"],
    applyStatus: json["apply_status"],
    category: Category.fromJson(json["category"]),
    eligibility: List<dynamic>.from(json["eligibility"].map((x) => x)),
    volunteer: Recruiter.fromJson(json["volunteer"]),
    recruiter: Recruiter.fromJson(json["recruiter"]),
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
    "date_format": dateFormat,
    "date": date.toIso8601String(),
    "start_time": datumStartTime,
    "startTime": startTime.toIso8601String(),
    "end_time": datumEndTime,
    "endTime": endTime.toIso8601String(),
    "working_hours": workingHours,
    "benefits": benefits,
    "is_public": isPublic,
    "status": status,
    "apply_status": applyStatus,
    "category": category.toJson(),
    "eligibility": List<dynamic>.from(eligibility.map((x) => x)),
    "volunteer": volunteer.toJson(),
    "recruiter": recruiter.toJson(),
  };
}

class Category {
  Category({
    this.id,
    this.name,
    this.slug,
  });

  int id;
  String name;
  String slug;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
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
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
  };
}

class Recruiter {
  Recruiter({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.image,
    this.gender,
    this.typeOfDisability,
    this.country,
    this.state,
    this.city,
    this.zipCode,
    this.role,
    this.profileRating,
    this.rating,
    this.review,
  });

  int id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String image;
  String gender;
  String typeOfDisability;
  String country;
  String state;
  String city;
  String zipCode;
  String role;
  int profileRating;
  int rating;
  dynamic review;

  factory Recruiter.fromJson(Map<String, dynamic> json) => Recruiter(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    phone: json["phone"],
    image: json["image"],
    gender: json["gender"],
    typeOfDisability: json["type_of_disability"] == null ? null : json["type_of_disability"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    zipCode: json["zip_code"],
    role: json["role"],
    profileRating: json["profile_rating"],
    rating: json["rating"],
    review: json["review"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "phone": phone,
    "image": image,
    "gender": gender,
    "type_of_disability": typeOfDisability == null ? null : typeOfDisability,
    "country": country,
    "state": state,
    "city": city,
    "zip_code": zipCode,
    "role": role,
    "profile_rating": profileRating,
    "rating": rating,
    "review": review,
  };
}
