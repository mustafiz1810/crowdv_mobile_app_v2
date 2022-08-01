// To parse this JSON data, do
//
//     final certificateModel = certificateModelFromJson(jsonString);

import 'dart:convert';

CertificateModel certificateModelFromJson(String str) => CertificateModel.fromJson(json.decode(str));

String certificateModelToJson(CertificateModel data) => json.encode(data.toJson());

class CertificateModel {
  CertificateModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum> data;

  factory CertificateModel.fromJson(Map<String, dynamic> json) => CertificateModel(
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
    this.totalScore,
    this.result,
    this.status,
    this.user,
    this.test,
  });

  int id;
  int totalScore;
  String result;
  String status;
  User user;
  Test test;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    totalScore: json["total_score"],
    result: json["result"],
    status: json["status"],
    user: User.fromJson(json["user"]),
    test: Test.fromJson(json["test"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "total_score": totalScore,
    "result": result,
    "status": status,
    "user": user.toJson(),
    "test": test.toJson(),
  };
}

class Test {
  Test({
    this.id,
    this.title,
    this.status,
  });

  int id;
  String title;
  int status;

  factory Test.fromJson(Map<String, dynamic> json) => Test(
    id: json["id"],
    title: json["title"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "status": status,
  };
}

class User {
  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.gender,
  });

  int id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String gender;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    phone: json["phone"],
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "phone": phone,
    "gender": gender,
  };
}
