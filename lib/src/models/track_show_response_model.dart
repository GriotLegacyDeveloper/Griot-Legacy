// To parse this JSON data, do
//
//     final trackUsageResponseModel = trackUsageResponseModelFromJson(jsonString);

import 'dart:convert';

TrackUsageResponseModel trackUsageResponseModelFromJson(String str) => TrackUsageResponseModel.fromJson(json.decode(str));

String trackUsageResponseModelToJson(TrackUsageResponseModel data) => json.encode(data.toJson());

class TrackUsageResponseModel {
  TrackUsageResponseModel({
    this.success,
    this.message,
    this.responseData,
  });

  bool success;
  String message;
  ResponseData responseData;

  factory TrackUsageResponseModel.fromJson(Map<String, dynamic> json) => TrackUsageResponseModel(
    success: json["success"],
    message: json["message"],
    responseData: ResponseData.fromJson(json["response_data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "response_data": responseData.toJson(),
  };
}

class ResponseData {
  ResponseData({
    this.responseDataIn,
    this.out,
    this.countryCode,
    this.phone,
    this.id,
    this.name,
    this.email,
    this.customerId,
    this.date,
    this.appUsage,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String responseDataIn;
  String out;
  String countryCode;
  int phone;
  String id;
  String name;
  String email;
  String customerId;
  String date;
  String appUsage;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    responseDataIn: json["IN"],
    out: json["OUT"],
    countryCode: json["countryCode"],
    phone: json["phone"],
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    customerId: json["customerId"],
    date: json["date"],
    appUsage: "${json["appUsage"].toString()}",
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "IN": responseDataIn,
    "OUT": out,
    "countryCode": countryCode,
    "phone": phone,
    "_id": id,
    "name": name,
    "email": email,
    "customerId": customerId,
    "date": date,
    "appUsage": appUsage,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
