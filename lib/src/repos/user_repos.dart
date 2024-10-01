import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:griot_legacy_social_media_app/src/models/block_tribe_list_response_model.dart';
import 'package:griot_legacy_social_media_app/src/models/get_content_model.dart';
import 'package:griot_legacy_social_media_app/src/models/home_data_model.dart';
import 'package:griot_legacy_social_media_app/src/repos/block_list_response_model.dart';
import 'package:griot_legacy_social_media_app/src/utils/constant_class.dart';
import 'package:http/http.dart' as http;
import 'package:global_configuration/global_configuration.dart';
import 'package:griot_legacy_social_media_app/src/models/reply.dart';
import 'package:griot_legacy_social_media_app/src/models/user.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/add_advertisment_response_model.dart';
import '../models/all_friends_list_response_model.dart';
import '../models/apple_pay_response_model.dart';
import '../models/card_list_response_model.dart';
import '../models/chat_listing_response_model.dart';
import '../models/check_fare_response_model.dart';
import '../models/create_group_response_model.dart';
import '../models/get_advertisement_response_model.dart';
import '../models/get_all_group_message_response_model.dart';
import '../models/get_setting_response_model.dart';
import '../models/get_storage_list_response_model.dart';
import '../models/one_to_one_message_list_response_model.dart';
import '../models/paypal_response_model.dart';
import '../models/send_message_group_response_model.dart';
import '../models/send_message_response_model.dart';
import '../models/set_default_card_response_model.dart';
import '../models/token_create_response_model.dart';
import '../models/track_order_response_model.dart';
import '../models/update_setting_response_model.dart';
import 'dashboardResponseModel.dart';
import 'other_user_response_model.dart';


final gc = GlobalConfiguration();
final sharedPrefs = SharedPreferences.getInstance();
Future<Reply> login(Map<String, dynamic> body) async {
  final response = await post(
      //Uri.parse("https://nodeserver.mydevfactory.com:2109/api/user/login"),
      Uri.parse(Constant.LOGIN_URL),
      body: body);
  //print("response    ${response.body}");
  return Reply.fromMap(json.decode(response.body));
}

Future<Reply> resetPassword(Map<String, dynamic> body) async {
  final response = await post(
      // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/user/resetPassword"),
      Uri.parse(Constant.RESET_PASSWORD_URL),
      body: body);
  return Reply.fromMap(json.decode(response.body));
}

Future<Reply> changePassword(Map<String, dynamic> body) async {
  final prefs = await sharedPrefs;

  final response =
      await post(Uri.parse(Constant.changePasswordUrl), body: body, headers: {
    HttpHeaders.authorizationHeader: "Bearer " + prefs.getString("spAuthToken")
  });
  return Reply.fromMap(json.decode(response.body));
}

Future<Reply> logout(Map<String, dynamic> body) async {
  try {
    final response = await post(Uri.parse(Constant.LOGOUT_URL),

        //Uri.parse("https://nodeserver.mydevfactory.com:2109/api/user/logout"),
        body: body);
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}


Future<Reply> deleteAccount(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    print("hhhhhhhhh");
    final response =
        await post(Uri.parse(Constant.deleteAccountUrl), body: body, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + prefs.getString("spAuthToken"),
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    });
    print("bbbbb $response");
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<Reply> register(Map<String, dynamic> body) async {
  final response = await post(Uri.parse(Constant.REGISTER_URL), body: body);
  return Reply.fromMap(json.decode(response.body));
}

Future<Reply> cardSave(Map<String, dynamic> body) async {
  final response = await post(Uri.parse(Constant.cardSaveUrl),

      //Uri.parse("https://nodeserver.mydevfactory.com:2109/api/" + "user/register"),
      body: body);
  return Reply.fromMap(json.decode(response.body));
}

Future<Reply> deleteAds(Map<String, dynamic> body) async {
  print("body   ${body}");
  try {
    final prefs = await sharedPrefs;

    final response =
        await post(Uri.parse(Constant.deleteAdsUrl), body: body, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + prefs.getString("spAuthToken"),
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    });
    print("response   ${response.body}");
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}
Future<Reply> cancelAds(Map<String, dynamic> body) async {
  print("body   ${body}");
  try {
    final prefs = await sharedPrefs;

    final response =
    await post(Uri.parse(Constant.cancelAdsUrl), body: body, headers: {
      HttpHeaders.authorizationHeader:
      "Bearer " + prefs.getString("spAuthToken"),
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    });
    print("response   ${response.body}");
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<Reply> makePayment(Map<String, dynamic> body) async {
  final response = await post(Uri.parse(Constant.customerPaymentUrl),

      //Uri.parse("https://nodeserver.mydevfactory.com:2109/api/" + "user/register"),
      body: body);
  return Reply.fromMap(json.decode(response.body));
}

Future<Reply> cardDelete(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    print("prefs.getString  ${prefs.getString("spAuthToken")}");
    final response =
        await post(Uri.parse(Constant.cardDeleteUrl), body: body, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + prefs.getString("spAuthToken"),
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    });
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<StoreDetailsResponseModel> defaultCard(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    print("prefs.getString  ${prefs.getString("spAuthToken")}");
    final response = await post(
      Uri.parse(Constant.defaultCardSetUrl),
      body: body,
    );
    return StoreDetailsResponseModel.fromJson(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<PayPalResponseModel> makePaypalPayment(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;

    final response = await post(Uri.parse(Constant.payPalPaymentUrl),

        //Uri.parse("https://nodeserver.mydevfactory.com:2109/api/" + "user/register"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken"),
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        });
    log(response.body);
    return PayPalResponseModel.fromJson(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<ApplePayResponseModel> applePayPayment(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;

    final response = await post(Uri.parse(Constant.successApplePayUrl),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken"),
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        });
    log(response.body);
    return ApplePayResponseModel.fromJson(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<Reply> contactUs(Map<String, dynamic> body) async {
  final response = await post(Uri.parse(Constant.contactUsUrl),

      //Uri.parse("https://nodeserver.mydevfactory.com:2109/api/" + "user/register"),
      body: body);
  return Reply.fromMap(json.decode(response.body));
}

Future<Reply> verifyOTP(Map<String, dynamic> body, String api) async {
  try {
    //print("1111111;");

    final url = Uri.parse(Constant.BASEURL + Constant.USER + api);
    //print("url111111;");
    // Uri.parse(Constant.CUSTOMER_VERIFY_USER_URL);
    // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/" + "user/$api");
    // print(api);
    final response = await post(url, body: body);
    //print(response.body);
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    // print(e);
    rethrow;
  }
}

Future<User> getUserData(Map<String, dynamic> body) async {
  // print("body   $body");
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.VIEW_PROFILE_URL),

        // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/" + "user/viewProfile"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    print("viewProfile ${response.body} $response");

    return User.fromJSON(Reply.fromMap(json.decode(response.body)).data);
  } catch (e) {
    rethrow;
  }
}

Future<OtherUserProfileResponseModel> getOtherUserData(
    Map<String, dynamic> body) async {
  print("body//....   $body");
  try {
    final prefs = await sharedPrefs;
    print("prefs.getString   ${prefs.getString("spAuthToken")}");

    final response = await post(Uri.parse(Constant.otherUserProfileUrl),

        // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/" + "user/viewProfile"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });

    log(response.body);
    return OtherUserProfileResponseModel.fromJson(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<DashboardResponseModel> getDashboardData(
    Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    print(" ${prefs.getString("spAuthToken")}");
    print("body//   $body");

    final response = await post(Uri.parse(Constant.dashboardUrl),

        // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/" + "user/viewProfile"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken"),
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        });
    log(response.body);

    return DashboardResponseModel.fromJson(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<GetStoragePackageResponseModel> storagePackages(
    Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    print(" ${prefs.getString("spAuthToken")}");
    print("body//   $body");

    final response = await post(Uri.parse(Constant.getStoragePackUrl),

        // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/" + "user/viewProfile"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
          "Bearer " + prefs.getString("spAuthToken"),
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        });
    log(response.body);

    return GetStoragePackageResponseModel.fromJson(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<GetAdvertisementResponsemodel> getAdvertisemnetData(
    Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    print(" ${prefs.getString("spAuthToken")}");
    print("body//   $body");

    final response = await post(Uri.parse(Constant.getAdsUrl),
        // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/" + "user/viewProfile"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken"),
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        });
    log(response.body);

    return GetAdvertisementResponsemodel.fromJson(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<AddAdvertismentResponseData> addAdvertisement(
    /*Map<String, String> body, */ String filePath,
    String companyName,
    String contactPerson,
    String email,
    String countryCode,
    String phone,
    String address,
    String purposeOdAdv,
    String discription,
    String link,
    String title,
    String validFromController,
    String validTillController,
    String targetAudienceController,
    String useriD,
    String loginID) async {
  final body = {
    "userId": useriD,
    "loginId": loginID,
    "companyName": companyName,
    "appType": Platform.isAndroid ? "ANDROID" : (Platform.isIOS ? "IOS" : "BROWSER"),
    "contactPerson": contactPerson,
    "emailAddress": email,
    "countryCode": countryCode,
    "phoneNumber": phone,
    "physicalAddress": address,
    "purposeOfAdvertisement": purposeOdAdv,
    "description": discription,
    "link": link,
    "title": title,
    "validFrom": validFromController,
    "validTill": validTillController,
    "targetAudience": targetAudienceController,
  };
  var request = http.MultipartRequest('POST', Uri.parse(Constant.createAdsUrl));
  request.fields.addAll(body);
  request.files.add(await http.MultipartFile.fromPath('image', filePath));
  http.StreamedResponse response = await request.send();
  String resp;
  if (response.statusCode == 200) {
    resp = await response.stream.bytesToString();
    print("succcccc $resp");
  } else {}
  return AddAdvertismentResponseData.fromJson(json.decode(resp));
}

Future<GetAdvertisementResponsemodel> editAdvertisement(
    /*Map<String, String> body, */ String filePath,
    String companyName,
    String contactPerson,
    String email,
    String countryCode,
    String phone,
    String address,
    String purposeOdAdv,
    String discription,
    String link,
    String title,
    String validFromController,
    String validTillController,
    String targetAudienceController,
    String useriD,
    String loginID,
    String advertisementId) async {
  final body = {
    "userId": useriD,
    "loginId": loginID,
    "advertisementId":advertisementId,
    "companyName": companyName,
    "appType": Platform.isAndroid ? "ANDROID" : (Platform.isIOS ? "IOS" : "BROWSER"),
    "contactPerson": contactPerson,
    "emailAddress": email,
    "countryCode": countryCode,
    "phoneNumber": phone,
    "physicalAddress": address,
    "purposeOfAdvertisement": purposeOdAdv,
    "description": discription,
    "link": link,
    "title": title,
    "validFrom": validFromController,
    "validTill": validTillController,
    "targetAudience": targetAudienceController,
  };
  print("edit.....$body....\nConstant.editAdsUrl${Constant.editAdsUrl} ");
  var request = http.MultipartRequest('POST', Uri.parse(Constant.editAdsUrl));
  request.fields.addAll(body);
  print("edit....1111");
  if(filePath!=null) request.files.add(await http.MultipartFile.fromPath('image', filePath));
  print("edit....22222");
  http.StreamedResponse response = await request.send();
  String resp;
  print("edit......... $resp");
  if (response.statusCode == 200) {
    resp = await response.stream.bytesToString();
    print("succcccc $resp");
  } else {}
  return GetAdvertisementResponsemodel.fromJson(json.decode(resp));
}

Future<CheckFareResponseModel> checkFareData(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    print(" ${prefs.getString("spAuthToken")}");
    print("body//   $body");

    final response =
        await post(Uri.parse(Constant.checkFareApi), body: body, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + prefs.getString("spAuthToken"),
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    });
    log(response.body);

    return CheckFareResponseModel.fromJson(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<CardListResponseModel> cardListData(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    print(" ${prefs.getString("spAuthToken")}");
    print("body//   $body");

    final response =
        await post(Uri.parse(Constant.cardListUrl), body: body, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + prefs.getString("spAuthToken"),
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    });

    log(response.body);

    return CardListResponseModel.fromJson(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<BlockListResponseModel> getBlockList(Map<String, dynamic> body) async {
  // print("body   $body");
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.blockListUserUrl),

        // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/" + "user/viewProfile"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    print("response  ${json.decode(response.body)}");
    return BlockListResponseModel.fromJson(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<BlockTribeListResponseModel> getBlockTribeList(
    Map<String, dynamic> body) async {
  // print("body   $body");
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.blockTribeListUrl),

        // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/" + "user/viewProfile"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    //print("response  ${json.decode(response.body)}");
    return BlockTribeListResponseModel.fromJson(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<HomeResponseModel> getHomeData(Map<String, dynamic> body) async {
  //print(body);
  try {
    final prefs = await sharedPrefs;
    print("token    ${prefs.getString("spAuthToken")} $body");
    final response = await post(Uri.parse(Constant.HOME_URL),
        // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/post/home"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken"),
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        });
    // print("profile URL... ${prefs.getString("spAuthToken")}");
    print("profile detail... ${response.body}");
    log(response.body);
    return HomeResponseModel.fromJson(json.decode(response.body));
  } catch (e) {
    //  print("e......  $e");
    rethrow;
  }
}

Future<Reply> getNotificationData(Map<String, dynamic> body) async {
  //print(body);
  try {
    final prefs = await sharedPrefs;
    //  print("token    ${prefs.getString("spAuthToken")} $body");
    final response = await post(Uri.parse(Constant.notificationUrl),

        // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/post/home"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    //print(response.body);
    log(response.body);
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    //print(e);
    rethrow;
  }
}

Future<Reply> updateProfile(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.UPDATE_PROFILE_URL),

        //Uri.parse("https://nodeserver.mydevfactory.com:2109/api/" + "user/updateProfile"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<Reply> reportPost(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.reportPostUrl),

        //Uri.parse("https://nodeserver.mydevfactory.com:2109/api/" + "user/updateProfile"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<Reply> reportUser(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.reportUserUrl),

        //Uri.parse("https://nodeserver.mydevfactory.com:2109/api/" + "user/updateProfile"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    print("responseresponse $body ");

    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<Reply> getOtp(Map<String, dynamic> body, String url) async {
  try {
    //
    //final prefs = await sharedPrefs;
    final response = await post(
      Uri.parse(url),
      body: body,
    );
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<Reply> uploadProfileImage(
    Map<String, String> body, String filePath) async {
  var request = http.MultipartRequest(
      'POST', Uri.parse(Constant.PROFILE_IMAGE_UPLOAD_URL));

  // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/" + "user/profileImageUpload"));
  request.fields.addAll(body);
  request.files.add(await http.MultipartFile.fromPath('image', filePath));
  http.StreamedResponse response = await request.send();
  String resp;
  if (response.statusCode == 200) {
    resp = await response.stream.bytesToString();
  } else {
    // print(response.reasonPhrase);
  }
  return Reply.fromMap(json.decode(resp));
  /*try {
    final prefs = await sharedPrefs;
    final response = await post(
      Uri.parse("https://nodeserver.mydevfactory.com:2109/api/"+ "user/profileImageUpload"),
      body: body,
    );
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }*/
}

/*uplaof group photo*/

Future<Reply> uploadGroupImage(
    Map<String, String> body, String filePath) async {
  var request =
      http.MultipartRequest('POST', Uri.parse(Constant.displayImageUploadUrl));
  request.fields.addAll(body);

  request.files.add(await http.MultipartFile.fromPath('image', filePath));
  http.StreamedResponse response = await request.send();
  String resp;
  if (response.statusCode == 200) {
    resp = await response.stream.bytesToString();
  } else {
    //print(response.reasonPhrase);
  }
  return Reply.fromMap(json.decode(resp));
}

//-----------------------------------------------------------------------------------------------------

Future<Reply> searchUser(Map<String, dynamic> body) async {
  try {
    // final prefs = await sharedPrefs;
    final response = await post(
      Uri.parse(Constant.SEARCH_USER_URL),

      // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/user/searchUser"),
      body: body,
    );
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<Reply> sendInvitation(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.sendInvitationUrl),

        // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/user/searchUser"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<Reply> acceptRejectInvitation(Map<String, dynamic> body) async {
  try {
    // print("body...  $body");
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.acceptUrl),

        // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/user/searchUser"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<Reply> createTribe(Map<String, String> body, image) async {
  http.StreamedResponse response;
  try {
    final prefs = await sharedPrefs;
    final token = prefs.getString("spAuthToken");
    //print(token);
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse(Constant.CREATE_TRIBE_URL));

    //  Uri.parse('https://nodeserver.mydevfactory.com:2109/api/tribe/createTribe'));
    request.fields.addAll(body);
    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }
    request.headers.addAll(headers);

    response = await request.send();

    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      // print(response.reasonPhrase);
    } else {
      // print(response.reasonPhrase);
    }

    return Reply.fromMap(json.decode(await response.stream.bytesToString()));
  } catch (e) {
    rethrow;
  }
}

Future<Reply> getTribeList(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.TRIBE_LIST_URL),

        //  Uri.parse("https://nodeserver.mydevfactory.com:2109/api/tribe/tribeList"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<Reply> leaveTribe(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    // print("inside1111111");
    final response = await post(Uri.parse(Constant.leaveTribeApiUrl),

        //  Uri.parse("https://nodeserver.mydevfactory.com:2109/api/tribe/tribeList"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    //print("inside2222222");

    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    // print("errrrrr");

    rethrow;
  }
}

Future<Reply> deletePost(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    //  print("inside1111111");
    final response = await post(Uri.parse(Constant.deletePost),

        //  Uri.parse("https://nodeserver.mydevfactory.com:2109/api/tribe/tribeList"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    //  print("inside2222222");
    // print("dddeee..${Uri.parse(Constant.deletePost)}..$body");

    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    // print("errrrrr");

    rethrow;
  }
}

Future<Reply> deleteChat(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    // print("inside1111111");
    final response = await post(Uri.parse(Constant.deleteMessageUrl),

        //  Uri.parse("https://nodeserver.mydevfactory.com:2109/api/tribe/tribeList"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    //  print("inside2222222");

    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    //print("errrrrr");

    rethrow;
  }
}

Future<Reply> deleteGroup(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    // print("inside1111111");
    final response = await post(Uri.parse(Constant.removeUserFromGroupUrl),

        //  Uri.parse("https://nodeserver.mydevfactory.com:2109/api/tribe/tribeList"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    //  print("inside2222222");

    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    // print("errrrrr");

    rethrow;
  }
}

Future<Map<String, dynamic>> likePost(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.likePostUrl),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });

    return (json.decode(response.body));
  } catch (e) {
    //  print("errrrrr");
    rethrow;
  }
}

Future<Reply> unlikePost(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.unlikePostUrl),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    // print("errrrrr");
    rethrow;
  }
}

Future<Reply> removeImage(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
     print("body.....${Uri.parse(Constant.removeImageUrl)}     ${body}");
    final response = await post(Uri.parse(Constant.removeImageUrl),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    // print("errrrrr");
    rethrow;
  }
}

Future<Map<String, dynamic>> commentPost(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.commentPostUrl),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });

    return (json.decode(response.body));
  } catch (e) {
    //print("errrrrr");
    rethrow;
  }
}

Future<Reply> blockTribe(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    // print("inside1111111");
    final response = await post(Uri.parse(Constant.blockTribeApiUrl),

        //  Uri.parse("https://nodeserver.mydevfactory.com:2109/api/tribe/tribeList"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    // print("inside2222222");

    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    //print("errrrrr");

    rethrow;
  }
}

Future<ContentResponseModel> getContent(Map<String, dynamic> body) async {
  //print(body);
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.cmsUrl),

        // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/post/home"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken"),
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        });
    //print("response  ${Constant.cmsUrl}");

    //print(response.body);
    log(response.body);
    return ContentResponseModel.fromJson(json.decode(response.body));
  } catch (e) {
    //print(e);
    rethrow;
  }
}

Future<UpdateSettingResponseModel> updateSetting(
    Map<String, dynamic> body) async {
  //print(body);
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.updateSettingUrl),

        // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/post/home"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    //print(response.body);
    log(response.body);
    return UpdateSettingResponseModel.fromJson(json.decode(response.body));
  } catch (e) {
    //print(e);
    rethrow;
  }
}

Future<GetSettingResponseModel> getSetting(Map<String, dynamic> body) async {
  //print(body);
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.getSettingsUrl),

        // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/post/home"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    //print(response.body);
    log(response.body);
    return GetSettingResponseModel.fromJson(json.decode(response.body));
  } catch (e) {
    //print(e);
    rethrow;
  }
}

Future<TrackOrderResponseModel> trackOrder(Map<String, dynamic> body) async {
  print(body);
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.trackOrderUrl),

        // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/post/home"),
        body: body,

        );
    print("chhhhh..${response.body}");
    log(response.body);
    return TrackOrderResponseModel.fromJson(json.decode(response.body));
  } catch (e) {
    //print(e);
    rethrow;
  }
}

Future<Reply> addInnerCircleMember(Map<String, dynamic> body) async {
  try {
    // final prefs = await sharedPrefs;
    final prefs = await sharedPrefs;

    final response = await post(Uri.parse(Constant.ADD_INNER_CIRCLE_MEMBER_URL),

        //Uri.parse("https://nodeserver.mydevfactory.com:2109/api/" + "user/addInnerCircleMember"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<Reply> blockUser(Map<String, dynamic> body) async {
  try {
    // final prefs = await sharedPrefs;
    final prefs = await sharedPrefs;

    final response = await post(Uri.parse(Constant.blockUserUrl),

        //Uri.parse("https://nodeserver.mydevfactory.com:2109/api/" + "user/addInnerCircleMember"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<Reply> blockGroup(Map<String, dynamic> body) async {
  try {
    // final prefs = await sharedPrefs;
    final prefs = await sharedPrefs;

    final response = await post(Uri.parse(Constant.blockGroupUrl),

        //Uri.parse("https://nodeserver.mydevfactory.com:2109/api/" + "user/addInnerCircleMember"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<Reply> deleteNotification(Map<String, dynamic> body) async {
  try {
    // final prefs = await sharedPrefs;
    final prefs = await sharedPrefs;

    final response = await post(Uri.parse(Constant.deleteNotificationUrl),

        //Uri.parse("https://nodeserver.mydevfactory.com:2109/api/" + "user/addInnerCircleMember"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<Reply> unblockUser(Map<String, dynamic> body) async {
  try {
    // final prefs = await sharedPrefs;
    final prefs = await sharedPrefs;

    final response = await post(Uri.parse(Constant.unblockUserUrl),

        //Uri.parse("https://nodeserver.mydevfactory.com:2109/api/" + "user/addInnerCircleMember"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<Reply> unblockTribe(Map<String, dynamic> body) async {
  try {
    // final prefs = await sharedPrefs;
    final prefs = await sharedPrefs;

    final response = await post(Uri.parse(Constant.unBlockTribeUrl),

        //Uri.parse("https://nodeserver.mydevfactory.com:2109/api/" + "user/addInnerCircleMember"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<Reply> getInnerCircleMember(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.INNER_CIRCLE_LIST_URL),

        // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/tribe/innerCircleList"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<ChatListResponseModel> getMessageList(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    print(
        "body...   ${body} ${Constant.messageListUrl} ${prefs.getString("spAuthToken")}");

    final response = await post(Uri.parse(Constant.messageListUrl),

        // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/tribe/innerCircleList"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken"),
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        });
    return ChatListResponseModel.fromJson(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<TokenCreateResponseModel> createCardToken(
    Map<String, dynamic> body) async {
  try {
    final response = await post(
      Uri.parse(Constant.createCardTokenUrl),

      // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/tribe/innerCircleList"),
      body: body,
    );
    log(response.body);
    return TokenCreateResponseModel.fromJson(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<OneToOneMessageListResponseModel> getOneToOneMessageList(
    Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.oneToOneMessageListUrl),

        // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/tribe/innerCircleList"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    return OneToOneMessageListResponseModel.fromJson(
        json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<GetAllGroupMessageResponseModel> getAllGroupMessage(
    Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.getAllGroupMessageUrl),

        // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/tribe/innerCircleList"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    return GetAllGroupMessageResponseModel.fromJson(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<AllFriendListResponseModel> getAllFriendsList(
    Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.gelAllFriendUrl),

        // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/tribe/innerCircleList"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    return AllFriendListResponseModel.fromJson(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<SendMessageResponseModel> getSendMessagePost(
    Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.sendMessagePostUrl),

        // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/tribe/innerCircleList"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    return SendMessageResponseModel.fromJson(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<SendMessageGroupResponseModel> getSendMessageGroup(
    Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.sendMessageGroupUrl),

        // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/tribe/innerCircleList"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    return SendMessageGroupResponseModel.fromJson(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<Reply> getMessageRead(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.readMessageUrl),

        // Uri.parse("https://nodeserver.mydevfactory.com:2109/api/tribe/innerCircleList"),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    //print("val   $e");

    rethrow;
  }
}

Future<CreateGroupResponseModel> getCreateGroup(String body) async {
  try {
    final prefs = await sharedPrefs;
    final response =
        await post(Uri.parse(Constant.createGroupUrl), body: body, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + prefs.getString("spAuthToken"),
      "Content-Type": "application/json"
    });
    //print("response,,,,,, ${response.body}");
    return CreateGroupResponseModel.fromJson(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<Reply> deleteMessage(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.removeMessageUrl),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    //print("response   ${response.body}");
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<Reply> editMessage(Map<String, dynamic> body, String comeFrom) async {
  try {
    final response = await put(
      comeFrom == "group"
          ? Uri.parse(Constant.editGroupChatUrl)
          : Uri.parse(Constant.editChatUrl),
      body: body,
      /* headers: {
          HttpHeaders.authorizationHeader:
          "Bearer " + prefs.getString("spAuthToken")
        }*/
    );
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}

Future<Reply> deleteMessageFromGroup(Map<String, dynamic> body) async {
  try {
    final prefs = await sharedPrefs;
    final response = await post(Uri.parse(Constant.removeChatFromGroupUrl),
        body: body,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + prefs.getString("spAuthToken")
        });
    // print("response   ${response.body}");
    return Reply.fromMap(json.decode(response.body));
  } catch (e) {
    rethrow;
  }
}


