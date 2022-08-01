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
    this.serviceCity,
    this.serviceState,
    this.serviceZipCode,
  });

  int id;
  dynamic token;
  String firstName;
  String lastName;
  String email;
  String phone;
  String state;
  String city;
  String zipCode;
  dynamic typeOfDisability;
  dynamic profession;
  bool termsAndConditions;
  Membership membership;
  String gender;
  DateTime dob;
  String image;
  String role;
  dynamic serviceCity;
  dynamic serviceState;
  dynamic serviceZipCode;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    token: json["token"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    phone: json["phone"],
    state: json["state"],
    city: json["city"],
    zipCode: json["zip_code"],
    typeOfDisability: json["type_of_disability"],
    profession: json["profession"],
    termsAndConditions: json["terms_and_conditions"],
    membership: Membership.fromJson(json["membership"]),
    gender: json["gender"],
    dob: DateTime.parse(json["dob"]),
    image: json["image"],
    role: json["role"],
    serviceCity: json["service_city"],
    serviceState: json["service_state"],
    serviceZipCode: json["service_zip_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "token": token,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "phone": phone,
    "state": state,
    "city": city,
    "zip_code": zipCode,
    "type_of_disability": typeOfDisability,
    "profession": profession,
    "terms_and_conditions": termsAndConditions,
    "membership": membership.toJson(),
    "gender": gender,
    "dob": "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}",
    "image": image,
    "role": role,
    "service_city": serviceCity,
    "service_state": serviceState,
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