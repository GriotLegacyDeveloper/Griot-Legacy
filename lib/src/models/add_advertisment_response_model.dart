class AddAdvertismentResponseData {
  bool success;
  int sTATUSCODE;
  String message;
  List<ResponseData1> responseData;

  AddAdvertismentResponseData(
      {this.success, this.sTATUSCODE, this.message, this.responseData});

  AddAdvertismentResponseData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    sTATUSCODE = json['STATUSCODE'];
    message = json['message'];
    if (json['response_data'] != null) {
      responseData = <ResponseData1>[];
      json['response_data'].forEach((v) {
        responseData.add(ResponseData1.fromJson(v));
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

class ResponseData1 {
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
  int iV;
  String createdAt;
  String updatedAt;

  ResponseData1(
      {this.companyName,
        this.contactPerson,
        this.emailAddress,
        this.phoneNumber,
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

  ResponseData1.fromJson(Map<String, dynamic> json) {
    companyName = json['companyName'];
    contactPerson = json['contactPerson'];
    emailAddress = json['emailAddress'];
    phoneNumber = json['phoneNumber'];
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
