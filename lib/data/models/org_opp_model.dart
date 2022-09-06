// To parse this JSON data, do
//
//     final orgModel = orgModelFromJson(jsonString);

import 'dart:convert';

OrgModel orgModelFromJson(String str) => OrgModel.fromJson(json.decode(str));

String orgModelToJson(OrgModel data) => json.encode(data.toJson());

class OrgModel {
  OrgModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum> data;

  factory OrgModel.fromJson(Map<String, dynamic> json) => OrgModel(
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
    this.links,
    this.description,
    this.banner,
    this.status,
    this.organization,
  });

  int id;
  String title;
  String links;
  String description;
  String banner;
  int status;
  Organization organization;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    links: json["links"],
    description: json["description"],
    banner: json["banner"],
    status: json["status"],
    organization: Organization.fromJson(json["organization"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "links": links,
    "description": description,
    "banner": banner,
    "status": status,
    "organization": organization.toJson(),
  };
}

class Organization {
  Organization({
    this.id,
    this.logo,
    this.name,
    this.email,
    this.phone,
    this.state,
    this.city,
    this.building,
    this.streetAddress,
    this.zipCode,
    this.website,
    this.facebook,
    this.linkedin,
    this.twitter,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  dynamic logo;
  String name;
  String email;
  String phone;
  String state;
  String city;
  dynamic building;
  dynamic streetAddress;
  String zipCode;
  String website;
  String facebook;
  String linkedin;
  dynamic twitter;
  int status;
  dynamic deletedAt;
  DateTime createdAt;
  DateTime updatedAt;

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
    id: json["id"],
    logo: json["logo"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    state: json["state"],
    city: json["city"],
    building: json["building"],
    streetAddress: json["street_address"],
    zipCode: json["zip_code"],
    website: json["website"],
    facebook: json["facebook"],
    linkedin: json["linkedin"],
    twitter: json["twitter"],
    status: json["status"],
    deletedAt: json["deleted_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "logo": logo,
    "name": name,
    "email": email,
    "phone": phone,
    "state": state,
    "city": city,
    "building": building,
    "street_address": streetAddress,
    "zip_code": zipCode,
    "website": website,
    "facebook": facebook,
    "linkedin": linkedin,
    "twitter": twitter,
    "status": status,
    "deleted_at": deletedAt,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
