// To parse this JSON data, do
//
//     final recruiterHistoryModel = recruiterHistoryModelFromJson(jsonString);

import 'dart:convert';

RecruiterHistoryModel recruiterHistoryModelFromJson(String str) => RecruiterHistoryModel.fromJson(json.decode(str));

String recruiterHistoryModelToJson(RecruiterHistoryModel data) => json.encode(data.toJson());

class RecruiterHistoryModel {
  RecruiterHistoryModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum> data;

  factory RecruiterHistoryModel.fromJson(Map<String, dynamic> json) => RecruiterHistoryModel(
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
    this.expiredAt,
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
    this.applyId,
    this.category,
    this.eligibility,
    this.otherEligibility,
    this.volunteer,
    this.recruiter,
    this.applyInvite,
  });

  int id;
  String title;
  String details;
  String expiredAt;
  City country;
  City state;
  City city;
  dynamic zipCode;
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
  dynamic applyId;
  Category category;
  List<dynamic> eligibility;
  String otherEligibility;
  Recruiter volunteer;
  Recruiter recruiter;
  List<dynamic> applyInvite;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
    datumStartTime: json["start_time"],
    startTime: DateTime.parse(json["startTime"]),
    datumEndTime: json["end_time"],
    endTime: DateTime.parse(json["endTime"]),
    workingHours: json["working_hours"],
    benefits: json["benefits"],
    isPublic: json["is_public"],
    status: json["status"],
    applyStatus: json["apply_status"],
    applyId: json["apply_id"],
    category: Category.fromJson(json["category"]),
    eligibility: List<dynamic>.from(json["eligibility"].map((x) => x)),
    otherEligibility: json["other_eligibility"],
    volunteer: Recruiter.fromJson(json["volunteer"]),
    recruiter: Recruiter.fromJson(json["recruiter"]),
    applyInvite: List<dynamic>.from(json["apply_invite"].map((x) => x)),
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
    "start_time": datumStartTime,
    "startTime": startTime.toIso8601String(),
    "end_time": datumEndTime,
    "endTime": endTime.toIso8601String(),
    "working_hours": workingHours,
    "benefits": benefits,
    "is_public": isPublic,
    "status": status,
    "apply_status": applyStatus,
    "apply_id": applyId,
    "category": category.toJson(),
    "eligibility": List<dynamic>.from(eligibility.map((x) => x)),
    "other_eligibility": otherEligibility,
    "volunteer": volunteer.toJson(),
    "recruiter": recruiter.toJson(),
    "apply_invite": List<dynamic>.from(applyInvite.map((x) => x)),
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
  dynamic zipCode;
  String role;
  int profileRating;
  int rating;
  dynamic review;
  String uid;
  bool isOnline;

  factory Recruiter.fromJson(Map<String, dynamic> json) => Recruiter(
    id: json["id"] == null ? null : json["id"],
    firstName: json["first_name"] == null ? null : json["first_name"],
    lastName: json["last_name"] == null ? null : json["last_name"],
    email: json["email"] == null ? null : json["email"],
    gender: json["gender"] == null ? null : json["gender"],
    phone: json["phone"] == null ? null : json["phone"],
    image: json["image"] == null ? null : json["image"],
    typeOfDisability: json["type_of_disability"] == null ? null : json["type_of_disability"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    zipCode: json["zip_code"],
    role: json["role"] == null ? null : json["role"],
    profileRating: json["profile_rating"],
    rating: json["rating"],
    review: json["review"],
    uid: json["uid"] == null ? null : json["uid"],
    isOnline: json["is_online"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "first_name": firstName == null ? null : firstName,
    "last_name": lastName == null ? null : lastName,
    "email": email == null ? null : email,
    "gender": gender == null ? null : gender,
    "phone": phone == null ? null : phone,
    "image": image == null ? null : image,
    "type_of_disability": typeOfDisability == null ? null : typeOfDisability,
    "country": country,
    "state": state,
    "city": city,
    "zip_code": zipCode,
    "role": role == null ? null : role,
    "profile_rating": profileRating,
    "rating": rating,
    "review": review,
    "uid": uid == null ? null : uid,
    "is_online": isOnline,
  };
}
