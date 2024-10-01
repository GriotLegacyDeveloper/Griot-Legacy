// To parse this JSON data, do
//
//     final notificationResponseModel = notificationResponseModelFromJson(jsonString);

import 'dart:convert';

/*NotificationResponseModel notificationResponseModelFromJson(String str) => NotificationResponseModel.fromJson(json.decode(str));

String notificationResponseModelToJson(NotificationResponseModel data) => json.encode(data.toJson());*/

class NotificationResponseModel {
  NotificationResponseModel({
    this.success,
    this.statuscode,
    this.message,
    this.responseData,
  });

  bool success;
  int statuscode;
  String message;
  ResponseData responseData;

 /* factory NotificationResponseModel.fromJson(Map<String, dynamic> json) => NotificationResponseModel(
    success: json["success"],
    statuscode: json["STATUSCODE"],
    message: json["message"],
    responseData: json['response_data'] != null ?ResponseData.fromJson(json["response_data"]) :"",
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "STATUSCODE": statuscode,
    "message": message,
    "response_data": responseData!=null ?responseData.toJson():"",
  };*/

  NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statuscode = json['STATUSCODE'];
    message = json['message'];
    responseData = json['response_data'] != null
        ? NotificationResponseModel.fromJson(json['response_data'])
        : "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['STATUSCODE'] = statuscode;
    data['message'] = message;
    if (responseData != null) {
      data['response_data'] = responseData.toJson();
    }
    return data;
  }
}

class ResponseData {
  ResponseData({
    this.userNot,
  });

  List<UserNot> userNot;

/*  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    userNot: List<dynamic>.from(json["userNot"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "userNot": List<dynamic>.from(userNot.map((x) => x)),
  };*/

  ResponseData.fromJson(Map<String, dynamic> json) {

    if (json['userNot'] != null) {
      userNot =  <UserNot>[];
      json['dashboard'].forEach((v) {
        userNot.add( UserNot.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (userNot != null) {
      data['dashboard'] = userNot.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class UserNot {
  String userId;
  String notificationType;
  String title;
  String message;

  UserNot(this.userId, this.notificationType, this.title, this.message,
      this.otherData, this.sendUserEmail, this.profileImage);

  String otherData;
  String sendUserEmail;
  String profileImage;


  UserNot.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    notificationType = json['notificationType'];
    title = json['title'];
    message = json['message'];
    otherData = json['otherData'];
    sendUserEmail = json['sendUserEmail'];
    profileImage = json['profileImage'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['notificationType'] = notificationType;
    data['title'] = title;
    data['message'] = message;
    data['otherData'] = otherData;
    data['sendUserEmail'] = sendUserEmail;
    data['profileImage'] = profileImage;

    return data;
  }
}
