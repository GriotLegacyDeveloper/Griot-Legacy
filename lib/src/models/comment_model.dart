class CommentsModel {
  String createdAt;
  String sId;
  String comment;
  CreatedBy commentedBy;

  CommentsModel({this.createdAt, this.sId, this.comment, this.commentedBy});

  CommentsModel.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_At'];
    sId = json['_id'];
    comment = json['comment'];
    commentedBy = json['commentedBy'] != null
        ? CreatedBy.fromJson(json['commentedBy'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['created_At'] = this.createdAt;
    data['_id'] = this.sId;
    data['comment'] = this.comment;
    if (this.commentedBy != null) {
      data['commentedBy'] = this.commentedBy.toJson();
    }
    return data;
  }
}

class CreatedBy {
  String fullName;
  String profileImage;
  String sId;
  String email;

  CreatedBy({this.fullName,this.sId, this.email,this.profileImage});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    profileImage = json['profileImage'];
    sId = json['_id'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['profileImage'] = this.profileImage;
    data['_id'] = this.sId;
    data['email'] = this.email;
    return data;
  }

}