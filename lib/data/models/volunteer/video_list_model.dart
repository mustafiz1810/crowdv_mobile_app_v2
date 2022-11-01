// To parse this JSON data, do
//
//     final videoListModel = videoListModelFromJson(jsonString);

import 'dart:convert';

VideoListModel videoListModelFromJson(String str) => VideoListModel.fromJson(json.decode(str));

String videoListModelToJson(VideoListModel data) => json.encode(data.toJson());

class VideoListModel {
  VideoListModel({
    this.success,
    this.message,
    this.data,
  });

  bool success;
  String message;
  Data data;

  factory VideoListModel.fromJson(Map<String, dynamic> json) => VideoListModel(
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
    this.videos,
  });

  int trainingId;
  String trainingTitle;
  String trainingDescription;
  String trainingStatus;
  List<Video> videos;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    trainingId: json["training_id"],
    trainingTitle: json["training_title"],
    trainingDescription: json["training_description"],
    trainingStatus: json["training_status"],
    videos: List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "training_id": trainingId,
    "training_title": trainingTitle,
    "training_description": trainingDescription,
    "training_status": trainingStatus,
    "videos": List<dynamic>.from(videos.map((x) => x.toJson())),
  };
}

class Video {
  Video({
    this.id,
    this.trainingId,
    this.title,
    this.details,
    this.video,
    this.thumbnail,
    this.isWatched,
    this.watchedStatus,
  });

  int id;
  int trainingId;
  String title;
  String details;
  String video;
  String thumbnail;
  bool isWatched;
  String watchedStatus;

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    id: json["id"],
    trainingId: json["training_id"],
    title: json["title"],
    details: json["details"],
    video: json["video"],
    thumbnail: json["thumbnail"],
    isWatched: json["is_watched"],
    watchedStatus: json["watched_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "training_id": trainingId,
    "title": title,
    "details": details,
    "video": video,
    "thumbnail": thumbnail,
    "is_watched": isWatched,
    "watched_status": watchedStatus,
  };
}
