class TokenCreateResponseModel {
  bool success;
  int sTATUSCODE;
  String message;
  List<ResponseData> responseData;

  TokenCreateResponseModel(
      {this.success, this.sTATUSCODE, this.message, this.responseData});

  TokenCreateResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    sTATUSCODE = json['STATUSCODE'];
    message = json['message'];
    if (json['response_data'] != null) {
      responseData = <ResponseData>[];
      json['response_data'].forEach((v) {
        responseData.add(ResponseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['STATUSCODE'] = sTATUSCODE;
    data['message'] = message;
    if (responseData != null) {
      data['response_data'] =
          responseData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResponseData {
  String token;

  ResponseData({this.token});

  ResponseData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    return data;
  }
}
