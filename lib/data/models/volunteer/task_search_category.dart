// To parse this JSON data, do
//
//     final categorywiseTask = categorywiseTaskFromJson(jsonString);

import 'dart:convert';

CategorywiseTask categorywiseTaskFromJson(String str) => CategorywiseTask.fromJson(json.decode(str));

String categorywiseTaskToJson(CategorywiseTask data) => json.encode(data.toJson());

class CategorywiseTask {
  CategorywiseTask({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  List<Datum> data;

  factory CategorywiseTask.fromJson(Map<String, dynamic> json) => CategorywiseTask(
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
    this.title,
    this.details,
    this.state,
    this.city,
    this.zipCode,
    this.taskType,
    this.date,
    this.datumStartTime,
    this.startTime,
    this.datumEndTime,
    this.endTime,
    this.workingHours,
    this.benefits,
    this.isPublic,
    this.status,
    this.applyStatus,
    this.category,
    this.eligibility,
    this.volunteer,
    this.recruiter,
  });

  int id;
  String title;
  String details;
  String state;
  String city;
  String zipCode;
  TaskType taskType;
  DateTime date;
  String datumStartTime;
  DateTime startTime;
  String datumEndTime;
  DateTime endTime;
  int workingHours;
  dynamic benefits;
  bool isPublic;
  Status status;
  int applyStatus;
  Category category;
  List<Eligibility> eligibility;
  Recruiter volunteer;
  Recruiter recruiter;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    details: json["details"],
    state: json["state"],
    city: json["city"],
    zipCode: json["zip_code"],
    taskType: taskTypeValues.map[json["task_type"]],
    date: DateTime.parse(json["date"]),
    datumStartTime: json["start_time"],
    startTime: DateTime.parse(json["startTime"]),
    datumEndTime: json["end_time"],
    endTime: DateTime.parse(json["endTime"]),
    workingHours: json["working_hours"],
    benefits: json["benefits"],
    isPublic: json["is_public"],
    status: statusValues.map[json["status"]],
    applyStatus: json["apply_status"],
    category: Category.fromJson(json["category"]),
    eligibility: List<Eligibility>.from(json["eligibility"].map((x) => Eligibility.fromJson(x))),
    volunteer: Recruiter.fromJson(json["volunteer"]),
    recruiter: Recruiter.fromJson(json["recruiter"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "details": details,
    "state": state,
    "city": city,
    "zip_code": zipCode,
    "task_type": taskTypeValues.reverse[taskType],
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "start_time": datumStartTime,
    "startTime": startTime.toIso8601String(),
    "end_time": datumEndTime,
    "endTime": endTime.toIso8601String(),
    "working_hours": workingHours,
    "benefits": benefits,
    "is_public": isPublic,
    "status": statusValues.reverse[status],
    "apply_status": applyStatus,
    "category": category.toJson(),
    "eligibility": List<dynamic>.from(eligibility.map((x) => x.toJson())),
    "volunteer": volunteer.toJson(),
    "recruiter": recruiter.toJson(),
  };
}

class Category {
  Category({
    this.id,
    this.name,
    this.slug,
    this.icon,
  });

  int id;
  Name name;
  Slug slug;
  String icon;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: nameValues.map[json["name"]],
    slug: slugValues.map[json["slug"]],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": nameValues.reverse[name],
    "slug": slugValues.reverse[slug],
    "icon": icon,
  };
}

enum Name { FOOD_PREPARING, OTHER }

final nameValues = EnumValues({
  "Food preparing": Name.FOOD_PREPARING,
  "Other": Name.OTHER
});

enum Slug { FOOD_PREPARING, OTHER }

final slugValues = EnumValues({
  "food-preparing": Slug.FOOD_PREPARING,
  "other": Slug.OTHER
});

class Eligibility {
  Eligibility({
    this.id,
    this.categoryId,
    this.title,
    this.details,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.pivot,
  });

  int id;
  int categoryId;
  String title;
  dynamic details;
  int status;
  dynamic createdAt;
  dynamic updatedAt;
  Pivot pivot;

  factory Eligibility.fromJson(Map<String, dynamic> json) => Eligibility(
    id: json["id"],
    categoryId: json["category_id"],
    title: json["title"],
    details: json["details"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    pivot: Pivot.fromJson(json["pivot"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "title": title,
    "details": details,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "pivot": pivot.toJson(),
  };
}

class Pivot {
  Pivot({
    this.opportunityId,
    this.eligibilityId,
  });

  int opportunityId;
  int eligibilityId;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    opportunityId: json["opportunity_id"],
    eligibilityId: json["eligibility_id"],
  );

  Map<String, dynamic> toJson() => {
    "opportunity_id": opportunityId,
    "eligibility_id": eligibilityId,
  };
}

class Recruiter {
  Recruiter({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.image,
    this.typeOfDisability,
    this.state,
    this.city,
    this.zipCode,
    this.role,
    this.profileRating,
    this.rating,
    this.review,
    this.gender,
  });

  int id;
  String firstName;
  String lastName;
  String email;
  String phone;
  String image;
  String typeOfDisability;
  String state;
  String city;
  String zipCode;
  Role role;
  int profileRating;
  int rating;
  String review;
  String gender;

  factory Recruiter.fromJson(Map<String, dynamic> json) => Recruiter(
    id: json["id"] == null ? null : json["id"],
    firstName: json["first_name"] == null ? null : json["first_name"],
    lastName: json["last_name"] == null ? null : json["last_name"],
    email: json["email"] == null ? null : json["email"],
    phone: json["phone"] == null ? null : json["phone"],
    image: json["image"] == null ? null : json["image"],
    typeOfDisability: json["type_of_disability"] == null ? null : json["type_of_disability"],
    state: json["state"] == null ? null : json["state"],
    city: json["city"] == null ? null : json["city"],
    zipCode: json["zip_code"] == null ? null : json["zip_code"],
    role: json["role"] == null ? null : roleValues.map[json["role"]],
    profileRating: json["profile_rating"] == null ? null : json["profile_rating"],
    rating: json["rating"],
    review: json["review"] == null ? null : json["review"],
    gender: json["gender"] == null ? null : json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "first_name": firstName == null ? null : firstName,
    "last_name": lastName == null ? null : lastName,
    "email": email == null ? null : email,
    "phone": phone == null ? null : phone,
    "image": image == null ? null : image,
    "type_of_disability": typeOfDisability == null ? null : typeOfDisability,
    "state": state == null ? null : state,
    "city": city == null ? null : city,
    "zip_code": zipCode == null ? null : zipCode,
    "role": role == null ? null : roleValues.reverse[role],
    "profile_rating": profileRating == null ? null : profileRating,
    "rating": rating,
    "review": review == null ? null : review,
    "gender": gender == null ? null : gender,
  };
}

enum Role { VOLUNTEER, RECRUITER }

final roleValues = EnumValues({
  "recruiter": Role.RECRUITER,
  "volunteer": Role.VOLUNTEER
});

enum Status { PENDING, COMPLETED }

final statusValues = EnumValues({
  "Completed": Status.COMPLETED,
  "Pending": Status.PENDING
});

enum TaskType { OFFLINE, BOTH }

final taskTypeValues = EnumValues({
  "Both": TaskType.BOTH,
  "Offline": TaskType.OFFLINE
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
