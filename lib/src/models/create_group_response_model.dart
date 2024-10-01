// To parse this JSON data, do
//
//     final createGroupResponseModel = createGroupResponseModelFromJson(jsonString);

import 'dart:convert';

CreateGroupResponseModel createGroupResponseModelFromJson(String str) => CreateGroupResponseModel.fromJson(json.decode(str));

String createGroupResponseModelToJson(CreateGroupResponseModel data) => json.encode(data.toJson());

class CreateGroupResponseModel {
  CreateGroupResponseModel({
    this.success,
    this.statuscode,
    this.message,
    this.groupId,
  });

  bool success;
  int statuscode;
  String message;
  String groupId;

  factory CreateGroupResponseModel.fromJson(Map<String, dynamic> json) => CreateGroupResponseModel(
    success: json["success"],
    statuscode: json["STATUSCODE"],
    message: json["message"],
    groupId: json["groupId"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "STATUSCODE": statuscode,
    "message": message,
    "groupId": groupId,
  };
}
