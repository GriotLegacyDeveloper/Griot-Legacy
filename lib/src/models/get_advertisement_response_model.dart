class GetAdvertisementResponsemodel {
  bool success;
  int sTATUSCODE;
  String message;
  int advertisementCount;
  List<ResponseData> responseData;

  GetAdvertisementResponsemodel(
      {this.success,
        this.sTATUSCODE,
        this.message,
        this.advertisementCount,
        this.responseData});

  GetAdvertisementResponsemodel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    sTATUSCODE = json['STATUSCODE'];
    message = json['message'];
    advertisementCount = json['advertisementCount'];
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
    data['advertisementCount'] = advertisementCount;
    if (responseData != null) {
      data['response_data'] =
          responseData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResponseData {
  String companyName;
  String contactPerson;
  String emailAddress;
  int phoneNumber;
  String physicalAddress;
  String purposeOfAdvertisement;
  String image;
  String description;
  String link;
  String title;
  String targetAudience;
  String status;
  String sId;
  String userId;
  String validFrom;
  String validTill;
  String countryCode;
  int iV;
  String createdAt;
  String updatedAt;

  ResponseData(
      {this.companyName,
        this.contactPerson,
        this.emailAddress,
        this.phoneNumber,
        this.countryCode,
        this.physicalAddress,
        this.purposeOfAdvertisement,
        this.image,
        this.description,
        this.link,
        this.title,
        this.targetAudience,
        this.status,
        this.sId,
        this.userId,
        this.validFrom,
        this.validTill,
        this.iV,
        this.createdAt,
        this.updatedAt});

  ResponseData.fromJson(Map<String, dynamic> json) {
    companyName = json['companyName'];
    contactPerson = json['contactPerson'];
    emailAddress = json['emailAddress'];
    phoneNumber = json['phoneNumber'];
    countryCode = json['countryCode'];
    physicalAddress = json['physicalAddress'];
    purposeOfAdvertisement = json['purposeOfAdvertisement'];
    image = json['image'];
    description = json['description'];
    link = json['link'];
    title = json['title'];
    targetAudience = json['targetAudience'];
    status = json['status'];
    sId = json['_id'];
    userId = json['userId'];
    validFrom = json['validFrom'];
    validTill = json['validTill'];
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['companyName'] = companyName;
    data['contactPerson'] = contactPerson;
    data['countryCode'] = countryCode;
    data['emailAddress'] = emailAddress;
    data['phoneNumber'] = phoneNumber;
    data['physicalAddress'] = physicalAddress;
    data['purposeOfAdvertisement'] = purposeOfAdvertisement;
    data['image'] = image;
    data['description'] = description;
    data['link'] = link;
    data['title'] = title;
    data['targetAudience'] = targetAudience;
    data['status'] = status;
    data['_id'] = sId;
    data['userId'] = userId;
    data['validFrom'] = validFrom;
    data['validTill'] = validTill;
    data['__v'] = iV;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
