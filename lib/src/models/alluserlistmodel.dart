class AllUserListModel {
  bool success;
  int sTATUSCODE;
  String message;
  UserListData responseData;

  AllUserListModel(
      {this.success, this.sTATUSCODE, this.message, this.responseData});

  AllUserListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    sTATUSCODE = json['STATUSCODE'];
    message = json['message'];
    responseData = json['response_data'] != null
        ? new UserListData.fromJson(json['response_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['STATUSCODE'] = this.sTATUSCODE;
    data['message'] = this.message;
    if (this.responseData != null) {
      data['response_data'] = this.responseData.toJson();
    }
    return data;
  }
}

class UserListData {
  List<AllUserData> data;
  String userImageUrl;

  UserListData({this.data, this.userImageUrl});

  UserListData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<AllUserData>();
      json['data'].forEach((v) {
        data.add(new AllUserData.fromJson(v));
      });
    }
    userImageUrl = json['userImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['userImageUrl'] = this.userImageUrl;
    return data;
  }
}

class AllUserData {
  String profileImage;
  String fullName;
  String userId;
  bool _isSelected=false;

  set isSelected(bool value) {
    _isSelected = value;
  }

  bool get isSelected => _isSelected;

  AllUserData({this.profileImage, this.fullName, this.userId});

  AllUserData.fromJson(Map<String, dynamic> json) {
    profileImage = json['profileImage'];
    fullName = json['fullName'];
    userId = json["userId"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileImage'] = this.profileImage;
    data['fullName'] = this.fullName;
    data['userId'] = this.userId;
    return data;
  }
}
