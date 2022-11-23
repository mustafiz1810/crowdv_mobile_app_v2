// To parse this JSON data, do
//
//     final organizationOpDetails = organizationOpDetailsFromJson(jsonString);

import 'dart:convert';

OrganizationOpDetails organizationOpDetailsFromJson(String str) => OrganizationOpDetails.fromJson(json.decode(str));

String organizationOpDetailsToJson(OrganizationOpDetails data) => json.encode(data.toJson());

class OrganizationOpDetails {
  OrganizationOpDetails({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  Data data;

  factory OrganizationOpDetails.fromJson(Map<String, dynamic> json) => OrganizationOpDetails(
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
    this.countryId,
    this.stateId,
    this.cityId,
  });

  int id;
  String logo;
  String name;
  String email;
  String phone;
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
  int countryId;
  int stateId;
  int cityId;

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
    id: json["id"],
    logo: json["logo"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
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
    countryId: json["country_id"],
    stateId: json["state_id"],
    cityId: json["city_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "logo": logo,
    "name": name,
    "email": email,
    "phone": phone,
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
    "country_id": countryId,
    "state_id": stateId,
    "city_id": cityId,
  };
}
