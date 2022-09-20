// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

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
    this.id,
    this.token,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
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
  });

  int id;
  dynamic token;
  String firstName;
  String lastName;
  String email;
  String phone;
  City country;
  City state;
  City city;
  String zipCode;
  List<String> typeOfDisability;
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
  String serviceZipCode;
  bool isEmailNotification;
  bool isDatabaseNotification;
  bool isSmsNotification;
  int workingHours;
  int rating;
  int opportunities;
  int isComplete;
  bool isOnline;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    token: json["token"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    phone: json["phone"],
    country: City.fromJson(json["country"]),
    state: City.fromJson(json["state"]),
    city: City.fromJson(json["city"]),
    zipCode: json["zip_code"],
    typeOfDisability: List<String>.from(json["type_of_disability"].map((x) => x)),
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
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "token": token,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "phone": phone,
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
