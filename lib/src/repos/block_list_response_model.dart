// To parse this JSON data, do
//
//     final blockListResponseModel = blockListResponseModelFromJson(jsonString);

import 'dart:convert';

BlockListResponseModel blockListResponseModelFromJson(String str) => BlockListResponseModel.fromJson(json.decode(str));

String blockListResponseModelToJson(BlockListResponseModel data) => json.encode(data.toJson());

class BlockListResponseModel {
  BlockListResponseModel({
    this.success,
    this.statuscode,
    this.message,
    this.responseData,
  });

  bool success;
  int statuscode;
  String message;
  ResponseData responseData;

  factory BlockListResponseModel.fromJson(Map<String, dynamic> json) => BlockListResponseModel(
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
    this.data,
    this.userImageUrl,
  });

  List<BlockListData> data;
  String userImageUrl;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    data: json["data"]==null ?"":List<BlockListData>.from(json["data"].map((x) => BlockListData.fromJson(x))),
    userImageUrl: json["userImageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "userImageUrl": userImageUrl,
  };
}

class BlockListData {
  BlockListData({
    this.email,
    this.countryCode,
    this.phone,
    this.profileImage,
    this.gender,
    this.relationship,
    this.verificationOtp,
    this.fpOtp,
    this.badgeCount,
    this.id,
    this.fullName,
    this.password,
    this.status,
    this.userLoginType,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String email;
  String countryCode;
  int phone;
  String profileImage;
  String gender;
  String relationship;
  String verificationOtp;
  String fpOtp;
  int badgeCount;
  String id;
  String fullName;
  String password;
  String status;
  String userLoginType;
  DateTime dateOfBirth;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory BlockListData.fromJson(Map<String, dynamic> json) => BlockListData(
    email: json["email"],
    countryCode: json["countryCode"],
    phone: json["phone"],
    profileImage: json["profileImage"],
    gender: json["gender"],
    relationship: json["relationship"],
    verificationOtp: json["verificationOTP"],
    fpOtp: json["fpOTP"],
    badgeCount: json["badgeCount"],
    id: json["_id"],
    fullName: json["fullName"],
    password: json["password"],
    status: json["status"],
    userLoginType: json["userLoginType"],
    dateOfBirth: DateTime.parse(json["dateOfBirth"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "countryCode": countryCode,
    "phone": phone,
    "profileImage": profileImage,
    "gender": gender,
    "relationship": relationship,
    "verificationOTP": verificationOtp,
    "fpOTP": fpOtp,
    "badgeCount": badgeCount,
    "_id": id,
    "fullName": fullName,
    "password": password,
    "status": status,
    "userLoginType": userLoginType,
    "dateOfBirth": dateOfBirth.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}
