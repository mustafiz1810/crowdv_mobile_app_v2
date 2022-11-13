// To parse this JSON data, do
//
//     final orgProfileModel = orgProfileModelFromJson(jsonString);

import 'dart:convert';

OrgProfileModel orgProfileModelFromJson(String str) => OrgProfileModel.fromJson(json.decode(str));

String orgProfileModelToJson(OrgProfileModel data) => json.encode(data.toJson());

class OrgProfileModel {
  OrgProfileModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  Data data;

  factory OrgProfileModel.fromJson(Map<String, dynamic> json) => OrgProfileModel(
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
    this.name,
    this.email,
    this.phone,
    this.country,
    this.state,
    this.city,
    this.zipCode,
    this.logo,
    this.facebook,
    this.website,
    this.linkedin,
    this.status,
  });

  int id;
  String name;
  String email;
  String phone;
  String country;
  String state;
  String city;
  dynamic zipCode;
  String logo;
  dynamic facebook;
  dynamic website;
  dynamic linkedin;
  int status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    zipCode: json["zip_code"],
    logo: json["logo"],
    facebook: json["facebook"],
    website: json["website"],
    linkedin: json["linkedin"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "country": country,
    "state": state,
    "city": city,
    "zip_code": zipCode,
    "logo": logo,
    "facebook": facebook,
    "website": website,
    "linkedin": linkedin,
    "status": status,
  };
}
