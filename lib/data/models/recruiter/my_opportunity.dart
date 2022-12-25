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
    this.charge,
    this.type,
    this.expiredAt,
    this.taskType,
    this.status,
    this.country,
    this.state,
    this.city,
    this.category,
    this.volunteer,
    this.recruiter,
  });

  int id;
  String title;
  String details;
  int charge;
  String type;
  String expiredAt;
  String taskType;
  String status;
  City country;
  City state;
  City city;
  Category category;
  Recruiter volunteer;
  Recruiter recruiter;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        details: json["details"],
        charge: json["charge"],
        type: json["type"],
        expiredAt: json["expired_at"],
        taskType: json["task_type"],
        status: json["status"],
        country: City.fromJson(json["country"]),
        state: City.fromJson(json["state"]),
        city: City.fromJson(json["city"]),
        category: Category.fromJson(json["category"]),
        volunteer: Recruiter.fromJson(json["volunteer"]),
        recruiter: Recruiter.fromJson(json["recruiter"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "details": details,
        "charge": charge,
        "type": type,
        "expired_at": expiredAt,
        "task_type": taskType,
        "status": status,
        "country": country.toJson(),
        "state": state.toJson(),
        "city": city.toJson(),
        "category": category.toJson(),
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

class Recruiter {
  Recruiter({
    this.id,
    this.firstName,
    this.lastName,
    this.image,
    this.profileRating,
    this.rating,
    this.review,
    this.uid,
    this.isOnline,
  });

  int id;
  String firstName;
  String lastName;
  String image;
  int profileRating;
  int rating;
  dynamic review;
  String uid;
  bool isOnline;

  factory Recruiter.fromJson(Map<String, dynamic> json) => Recruiter(
        id: json["id"] == null ? null : json["id"],
        firstName: json["first_name"] == null ? null : json["first_name"],
        lastName: json["last_name"] == null ? null : json["last_name"],
        image: json["image"] == null ? null : json["image"],
        profileRating:
            json["profile_rating"] == null ? null : json["profile_rating"],
        rating: json["rating"],
        review: json["review"],
        uid: json["uid"] == null ? null : json["uid"],
        isOnline: json["is_online"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "first_name": firstName == null ? null : firstName,
        "last_name": lastName == null ? null : lastName,
        "image": image == null ? null : image,
        "profile_rating": profileRating == null ? null : profileRating,
        "rating": rating,
        "review": review,
        "uid": uid == null ? null : uid,
        "is_online": isOnline,
      };
}
