// To parse this JSON data, do
//
//     final getSettingResponseModel = getSettingResponseModelFromJson(jsonString);

import 'dart:convert';

GetSettingResponseModel getSettingResponseModelFromJson(String str) => GetSettingResponseModel.fromJson(json.decode(str));

String getSettingResponseModelToJson(GetSettingResponseModel data) => json.encode(data.toJson());

class GetSettingResponseModel {
  GetSettingResponseModel({
    this.success,
    this.statuscode,
    this.message,
    this.responseData,
  });

  bool success;
  int statuscode;
  String message;
  ResponseData responseData;

  factory GetSettingResponseModel.fromJson(Map<String, dynamic> json) => GetSettingResponseModel(
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
  ResponseData({
    this.profile,
    this.notification,
  });

  String profile;
  String notification;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    profile: json["profile"],
    notification: json["notification"],
  );

  Map<String, dynamic> toJson() => {
    "profile": profile,
    "notification": notification,
  };
}
