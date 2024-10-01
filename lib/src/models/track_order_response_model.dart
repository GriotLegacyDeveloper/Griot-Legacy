// To parse this JSON data, do
//
//     final trackOrderResponseModel = trackOrderResponseModelFromJson(jsonString);

import 'dart:convert';

TrackOrderResponseModel trackOrderResponseModelFromJson(String str) =>
    TrackOrderResponseModel.fromJson(json.decode(str));

String trackOrderResponseModelToJson(TrackOrderResponseModel data) =>
    json.encode(data.toJson());

class TrackOrderResponseModel {
  bool success;
  int statuscode;
  String message;
  ResponseData responseData;

  TrackOrderResponseModel({
    this.success,
    this.statuscode,
    this.message,
    this.responseData,
  });

  factory TrackOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      TrackOrderResponseModel(
        success: json["success"],
        statuscode: json["STATUSCODE"],
        message: json["message"],
        responseData: ResponseData.fromJson(json["response_data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "STATUSCODE": statuscode,
        "message": message,
        "response_data": responseData.toJson(),
      };
}

class ResponseData {
  String totalStorage;
  String availableStorage;
  String usedStoragePercentage;
  String totalStorageUsed;
  String photoStorageUsed;
  String videoStorageUsed;
  String usedPercentage;
  String videoPercentage;
  String photoPercentage;

  ResponseData({
    this.totalStorage,
    this.availableStorage,
    this.usedStoragePercentage,
    this.totalStorageUsed,
    this.photoStorageUsed,
    this.videoStorageUsed,
    this.usedPercentage,
    this.videoPercentage,
    this.photoPercentage,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
        totalStorage: json["totalStorage"],
        availableStorage: json["availableStorage"],
        usedStoragePercentage: json["usedStoragePercentage"],
        totalStorageUsed: json["totalStorageUsed"],
        photoStorageUsed: json["photoStorageUsed"],
        videoStorageUsed: json["videoStorageUsed"],
        usedPercentage: json["usedPercentage"],
        videoPercentage: json["videoPercentage"],
        photoPercentage: json["photoPercentage"],
      );

  Map<String, dynamic> toJson() => {
        "totalStorage": totalStorage,
        "availableStorage": availableStorage,
        "usedStoragePercentage": usedStoragePercentage,
        "totalStorageUsed": totalStorageUsed,
        "photoStorageUsed": photoStorageUsed,
        "videoStorageUsed": videoStorageUsed,
        "usedPercentage": usedPercentage,
        "videoPercentage": videoPercentage,
        "photoPercentage": photoPercentage,
      };
}
