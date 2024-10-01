import 'package:griot_legacy_social_media_app/src/models/comment_model.dart';

class LikeModel {
  String createdAt;
  String id;
  CreatedBy likedBy;

  LikeModel({this.createdAt, this.id, this.likedBy});

  LikeModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_At'];
    id = json['_id'];
    likedBy =json['likedBy'] != null ? new CreatedBy.fromJson(json['likedBy']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_At'] = this.createdAt;
    data['_id'] = this.id;
    if (this.likedBy != null) {
      data['likedBy'] = this.likedBy.toJson();
    }
    return data;
  }

}