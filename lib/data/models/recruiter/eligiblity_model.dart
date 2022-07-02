// To parse this JSON data, do
//
//     final eligibilityModel = eligibilityModelFromJson(jsonString);

import 'dart:convert';

EligibilityModel eligibilityModelFromJson(String str) => EligibilityModel.fromJson(json.decode(str));

String eligibilityModelToJson(EligibilityModel data) => json.encode(data.toJson());

class EligibilityModel {
  EligibilityModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum> data;

  factory EligibilityModel.fromJson(Map<String, dynamic> json) => EligibilityModel(
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
    this.status,
    this.category,
  });

  int id;
  String title;
  String details;
  int status;
  Category category;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    details: json["details"],
    status: json["status"],
    category: Category.fromJson(json["category"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "details": details,
    "status": status,
    "category": category.toJson(),
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
