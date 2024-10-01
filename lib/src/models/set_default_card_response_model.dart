// To parse this JSON data, do
//
//     final storeDetailsResponseModel = storeDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

StoreDetailsResponseModel storeDetailsResponseModelFromJson(String str) => StoreDetailsResponseModel.fromJson(json.decode(str));

String storeDetailsResponseModelToJson(StoreDetailsResponseModel data) => json.encode(data.toJson());

class StoreDetailsResponseModel {
  bool success;
  int statuscode;
  Message message;
  Message responseData;

  StoreDetailsResponseModel({
     this.success,
     this.statuscode,
     this.message,
     this.responseData,
  });

  factory StoreDetailsResponseModel.fromJson(Map<String, dynamic> json) => StoreDetailsResponseModel(
    success: json["success"],
    statuscode: json["STATUSCODE"],
    message: Message.fromJson(json["message"]),
    responseData: Message.fromJson(json["response_data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "STATUSCODE": statuscode,
    "message": message.toJson(),
    "response_data": responseData.toJson(),
  };
}

class Message {
  Message();

  factory Message.fromJson(Map<String, dynamic> json) => Message(
  );

  Map<String, dynamic> toJson() => {
  };
}
