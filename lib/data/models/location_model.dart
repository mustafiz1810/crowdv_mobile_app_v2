// To parse this JSON data, do
//
//     final locationModel = locationModelFromJson(jsonString);

import 'dart:convert';

LocationModel locationModelFromJson(String str) => LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
  LocationModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  Data data;

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
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
    this.serviceCountry,
    this.serviceState,
    this.serviceCity,
    this.serviceZipCode,
    this.category,
  });

  Service serviceCountry;
  Service serviceState;
  Service serviceCity;
  String serviceZipCode;
  List<dynamic> category;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    serviceCountry: Service.fromJson(json["service_country"]),
    serviceState: Service.fromJson(json["service_state"]),
    serviceCity: Service.fromJson(json["service_city"]),
    serviceZipCode: json["service_zip_code"],
    category: List<dynamic>.from(json["category"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "service_country": serviceCountry.toJson(),
    "service_state": serviceState.toJson(),
    "service_city": serviceCity.toJson(),
    "service_zip_code": serviceZipCode,
    "category": List<dynamic>.from(category.map((x) => x)),
  };
}

class Service {
  Service({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
