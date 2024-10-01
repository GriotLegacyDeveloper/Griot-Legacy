import 'dart:convert';

ApplePayResponseModel applePayResponseModelFromJson(String str) => ApplePayResponseModel.fromJson(json.decode(str));
String applePayResponseModelToJson(ApplePayResponseModel data) => json.encode(data.toJson());

class ApplePayResponseModel {
  bool success;
  int statuscode;
  String message;
  ResponseCode responseCode;

  ApplePayResponseModel({
     this.success,
     this.statuscode,
     this.message,
     this.responseCode,
  });

  factory ApplePayResponseModel.fromJson(Map<String, dynamic> json) => ApplePayResponseModel(
    success: json["success"],
    statuscode: json["STATUSCODE"],
    message: json["message"],
    responseCode: ResponseCode.fromJson(json["response_code"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "STATUSCODE": statuscode,
    "message": message,
    "response_code": responseCode.toJson(),
  };
}

class ResponseCode {
  ResponseCode();

  factory ResponseCode.fromJson(Map<String, dynamic> json) => ResponseCode(
  );

  Map<String, dynamic> toJson() => {
  };
}
