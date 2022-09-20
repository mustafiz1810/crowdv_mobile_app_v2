// To parse this JSON data, do
//
//     final testModel = testModelFromJson(jsonString);

import 'dart:convert';

TestModel testModelFromJson(String str) => TestModel.fromJson(json.decode(str));

String testModelToJson(TestModel data) => json.encode(data.toJson());

class TestModel {
  TestModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  Data data;

  factory TestModel.fromJson(Map<String, dynamic> json) => TestModel(
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
    this.trainingId,
    this.trainingTitle,
    this.trainingDescription,
    this.trainingStatus,
    this.tests,
  });

  int trainingId;
  String trainingTitle;
  String trainingDescription;
  String trainingStatus;
  List<Test> tests;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    trainingId: json["training_id"],
    trainingTitle: json["training_title"],
    trainingDescription: json["training_description"],
    trainingStatus: json["training_status"],
    tests: List<Test>.from(json["tests"].map((x) => Test.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "training_id": trainingId,
    "training_title": trainingTitle,
    "training_description": trainingDescription,
    "training_status": trainingStatus,
    "tests": List<dynamic>.from(tests.map((x) => x.toJson())),
  };
}

class Test {
  Test({
    this.id,
    this.trainingId,
    this.title,
    this.details,
    this.totalScore,
    this.passingMark,
    this.status,
    this.userTest,
  });

  int id;
  int trainingId;
  String title;
  String details;
  int totalScore;
  int passingMark;
  int status;
  dynamic userTest;

  factory Test.fromJson(Map<String, dynamic> json) => Test(
    id: json["id"],
    trainingId: json["training_id"],
    title: json["title"],
    details: json["details"],
    totalScore: json["total_score"],
    passingMark: json["passing_mark"],
    status: json["status"],
    userTest: json["userTest"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "training_id": trainingId,
    "title": title,
    "details": details,
    "total_score": totalScore,
    "passing_mark": passingMark,
    "status": status,
    "userTest": userTest,
  };
}
