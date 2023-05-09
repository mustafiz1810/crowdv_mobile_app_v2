// To parse this JSON data, do
//
//     final faqModel = faqModelFromJson(jsonString);

import 'dart:convert';

FaqModel faqModelFromJson(String str) => FaqModel.fromJson(json.decode(str));

String faqModelToJson(FaqModel data) => json.encode(data.toJson());

class FaqModel {
  bool success;
  String message;
  Data data;

  FaqModel({
    this.success,
    this.message,
    this.data,
  });

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
  List<GeneralQuestion> signupAndLogin;
  List<GeneralQuestion> generalQuestions;
  List<GeneralQuestion> testAndTraining;
  List<GeneralQuestion> membershipBenefitsAndCertificates;

  Data({
    this.signupAndLogin,
    this.generalQuestions,
    this.testAndTraining,
    this.membershipBenefitsAndCertificates,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    signupAndLogin: List<GeneralQuestion>.from(json["signup-and-login"].map((x) => GeneralQuestion.fromJson(x))),
    generalQuestions: List<GeneralQuestion>.from(json["general-questions"].map((x) => GeneralQuestion.fromJson(x))),
    testAndTraining: List<GeneralQuestion>.from(json["test-and-training"].map((x) => GeneralQuestion.fromJson(x))),
    membershipBenefitsAndCertificates: List<GeneralQuestion>.from(json["membership-benefits-and-certificates"].map((x) => GeneralQuestion.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "signup-and-login": List<dynamic>.from(signupAndLogin.map((x) => x.toJson())),
    "general-questions": List<dynamic>.from(generalQuestions.map((x) => x.toJson())),
    "test-and-training": List<dynamic>.from(testAndTraining.map((x) => x.toJson())),
    "membership-benefits-and-certificates": List<dynamic>.from(membershipBenefitsAndCertificates.map((x) => x.toJson())),
  };
}

class GeneralQuestion {
  int id;
  String slug;
  String label;
  String question;
  String answer;
  int status;

  GeneralQuestion({
    this.id,
    this.slug,
    this.label,
    this.question,
    this.answer,
    this.status,
  });

  factory GeneralQuestion.fromJson(Map<String, dynamic> json) => GeneralQuestion(
    id: json["id"],
    slug: json["slug"],
    label: json["label"],
    question: json["question"],
    answer: json["answer"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "slug": slug,
    "label": label,
    "question": question,
    "answer": answer,
    "status": status,
  };
}
