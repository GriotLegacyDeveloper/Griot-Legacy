class CheckFareResponseModel {
  bool success;
  int sTATUSCODE;
  String message;
  ResponseData responseData;

  CheckFareResponseModel(
      {this.success, this.sTATUSCODE, this.message, this.responseData});

  CheckFareResponseModel.fromJson(Map<String, dynamic> json) {
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
  String advertisementId;
  String userId;
  int numberOfDays;
  String pricePerDay;
  int totalCost;

  ResponseData(
      {this.advertisementId,
        this.userId,
        this.numberOfDays,
        this.pricePerDay,
        this.totalCost});

  ResponseData.fromJson(Map<String, dynamic> json) {
    advertisementId = json['advertisementId'];
    userId = json['userId'];
    numberOfDays = json['numberOfDays'];
    pricePerDay = json['pricePerDay'];
    totalCost = json['totalCost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['advertisementId'] = advertisementId;
    data['userId'] = userId;
    data['numberOfDays'] = numberOfDays;
    data['pricePerDay'] = pricePerDay;
    data['totalCost'] = totalCost;
    return data;
  }
}
