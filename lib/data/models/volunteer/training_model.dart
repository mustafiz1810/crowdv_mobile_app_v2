// To parse this JSON data, do
//
//     final trainingModel = trainingModelFromJson(jsonString);

import 'dart:convert';

TrainingModel trainingModelFromJson(String str) => TrainingModel.fromJson(json.decode(str));

String trainingModelToJson(TrainingModel data) => json.encode(data.toJson());

class TrainingModel {
  TrainingModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum> data;

  factory TrainingModel.fromJson(Map<String, dynamic> json) => TrainingModel(
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
    this.trainingId,
    this.trainingTitle,
    this.trainingDescription,
    this.trainingStatus,
  });

  int trainingId;
  String trainingTitle;
  String trainingDescription;
  String trainingStatus;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    trainingId: json["training_id"],
    trainingTitle: json["training_title"],
    trainingDescription: json["training_description"],
    trainingStatus: json["training_status"],
  );

  Map<String, dynamic> toJson() => {
    "training_id": trainingId,
    "training_title": trainingTitle,
    "training_description": trainingDescription,
    "training_status": trainingStatus,
  };
}
