// To parse this JSON data, do
//
//     final updateSettingResponseModel = updateSettingResponseModelFromJson(jsonString);

import 'dart:convert';

UpdateSettingResponseModel updateSettingResponseModelFromJson(String str) => UpdateSettingResponseModel.fromJson(json.decode(str));

String updateSettingResponseModelToJson(UpdateSettingResponseModel data) => json.encode(data.toJson());

class UpdateSettingResponseModel {
  UpdateSettingResponseModel({
    this.success,
    this.statuscode,
    this.message,
    this.responseData,
  });

  bool success;
  int statuscode;
  String message;
  ResponseData responseData;

  factory UpdateSettingResponseModel.fromJson(Map<String, dynamic> json) => UpdateSettingResponseModel(
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
  ResponseData();

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
  );

  Map<String, dynamic> toJson() => {
  };
}
