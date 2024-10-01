// To parse this JSON data, do
//
//     final blockTribeListResponseModel = blockTribeListResponseModelFromJson(jsonString);

import 'dart:convert';

BlockTribeListResponseModel blockTribeListResponseModelFromJson(String str) => BlockTribeListResponseModel.fromJson(json.decode(str));

String blockTribeListResponseModelToJson(BlockTribeListResponseModel data) => json.encode(data.toJson());

class BlockTribeListResponseModel {
  BlockTribeListResponseModel({
    this.success,
    this.statuscode,
    this.message,
    this.responseData,
  });

  bool success;
  int statuscode;
  String message;
  ResponseData responseData;

  factory BlockTribeListResponseModel.fromJson(Map<String, dynamic> json) => BlockTribeListResponseModel(
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
  });

  List<BlockTribeListData> data;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    data: List<BlockTribeListData>.from(json["data"].map((x) => BlockTribeListData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class BlockTribeListData {
  BlockTribeListData({
    this.id,
    this.createrUserId,
    this.image,
    this.name,
    this.type,
    this.tribeImageUrl,
    this.userImageUrl,
  });

  String id;
  String createrUserId;
  String image;
  String name;
  String type;
  String tribeImageUrl;
  String userImageUrl;

  factory BlockTribeListData.fromJson(Map<String, dynamic> json) => BlockTribeListData(
    id: json["_id"],
    createrUserId: json["createrUserId"],
    image: json["image"],
    name: json["name"],
    type: json["type"],
    tribeImageUrl: json["tribeImageUrl"],
    userImageUrl: json["userImageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "createrUserId": createrUserId,
    "image": image,
    "name": name,
    "type": type,
    "tribeImageUrl": tribeImageUrl,
    "userImageUrl": userImageUrl,
  };
}
