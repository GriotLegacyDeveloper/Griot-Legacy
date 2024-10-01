/*


import 'dart:convert';

ChatListResponseModel chatListResponseModelFromJson(String str) => ChatListResponseModel.fromJson(json.decode(str));

String chatListResponseModelToJson(ChatListResponseModel data) => json.encode(data.toJson());

class ChatListResponseModel {
  ChatListResponseModel({
    this.success,
    this.statuscode,
    this.message,
    this.responseData,
  });

  bool success;
  int statuscode;
  String message;
  ResponseData responseData;

  factory ChatListResponseModel.fromJson(Map<String, dynamic> json) => ChatListResponseModel(
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

  List<MessageListing> message;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    message: List<MessageListing>.from(json["message"].map((x) => MessageListing.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": List<dynamic>.from(message.map((x) => x.toJson())),
  };
}

class MessageListing {
  MessageListing({
    this.id,
    this.fromIsRead,
    this.toIsRead,
    this.fromUserId,
    this.toUserId,
    this.message,
    this.combinationName,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.fromuser,
    this.touser,
    this.isRead,
  });

  String id;
  String fromIsRead;
  String toIsRead;
  String fromUserId;
  String toUserId;
  String message;
  String combinationName;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  List<FromUser> fromuser;
  List<ToUser> touser;
  String isRead;

  factory MessageListing.fromJson(Map<String, dynamic> json) => MessageListing(
    id: json["_id"],
    fromIsRead: json["fromIsRead"],
    toIsRead: json["toIsRead"],
    fromUserId: json["fromUserId"],
    toUserId: json["toUserId"],
    message: json["message"],
    combinationName: json["combinationName"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    fromuser: List<FromUser>.from(json["fromuser"].map((x) => FromUser.fromJson(x))),
    touser: List<ToUser>.from(json["touser"].map((x) => ToUser.fromJson(x))),
    isRead: json["isRead"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "fromIsRead": fromIsRead,
    "toIsRead": toIsRead,
    "fromUserId": fromUserId,
    "toUserId": toUserId,
    "message": message,
    "combinationName": combinationName,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "fromuser": List<dynamic>.from(fromuser.map((x) => x.toJson())),
    "touser": List<dynamic>.from(touser.map((x) => x.toJson())),
    "isRead": isRead,
  };
}

class FromUser {
  FromUser({
    this.id,
    this.email,
    this.countryCode,
    this.phone,
    this.profileImage,
    this.gender,
    this.relationship,
    this.verificationOtp,
    this.fpOtp,
    this.badgeCount,
    this.fullName,
    this.password,
    this.status,
    this.userLoginType,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.notification,
    this.profile,
  });

  String id;
  String email;
  String countryCode;
  int phone;
  String profileImage;
  String gender;
  String relationship;
  String verificationOtp;
  String fpOtp;
  int badgeCount;
  String fullName;
  String password;
  String status;
  String userLoginType;
  DateTime dateOfBirth;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String notification;
  String profile;

  factory FromUser.fromJson(Map<String, dynamic> json) => FromUser(
    id: json["_id"],
    email: json["email"],
    countryCode: json["countryCode"],
    phone: json["phone"],
    profileImage: json["profileImage"],
    gender: json["gender"],
    relationship: json["relationship"],
    verificationOtp: json["verificationOTP"],
    fpOtp: json["fpOTP"],
    badgeCount: json["badgeCount"],
    fullName: json["fullName"],
    password: json["password"],
    status: json["status"],
    userLoginType: json["userLoginType"],
    dateOfBirth: DateTime.parse(json["dateOfBirth"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    notification: json["notification"] == null ? null : json["notification"],
    profile: json["profile"] == null ? null : json["profile"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "countryCode": countryCode,
    "phone": phone,
    "profileImage": profileImage,
    "gender": gender,
    "relationship": relationship,
    "verificationOTP": verificationOtp,
    "fpOTP": fpOtp,
    "badgeCount": badgeCount,
    "fullName": fullName,
    "password": password,
    "status": status,
    "userLoginType": userLoginType,
    "dateOfBirth": dateOfBirth.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "notification": notification == null ? null : notification,
    "profile": profile == null ? null : profile,
  };
}

class ToUser {
  ToUser({
    this.id,
    this.email,
    this.countryCode,
    this.phone,
    this.profileImage,
    this.gender,
    this.relationship,
    this.verificationOtp,
    this.fpOtp,
    this.badgeCount,
    this.fullName,
    this.password,
    this.status,
    this.userLoginType,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.notification,
    this.profile,
  });

  String id;
  String email;
  String countryCode;
  int phone;
  String profileImage;
  String gender;
  String relationship;
  String verificationOtp;
  String fpOtp;
  int badgeCount;
  String fullName;
  String password;
  String status;
  String userLoginType;
  DateTime dateOfBirth;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String notification;
  String profile;

  factory ToUser.fromJson(Map<String, dynamic> json) => ToUser(
    id: json["_id"],
    email: json["email"],
    countryCode: json["countryCode"],
    phone: json["phone"],
    profileImage: json["profileImage"],
    gender: json["gender"],
    relationship: json["relationship"],
    verificationOtp: json["verificationOTP"],
    fpOtp: json["fpOTP"],
    badgeCount: json["badgeCount"],
    fullName: json["fullName"],
    password: json["password"],
    status: json["status"],
    userLoginType: json["userLoginType"],
    dateOfBirth: DateTime.parse(json["dateOfBirth"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    notification: json["notification"] == null ? null : json["notification"],
    profile: json["profile"] == null ? null : json["profile"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "countryCode": countryCode,
    "phone": phone,
    "profileImage": profileImage,
    "gender": gender,
    "relationship": relationship,
    "verificationOTP": verificationOtp,
    "fpOTP": fpOtp,
    "badgeCount": badgeCount,
    "fullName": fullName,
    "password": password,
    "status": status,
    "userLoginType": userLoginType,
    "dateOfBirth": dateOfBirth.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "notification": notification == null ? null : notification,
    "profile": profile == null ? null : profile,
  };
}
*/






// To parse this JSON data, do
//
//     final chatListResponseModel = chatListResponseModelFromJson(jsonString);

import 'dart:convert';

ChatListResponseModel chatListResponseModelFromJson(String str) => ChatListResponseModel.fromJson(json.decode(str));

String chatListResponseModelToJson(ChatListResponseModel data) => json.encode(data.toJson());

class ChatListResponseModel {
  ChatListResponseModel({
    this.success,
    this.statuscode,
    this.message,
    this.responseData,
  });

  bool success;
  int statuscode;
  String message;
  ResponseData responseData;

  factory ChatListResponseModel.fromJson(Map<String, dynamic> json) => ChatListResponseModel(
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
    this.group,
  });

  List<Message> message;
  List<Group> group;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    message: List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
    group: List<Group>.from(json["group"].map((x) => Group.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": List<dynamic>.from(message.map((x) => x.toJson())),
    "group": List<dynamic>.from(group.map((x) => x.toJson())),
  };
}

class Group {
  Group({
    this.isGroup,
    this.groupId,
    this.groupName,
    this.groupImage,
    this.updatedAt,
  });

  bool isGroup;
  String groupId;
  String groupName;
  String groupImage;
  DateTime updatedAt;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    isGroup: json["isGroup"],
    groupId: json["groupId"],
    groupName: json["groupName"],
    groupImage: json["groupImage"],
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "isGroup": isGroup,
    "groupId": groupId,
    "groupName": groupName,
    "groupImage": groupImage,
    "updatedAt": updatedAt.toIso8601String(),
  };
}

class Message {
  Message({
    this.id,
    this.fromIsRead,
    this.toIsRead,
   // this.deletedBy,
    this.quoteMsgId,
    this.quoteMsg,
    this.fromUserId,
    this.toUserId,
    this.message,
    this.combinationName,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.fromuser,
    this.touser,
    this.isGroup,
    this.isRead,
  });

  String id;
  String fromIsRead;
  String toIsRead;
  //List<dynamic> deletedBy;
  String quoteMsgId;
  String quoteMsg;
  String fromUserId;
  String toUserId;
  String message;
  String combinationName;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  List<FromUser> fromuser;
  List<ToUser> touser;
  bool isGroup;
  String isRead;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["_id"],
    fromIsRead: json["fromIsRead"],
    toIsRead: json["toIsRead"],
   // deletedBy: List<dynamic>.from(json["deletedBy"].map((x) => x)),
    quoteMsgId: json["quoteMsgID"],
    quoteMsg: json["quoteMsg"],
    fromUserId: json["fromUserId"],
    toUserId: json["toUserId"],
    message: json["message"],
    combinationName: json["combinationName"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    fromuser: List<FromUser>.from(json["fromuser"].map((x) => FromUser.fromJson(x))),
    touser: List<ToUser>.from(json["touser"].map((x) => ToUser.fromJson(x))),
    isGroup: json["isGroup"],
    isRead: json["isRead"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "fromIsRead": fromIsRead,
    "toIsRead": toIsRead,
    //"deletedBy": List<dynamic>.from(deletedBy.map((x) => x)),
    "quoteMsgID": quoteMsgId,
    "quoteMsg": quoteMsg,
    "fromUserId": fromUserId,
    "toUserId": toUserId,
    "message": message,
    "combinationName": combinationName,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "fromuser": List<dynamic>.from(fromuser.map((x) => x.toJson())),
    "touser": List<dynamic>.from(touser.map((x) => x.toJson())),
    "isGroup": isGroup,
    "isRead": isRead,
  };
}

class FromUser {
  FromUser({
    this.id,
    this.email,
    this.countryCode,
    this.phone,
    this.profileImage,
    this.gender,
    this.relationship,
    this.verificationOtp,
    this.fpOtp,
    this.badgeCount,
    this.fullName,
    this.password,
    this.status,
    this.userLoginType,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.lastLogin,
    this.notificationCount,
    this.notification,
    this.profile,
  });

  String id;
  String email;
  String countryCode;
  int phone;
  String profileImage;
  String gender;
  String relationship;
  String verificationOtp;
  String fpOtp;
  int badgeCount;
  String fullName;
  String password;
  String status;
  String userLoginType;
  DateTime dateOfBirth;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String lastLogin;
  int notificationCount;
  String notification;
  String profile;

  factory FromUser.fromJson(Map<String, dynamic> json) => FromUser(
    id: json["_id"],
    email: json["email"],
    countryCode: json["countryCode"],
    phone: json["phone"],
    profileImage: json["profileImage"],
    gender: json["gender"],
    relationship: json["relationship"],
    verificationOtp: json["verificationOTP"],
    fpOtp: json["fpOTP"],
    badgeCount: json["badgeCount"],
    fullName: json["fullName"],
    password: json["password"],
    status: json["status"],
    userLoginType: json["userLoginType"],
    dateOfBirth: DateTime.parse(json["dateOfBirth"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    lastLogin: json["lastLogin"],
    notificationCount: json["notificationCount"],
    notification: json["notification"] == null ? null : json["notification"],
    profile: json["profile"] == null ? null : json["profile"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "countryCode": countryCode,
    "phone": phone,
    "profileImage": profileImage,
    "gender": gender,
    "relationship": relationship,
    "verificationOTP": verificationOtp,
    "fpOTP": fpOtp,
    "badgeCount": badgeCount,
    "fullName": fullName,
    "password": password,
    "status": status,
    "userLoginType": userLoginType,
    "dateOfBirth": dateOfBirth.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "lastLogin": lastLogin,
    "notificationCount": notificationCount,
    "notification": notification == null ? null : notification,
    "profile": profile == null ? null : profile,
  };
}



class ToUser {
  ToUser({
    this.id,
    this.email,
    this.countryCode,
    this.phone,
    this.profileImage,
    this.gender,
    this.relationship,
    this.verificationOtp,
    this.fpOtp,
    this.badgeCount,
    this.fullName,
    this.password,
    this.status,
    this.userLoginType,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.lastLogin,
    this.notificationCount,
    this.notification,
    this.profile,
  });

  String id;
  String email;
  String countryCode;
  int phone;
  String profileImage;
  String gender;
  String relationship;
  String verificationOtp;
  String fpOtp;
  int badgeCount;
  String fullName;
  String password;
  String status;
  String userLoginType;
  DateTime dateOfBirth;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String lastLogin;
  int notificationCount;
  String notification;
  String profile;

  factory ToUser.fromJson(Map<String, dynamic> json) => ToUser(
    id: json["_id"],
    email: json["email"],
    countryCode: json["countryCode"],
    phone: json["phone"],
    profileImage: json["profileImage"],
    gender: json["gender"],
    relationship: json["relationship"],
    verificationOtp: json["verificationOTP"],
    fpOtp: json["fpOTP"],
    badgeCount: json["badgeCount"],
    fullName: json["fullName"],
    password: json["password"],
    status: json["status"],
    userLoginType: json["userLoginType"],
    dateOfBirth: DateTime.parse(json["dateOfBirth"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    lastLogin: json["lastLogin"],
    notificationCount: json["notificationCount"],
    notification: json["notification"] == null ? null : json["notification"],
    profile: json["profile"] == null ? null : json["profile"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "email": email,
    "countryCode": countryCode,
    "phone": phone,
    "profileImage": profileImage,
    "gender": gender,
    "relationship": relationship,
    "verificationOTP": verificationOtp,
    "fpOTP": fpOtp,
    "badgeCount": badgeCount,
    "fullName": fullName,
    "password": password,
    "status": status,
    "userLoginType": userLoginType,
    "dateOfBirth": dateOfBirth.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "lastLogin": lastLogin,
    "notificationCount": notificationCount,
    "notification": notification == null ? null : notification,
    "profile": profile == null ? null : profile,
  };
}

class DeletBy {
  DeletBy({
    this.id,

  });

  String id;


  factory DeletBy.fromJson(Map<String, dynamic> json) => DeletBy(
    id: json["_id"],

  );

  Map<String, dynamic> toJson() => {
    "_id": id,

  };
}

