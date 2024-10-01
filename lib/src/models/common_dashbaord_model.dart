import 'comment_model.dart';
import 'like_model.dart';

class DashBoradCommonModel {
  String album;
  String postType;
  List<Data> data;
  Post post;
  List<LikeModel> like;
  List<CommentsModel> comment;
  User user;

  String image;
  String link;
  String title;
  String sId;
  String imageKey;
  String validFrom;
  String validTill;
  String trimmedValidFrom;
  String trimmedValidTill;



  DashBoradCommonModel(
      {this.album,
        this.postType,
        this.data,
        this.post,
        this.like,
        this.comment,
        this.user,
        this.image,
        this.link,
        this.title,
        this.sId,
        this.imageKey,
        this.validFrom,
        this.validTill,
        this.trimmedValidFrom,
        this.trimmedValidTill});

  DashBoradCommonModel.fromJson(Map<String, dynamic> json) {
    album = json['album'];
    postType = json['postType'];



    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
    post = json['post'] != null ? Post.fromJson(json['post']) : null;
    if (json['like'] != null) {
      like = <Null>[];
      json['like'].forEach((v) {
        like.add(LikeModel.fromJson(v));
      });
    }
    if (json['comment'] != null) {
      comment = <Null>[];
      json['comment'].forEach((v) {
        comment.add( CommentsModel.fromJson(v));
      });
    }
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    image = json['image'];
    link = json['link'];
    title = json['title'];
    sId = json['_id'];
    imageKey = json['imageKey'];
    validFrom = json['validFrom'];
    validTill = json['validTill'];
    trimmedValidFrom = json['trimmedValidFrom'];
    trimmedValidTill = json['trimmedValidTill'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['album'] = this.album;
    data['postType'] = this.postType;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.post != null) {
      data['post'] = this.post.toJson();
    }
    if (this.like != null) {
      data['like'] = this.like.map((v) => v.toJson()).toList();
    }
    if (this.comment != null) {
      data['comment'] = this.comment.map((v) => v.toJson()).toList();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }

    data['image'] = this.image;
    data['link'] = this.link;
    data['title'] = this.title;
    data['_id'] = this.sId;
    data['imageKey'] = this.imageKey;
    data['validFrom'] = this.validFrom;
    data['validTill'] = this.validTill;
    data['trimmedValidFrom'] = this.trimmedValidFrom;
    data['trimmedValidTill'] = this.trimmedValidTill;
    return data;
  }
}

class Data {
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

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['type'] = this.type;
    data['thumb'] = this.thumb;
    data['caption'] = this.caption;
    data['album'] = this.album;
    data['arrange'] = this.arrange;
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['postId'] = this.postId;
    data['file'] = this.file;
    data['__v'] = this.iV;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Post {
  String caption;
  String postType;
  String audience;
  List<String> tribe;
  List<LikeModel> likes;
  List<CommentsModel> comments;
  String sId;
  String userId;
  String createdAt;
  String updatedAt;
  int iV;

  Post(
      {this.caption,
        this.postType,
        this.audience,
        this.tribe,
        this.likes,
        this.comments,
        this.sId,
        this.userId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Post.fromJson(Map<String, dynamic> json) {
    caption = json['caption'];
    postType = json['postType'];
    audience = json['audience'];
    tribe = json['tribe'].cast<String>();
    if (json['likes'] != null) {
      likes = <Null>[];
      json['likes'].forEach((v) {
        likes.add( LikeModel.fromJson(v));
      });
    }
/*    if (json['share'] != null) {
      share = <Null>[];
      json['share'].forEach((v) {
        share.add( Null.fromJson(v));
      });
    }*/
    if (json['comments'] != null) {
      comments = <Null>[];
      json['comments'].forEach((v) {
        comments.add( CommentsModel.fromJson(v));
      });
    }
    sId = json['_id'];
    userId = json['userId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['caption'] = this.caption;
    data['postType'] = this.postType;
    data['audience'] = this.audience;
    data['tribe'] = this.tribe;
    if (this.likes != null) {
      data['likes'] = this.likes.map((v) => v.toJson()).toList();
    }
  /*  if (this.share != null) {
      data['share'] = this.share.map((v) => v.toJson()).toList();
    }*/
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class User {
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

  User(
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

  User.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['email'] = this.email;
    data['countryCode'] = this.countryCode;
    data['phone'] = this.phone;
    data['profileImage'] = this.profileImage;
    data['gender'] = this.gender;
    data['relationship'] = this.relationship;
    data['verificationOTP'] = this.verificationOTP;
    data['fpOTP'] = this.fpOTP;
    data['badgeCount'] = this.badgeCount;
    data['notificationCount'] = this.notificationCount;
    data['profile'] = this.profile;
    data['notification'] = this.notification;
    data['_id'] = this.sId;
    data['fullName'] = this.fullName;
    data['password'] = this.password;
    data['status'] = this.status;
    data['userLoginType'] = this.userLoginType;
    data['dateOfBirth'] = this.dateOfBirth;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['lastLogin'] = this.lastLogin;
    return data;
  }
}
