// To parse this JSON data, do
//
//     final allFriendListResponseModel = allFriendListResponseModelFromJson(jsonString);

import 'dart:convert';

AllFriendListResponseModel allFriendListResponseModelFromJson(String str) => AllFriendListResponseModel.fromJson(json.decode(str));

String allFriendListResponseModelToJson(AllFriendListResponseModel data) => json.encode(data.toJson());

class AllFriendListResponseModel {
  AllFriendListResponseModel({
    this.status,
    this.statuscode,
    this.message,
    this.responseData,
  });

  bool status;
  int statuscode;
  String message;
  ResponseData responseData;

  factory AllFriendListResponseModel.fromJson(Map<String, dynamic> json) => AllFriendListResponseModel(
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
    this.data,
  });

  List<NewgroupUserList> data;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    data: List<NewgroupUserList>.from(json["data"].map((x) => NewgroupUserList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class NewgroupUserList {
  NewgroupUserList({
    this.userId,
    this.userName,
    this.profileImage,
    this.gender,
  });

  String userId;
  String userName;
  String profileImage;
  String gender;

  bool _isSelected=false;

  set isSelected(bool value) {
    _isSelected = value;
  }

  bool get isSelected => _isSelected;

  factory NewgroupUserList.fromJson(Map<String, dynamic> json) => NewgroupUserList(
    userId: json["userId"],
    userName: json["userName"],
    profileImage: json["profileImage"],
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
    "profileImage": profileImage,
    "gender": gender,
  };
}
