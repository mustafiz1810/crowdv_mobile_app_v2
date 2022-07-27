// To parse this JSON data, do
//
//     final trainingVideoModel = trainingVideoModelFromJson(jsonString);

import 'dart:convert';

TrainingVideoModel trainingVideoModelFromJson(String str) => TrainingVideoModel.fromJson(json.decode(str));

String trainingVideoModelToJson(TrainingVideoModel data) => json.encode(data.toJson());

class TrainingVideoModel {
  TrainingVideoModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  Data data;

  factory TrainingVideoModel.fromJson(Map<String, dynamic> json) => TrainingVideoModel(
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
    this.details,
    this.video,
  });

  int id;
  String title;
  String details;
  String video;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    title: json["title"],
    details: json["details"],
    video: json["video"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "details": details,
    "video": video,
  };
}
