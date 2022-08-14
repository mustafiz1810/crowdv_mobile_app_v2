// To parse this JSON data, do
//
//     final disabilityModel = disabilityModelFromJson(jsonString);

import 'dart:convert';

DisabilityModel disabilityModelFromJson(String str) => DisabilityModel.fromJson(json.decode(str));

String disabilityModelToJson(DisabilityModel data) => json.encode(data.toJson());

class DisabilityModel {
  DisabilityModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum> data;

  factory DisabilityModel.fromJson(Map<String, dynamic> json) => DisabilityModel(
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
    this.order,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String title;
  dynamic order;
  String status;
  dynamic createdAt;
  dynamic updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    order: json["order"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "order": order,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
