// To parse this JSON data, do
//
//     final otherUserProfileResponseModel = otherUserProfileResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:griot_legacy_social_media_app/src/models/comment_model.dart';
import 'package:griot_legacy_social_media_app/src/models/like_model.dart';

OtherUserProfileResponseModel otherUserProfileResponseModelFromJson(String str) => OtherUserProfileResponseModel.fromJson(json.decode(str));

String otherUserProfileResponseModelToJson(OtherUserProfileResponseModel data) => json.encode(data.toJson());

class OtherUserProfileResponseModel {
  OtherUserProfileResponseModel({
    this.success,
    this.statuscode,
    this.message,
    this.responseData,
  });

  bool success;
  int statuscode;
  String message;
  ResponseData responseData;

  OtherUserProfileResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statuscode = json['STATUSCODE'];
    message = json['message'];
    if(json['response_data'].isNotEmpty){
      responseData= ResponseData.fromJson(json["response_data"]);
      //List<ResponseDataDashboard>.from(json["response_data"].map((x) => ResponseDataDashboard.fromJson(x)));
    }
   /* responseData = json['response_data']
        ? ResponseData.fromJson(json["response_data"])
        : "";*/
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

  /*factory OtherUserProfileResponseModel.fromJson(Map<String, dynamic> json) => OtherUserProfileResponseModel(
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
  };*/
}

class ResponseData {
  ResponseData({
    this.fullName,
    this.email,
    this.phone,
    this.gender,
    this.countryCode,
    this.dateOfBirth,
    this.profileImage,
    this.post,
    this.circle,
    this.INNERCRCL,
  });

  String fullName;
  String email;
  int phone;
  String gender;
  String countryCode;
  DateTime dateOfBirth;
  String profileImage;
  List<OtherUserPost> post;
  String circle;
  String INNERCRCL;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    fullName: json["fullName"],
    email: json["email"],
    phone: json["phone"] ?? 0,
    gender: json["gender"] ??"",
    countryCode: json["countryCode"],
    dateOfBirth: DateTime.parse(json["dateOfBirth"]),
    profileImage: json["profileImage"],
    post: List<OtherUserPost>.from(json["post"].map((x) => OtherUserPost.fromJson(x))).toList(),
    circle: json["circle"],
    INNERCRCL: json["INNERCRCL"],
  );

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "email": email,
    "phone": phone,
    "gender": gender,
    "countryCode": countryCode,
    "dateOfBirth": dateOfBirth.toIso8601String(),
    "profileImage": profileImage,
    "post": List<dynamic>.from(post.map((x) => x.toJson())).toList(),
    "circle": circle,
    "INNERCRCL": INNERCRCL,
  };
}

class OtherUserPost {
  OtherUserPost({
    this.userId,
    this.postId,
    this.name,
    this.caption,
    this.postDate,
    this.like,
    this.comment,
    this.imageArr,
    this.likedId,
    this.isliked,
    this.album,
    this.isBlocked
  });

  String userId;
  String postId;
  String name;
  String caption;
  DateTime postDate;
  List<LikeModel> like;
  bool isliked;
  String likedId;
  List<CommentsModel> comment;
  List<ImageArr> imageArr;
  bool isBlocked;

  String album;


  OtherUserPost.fromJson(Map<String, dynamic> json) {

     userId= json["userId"];
     postId= json["postId"];
     name= json["name"];
     caption= json["caption"];
     album= json["album"];
     isBlocked= json["isBlocked"];
     postDate= DateTime.parse(json["postDate"]);
     imageArr= json["imageArr"] == null ?
     null : List<ImageArr>.from(json["imageArr"].map((x) => ImageArr.fromJson(x)));
     if (json['comment'] != null) {
       comment = [];
       json['comment'].forEach((v) {
         comment.add(new CommentsModel.fromJson(v));
       });
     }

     if (json['like'] != null) {
       like = [];
       json['like'].forEach((v) {
         like.add( LikeModel.fromJson(v));
       });
     }

     // imageArr: json["imageArr"]!=null?List<ImageClass>.from(json["imageArr"].map((x) => ImageClass.fromJson(x))).toList():null,
     //imageArr: json["imageArr"] == null ? null : List<String>.from(json["imageArr"].map((x) => x)),
   }

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "postId": postId,
    "name": name,
    "caption": caption,
    "album": album,
    "isBlocked": isBlocked,
    "postDate": postDate.toIso8601String(),
    "like": like,
    "comment": comment,
    "imageArr": List<dynamic>.from(imageArr.map((x) => x.toJson())).toList(),

    //"imageArr": imageArr == null ? null : List<dynamic>.from(imageArr.map((x) => x)),
  };
}

class ImageArr {
  ImageArr({
    this.image,
    this.type,
    this.thumb,
  });

  String image;
  String type;
  String thumb;

  factory ImageArr.fromJson(Map<String, dynamic> json) => ImageArr(
    image: json["image"],
    type: json["type"],
    thumb: json["thumb"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "type": type,
    "thumb": thumb,
  };
}

enum Type { IMAGE, VIDEO }

final typeValues = EnumValues({
  "IMAGE": Type.IMAGE,
  "VIDEO": Type.VIDEO
});




class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}


/*class ImageClass {
  ImageClass({
    this.image,
    this.type,

  });

  String image;
  String type;


  factory ImageClass.fromJson(Map<String, dynamic> json) => ImageClass(
    image: json["image"],
    type: json["type"],

  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "type": type,

  };
}*/

