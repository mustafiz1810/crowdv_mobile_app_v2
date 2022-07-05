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
    this.title,
    this.details,
    this.state,
    this.city,
    this.zipCode,
    this.taskType,
    this.category,
    this.eligibility,
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
  List<Eligibility> eligibility;
  Recruiter volunteer;
  Recruiter recruiter;
  DateTime date;
  DateTime startTime;
  DateTime endTime;
  int workingHours;
  dynamic benefits;
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
    eligibility: List<Eligibility>.from(json["eligibility"].map((x) => Eligibility.fromJson(x))),
    volunteer: Recruiter.fromJson(json["volunteer"]),
    recruiter: Recruiter.fromJson(json["recruiter"]),
    date: DateTime.parse(json["date"]),
    startTime: DateTime.parse(json["start_time"]),
    endTime: DateTime.parse(json["end_time"]),
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
    "eligibility": List<dynamic>.from(eligibility.map((x) => x.toJson())),
    "volunteer": volunteer.toJson(),
    "recruiter": recruiter.toJson(),
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "start_time": startTime.toIso8601String(),
    "end_time": endTime.toIso8601String(),
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
  String details;
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
    this.surName,
    this.image,
    this.phone,
    this.email,
    this.gender,
    this.typeOfDisability,
    this.state,
    this.city,
    this.zipCode,
    this.role,
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
  String role;
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
    role: json["role"],
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
    "role": role,
    "profession": profession,
  };
}
