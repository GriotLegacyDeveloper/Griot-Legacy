/*



import 'dart:convert';

DashboardResponseModel dashboardResponseModelFromJson(String str) => DashboardResponseModel.fromJson(json.decode(str));

String dashboardResponseModelToJson(DashboardResponseModel data) => json.encode(data.toJson());

class DashboardResponseModel {
  DashboardResponseModel({
    this.success,
    this.statuscode,
    this.message,
    this.responseData,
    this.advertisementListArray,
  });

  bool success;
  int statuscode;
  String message;
  List<ResponseDataDashboard> responseData;
  List<AdvertisementListArrData> advertisementListArray;


  DashboardResponseModel.fromJson(Map<String, dynamic> json) {
    print("json $json");
    success = json['success'];
    statuscode = json['STATUSCODE'];
    message = json['message'];
    if(json['response_data'].isNotEmpty){
      responseData= List<ResponseDataDashboard>.from(json["response_data"].map((x) => ResponseDataDashboard.fromJson(x)));
    }
    if(json['advertisementListArray'].isNotEmpty){
      advertisementListArray= List<AdvertisementListArrData>.from(json["advertisementListArray"].map((x) => x));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['STATUSCODE'] = statuscode;
    data['message'] = message;
    if (responseData != null) {

      data['response_data'] = List<dynamic>.from(responseData.map((x) => x.toJson()));
    }
    if (advertisementListArray != null) {

      data['advertisementListArray'] = List<dynamic>.from(advertisementListArray.map((x) => x));
    }
    return data;
  }


}

class ResponseDataDashboard {
  ResponseDataDashboard({
    this.album,
    this.postType,
    this.data,
    this.post,
    this.like,
    this.comment,
    this.isBlocked,
    this.user,
  });

  String album;
  String postType;
  List<DashboardDataVillage> data;
  PostDashboard post;
  List<Comment> like;
  List<Comment> comment;
  bool isBlocked;
  UserDashboard user;

  factory ResponseDataDashboard.fromJson(Map<String, dynamic> json) => ResponseDataDashboard(
    album: json["album"],
    postType: json["postType"],
    data: List<DashboardDataVillage>.from(json["data"].map((x) => DashboardDataVillage.fromJson(x))),
    post: PostDashboard.fromJson(json["post"]),
    like: List<Comment>.from(json["like"].map((x) => Comment.fromJson(x))),
    comment: List<Comment>.from(json["comment"].map((x) => Comment.fromJson(x))),
    isBlocked: json["isBlocked"],
    user: json["user"] == null ? null : UserDashboard.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "album": album,
    "postType": postType,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "post": post.toJson(),
    "like": List<dynamic>.from(like.map((x) => x.toJson())),
    "comment": List<dynamic>.from(comment.map((x) => x.toJson())),
    "isBlocked": isBlocked,
    "user": user == null ? null : user.toJson(),
  };
}

class Comment {
  Comment({
    this.commentCreatedAt,
    this.id,
    this.postId,
    this.comment,
    this.commentedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.likedBy,
  });

  DateTime commentCreatedAt;
  String id;
  String postId;
  String comment;
  EdBy commentedBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  EdBy likedBy;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    commentCreatedAt: DateTime.parse(json["created_At"]),
    id: json["_id"],
    postId: json["postId"],
    comment: json["comment"] == null ? null : json["comment"],
    commentedBy: json["commentedBy"] == null ? null : EdBy.fromJson(json["commentedBy"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    likedBy: json["likedBy"] == null ? null : EdBy.fromJson(json["likedBy"]),
  );

  Map<String, dynamic> toJson() => {
    "created_At": commentCreatedAt.toIso8601String(),
    "_id": id,
    "postId": postId,
    "comment": comment == null ? null : comment,
    "commentedBy": commentedBy == null ? null : commentedBy.toJson(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "likedBy": likedBy == null ? null : likedBy.toJson(),
  };
}

class EdBy {
  EdBy({
    this.email,
    this.profileImage,
    this.id,
    this.fullName,
  });

  String email;
  String profileImage;
  String id;
  String fullName;

  factory EdBy.fromJson(Map<String, dynamic> json) => EdBy(
    email: json["email"],
    profileImage: json["profileImage"],
    id: json["_id"],
    fullName: json["fullName"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "profileImage": profileImage,
    "_id": id,
    "fullName": fullName,
  };
}

class DashboardDataVillage {
  DashboardDataVillage({
    this.type,
    this.thumb,
    this.caption,
    this.album,
    this.arrange,
    this.id,
    this.userId,
    this.postId,
    this.file,
    this.v,
    this.createdAt,
    this.updatedAt,
  });

  String type;
  String thumb;
  String caption;
  String album;
  int arrange;
  String id;
  String userId;
  String postId;
  String file;
  int v;
  DateTime createdAt;
  DateTime updatedAt;

  factory DashboardDataVillage.fromJson(Map<String, dynamic> json) => DashboardDataVillage(
    type: json["type"],
    thumb: json["thumb"],
    caption: json["caption"],
    album: json["album"],
    arrange: json["arrange"],
    id: json["_id"],
    userId: json["userId"],
    postId: json["postId"],
    file: json["file"],
    v: json["__v"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "thumb": thumb,
    "caption": caption,
    "album": album,
    "arrange": arrange,
    "_id": id,
    "userId": userId,
    "postId": postId,
    "file": file,
    "__v": v,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}

class PostDashboard {
  PostDashboard({
    this.caption,
    this.postType,
    this.audience,
    this.tribe,
    this.likes,
    this.share,
    this.comments,
    this.id,
    this.tribeId,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.reportCount,
  });

  String caption;
  String postType;
  String audience;
  List<dynamic> tribe;
  List<dynamic> likes;
  List<dynamic> share;
  List<dynamic> comments;
  String id;
  String tribeId;
  String userId;
  String reportCount;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory PostDashboard.fromJson(Map<String, dynamic> json) => PostDashboard(
    caption: json["caption"],
    postType: json["postType"],
    audience: json["audience"],
    reportCount: json["reportCount"],
    tribe: List<dynamic>.from(json["tribe"].map((x) => x)),
    likes: List<dynamic>.from(json["likes"].map((x) => x)),
    share: List<dynamic>.from(json["share"].map((x) => x)),
    comments: List<dynamic>.from(json["comments"].map((x) => x)),
    id: json["_id"],
    tribeId: json["tribeId"],
    userId: json["userId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
  );

  Map<String, dynamic> toJson() => {
    "caption": caption,
    "postType": postType,
    "audience": audience,
    "tribe": List<dynamic>.from(tribe.map((x) => x)),
    "likes": List<dynamic>.from(likes.map((x) => x)),
    "share": List<dynamic>.from(share.map((x) => x)),
    "comments": List<dynamic>.from(comments.map((x) => x)),
    "_id": id,
    "tribeId": tribeId,
    "userId": userId,
    "reportCount": reportCount,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
  };
}




List<AdvertisementListArrData> advertisementListArrDataFromJson(String str) => List<AdvertisementListArrData>.from(json.decode(str).map((x) => AdvertisementListArrData.fromJson(x)));

String advertisementListArrDataToJson(List<AdvertisementListArrData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AdvertisementListArrData {
  String postType;
  String image;
  String link;
  String title;
  String id;
  DateTime validFrom;
  DateTime validTill;

  AdvertisementListArrData({
     this.postType,
     this.image,
     this.link,
     this.title,
     this.id,
     this.validFrom,
     this.validTill,
  });

  factory AdvertisementListArrData.fromJson(Map<String, dynamic> json) => AdvertisementListArrData(
    postType: json["postType"],
    image: json["image"],
    link: json["link"],
    title: json["title"],
    id: json["_id"],
    validFrom: DateTime.parse(json["validFrom"]),
    validTill: DateTime.parse(json["validTill"]),
  );

  Map<String, dynamic> toJson() => {
    "postType": postType,
    "image": image,
    "link": link,
    "title": title,
    "_id": id,
    "validFrom": validFrom.toIso8601String(),
    "validTill": validTill.toIso8601String(),
  };
}


class UserDashboard {
  UserDashboard({
   // this.time,
    this.email,
    this.countryCode,
    this.phone,
    this.profileImage,
    this.gender,
    this.relationship,
    this.verificationOtp,
    this.fpOtp,
    this.badgeCount,
    this.notificationCount,
    this.profile,
    this.notification,
    this.totalDuration,
    this.date,
    this.id,
    this.fullName,
    this.password,
    this.status,
    this.userLoginType,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.lastLogin,
  });

 // Time time;
  String email;
  String countryCode;
  int phone;
  String profileImage;
  String gender;
  String relationship;
  String verificationOtp;
  String fpOtp;
  int badgeCount;
  int notificationCount;
  String profile;
  String notification;
  String totalDuration;
  List<String> date;
  String id;
  String fullName;
  String password;
  String status;
  String userLoginType;
  DateTime dateOfBirth;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String lastLogin;

  factory UserDashboard.fromJson(Map<String, dynamic> json) => UserDashboard(
   // time: Time.fromJson(json["time"]),
    email: json["email"],
    countryCode: json["countryCode"],
    phone: json["phone"],
    profileImage: json["profileImage"],
    gender: json["gender"],
    relationship: json["relationship"],
    verificationOtp: json["verificationOTP"],
    fpOtp: json["fpOTP"],
    badgeCount: json["badgeCount"],
    notificationCount: json["notificationCount"],
    profile: json["profile"],
    notification: json["notification"],
    totalDuration: json["totalDuration"],
    date: List<String>.from(json["date"].map((x) => x)),
    id: json["_id"],
    fullName: json["fullName"],
    password: json["password"],
    status: json["status"],
    userLoginType: json["userLoginType"],
    dateOfBirth: DateTime.parse(json["dateOfBirth"]),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    v: json["__v"],
    lastLogin: json["lastLogin"],
  );

  Map<String, dynamic> toJson() => {
  //  "time": time.toJson(),
    "email": email,
    "countryCode": countryCode,
    "phone": phone,
    "profileImage": profileImage,
    "gender": gender,
    "relationship": relationship,
    "verificationOTP": verificationOtp,
    "fpOTP": fpOtp,
    "badgeCount": badgeCount,
    "notificationCount": notificationCount,
    "profile": profile,
    "notification": notification,
    "totalDuration": totalDuration,
    "date": List<dynamic>.from(date.map((x) => x)),
    "_id": id,
    "fullName": fullName,
    "password": password,
    "status": status,
    "userLoginType": userLoginType,
    "dateOfBirth": dateOfBirth.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "__v": v,
    "lastLogin": lastLogin,
  };
}

class Time {
  Time({
    this.out,
    this.timeIn,
  });

  String out;
  String timeIn;

  factory Time.fromJson(Map<String, dynamic> json) => Time(
    out: json["OUT"],
    timeIn: json["IN"],
  );

  Map<String, dynamic> toJson() => {
    "OUT": out,
    "IN": timeIn,
  };
}






*/

class DashboardResponseModel {
  bool success;
  int sTATUSCODE;
  String message;
  List<ResponseDataDashboard> responseData;
  List<AdvertisementListArray> advertisementListArray;

  DashboardResponseModel(
      {this.success,
      this.sTATUSCODE,
      this.message,
      this.responseData,
      this.advertisementListArray});

  DashboardResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    sTATUSCODE = json['STATUSCODE'];
    message = json['message'];
    if (json['response_data'] != null) {
      responseData = <ResponseDataDashboard>[];
      json['response_data'].forEach((v) {
        responseData.add(ResponseDataDashboard.fromJson(v));
      });
    }
    if (json['advertisementListArray'] != null) {
      advertisementListArray = <AdvertisementListArray>[];
      json['advertisementListArray'].forEach((v) {
        advertisementListArray.add(AdvertisementListArray.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['STATUSCODE'] = sTATUSCODE;
    data['message'] = message;
    if (responseData != null) {
      data['response_data'] = responseData.map((v) => v.toJson()).toList();
    }
    if (advertisementListArray != null) {
      data['advertisementListArray'] =
          advertisementListArray.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResponseDataDashboard {
  String album;
  String postType;
  List<DashboardDataVillage> data;
  PostDashboard post;
  List<Like> like;
  List<dynamic> comment;
  bool isBlocked;
  UserDashboard user;

  ResponseDataDashboard(
      {this.album,
      this.postType,
      this.data,
      this.post,
      this.like,
      this.comment,
      this.isBlocked,
      this.user});

  ResponseDataDashboard.fromJson(Map<String, dynamic> json) {
    album = json['album'];
    postType = json['postType'];
    if (json['data'] != null) {
      data = <DashboardDataVillage>[];
      json['data'].forEach((v) {
        data.add(DashboardDataVillage.fromJson(v));
      });
    }
    post = json['post'] != null ? PostDashboard.fromJson(json['post']) : null;
    if (json['like'] != null) {
      like = <Like>[];
      json['like'].forEach((v) {
        like.add(Like.fromJson(v));
      });
    }
    // if (json['comment'] != null) {
    //   comment = <Null>[];
    //   json['comment'].forEach((v) {
    //     comment.add(v.fromJson(v));
    //   });
    // }
    isBlocked = json['isBlocked'];
    user = json['user'] != null ? UserDashboard.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['album'] = album;
    data['postType'] = postType;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (post != null) {
      data['post'] = post.toJson();
    }
    if (like != null) {
      data['like'] = like.map((v) => v.toJson()).toList();
    }
    if (comment != null) {
      data['comment'] = comment.map((v) => v.toJson()).toList();
    }
    data['isBlocked'] = isBlocked;
    if (user != null) {
      data['user'] = user.toJson();
    }
    return data;
  }
}

class DashboardDataVillage {
  String type;
  String thumb;
  String caption;
  String album;
  int arrange;
  String sId;
  String userId;
  String postId;
  String file;
  int iV;
  String createdAt;
  String updatedAt;

  DashboardDataVillage(
      {this.type,
      this.thumb,
      this.caption,
      this.album,
      this.arrange,
      this.sId,
      this.userId,
      this.postId,
      this.file,
      this.iV,
      this.createdAt,
      this.updatedAt});

  DashboardDataVillage.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    thumb = json['thumb'];
    caption = json['caption'];
    album = json['album'];
    arrange = json['arrange'];
    sId = json['_id'];
    userId = json['userId'];
    postId = json['postId'];
    file = json['file'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['thumb'] = thumb;
    data['caption'] = caption;
    data['album'] = album;
    data['arrange'] = arrange;
    data['_id'] = sId;
    data['userId'] = userId;
    data['postId'] = postId;
    data['file'] = file;
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class PostDashboard {
  String caption;
  String postType;
  String audience;
  List<String> tribe;
  List<String> likes;
  List<dynamic> share;
  List<dynamic> comments;
  String reportCount;
  bool isBlocked;
  String sId;
  String userId;
  String createdAt;
  String updatedAt;
  int iV;

  PostDashboard(
      {this.caption,
      this.postType,
      this.audience,
      this.tribe,
      this.likes,
      this.share,
      this.comments,
      this.reportCount,
      this.isBlocked,
      this.sId,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  PostDashboard.fromJson(Map<String, dynamic> json) {
    caption = json['caption'];
    postType = json['postType'];
    audience = json['audience'];
    tribe = json['tribe'].cast<String>();
    likes = json['likes'].cast<String>();
    if (json['share'] != null) {
      share = <Null>[];
      json['share'].forEach((v) {
        share.add(v.fromJson(v));
      });
    }
    // if (json['comments'] != null) {
    //   comments = <Null>[];
    //   json['comments'].forEach((v) {
    //     comments.add(v.fromJson(v));
    //   });
    // }
    reportCount = json['reportCount'];
    isBlocked = json['isBlocked'];
    sId = json['_id'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['caption'] = caption;
    data['postType'] = postType;
    data['audience'] = audience;
    data['tribe'] = tribe;
    data['likes'] = likes;
    if (share != null) {
      data['share'] = share.map((v) => v.toJson()).toList();
    }
    if (comments != null) {
      data['comments'] = comments.map((v) => v.toJson()).toList();
    }
    data['reportCount'] = reportCount;
    data['isBlocked'] = isBlocked;
    data['_id'] = sId;
    data['userId'] = userId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Like {
  String createdAt;
  String sId;
  String postId;
  LikedBy likedBy;
  String updatedAt;
  int iV;

  Like(
      {this.createdAt,
      this.sId,
      this.postId,
      this.likedBy,
      this.updatedAt,
      this.iV});

  Like.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_At'];
    sId = json['_id'];
    postId = json['postId'];
    likedBy =
        json['likedBy'] != null ? LikedBy.fromJson(json['likedBy']) : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_At'] = createdAt;
    data['_id'] = sId;
    data['postId'] = postId;
    if (likedBy != null) {
      data['likedBy'] = likedBy.toJson();
    }
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class LikedBy {
  String email;
  String profileImage;
  String sId;
  String fullName;

  LikedBy({this.email, this.profileImage, this.sId, this.fullName});

  LikedBy.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    profileImage = json['profileImage'];
    sId = json['_id'];
    fullName = json['fullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['profileImage'] = profileImage;
    data['_id'] = sId;
    data['fullName'] = fullName;
    return data;
  }
}

class UserDashboard {
  String email;
  String countryCode;
  int phone;
  String profileImage;
  String gender;
  String relationship;
  String verificationOTP;
  String fpOTP;
  int badgeCount;
  int notificationCount;
  String profile;
  String notification;
  String totalDuration;
  List<dynamic> date;
  String sId;
  String fullName;
  String password;
  String status;
  String userLoginType;
  String dateOfBirth;
  String createdAt;
  String updatedAt;
  int iV;
  String lastLogin;

  UserDashboard(
      {this.email,
      this.countryCode,
      this.phone,
      this.profileImage,
      this.gender,
      this.relationship,
      this.verificationOTP,
      this.fpOTP,
      this.badgeCount,
      this.notificationCount,
      this.profile,
      this.notification,
      this.totalDuration,
      this.date,
      this.sId,
      this.fullName,
      this.password,
      this.status,
      this.userLoginType,
      this.dateOfBirth,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.lastLogin});

  UserDashboard.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    countryCode = json['countryCode'];
    phone = json['phone'];
    profileImage = json['profileImage'];
    gender = json['gender'];
    relationship = json['relationship'];
    verificationOTP = json['verificationOTP'];
    fpOTP = json['fpOTP'];
    badgeCount = json['badgeCount'];
    notificationCount = json['notificationCount'];
    profile = json['profile'];
    notification = json['notification'];
    totalDuration = json['totalDuration'];
    if (json['date'] != null) {
      date = <Null>[];
      json['date'].forEach((v) {
        date.add(v.fromJson(v));
      });
    }
    sId = json['_id'];
    fullName = json['fullName'];
    password = json['password'];
    status = json['status'];
    userLoginType = json['userLoginType'];
    dateOfBirth = json['dateOfBirth'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    lastLogin = json['lastLogin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['countryCode'] = countryCode;
    data['phone'] = phone;
    data['profileImage'] = profileImage;
    data['gender'] = gender;
    data['relationship'] = relationship;
    data['verificationOTP'] = verificationOTP;
    data['fpOTP'] = fpOTP;
    data['badgeCount'] = badgeCount;
    data['notificationCount'] = notificationCount;
    data['profile'] = profile;
    data['notification'] = notification;
    data['totalDuration'] = totalDuration;
    if (date != null) {
      data['date'] = date.map((v) => v.toJson()).toList();
    }
    data['_id'] = sId;
    data['fullName'] = fullName;
    data['password'] = password;
    data['status'] = status;
    data['userLoginType'] = userLoginType;
    data['dateOfBirth'] = dateOfBirth;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['lastLogin'] = lastLogin;
    return data;
  }
}

class AdvertisementListArray {
  String postType;
  String image;
  String link;
  String title;
  String sId;
  String validFrom;
  String validTill;

  AdvertisementListArray(
      {this.postType,
      this.image,
      this.link,
      this.title,
      this.sId,
      this.validFrom,
      this.validTill});

  AdvertisementListArray.fromJson(Map<String, dynamic> json) {
    postType = json['postType'];
    image = json['image'];
    link = json['link'];
    title = json['title'];
    sId = json['_id'];
    validFrom = json['validFrom'];
    validTill = json['validTill'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['postType'] = postType;
    data['image'] = image;
    data['link'] = link;
    data['title'] = title;
    data['_id'] = sId;
    data['validFrom'] = validFrom;
    data['validTill'] = validTill;
    return data;
  }
}
