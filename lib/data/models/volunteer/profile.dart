// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  Data data;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
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
    this.the0,
    this.workingHour,
  });

  The0 the0;
  int workingHour;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        the0: The0.fromJson(json["0"]),
        workingHour: json["working_hour"],
      );

  Map<String, dynamic> toJson() => {
        "0": the0.toJson(),
        "working_hour": workingHour,
      };
}

class The0 {
  The0({
    this.id,
    this.firstName,
    this.lastName,
    this.surName,
    this.email,
    this.phone,
    this.city,
    this.state,
    this.building,
    this.streetAddress,
    this.zipCode,
    this.typeOfDisability,
    this.profession,
    this.type,
    this.institutionName,
    this.membership,
    this.gender,
    this.dob,
    this.image,
    this.role,
    this.serviceCity,
    this.serviceState,
    this.serviceBuilding,
    this.serviceStreetAddress,
    this.serviceZipCode,
  });

  int id;
  String firstName;
  String lastName;
  String surName;
  String email;
  String phone;
  String city;
  String state;
  String building;
  String streetAddress;
  String zipCode;
  dynamic typeOfDisability;
  String profession;
  dynamic type;
  dynamic institutionName;
  Membership membership;
  String gender;
  DateTime dob;
  String image;
  Membership role;
  dynamic serviceCity;
  dynamic serviceState;
  dynamic serviceBuilding;
  dynamic serviceStreetAddress;
  dynamic serviceZipCode;

  factory The0.fromJson(Map<String, dynamic> json) => The0(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        surName: json["sur_name"],
        email: json["email"],
        phone: json["phone"],
        city: json["city"],
        state: json["state"],
        building: json["building"],
        streetAddress: json["street_address"],
        zipCode: json["zip_code"],
        typeOfDisability: json["type_of_disability"],
        profession: json["profession"],
        type: json["type"],
        institutionName: json["institution_name"],
        membership: Membership.fromJson(json["membership"]),
        gender: json["gender"],
        dob: DateTime.parse(json["dob"]),
        image: json["image"],
        role: Membership.fromJson(json["role"]),
        serviceCity: json["service_city"],
        serviceState: json["service_state"],
        serviceBuilding: json["service_building"],
        serviceStreetAddress: json["service_street_address"],
        serviceZipCode: json["service_zip_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "sur_name": surName,
        "email": email,
        "phone": phone,
        "city": city,
        "state": state,
        "building": building,
        "street_address": streetAddress,
        "zip_code": zipCode,
        "type_of_disability": typeOfDisability,
        "profession": profession,
        "type": type,
        "institution_name": institutionName,
        "membership": membership.toJson(),
        "gender": gender,
        "dob": dob.toIso8601String(),
        "image": image,
        "role": role.toJson(),
        "service_city": serviceCity,
        "service_state": serviceState,
        "service_building": serviceBuilding,
        "service_street_address": serviceStreetAddress,
        "service_zip_code": serviceZipCode,
      };
}

class Membership {
  Membership({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Membership.fromJson(Map<String, dynamic> json) => Membership(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
