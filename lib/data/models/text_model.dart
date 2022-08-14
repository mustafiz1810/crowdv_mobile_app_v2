// To parse this JSON data, do
//
//     final textModel = textModelFromJson(jsonString);

import 'dart:convert';

TextModel textModelFromJson(String str) => TextModel.fromJson(json.decode(str));

String textModelToJson(TextModel data) => json.encode(data.toJson());

class TextModel {
  TextModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  Data data;

  factory TextModel.fromJson(Map<String, dynamic> json) => TextModel(
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
    this.logo,
    this.companyName,
    this.address,
    this.email,
    this.phoneNumber,
    this.googleLocation,
    this.webAddress,
    this.facebook,
    this.twitter,
    this.instagram,
    this.youtube,
    this.tagLine,
    this.aboutUs,
    this.termsAndConditions,
  });

  int id;
  String logo;
  String companyName;
  String address;
  String email;
  String phoneNumber;
  dynamic googleLocation;
  String webAddress;
  String facebook;
  String twitter;
  String instagram;
  String youtube;
  String tagLine;
  String aboutUs;
  String termsAndConditions;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    logo: json["logo"],
    companyName: json["company_name"],
    address: json["address"],
    email: json["email"],
    phoneNumber: json["phone_number"],
    googleLocation: json["google_location"],
    webAddress: json["web_address"],
    facebook: json["facebook"],
    twitter: json["twitter"],
    instagram: json["instagram"],
    youtube: json["youtube"],
    tagLine: json["tag_line"],
    aboutUs: json["about_us"],
    termsAndConditions: json["terms_and_conditions"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "logo": logo,
    "company_name": companyName,
    "address": address,
    "email": email,
    "phone_number": phoneNumber,
    "google_location": googleLocation,
    "web_address": webAddress,
    "facebook": facebook,
    "twitter": twitter,
    "instagram": instagram,
    "youtube": youtube,
    "tag_line": tagLine,
    "about_us": aboutUs,
    "terms_and_conditions": termsAndConditions,
  };
}
