// To parse this JSON data, do
//
//     final examModel = examModelFromJson(jsonString);

import 'dart:convert';

ExamModel examModelFromJson(String str) => ExamModel.fromJson(json.decode(str));

String examModelToJson(ExamModel data) => json.encode(data.toJson());

class ExamModel {
  ExamModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  Data data;

  factory ExamModel.fromJson(Map<String, dynamic> json) => ExamModel(
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
    this.testId,
    this.testTitle,
    this.testDetails,
    this.testPassingMark,
    this.testTotalScore,
    this.testStatus,
    this.questions,
  });

  int testId;
  String testTitle;
  String testDetails;
  int testPassingMark;
  int testTotalScore;
  String testStatus;
  List<Question> questions;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    testId: json["test_id"],
    testTitle: json["test_title"],
    testDetails: json["test_details"],
    testPassingMark: json["test_passing_mark"],
    testTotalScore: json["test_total_score"],
    testStatus: json["test_status"],
    questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "test_id": testId,
    "test_title": testTitle,
    "test_details": testDetails,
    "test_passing_mark": testPassingMark,
    "test_total_score": testTotalScore,
    "test_status": testStatus,
    "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
  };
}

class Question {
  Question({
    this.id,
    this.testId,
    this.question,
    this.status,
    this.value,
    this.createdAt,
    this.updatedAt,
    this.options,
  });

  int id;
  int testId;
  String question;
  int status;
  dynamic value;
  DateTime createdAt;
  DateTime updatedAt;
  List<Option> options;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: json["id"],
    testId: json["test_id"],
    question: json["question"],
    status: json["status"],
    value: json["value"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    options: List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "test_id": testId,
    "question": question,
    "status": status,
    "value": value,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "options": List<dynamic>.from(options.map((x) => x.toJson())),
  };
}

class Option {
  Option({
    this.id,
    this.questionId,
    this.correctAnswer,
    this.optionName,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int questionId;
  int correctAnswer;
  String optionName;
  DateTime createdAt;
  DateTime updatedAt;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    id: json["id"],
    questionId: json["question_id"],
    correctAnswer: json["correct_answer"],
    optionName: json["option_name"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question_id": questionId,
    "correct_answer": correctAnswer,
    "option_name": optionName,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
