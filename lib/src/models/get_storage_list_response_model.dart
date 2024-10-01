// To parse this JSON data, do
//
//     final getStoragePackageResponseModel = getStoragePackageResponseModelFromJson(jsonString);

import 'dart:convert';

GetStoragePackageResponseModel getStoragePackageResponseModelFromJson(String str) => GetStoragePackageResponseModel.fromJson(json.decode(str));

String getStoragePackageResponseModelToJson(GetStoragePackageResponseModel data) => json.encode(data.toJson());

class GetStoragePackageResponseModel {
  bool success;
  int statuscode;
  String message;
  List<ResponseDatum> responseData;

  GetStoragePackageResponseModel({
     this.success,
     this.statuscode,
     this.message,
     this.responseData,
  });

  factory GetStoragePackageResponseModel.fromJson(Map<String, dynamic> json) => GetStoragePackageResponseModel(
    success: json["success"],
    statuscode: json["STATUSCODE"],
    message: json["message"],
    responseData: List<ResponseDatum>.from(json["response_data"].map((x) => ResponseDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "STATUSCODE": statuscode,
    "message": message,
    "response_data": List<dynamic>.from(responseData.map((x) => x.toJson())),
  };
}

class ResponseDatum {
  String id;
  String size;
  String unit;
  String price;
  String currency;
  int v;

  ResponseDatum({
     this.id,
     this.size,
     this.unit,
     this.price,
     this.currency,
     this.v,
  });

  factory ResponseDatum.fromJson(Map<String, dynamic> json) => ResponseDatum(
    id: json["_id"],
    size: json["size"],
    unit: json["unit"],
    price: json["price"],
    currency: json["currency"],
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "size": size,
    "unit": unit,
    "price": price,
    "currency": currency,
    "__v": v,
  };
}
