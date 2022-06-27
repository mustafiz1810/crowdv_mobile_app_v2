// To parse this JSON data, do
//
//     final postOffice = postOfficeFromJson(jsonString);

import 'dart:convert';

PostOffice postOfficeFromJson(String str) => PostOffice.fromJson(json.decode(str));

String postOfficeToJson(PostOffice data) => json.encode(data.toJson());

class PostOffice {
  PostOffice({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<List<Datum>> data;

  factory PostOffice.fromJson(Map<String, dynamic> json) => PostOffice(
    success: json["success"],
    message: json["message"],
    data: List<List<Datum>>.from(json["data"].map((x) => List<Datum>.from(x.map((x) => Datum.fromJson(x))))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
  };
}

class Datum {
  Datum({
    this.id,
    this.name,
    this.countryId,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  int countryId;
  dynamic createdAt;
  dynamic updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    countryId: json["country_id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "country_id": countryId,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
