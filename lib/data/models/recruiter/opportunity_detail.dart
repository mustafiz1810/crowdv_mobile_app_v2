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
    this.date,
    this.startTime,
    this.endTime,
    this.workingHours,
    this.benefits,
    this.isPublic,
    this.status,
    this.category,
    this.eligibility,
    this.volunteer,
    this.recruiter,
  });

  int id;
  String title;
  String details;
  String state;
  String city;
  String zipCode;
  String taskType;
  DateTime date;
  DateTime startTime;
  DateTime endTime;
  int workingHours;
  dynamic benefits;
  bool isPublic;
  String status;
  Category category;
  List<Eligibility> eligibility;
  Recruiter volunteer;
  Recruiter recruiter;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    title: json["title"],
    details: json["details"],
    state: json["state"],
    city: json["city"],
    zipCode: json["zip_code"],
    taskType: json["task_type"],
    date: DateTime.parse(json["date"]),
    startTime: DateTime.parse(json["start_time"]),
    endTime: DateTime.parse(json["end_time"]),
    workingHours: json["working_hours"],
    benefits: json["benefits"],
    isPublic: json["is_public"],
    status: json["status"],
    category: Category.fromJson(json["category"]),
    eligibility: List<Eligibility>.from(json["eligibility"].map((x) => Eligibility.fromJson(x))),
    volunteer: Recruiter.fromJson(json["volunteer"]),
    recruiter: Recruiter.fromJson(json["recruiter"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "details": details,
    "state": state,
    "city": city,
    "zip_code": zipCode,
    "task_type": taskType,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "start_time": startTime.toIso8601String(),
    "end_time": endTime.toIso8601String(),
    "working_hours": workingHours,
    "benefits": benefits,
    "is_public": isPublic,
    "status": status,
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
  DateTime createdAt;
  DateTime updatedAt;
  Pivot pivot;

  factory Eligibility.fromJson(Map<String, dynamic> json) => Eligibility(
    id: json["id"],
    categoryId: json["category_id"],
    title: json["title"],
    details: json["details"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    pivot: Pivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "title": title,
    "details": details,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
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
    this.state,
    this.city,
    this.zipCode,
    this.role,
    this.rating,
    this.review,
  });

  int id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String image;
  String typeOfDisability;
  String state;
  String city;
  String zipCode;
  String role;
  int rating;
  String review;

  factory Recruiter.fromJson(Map<String, dynamic> json) => Recruiter(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    phone: json["phone"],
    image: json["image"],
    typeOfDisability: json["type_of_disability"] == null ? null : json["type_of_disability"],
    state: json["state"],
    city: json["city"],
    zipCode: json["zip_code"],
    role: json["role"],
    rating: json["rating"],
    review: json["review"] == null ? null : json["review"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "phone": phone,
    "image": image,
    "type_of_disability": typeOfDisability == null ? null : typeOfDisability,
    "state": state,
    "city": city,
    "zip_code": zipCode,
    "role": role,
    "rating": rating,
    "review": review == null ? null : review,
  };
}
