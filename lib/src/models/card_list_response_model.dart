class CardListResponseModel {
  bool success;
  int sTATUSCODE;
  String message;
  List<ResponseDataofCardList> responseData;

  CardListResponseModel(
      {this.success, this.sTATUSCODE, this.message, this.responseData});

  CardListResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    sTATUSCODE = json['STATUSCODE'];
    message = json['message'];
    if (json['response_data'] != null) {
      responseData = <ResponseDataofCardList>[];
      json['response_data'].forEach((v) {
        responseData.add(ResponseDataofCardList.fromJson(v));
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

class ResponseDataofCardList {
  String name;
  String cardId;
  String cardType;
  String country;
  String stripeAccountId;
  int expMonth;
  int expYear;
  String last4;
  String isDefault;
  bool isSelect;
  bool isNoSelect;

  ResponseDataofCardList(
      {this.name,
        this.cardId,
        this.cardType,
        this.country,
        this.stripeAccountId,
        this.expMonth,
        this.expYear,
        this.last4,
        this.isDefault,this.isSelect,this.isNoSelect});

  ResponseDataofCardList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    cardId = json['card_id'];
    cardType = json['card_type'];
    country = json['country'];
    stripeAccountId = json['StripeAccountId'];
    expMonth = json['exp_month'];
    expYear = json['exp_year'];
    last4 = json['last4'];
    isDefault = json['isDefault'];
    isSelect = json['isSelect'];
    isNoSelect = json['isNoSelect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['card_id'] = cardId;
    data['card_type'] = cardType;
    data['country'] = country;
    data['StripeAccountId'] = stripeAccountId;
    data['exp_month'] = expMonth;
    data['exp_year'] = expYear;
    data['last4'] = last4;
    data['isDefault'] = isDefault;
    data['isNoSelect'] = isNoSelect;
    return data;
  }
}
