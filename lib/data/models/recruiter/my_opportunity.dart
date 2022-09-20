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
    this.country,
    this.state,
    this.city,
    this.zipCode,
    this.taskType,
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
  String date;
  String datumStartTime;
  DateTime startTime;
  String datumEndTime;
  DateTime endTime;
  int workingHours;
  String benefits;
  bool isPublic;
  String status;
  int applyStatus;
  Category category;
  List<Eligibility> eligibility;
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
    date: json["date"],
    datumStartTime: json["start_time"],
    startTime: DateTime.parse(json["startTime"]),
    datumEndTime: json["end_time"],
    endTime: DateTime.parse(json["endTime"]),
    workingHours: json["working_hours"],
    benefits: json["benefits"] == null ? null : json["benefits"],
    isPublic: json["is_public"],
    status: json["status"],
    applyStatus: json["apply_status"],
    category: Category.fromJson(json["category"]),
    eligibility: List<Eligibility>.from(json["eligibility"].map((x) => Eligibility.fromJson(x))),
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
    "date": date,
    "start_time": datumStartTime,
    "startTime": startTime.toIso8601String(),
    "end_time": datumEndTime,
    "endTime": endTime.toIso8601String(),
    "working_hours": workingHours,
    "benefits": benefits == null ? null : benefits,
    "is_public": isPublic,
    "status": status,
    "apply_status": applyStatus,
    "category": category.toJson(),
    "eligibility": List<dynamic>.from(eligibility.map((x) => x.toJson())),
    "volunteer": volunteer.toJson(),
    "recruiter": recruiter.toJson(),
  };
}

class Category {
  Category({
    this.id,
    this.name,
    this.slug,
    this.icon,
  });

  int id;
  String name;
  String slug;
  String icon;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "icon": icon,
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

class Eligibility {
  Eligibility({
    this.id,
    this.categoryId,
    this.title,
    this.details,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  int id;
  int categoryId;
  String title;
  dynamic details;
  int status;
  dynamic createdAt;
  dynamic updatedAt;
  Pivot pivot;

  factory Eligibility.fromJson(Map<String, dynamic> json) => Eligibility(
    id: json["id"],
    categoryId: json["category_id"],
    title: json["title"],
    details: json["details"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    pivot: Pivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "title": title,
    "details": details,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "pivot": pivot.toJson(),
  };
}

class Pivot {
  Pivot({
    this.opportunityId,
    this.eligibilityId,
  });

  int opportunityId;
  int eligibilityId;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    opportunityId: json["opportunity_id"],
    eligibilityId: json["eligibility_id"],
  );

  Map<String, dynamic> toJson() => {
    "opportunity_id": opportunityId,
    "eligibility_id": eligibilityId,
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
    this.typeOfDisability,
    this.country,
    this.state,
    this.city,
    this.zipCode,
    this.role,
    this.profileRating,
    this.rating,
    this.review,
    this.gender,
  });

  int id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String image;
  String typeOfDisability;
  String country;
  String state;
  String city;
  String zipCode;
  String role;
  int profileRating;
  int rating;
  dynamic review;
  String gender;

  factory Recruiter.fromJson(Map<String, dynamic> json) => Recruiter(
    id: json["id"] == null ? null : json["id"],
    firstName: json["first_name"] == null ? null : json["first_name"],
    lastName: json["last_name"] == null ? null : json["last_name"],
    email: json["email"] == null ? null : json["email"],
    phone: json["phone"] == null ? null : json["phone"],
    image: json["image"] == null ? null : json["image"],
    typeOfDisability: json["type_of_disability"] == null ? null : json["type_of_disability"],
    country: json["country"] == null ? null : json["country"],
    state: json["state"] == null ? null : json["state"],
    city: json["city"] == null ? null : json["city"],
    zipCode: json["zip_code"] == null ? null : json["zip_code"],
    role: json["role"] == null ? null : json["role"],
    profileRating: json["profile_rating"] == null ? null : json["profile_rating"],
    rating: json["rating"],
    review: json["review"],
    gender: json["gender"] == null ? null : json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "first_name": firstName == null ? null : firstName,
    "last_name": lastName == null ? null : lastName,
    "email": email == null ? null : email,
    "phone": phone == null ? null : phone,
    "image": image == null ? null : image,
    "type_of_disability": typeOfDisability == null ? null : typeOfDisability,
    "country": country == null ? null : country,
    "state": state == null ? null : state,
    "city": city == null ? null : city,
    "zip_code": zipCode == null ? null : zipCode,
    "role": role == null ? null : role,
    "profile_rating": profileRating == null ? null : profileRating,
    "rating": rating,
    "review": review,
    "gender": gender == null ? null : gender,
  };
}
