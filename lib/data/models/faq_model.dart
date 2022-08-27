// To parse this JSON data, do
//
//     final faqModel = faqModelFromJson(jsonString);

import 'dart:convert';

FaqModel faqModelFromJson(String str) => FaqModel.fromJson(json.decode(str));

String faqModelToJson(FaqModel data) => json.encode(data.toJson());

class FaqModel {
  FaqModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  Data data;

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
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
    this.volunteer,
    this.recruiter,
  });

  List<Recruiter> volunteer;
  List<Recruiter> recruiter;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    volunteer: List<Recruiter>.from(json["volunteer"].map((x) => Recruiter.fromJson(x))),
    recruiter: List<Recruiter>.from(json["recruiter"].map((x) => Recruiter.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "volunteer": List<dynamic>.from(volunteer.map((x) => x.toJson())),
    "recruiter": List<dynamic>.from(recruiter.map((x) => x.toJson())),
  };
}

class Recruiter {
  Recruiter({
    this.id,
    this.label,
    this.question,
    this.answer,
    this.status,
  });

  int id;
  String label;
  String question;
  String answer;
  int status;

  factory Recruiter.fromJson(Map<String, dynamic> json) => Recruiter(
    id: json["id"],
    label: json["label"],
    question: json["question"],
    answer: json["answer"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "question": question,
    "answer": answer,
    "status": status,
  };
}
