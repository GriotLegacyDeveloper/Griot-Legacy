import 'package:griot_legacy_social_media_app/src/models/comment_model.dart';
import 'package:griot_legacy_social_media_app/src/models/like_model.dart';

class HomeResponseModel {
  bool success;
  int sTATUSCODE;
  String message;
  HomeResponseData responseData;

  HomeResponseModel(
      {this.success, this.sTATUSCODE, this.message, this.responseData});

  HomeResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    sTATUSCODE = json['STATUSCODE'];
    message = json['message'];
    responseData = json['response_data'] != null
        ? HomeResponseData.fromJson(json['response_data'])
        : "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['STATUSCODE'] = sTATUSCODE;
    data['message'] = message;
    if (responseData != null) {
      data['response_data'] = responseData.toJson();
    }
    return data;
  }
}

class HomeResponseData {
  TrendingUser user;
  List<Dashboard> dashboard;
  String userPic;
  String postPic;
  List<Trending> trending;

  HomeResponseData(
      {this.user, this.dashboard, this.userPic, this.postPic, this.trending});

  HomeResponseData.fromJson(Map<String, dynamic> json) {
    user =
        json['user'] != null ?  TrendingUser.fromJson(json['user'],json['userPic']) : null;
    if (json['dashboard'] != null) {
      dashboard =  <Dashboard>[];
      json['dashboard'].forEach((v) {
        dashboard.add( Dashboard.fromJson(v));
      });
    }
    userPic = json['userPic'];
    postPic = json['postPic'];
    if (json['trending'] != null) {
      trending = <Trending>[];
      json['trending'].forEach((v) {
        trending.add(Trending.fromJson(v,json['userPic']));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user.toJson();
    }
    if (dashboard != null) {
      data['dashboard'] = dashboard.map((v) => v.toJson()).toList();
    }
    data['userPic'] = userPic;
    data['postPic'] = postPic;
    if (trending != null) {
      data['trending'] = trending.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Dashboard {
  String album;
  List<DashboardData> data;
  List<CommentsModel> comments=[];
  //List<CommentsModel> comments=[];
  List<LikeModel> likes=[];
  List<TribeModel> tribe=[];
  bool isLiked;
  bool isBlocked;
  String likedId;

  Dashboard({this.album, this.data,this.likes,this.isLiked,this.comments,this.likedId,this.tribe,this.isBlocked});

  Dashboard.fromJson(Map<String, dynamic> json) {
    album = json['album'];
    isBlocked = json['isBlocked'];
    if (json['data'] != null) {
      // ignore: deprecated_member_use
      data = <DashboardData>[];
      json['data'].forEach((v) {
        data.add(DashboardData.fromJson(v));
      });
    }
    if (json['comment'] != null) {
      comments = [];
      json['comment'].forEach((v) {
        comments.add(CommentsModel.fromJson(v));
      });
    }
    if (json['like'] != null) {
      likes = [];
      json['like'].forEach((v) {
        likes.add(LikeModel.fromJson(v));
      });
    }
    if (json['tribe'] != null) {
      tribe = [];
      json['tribe'].forEach((v) {
        tribe.add(TribeModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['album'] = album;
    data['isBlocked'] = isBlocked;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.comments != null) {
      data['comment'] = this.comments.map((v) => v.toJson()).toList();
    }
    if (this.likes != null) {
      data['like'] = this.likes.map((v) => v.toJson()).toList();
    }
    if (this.tribe != null) {
      data['tribe'] = this.tribe.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DashboardData {
  String type;
  String album;
  String sId;
  String userId;
  String postId;
  String file;
  String thumb;
  int iV;
  String createdAt;
  String updatedAt;
  String caption;

  DashboardData(
      {this.type,
      this.album,
      this.sId,
      this.userId,
      this.postId,
      this.file,
      this.iV,
      this.createdAt,
      this.updatedAt,this.thumb,this.caption,
      });

  DashboardData.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    album = json['album'];
    sId = json['_id'];
    userId = json['userId'];
    postId = json['postId'];
    file = json['file'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    thumb = json['thumb'];
    caption = json['caption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['album'] = album;
    data['_id'] = sId;
    data['userId'] = userId;
    data['postId'] = postId;
    data['file'] = file;
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['thumb'] = thumb;
    data['caption'] = caption;
    return data;
  }
}

class Trending {
  DashboardData post;
  TrendingUser user;

  Trending({this.post, this.user});

  Trending.fromJson(Map<String, dynamic> json,String serverUrl) {
    post =
        json['post'] != null ? DashboardData.fromJson(json['post']) : null;
    user =
        json['user'] != null ? TrendingUser.fromJson(json['user'],serverUrl) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (post != null) {
      data['post'] = post.toJson();
    }
    if (user != null) {
      data['user'] = user.toJson();
    }
    return data;
  }
}

class TrendingUser {
  String email;
  String countryCode;
  int phone;
  String profileImage;
  String gender;
  String relationship;
  String verificationOTP;
  String fpOTP;
  int badgeCount;
  String sId;
  String fullName;
  String password;
  String status;
  String userLoginType;
  String dateOfBirth;
  String createdAt;
  String updatedAt;
  int iV;

  TrendingUser(
      {this.email,
      this.countryCode,
      this.phone,
      this.profileImage,
      this.gender,
      this.relationship,
      this.verificationOTP,
      this.fpOTP,
      this.badgeCount,
      this.sId,
      this.fullName,
      this.password,
      this.status,
      this.userLoginType,
      this.dateOfBirth,
      this.createdAt,
      this.updatedAt,
      this.iV});

  TrendingUser.fromJson(Map<String, dynamic> json,String serverUrl) {
    email = json['email'];
    countryCode = json['countryCode'];
    phone = json['phone'];
    profileImage = /*serverUrl+*/json['profileImage'];
    gender = json['gender'];
    relationship = json['relationship'];
    verificationOTP = json['verificationOTP'];
    fpOTP = json['fpOTP'];
    badgeCount = json['badgeCount'];
    sId = json['_id'];
    fullName = json['fullName'];
    password = json['password'];
    status = json['status'];
    userLoginType = json['userLoginType'];
    dateOfBirth = json['dateOfBirth'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
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
    data['_id'] = sId;
    data['fullName'] = fullName;
    data['password'] = password;
    data['status'] = status;
    data['userLoginType'] = userLoginType;
    data['dateOfBirth'] = dateOfBirth;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class CreatePost {
  String caption;
  String postType;
  String audience;
  List<String> tribe;
  String sId;
  String userId;
  String createdAt;
  String updatedAt;
  int iV;
  String file;
  CreatePost(
      {this.caption,
      this.postType,
      this.audience,
      this.tribe,
      this.file,
      this.sId,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  CreatePost.fromJson(Map<String, dynamic> json) {
    caption = json['caption'];
    postType = json['postType'];
    audience = json['audience'];
    tribe = json['tribe'].cast<String>();
    sId = json['_id'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    file = json['file'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['caption'] = caption;
    data['postType'] = postType;
    data['audience'] = audience;
    data['tribe'] = tribe;
    data['_id'] = sId;
    data['userId'] = userId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['file'] = file;
    return data;
  }
}

class TribeModel {
  String createdAt;
  String id;

  TribeModel({this.createdAt, this.id, /*this.likedBy*/});

  TribeModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_At'];
    id = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['created_At'] = this.createdAt;
    data['_id'] = this.id;
 /*   if (this.likedBy != null) {
      data['likedBy'] = this.likedBy.toJson();
    }*/
    return data;
  }

}
