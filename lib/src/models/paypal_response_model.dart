// To parse this JSON data, do
//
//     final payPalResponseModel = payPalResponseModelFromJson(jsonString);

import 'dart:convert';

PayPalResponseModel payPalResponseModelFromJson(String str) => PayPalResponseModel.fromJson(json.decode(str));

String payPalResponseModelToJson(PayPalResponseModel data) => json.encode(data.toJson());

class PayPalResponseModel {
  bool success;
  int statuscode;
  String message;
  ResponseData responseData;

  PayPalResponseModel({
     this.success,
     this.statuscode,
     this.message,
     this.responseData,
  });

  factory PayPalResponseModel.fromJson(Map<String, dynamic> json) => PayPalResponseModel(
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
  String link;

  ResponseData({
     this.link,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    link: json["link"],
  );

  Map<String, dynamic> toJson() => {
    "link": link,
  };
}
