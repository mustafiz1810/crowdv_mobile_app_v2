// To parse this JSON data, do
//
//     final commonProfileModel = commonProfileModelFromJson(jsonString);

import 'dart:convert';

CommonProfileModel commonProfileModelFromJson(String str) => CommonProfileModel.fromJson(json.decode(str));

String commonProfileModelToJson(CommonProfileModel data) => json.encode(data.toJson());

class CommonProfileModel {
  CommonProfileModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  Data data;

  factory CommonProfileModel.fromJson(Map<String, dynamic> json) => CommonProfileModel(
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
    this.token,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.aboutMe,
    this.institution,
    this.country,
    this.state,
    this.city,
    this.zipCode,
    this.typeOfDisability,
    this.profession,
    this.termsAndConditions,
    this.membership,
    this.gender,
    this.dob,
    this.image,
    this.role,
    this.serviceCountry,
    this.serviceState,
    this.serviceCity,
    this.serviceZipCode,
    this.isEmailNotification,
    this.isDatabaseNotification,
    this.isSmsNotification,
    this.workingHours,
    this.rating,
    this.opportunities,
    this.isComplete,
    this.isOnline,
    this.uid,
    this.reviews,
  });

  int id;
  dynamic token;
  String firstName;
  String lastName;
  String email;
  String phone;
  dynamic aboutMe;
  dynamic institution;
  City country;
  City state;
  City city;
  dynamic zipCode;
  List<dynamic> typeOfDisability;
  String profession;
  bool termsAndConditions;
  Membership membership;
  String gender;
  DateTime dob;
  String image;
  String role;
  City serviceCountry;
  City serviceState;
  City serviceCity;
  dynamic serviceZipCode;
  bool isEmailNotification;
  bool isDatabaseNotification;
  bool isSmsNotification;
  int workingHours;
  int rating;
  int opportunities;
  int isComplete;
  bool isOnline;
  String uid;
  List<Review> reviews;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    token: json["token"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    phone: json["phone"],
    aboutMe: json["about_me"],
    institution: json["institution"],
    country: City.fromJson(json["country"]),
    state: City.fromJson(json["state"]),
    city: City.fromJson(json["city"]),
    zipCode: json["zip_code"],
    typeOfDisability: List<dynamic>.from(json["type_of_disability"].map((x) => x)),
    profession: json["profession"],
    termsAndConditions: json["terms_and_conditions"],
    membership: Membership.fromJson(json["membership"]),
    gender: json["gender"],
    dob: DateTime.parse(json["dob"]),
    image: json["image"],
    role: json["role"],
    serviceCountry: City.fromJson(json["service_country"]),
    serviceState: City.fromJson(json["service_state"]),
    serviceCity: City.fromJson(json["service_city"]),
    serviceZipCode: json["service_zip_code"],
    isEmailNotification: json["is_email_notification"],
    isDatabaseNotification: json["is_database_notification"],
    isSmsNotification: json["is_sms_notification"],
    workingHours: json["working_hours"],
    rating: json["rating"],
    opportunities: json["opportunities"],
    isComplete: json["is_complete"],
    isOnline: json["is_online"],
    uid: json["uid"],
    reviews: List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "token": token,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "phone": phone,
    "about_me": aboutMe,
    "institution": institution,
    "country": country.toJson(),
    "state": state.toJson(),
    "city": city.toJson(),
    "zip_code": zipCode,
    "type_of_disability": List<dynamic>.from(typeOfDisability.map((x) => x)),
    "profession": profession,
    "terms_and_conditions": termsAndConditions,
    "membership": membership.toJson(),
    "gender": gender,
    "dob": "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
    "image": image,
    "role": role,
    "service_country": serviceCountry.toJson(),
    "service_state": serviceState.toJson(),
    "service_city": serviceCity.toJson(),
    "service_zip_code": serviceZipCode,
    "is_email_notification": isEmailNotification,
    "is_database_notification": isDatabaseNotification,
    "is_sms_notification": isSmsNotification,
    "working_hours": workingHours,
    "rating": rating,
    "opportunities": opportunities,
    "is_complete": isComplete,
    "is_online": isOnline,
    "uid": uid,
    "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
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
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name,
  };
}

class Membership {
  Membership({
    this.id,
    this.name,
    this.icon,
  });

  int id;
  String name;
  String icon;

  factory Membership.fromJson(Map<String, dynamic> json) => Membership(
    id: json["id"],
    name: json["name"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "icon": icon,
  };
}

class Review {
  Review({
    this.id,
    this.reviewFrom,
    this.reviewTo,
    this.taskId,
    this.remark,
    this.rating,
  });

  int id;
  ReviewFromClass reviewFrom;
  ReviewFromClass reviewTo;
  TaskId taskId;
  String remark;
  String rating;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json["id"],
    reviewFrom: ReviewFromClass.fromJson(json["review_from"]),
    reviewTo: ReviewFromClass.fromJson(json["review_to"]),
    taskId: TaskId.fromJson(json["task_id"]),
    remark: json["remark"],
    rating: json["rating"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "review_from": reviewFrom.toJson(),
    "review_to": reviewTo.toJson(),
    "task_id": taskId.toJson(),
    "remark": remark,
    "rating": rating,
  };
}

class ReviewFromClass {
  ReviewFromClass({
    this.id,
    this.firstName,
    this.image,
    this.phone,
    this.email,
    this.gender,
    this.role,
  });

  int id;
  String firstName;
  String image;
  String phone;
  String email;
  String gender;
  String role;

  factory ReviewFromClass.fromJson(Map<String, dynamic> json) => ReviewFromClass(
    id: json["id"],
    firstName: json["first_name"],
    image: json["image"],
    phone: json["phone"],
    email: json["email"],
    gender: json["gender"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "image": image,
    "phone": phone,
    "email": email,
    "gender": gender,
    "role": role,
  };
}

class TaskId {
  TaskId({
    this.id,
    this.title,
    this.details,
    this.taskType,
    this.date,
    this.startTime,
    this.endTime,
    this.workingHours,
    this.status,
  });

  int id;
  String title;
  String details;
  String taskType;
  DateTime date;
  String startTime;
  String endTime;
  int workingHours;
  String status;

  factory TaskId.fromJson(Map<String, dynamic> json) => TaskId(
    id: json["id"],
    title: json["title"],
    details: json["details"],
    taskType: json["task_type"],
    date: DateTime.parse(json["date"]),
    startTime: json["start_time"],
    endTime: json["end_time"],
    workingHours: json["working_hours"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "details": details,
    "task_type": taskType,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "start_time": startTime,
    "end_time": endTime,
    "working_hours": workingHours,
    "status": status,
  };
}
