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
    this.expiredAt,
    this.country,
    this.state,
    this.city,
    this.zipCode,
    this.taskType,
    this.dateFormat,
    this.date,
    this.dataStartTime,
    this.startTime,
    this.dataEndTime,
    this.endTime,
    this.workingHours,
    this.benefits,
    this.isPublic,
    this.status,
    this.applyStatus,
    this.category,
    this.eligibility,
    this.otherEligibility,
    this.volunteer,
    this.recruiter,
  });

  int id;
  String title;
  String details;
  String expiredAt;
  City country;
  City state;
  City city;
  String zipCode;
  String taskType;
  String dateFormat;
  DateTime date;
  String dataStartTime;
  DateTime startTime;
  String dataEndTime;
  DateTime endTime;
  int workingHours;
  dynamic benefits;
  bool isPublic;
  String status;
  int applyStatus;
  Category category;
  List<Eligibility> eligibility;
  dynamic otherEligibility;
  Recruiter volunteer;
  Recruiter recruiter;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    title: json["title"],
    details: json["details"],
    expiredAt: json["expired_at"],
    country: City.fromJson(json["country"]),
    state: City.fromJson(json["state"]),
    city: City.fromJson(json["city"]),
    zipCode: json["zip_code"],
    taskType: json["task_type"],
    dateFormat: json["date_format"],
    date: DateTime.parse(json["date"]),
    dataStartTime: json["start_time"],
    startTime: DateTime.parse(json["startTime"]),
    dataEndTime: json["end_time"],
    endTime: DateTime.parse(json["endTime"]),
    workingHours: json["working_hours"],
    benefits: json["benefits"],
    isPublic: json["is_public"],
    status: json["status"],
    applyStatus: json["apply_status"],
    category: Category.fromJson(json["category"]),
    eligibility: List<Eligibility>.from(json["eligibility"].map((x) => Eligibility.fromJson(x))),
    otherEligibility: json["other_eligibility"],
    volunteer: Recruiter.fromJson(json["volunteer"]),
    recruiter: Recruiter.fromJson(json["recruiter"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "details": details,
    "expired_at": expiredAt,
    "country": country.toJson(),
    "state": state.toJson(),
    "city": city.toJson(),
    "zip_code": zipCode,
    "task_type": taskType,
    "date_format": dateFormat,
    "date": date.toIso8601String(),
    "start_time": dataStartTime,
    "startTime": startTime.toIso8601String(),
    "end_time": dataEndTime,
    "endTime": endTime.toIso8601String(),
    "working_hours": workingHours,
    "benefits": benefits,
    "is_public": isPublic,
    "status": status,
    "apply_status": applyStatus,
    "category": category.toJson(),
    "eligibility": List<dynamic>.from(eligibility.map((x) => x.toJson())),
    "other_eligibility": otherEligibility,
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
    this.gender,
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
    this.uid,
    this.isOnline,
  });

  int id;
  String firstName;
  String lastName;
  String email;
  String gender;
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
  String uid;
  bool isOnline;

  factory Recruiter.fromJson(Map<String, dynamic> json) => Recruiter(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    gender: json["gender"],
    phone: json["phone"],
    image: json["image"],
    typeOfDisability: json["type_of_disability"] == null ? null : json["type_of_disability"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    zipCode: json["zip_code"],
    role: json["role"],
    profileRating: json["profile_rating"],
    rating: json["rating"],
    review: json["review"],
    uid: json["uid"],
    isOnline: json["is_online"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "gender": gender,
    "phone": phone,
    "image": image,
    "type_of_disability": typeOfDisability == null ? null : typeOfDisability,
    "country": country,
    "state": state,
    "city": city,
    "zip_code": zipCode,
    "role": role,
    "profile_rating": profileRating,
    "rating": rating,
    "review": review,
    "uid": uid,
    "is_online": isOnline,
  };
}
