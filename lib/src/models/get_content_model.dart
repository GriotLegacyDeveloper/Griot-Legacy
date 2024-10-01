class ContentResponseModel {
  bool success;
  int sTATUSCODE;
  String message;
  ResponseData responseData;

  ContentResponseModel(
      {this.success, this.sTATUSCODE, this.message, this.responseData});

  ContentResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    sTATUSCODE = json['STATUSCODE'];
    message = json['message'];
    responseData = json['response_data'] != null
        ? ResponseData.fromJson(json['response_data'])
        : null;
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

class ResponseData {
  Content content;

  ResponseData({this.content});

  ResponseData.fromJson(Map<String, dynamic> json) {
    content =
    json['content'] != null ? Content.fromJson(json['content']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (content != null) {
      data['content'] = content.toJson();
    }
    return data;
  }
}

class Content {
  String title;
  String slug;
  String description;
  String sId;
  String createdAt;
  String updatedAt;

  Content(
      {this.title,
        this.slug,
        this.description,
        this.sId,
        this.createdAt,
        this.updatedAt});

  Content.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    slug = json['slug'];
    description = json['description'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['slug'] = slug;
    data['description'] = description;
    data['_id'] = sId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
