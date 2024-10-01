// To parse this JSON data, do
//
//     final oneToOneMessageListResponseModel = oneToOneMessageListResponseModelFromJson(jsonString);

import 'dart:convert';

OneToOneMessageListResponseModel oneToOneMessageListResponseModelFromJson(String str) => OneToOneMessageListResponseModel.fromJson(json.decode(str));

String oneToOneMessageListResponseModelToJson(OneToOneMessageListResponseModel data) => json.encode(data.toJson());

class OneToOneMessageListResponseModel {
  OneToOneMessageListResponseModel({
    this.success,
    this.statuscode,
    this.message,
    this.responseData,
  });

  bool success;
  int statuscode;
  String message;
  ResponseData responseData;

  factory OneToOneMessageListResponseModel.fromJson(Map<String, dynamic> json) => OneToOneMessageListResponseModel(
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

  List<MessageList> message;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    message: List<MessageList>.from(json["message"].map((x) => MessageList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": List<dynamic>.from(message.map((x) => x.toJson())),
  };
}

class MessageList {
  MessageList({
    this.fromIsRead,
    this.toIsRead,
    this.id,
    this.fromUserId,
    this.toUserId,
    this.message,
    this.combinationName,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.quoteMsgID,
    this.quoteMsg,
  });

  String fromIsRead;
  String quoteMsgID;
  String quoteMsg;
  String toIsRead;
  String id;
  FromUserIdClass fromUserId;
  ToUserIdClass toUserId;
  String message;
  String combinationName;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory MessageList.fromJson(Map<String, dynamic> json) => MessageList(
    fromIsRead: json["fromIsRead"],
    toIsRead: json["toIsRead"],
    quoteMsgID: json["quoteMsgID"],
    quoteMsg: json["quoteMsg"],
    id: json["_id"],
    fromUserId: FromUserIdClass.fromJson(json["fromUserId"]),
    toUserId: ToUserIdClass.fromJson(json["toUserId"]),
    message: json["message"],
    combinationName: json["combinationName"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "fromIsRead": fromIsRead,
    "toIsRead": toIsRead,
    "quoteMsgID": quoteMsgID,
    "quoteMsg": quoteMsg,
    "_id": id,
    "fromUserId": fromUserId.toJson(),
    "toUserId": toUserId.toJson(),
    "message": message,
    "combinationName": combinationName,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}

class FromUserIdClass {
  FromUserIdClass({
    this.email,
    this.countryCode,
    this.phone,
    this.profileImage,
    this.gender,
    this.relationship,
    this.verificationOtp,
    this.fpOtp,
    this.badgeCount,
    this.profile,
    this.notification,
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
  String profile;
  String notification;
  String id;
  String fullName;
  String password;
  String status;
  String userLoginType;
  DateTime dateOfBirth;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory FromUserIdClass.fromJson(Map<String, dynamic> json) => FromUserIdClass(
    email: json["email"],
    countryCode: json["countryCode"],
    phone: json["phone"],
    profileImage: json["profileImage"],
    gender: json["gender"],
    relationship: json["relationship"],
    verificationOtp: json["verificationOTP"],
    fpOtp: json["fpOTP"],
    badgeCount: json["badgeCount"],
    profile: json["profile"],
    notification: json["notification"],
    id: json["_id"],
    fullName: json["fullName"],
    password: json["password"],
    status:json["status"],
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
    "profile":profile,
    "notification": notification,
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



class ToUserIdClass {
  ToUserIdClass({
    this.email,
    this.countryCode,
    this.phone,
    this.profileImage,
    this.gender,
    this.relationship,
    this.verificationOtp,
    this.fpOtp,
    this.badgeCount,
    this.profile,
    this.notification,
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
  String profile;
  String notification;
  String id;
  String fullName;
  String password;
  String status;
  String userLoginType;
  DateTime dateOfBirth;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory ToUserIdClass.fromJson(Map<String, dynamic> json) => ToUserIdClass(
    email: json["email"],
    countryCode: json["countryCode"],
    phone: json["phone"],
    profileImage: json["profileImage"],
    gender: json["gender"],
    relationship: json["relationship"],
    verificationOtp: json["verificationOTP"],
    fpOtp: json["fpOTP"],
    badgeCount: json["badgeCount"],
    profile: json["profile"],
    notification: json["notification"],
    id: json["_id"],
    fullName: json["fullName"],
    password: json["password"],
    status:json["status"],
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
    "profile":profile,
    "notification": notification,
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


