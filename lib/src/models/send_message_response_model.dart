// To parse this JSON data, do
//
//     final sendMessageResponseModel = sendMessageResponseModelFromJson(jsonString);

import 'dart:convert';

SendMessageResponseModel sendMessageResponseModelFromJson(String str) => SendMessageResponseModel.fromJson(json.decode(str));

String sendMessageResponseModelToJson(SendMessageResponseModel data) => json.encode(data.toJson());

class SendMessageResponseModel {
  SendMessageResponseModel({
    this.success,
    this.statuscode,
    this.message,
    this.responseData,
  });

  bool success;
  int statuscode;
  String message;
  ResponseData responseData;

  factory SendMessageResponseModel.fromJson(Map<String, dynamic> json) => SendMessageResponseModel(
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
