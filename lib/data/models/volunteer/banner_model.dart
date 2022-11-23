// To parse this JSON data, do
//
//     final bannerModel = bannerModelFromJson(jsonString);

import 'dart:convert';

BannerModel bannerModelFromJson(String str) =>
    BannerModel.fromJson(json.decode(str));

String bannerModelToJson(BannerModel data) => json.encode(data.toJson());

class BannerModel {
  BannerModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  Data data;

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
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
    this.title,
    this.banner,
  });

  List<String> title;
  List<String> banner;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        title: List<String>.from(json["title"].map((x) => x)),
        banner: List<String>.from(json["banner"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "title": List<dynamic>.from(title.map((x) => x)),
        "banner": List<dynamic>.from(banner.map((x) => x)),
      };
}
