// To parse this JSON data, do
//
//     final getAllGroupMessageResponseModel = getAllGroupMessageResponseModelFromJson(jsonString);

import 'dart:convert';

GetAllGroupMessageResponseModel getAllGroupMessageResponseModelFromJson(String str) => GetAllGroupMessageResponseModel.fromJson(json.decode(str));

String getAllGroupMessageResponseModelToJson(GetAllGroupMessageResponseModel data) => json.encode(data.toJson());

class GetAllGroupMessageResponseModel {
  GetAllGroupMessageResponseModel({
    this.status,
    this.statuscode,
    this.message,
    this.responseData,
  });

  bool status;
  int statuscode;
  String message;
  ResponseData responseData;

  factory GetAllGroupMessageResponseModel.fromJson(Map<String, dynamic> json) => GetAllGroupMessageResponseModel(
    status: json["status"],
    statuscode: json["STATUSCODE"],
    message: json["message"],
    responseData: ResponseData.fromJson(json["response_data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "STATUSCODE": statuscode,
    "message": message,
    "response_data": responseData.toJson(),
  };
}

class ResponseData {
  ResponseData({
    this.message,
  });

  List<Message> message;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    message: List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": List<dynamic>.from(message.map((x) => x.toJson())),
  };
}

class Message {
  Message({
    this.id,
    this.fullName,
    this.profileImage,
    this.message,
    this.createdAt,
    this.msgId,
    this.quoteMsg,
    this.quoteMsgID,
  });

  String id;
  String fullName;
  String profileImage;
  String message;
  String createdAt;
  String msgId;
  String quoteMsg;
  String quoteMsgID;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["_id"],
    fullName: json["fullName"],
    profileImage: json["profileImage"],
    message: json["message"],
    createdAt: json["createdAt"],
    msgId: json["msgId"],
    quoteMsg: json["quoteMsg"],
    quoteMsgID: json["quoteMsgID"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "fullName": fullName,
    "profileImage": profileImage,
    "message": message,
    "createdAt": createdAt,
    "msgId": msgId,
    "quoteMsg": quoteMsg,
    "quoteMsgID": quoteMsgID,
  };
}
