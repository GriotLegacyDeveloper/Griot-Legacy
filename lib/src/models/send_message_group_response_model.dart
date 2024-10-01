// To parse this JSON data, do
//
//     final sendMessageGroupResponseModel = sendMessageGroupResponseModelFromJson(jsonString);

import 'dart:convert';

SendMessageGroupResponseModel sendMessageGroupResponseModelFromJson(String str) => SendMessageGroupResponseModel.fromJson(json.decode(str));

String sendMessageGroupResponseModelToJson(SendMessageGroupResponseModel data) => json.encode(data.toJson());

class SendMessageGroupResponseModel {
  SendMessageGroupResponseModel({
    this.success,
    this.statuscode,
    this.message,
    this.responseData,
  });

  bool success;
  int statuscode;
  String message;
  ResponseData responseData;

  factory SendMessageGroupResponseModel.fromJson(Map<String, dynamic> json) => SendMessageGroupResponseModel(
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
    this.message,
  });

  String message;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
