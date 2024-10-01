import 'dart:convert';
import 'dart:developer';
import 'dart:io';
//import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/helpers/helper.dart';
import 'package:griot_legacy_social_media_app/src/models/block_tribe_list_response_model.dart';
import 'package:griot_legacy_social_media_app/src/models/get_content_model.dart';
import 'package:griot_legacy_social_media_app/src/models/quick_link.dart';
import 'package:griot_legacy_social_media_app/src/models/user.dart';
import 'package:griot_legacy_social_media_app/src/repos/block_list_response_model.dart';
import 'package:griot_legacy_social_media_app/src/repos/other_user_response_model.dart';
import 'package:griot_legacy_social_media_app/src/repos/user_repos.dart';
import 'package:griot_legacy_social_media_app/src/screens/internet_checker.dart';
import 'package:griot_legacy_social_media_app/src/screens/invite_friends_page.dart';
import 'package:griot_legacy_social_media_app/src/screens/login_page.dart';
import 'package:griot_legacy_social_media_app/src/screens/main_screen.dart';
import 'package:griot_legacy_social_media_app/src/screens/otp_verification_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/add_advertisment_response_model.dart';
import '../models/all_friends_list_response_model.dart';
import '../models/apple_pay_response_model.dart';
import '../models/card_list_response_model.dart';
import '../models/chat_listing_response_model.dart';
import '../models/check_fare_response_model.dart';
import '../models/get_advertisement_response_model.dart';
import '../models/get_all_group_message_response_model.dart';
import '../models/get_setting_response_model.dart';
import '../models/get_storage_list_response_model.dart';
import '../models/one_to_one_message_list_response_model.dart';
import '../models/paypal_response_model.dart';
import '../models/token_create_response_model.dart';
import '../models/track_order_response_model.dart';
import '../models/update_setting_response_model.dart';
import '../repos/dashboardResponseModel.dart';

class UserController extends GetxController {
  BuildContext buildContext;
  GetBuilderState<UserController> getBuilderState;
  int genderIndex = 0;
  int count = 6;
  String val = "";
  String relationshipStatus = "SINGLE";
  String value = "Tribe";
  String groupIdlocal = "";
  int sucessCode;

  String gender = "";
  String nationCode = "+1";
  ValueNotifier<User> user =
      ValueNotifier(User("", "", "", "", "", "", "", "", ""));

  OtherUserProfileResponseModel otherUser = OtherUserProfileResponseModel();
  BlockListResponseModel blockUserModel = BlockListResponseModel();
  PayPalResponseModel payPalModel = PayPalResponseModel();
  ApplePayResponseModel applePayModel = ApplePayResponseModel();
  BlockTribeListResponseModel blockTribeListModel =
      BlockTribeListResponseModel();
  DashboardResponseModel dashboardModel = DashboardResponseModel();
  GetAdvertisementResponsemodel adsModel = GetAdvertisementResponsemodel();
  CheckFareResponseModel checkFareModel = CheckFareResponseModel();
  AddAdvertismentResponseData addAdsResponse = AddAdvertismentResponseData();
  GetAdvertisementResponsemodel editAdsResponse = GetAdvertisementResponsemodel();
  CardListResponseModel cardListModel = CardListResponseModel();
  GetStoragePackageResponseModel getStorageList =
      GetStoragePackageResponseModel();

  List<QuickLink> quickLinks = <QuickLink>[];
  List<FocusNode> fcNs = <FocusNode>[];
  bool hideText = true, notFlag = false, profFlag = false;
  List<TextEditingController> tec = <TextEditingController>[];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController ec = TextEditingController(),
      pc = TextEditingController(),
      cpc = TextEditingController(),
      nc = TextEditingController(),
      dobc = TextEditingController(),
      phc = TextEditingController(),
      ccc = TextEditingController(),
      dobForServer = TextEditingController(),
      contactEmail = TextEditingController(),
      contactMessage = TextEditingController(),
      contactName = TextEditingController();
  var contentModel = ContentResponseModel();
  var getSettingModel = GetSettingResponseModel();
  var getTrackOrderModel = TrackOrderResponseModel();
  var getUpdateSetting = UpdateSettingResponseModel();
  var oneToOneMessageModel = OneToOneMessageListResponseModel();
  var allFriendListResponseModel = AllFriendListResponseModel();
  var chatListingResponseModel = ChatListResponseModel();
  var getAllGroupMessageResponse = GetAllGroupMessageResponseModel();
  var tokenResponse = TokenCreateResponseModel();

  List<String> genders = <String>[
    "MALE",
    "FEMALE",
    "NON BINARY",
    "PREFER NOT TO REVEAL IT"
  ];

  List<bool> flags = <bool>[false, false, false, false];
  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
  List searchResultList = [];
  String userImageUrl = "";
  List tribesList = [];
  List otherUserProfileList = [];
  List notificationList = [];
  List innerCircleList = [];
  List tribeMembersList = [];
  List blockList = [];
  List messageList = [];
  List chatUserList = [];
  List createResponseList = [];
  Helper get hp => Helper.of(buildContext, getBuilderState);

  UserController(BuildContext context, GetBuilderState<UserController> state) {
    buildContext = context;
    getBuilderState = state;
    quickLinks.addAll(<QuickLink>[
      QuickLink("Friends", () {}),
      QuickLink("Invite Friends", () {
        hp.goToRoute("/inviteFriends");
      }),
      QuickLink("Logout", () async {
        final prefs = await sharedPrefs;
        final body = {
          "userId": prefs.getString("spUserID"),
          "loginId": prefs.getString("spLoginID"),
          "appType": Platform.isAndroid
              ? "ANDROID"
              : (Platform.isIOS ? "IOS" : "BROWSER")
        };
        waitUntilLogout(body);
      })
    ]);
  }

  void hideOrRevealText() {
    hideText = !hideText;
    update();
  }

  void setNot(bool flag) {
    notFlag = flag;
    update();
  }

  void setProfileVisibility(bool flag) {
    profFlag = flag;
    update();
  }

  void setGender(int index) {
    if (flags.contains(true)) {
      flags[flags.indexOf(true)] = false;
    }
    flags[index] = true;
    update();
  }

  void onChangedRelationStatus(String val) {
    relationshipStatus = val;
  }

  void onChangedGender(String str) {
    gender = str;
  }

  void onChangedNationCode(CountryCode code) {
    //print("code... $code");
    nationCode = code.dialCode;
    ccc.text = code.dialCode;
    //  print("nationCode... $nationCode   ${ccc.text}");
  }

  init() {
    // ec.text = "";
    // pc.text = "";
    // cpc.text = "";
    // nc.text = "";
    // dobc.text = "";
    // phc.text = "";
    // ccc.text = "";
  }

  void getTEC(int n) {
    for (int i = 1, j = 1; i <= n; i++, ++j) {
      if (tec.length < n) tec.add(TextEditingController());
      final node = FocusScope.of(buildContext);
      node.onKey = (FocusNode a, RawKeyEvent b) {
        try {
          final flag = b.isKeyPressed(LogicalKeyboardKey.backspace) && j != 1;
          if (flag) {
            final p = a.previousFocus();
            if (p) {
              --j;
            }
          }
          return KeyEventResult.handled;
        } catch (e) {
          rethrow;
        }
      };
      if (fcNs.length < n) fcNs.add(node);
    }
    // update();
  }

  Future<bool> waitForLogin(Map<String, dynamic> body) async {
    bool returnValue = false;
    // hp.showLoader();
    // EasyLoading.show();
    //EasyLoading.showToast('Could not login try latter');
    // EasyLoading.show(status: '');
    //print("body    $body");

    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      // print("iffffffffff     $body");
      final value = await login(body);

      if (value.success) {
        if (value.code == 210) {
          //final prefs = await sharedPrefs;
          /*       final p = await prefs.setString("spSID", value.data['sid']);
          final q = await prefs.setString("spUserID", value.data['userId']);*/

          Navigator.push(
              hp.context,
              MaterialPageRoute(
                builder: (context) => OTPVerificationPage(
                  api: "customerVerifyUser",
                  userId: value.data['userId'],
                  sId: value.data['sid'],
                ),
              ));
        } else {
          returnValue = true;
          final prefs = await sharedPrefs;
          user.value = User.fromMap(value.data['userDetails']);
          print("user.value.imageURL   ${user.value.imageURL}");
          prefs.setString("profileImgUrl", user.value.imageURL);
          prefs.setString("profileFullName", user.value.fullName);
          //  print(user.value.fullName);
          final p = await prefs.setString("spUserID", user.value.userID);
          final q = await prefs.setString("spLoginID", user.value.loginID);
          final r =
              await prefs.setString("spAuthToken", value.data['authToken']);

          prefs.setString(
              "spAppType",
              Platform.isAndroid
                  ? "ANDROID"
                  : (Platform.isIOS ? "IOS" : "BROWSER"));

          final flag = p && q && r;
          if (flag) {
            prefs.setBool("loggedIn", true);
            if (prefs.getString("shownInviteFriend") == "true") {
              hp.goToRouteWithNoWayBack("/screens", flag);
            } else {
              prefs.setString("shownInviteFriend", "true");
              Navigator.push(
                  hp.context,
                  MaterialPageRoute(
                    builder: (context) => const InviteFriendsPage(
                      comesFrom: "Login",
                    ),
                  ));
            }
          }
        }
      } else {
        Helper.showToast(value.message);
        //EasyLoading.showToast(value.message);
      }
    } else {
      Helper.showToast(hp.internetMsg);
      // print("elssssssssss");
    }

    return returnValue;
  }

  Future<bool> waitUntilSearchUser(Map<String, dynamic> body) async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await searchUser(body);
      // final f =
      //     await Fluttertoast.showToast(msg: val.message + " !!!!!") ?? false;
      if (val.success && val.code == 200) {
        searchResultList = val.data["data"];
        userImageUrl = val.data["userImageUrl"];
        returnValue = true;
        // print("searchListHere" + searchResultList.toString());
      }
    } else {
      Helper.showToast(hp.internetMsg);
      //print("elssssssssss");
    }
    return returnValue;
  }

  Future<bool> waitUntilSendInvitation(Map<String, dynamic> body) async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await sendInvitation(body);

      if (val.success && val.code == 200) {
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<void> waitForCardList() async {
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      try {
        final prefs = await sharedPrefs;
        if (prefs.containsKey("spUserID") && prefs.containsKey("spLoginID")) {
          cardListModel = await cardListData({
            "customerId": prefs.getString("spUserID"),
            "loginId": prefs.getString("spLoginID"),
          });

          //update();
        }

        if (cardListModel.sTATUSCODE == 403) {
          prefs.setBool("loggedIn", false);
        }
      } catch (e) {
        rethrow;
      }
    } else {
      Helper.showToast("No internet connection");
    }
  }

  Future<bool> waitUntilAcceptRejectRequest(Map<String, dynamic> body) async {
    //print("boddddddd $body");
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await acceptRejectInvitation(body);

      if (val.success && val.code == 200) {
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
      //print("elssssssssss");
    }
    return returnValue;
  }

  Future<bool> waitUntilPasswordReset(Map<String, dynamic> body) async {
    // print("body    $body");
    bool returnValue = false;

    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final value = await resetPassword(body);

      if (value.code == 200) {
        returnValue = true;
        Fluttertoast.showToast(msg: value.message);

        Future.delayed(const Duration(milliseconds: 500), () {
          // hp.goToRouteWithNoWayBack("/screens", flag);
          // Navigator.popUntil(buildContext, ModalRoute.withName('/login_page'));
          Navigator.of(buildContext).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginPage(), // Or PageTwo
            ),
          );
        });
      } else {
        Fluttertoast.showToast(msg: "Resetting Password Failed");
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilChangePassword(Map<String, dynamic> body) async {
    bool returnValue = false;

    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final value = await changePassword(body);
      //  print("value    ${value.data}");

      if (value.code == 200) {
        returnValue = true;
      } else {
        Fluttertoast.showToast(msg: "change Password Failed");
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilLogout(Map<String, dynamic> body) async {
    bool returnValue = false;
    final prefs = await sharedPrefs;

    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final value = await logout(body);
      final f = await Fluttertoast.showToast(msg: value.message) ?? false;
      if (value.success && f && value.code == 200) {
        returnValue = true;
        user.value = User("", "", "", "", "", "", "", "", "");
        hp.logout();
        prefs.setBool("loggedIn", false);
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilDeleteAccount(Map<String, dynamic> body) async {
    print("preff33333   $body");

    bool returnValue = false;
    final prefs = await sharedPrefs;

    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final value = await deleteAccount(body);
      final f = await Fluttertoast.showToast(msg: value.message) ?? false;
      if (value.success && f && value.code == 200) {
        returnValue = true;
        user.value = User("", "", "", "", "", "", "", "", "");
        hp.logout();
        prefs.setBool("loggedIn", false);
      }
      //print("preff4444   ${value.success}");
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilRegister(Map<String, dynamic> body) async {
    // print(body);
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final value = await register(body);
      final f = await Fluttertoast.showToast(msg: value.message) ?? false;
      final prefs = await sharedPrefs;
      if (value.code == 210 && f) {
        returnValue = true;
        try {
          final p = await prefs.setString("spSID", value.data['sid']);
          final q = await prefs.setString("spUserID", value.data['userId']);
          if (p && q) {
            //hp.goToRoute("/verifyOTP");
            Navigator.push(
                hp.context,
                MaterialPageRoute(
                  builder: (context) => OTPVerificationPage(
                    emailPhone: body["email"],
                    api: "customerVerifyUser",
                    userId: "",
                    sId: "",
                  ),
                ));
          }
        } catch (e) {
          rethrow;
        }
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }

    return returnValue;
  }

  Future<bool> waitUntilCreateToken(
    String cardNumber,
    String expiryDateController,
    String expiryYearController,
    String cvvController,
  ) async {
    bool returnValue = false;
    print("333333333333");

    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      try {
        tokenResponse = await createCardToken({
          "cardNumber": cardNumber,
          "expMonth": expiryDateController,
          "expYear": expiryYearController,
          "cvc": cvvController
        });
        if (tokenResponse.sTATUSCODE == 422) {
          Helper.showToast(tokenResponse.message);
        }
        print("444444444444444");
        print("5555555555 ${tokenResponse}");
      } catch (e) {
        rethrow;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilCardSaveApi(Map<String, dynamic> body) async {
    // print(body);
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final value = await cardSave(body);
      final f = await Fluttertoast.showToast(msg: value.message) ?? false;
      if (value.code == 210 && f) {
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }

    return returnValue;
  }

  Future<bool> waitUntilAdsDeleteApi(Map<String, dynamic> body) async {
    // print(body);
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final value = await deleteAds(body);
      final f = await Fluttertoast.showToast(msg: value.message) ?? false;
      if (value.code == 210 && f) {
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }

    return returnValue;
  }

  Future<bool> waitUntilAdsCancelApi(Map<String, dynamic> body) async {
    // print(body);
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final value = await cancelAds(body);
      final f = await Fluttertoast.showToast(msg: value.message) ?? false;
      if (value.code == 210 && f) {
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }

    return returnValue;
  }

  Future<bool> waitUntilMakePayment(Map<String, dynamic> body) async {
    //print(body);
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final value = await makePayment(body);
      final f = await Fluttertoast.showToast(msg: value.message) ?? false;
      if (value.code == 210 && f) {
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }

    return returnValue;
  }

  Future<bool> waitUntilDeleteCard(Map<String, dynamic> body) async {
    // print(body);
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final value = await cardDelete(body);
      final f = await Fluttertoast.showToast(msg: value.message) ?? false;
      if (value.code == 210 && f) {
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }

    return returnValue;
  }

  Future<bool> waitUntilSetDefaultCard(Map<String, dynamic> body) async {
    //print(body);
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final value = await defaultCard(body);
      if (value.statuscode == 200) {
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }

    return returnValue;
  }

  Future<bool> waitUntilMakePaypalPayment(String amount, String advertisementId,
      {bool ispackage = false}) async {
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      try {
        final prefs = await sharedPrefs;
        if (prefs.containsKey("spUserID") &&
            prefs.containsKey("spLoginID") &&
            prefs.containsKey("spAppType")) {
          Map<String, dynamic> body = {};
          if (ispackage) {
            body = {
              "userId": prefs.getString("spUserID"),
              "loginId": prefs.getString("spLoginID"),
              "amount": amount,
              "storagePackageId": advertisementId,
              "paymentType": "storage"
            };
          } else {
            body = {
              "userId": prefs.getString("spUserID"),
              "loginId": prefs.getString("spLoginID"),
              "amount": amount,
              "advertisementId": advertisementId,
              "paymentType": "advertisement"
            };
          }

          log("$body");

          payPalModel = await makePaypalPayment(body);
          //update();
        }
        if (otherUser.statuscode == 403) {
          // print("qqqqqqqq");
          user.value = User("", "", "", "", "", "", "", "", "");
          hp.logout();
          prefs.setBool("loggedIn", false);
        }
      } catch (e) {
        rethrow;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
  }

  Future<bool> waitUntilMakeApplePay(
      String amount, String token, String paymentTypeId,String paymentType) async {
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      try {
        final prefs = await sharedPrefs;
        if (prefs.containsKey("spUserID") &&
            prefs.containsKey("spAppType")) {
          applePayModel = await applePayPayment({
            "customerId": prefs.getString("spUserID"),
            //"loginId": prefs.getString("spLoginID"),
            "amount": amount,
            "token": token,
            "currency":"USD",
            "paymentType" : paymentType,
            if(paymentType=="advertisement")"advertisementId": paymentTypeId
            else "storagePackageId" : paymentTypeId ,
          });
          //update();
        }
        if (otherUser.statuscode == 403) {
          // print("qqqqqqqq");
          user.value = User("", "", "", "", "", "", "", "", "");
          hp.logout();
          prefs.setBool("loggedIn", false);
        }
      } catch (e) {
        rethrow;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
  }

  Future<bool> waitUntilContact(Map<String, dynamic> body) async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final value = await contactUs(body);
      final f = await Fluttertoast.showToast(msg: value.message) ?? false;
      if (value.code == 200 && f) {
        returnValue = true;
        Navigator.pushReplacement(hp.context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }

    return returnValue;
  }

  Future<bool> waitUntilCreateTribe(Map<String, String> body, image) async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await createTribe(body, image);
      await Fluttertoast.showToast(msg: val.message) ?? false;
      if (val.success && val.code == 200) {
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilGetTribesList(Map<String, dynamic> body) async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await getTribeList(body);

      if (val.code == 403) {
        waitUntilLogout(body);
      } else if (val.success && val.code == 200) {
        tribesList = val.data["data"];
        returnValue = true;
        // print("searchListHere" + val.toString());
      } else {
        Helper.showToast(val.message);
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilChatUserList() async {
    bool returnValue = false;
    //print("333333333333");

    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      try {
        final prefs = await sharedPrefs;
        if (prefs.containsKey("spUserID") &&
            prefs.containsKey("spLoginID") &&
            prefs.containsKey("spAppType")) {
          chatListingResponseModel = await getMessageList({
            "userId": prefs.getString("spUserID"),
            "loginId": prefs.getString("spLoginID"),
            "appType": prefs.getString("spAppType"),
          });
          print("444444444444444");
          print("5555555555 ${chatListingResponseModel}");

          //log("therUser.value   ${chatListingResponseModel.responseData.toJson()}");

        }
      } catch (e) {
        rethrow;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilGetInnerCirclesList(Map<String, dynamic> body) async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await getInnerCircleMember(body);

      if (val.code == 403) {
        waitUntilLogout(body);
      } else if (val.success && val.code == 200) {
        innerCircleList = val.data["data"];
        log("val.ddddd    ${val.data["data"]}");
        returnValue = true;
      } else {
        Helper.showToast(val.message);
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> checkOTP(Map<String, dynamic> body, String api) async {
    // print("body... $body   $api");
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final value = await verifyOTP(body, api);
      // print("value...      ${value.toString()}");

      final f = await Fluttertoast.showToast(msg: value.message) ?? false;
      final prefs = await sharedPrefs;
      if (f && value.code == 200) {
        returnValue = true;
        if (api != "fpVerifyUser") {
          Navigator.of(buildContext).push(
            MaterialPageRoute(
              builder: (context) => const LoginPage(), // Or PageTwo
            ),
          );
        } else {
          final p = await prefs.setString("spUserID", value.data["userId"]);

          if (p) hp.goToRoute("/changePassword");
        }
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }

    return returnValue;
  }

  Future<void> waitForUserDetails() async {
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      try {
        final prefs = await sharedPrefs;
        if (prefs.containsKey("spUserID") &&
            prefs.containsKey("spLoginID") &&
            prefs.containsKey("spAppType")) {
          user.value = await getUserData({
            "userId": prefs.getString("spUserID"),
            "loginId": prefs.getString("spLoginID"),
            "appType": Platform.isAndroid
                ? "ANDROID"
                : (Platform.isIOS ? "IOS" : "BROWSER")
          });
          update();
        }
        if (otherUser.statuscode == 403) {
          //  print("qqqqqqqq");
          user.value = User("", "", "", "", "", "", "", "", "");
          hp.logout();
          prefs.setBool("loggedIn", false);
        }
      } catch (e) {
        rethrow;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
  }

  Future<void> waitForOtherUserDetails(String otherUserId) async {
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      try {
        final prefs = await sharedPrefs;
        if (prefs.containsKey("spUserID") &&
            prefs.containsKey("spLoginID") &&
            prefs.containsKey("spAppType")) {
          otherUser = await getOtherUserData({
            "userId": prefs.getString("spUserID"),
            "loginId": prefs.getString("spLoginID"),
            "otherUserId": otherUserId,
            "appType": Platform.isAndroid
                ? "ANDROID"
                : (Platform.isIOS ? "IOS" : "BROWSER")
          });
          print("hhhhhh  ${otherUser}");
          //update();
        }
        if (otherUser.statuscode == 403) {
          // print("qqqqqqqq");
          user.value = User("", "", "", "", "", "", "", "", "");
          hp.logout();
          prefs.setBool("loggedIn", false);
        }
      } catch (e) {
        rethrow;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
  }

  Future<void> waitForDashboard() async {
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      try {
        final prefs = await sharedPrefs;
        if (prefs.containsKey("spUserID") &&
            prefs.containsKey("spLoginID") &&
            prefs.containsKey("spAppType")) {
          dashboardModel = await getDashboardData({
            "userId": prefs.getString("spUserID"),
            "loginId": prefs.getString("spLoginID"),
            "appType": Platform.isAndroid
                ? "ANDROID"
                : (Platform.isIOS ? "IOS" : "BROWSER")
          });

          //update();
        }
        if (dashboardModel.sTATUSCODE == 403) {
          //print("qqqqqqqq");
          user.value = User("", "", "", "", "", "", "", "", "");
          hp.logout();
          prefs.setBool("loggedIn", false);
        }
      } catch (e) {
        rethrow;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
  }

  Future<void> waitForGetStorageList() async {
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      try {
        final prefs = await sharedPrefs;
        if (prefs.containsKey("spUserID") &&
            prefs.containsKey("spLoginID") &&
            prefs.containsKey("spAppType")) {
          getStorageList = await storagePackages({
            "loginId": prefs.getString("spLoginID"),
          });

          //update();
        }
        if (getStorageList.statuscode == 403) {
          //print("qqqqqqqq");
          user.value = User("", "", "", "", "", "", "", "", "");
          hp.logout();
          prefs.setBool("loggedIn", false);
        }
      } catch (e) {
        rethrow;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
  }

  Future<void> waitForGetAdvertisement() async {
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      try {
        final prefs = await sharedPrefs;
        if (prefs.containsKey("spUserID") && prefs.containsKey("spLoginID")) {
          adsModel = await getAdvertisemnetData({
            "userId": prefs.getString("spUserID"),
            "loginId": prefs.getString("spLoginID"),
          });

          //update();
        }
        if (adsModel.sTATUSCODE == 403) {
          //print("qqqqqqqq");
          user.value = User("", "", "", "", "", "", "", "", "");
          hp.logout();
          prefs.setBool("loggedIn", false);
        }
      } catch (e) {
        rethrow;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
  }

  Future<void> waitForGetCheckFareApi(String id) async {
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      try {
        final prefs = await sharedPrefs;
        if (prefs.containsKey("spUserID") && prefs.containsKey("spLoginID")) {
          checkFareModel = await checkFareData({
            "userId": prefs.getString("spUserID"),
            "loginId": prefs.getString("spLoginID"),
            "advertisementId": id,
          });

          //update();
        }
        if (checkFareModel.sTATUSCODE == 403) {
          //print("qqqqqqqq");
          user.value = User("", "", "", "", "", "", "", "", "");
          hp.logout();
          prefs.setBool("loggedIn", false);
        }
      } catch (e) {
        rethrow;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
  }

  Future<bool> waitUntilReportPost(Map<String, dynamic> body) async {
    bool returnValue = false;
    //print("body..    $body");
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await reportPost(body);

      if (val.success && val.code == 200) {
        Fluttertoast.showToast(msg: val.message);
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilReportUser(Map<String, dynamic> body) async {
    bool returnValue = false;
    //print("body..    $body");
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await reportUser(body);

      if (val.success && val.code == 200) {
        Fluttertoast.showToast(msg: val.message);
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<void> waitForBlockList(/*Map<String, dynamic> body*/) async {
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();

    if (netStatus == DataConnectionStatus.connected) {
      try {
        final prefs = await sharedPrefs;
        if (prefs.containsKey("spUserID") &&
            prefs.containsKey("spLoginID") &&
            prefs.containsKey("spAppType")) {
          blockUserModel = await getBlockList({
            "userId": prefs.getString("spUserID"),
            "loginId": prefs.getString("spLoginID"),
            "appType": Platform.isAndroid
                ? "ANDROID"
                : (Platform.isIOS ? "IOS" : "BROWSER")
          });
        }
      } catch (e) {
        rethrow;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
  }

  Future<void> waitForBlockTribeList(/*Map<String, dynamic> body*/) async {
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();

    if (netStatus == DataConnectionStatus.connected) {
      try {
        final prefs = await sharedPrefs;
        if (prefs.containsKey("spUserID") &&
            prefs.containsKey("spLoginID") &&
            prefs.containsKey("spAppType")) {
          blockTribeListModel = await getBlockTribeList({
            "userId": prefs.getString("spUserID"),
            "loginId": prefs.getString("spLoginID"),
            "appType": Platform.isAndroid
                ? "ANDROID"
                : (Platform.isIOS ? "IOS" : "BROWSER")
          });
        }
      } catch (e) {
        rethrow;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
  }

  Future<bool> waitUntilProfileUpdate(Map<String, dynamic> body) async {
    bool returnValue = false;
    //print("body..    $body");
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await updateProfile(body);

      if (val.success && val.code == 200) {
        Fluttertoast.showToast(msg: val.message);
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilGetOtp(Map<String, dynamic> body, String url) async {
    // print("body..... $body $url");
    bool returnValue = false;

    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await getOtp(body, url);
      //final f =
      await Fluttertoast.showToast(msg: val.message) ?? false;
      final prefs = await sharedPrefs;
      //prefs.setString("userEmail", body["user"]);

      if (val.success && val.code == 200) {
        prefs.setString("spUserID", val.data["id"]);
        prefs.setString("spSID", val.data["sid"]);
        returnValue = true;
      } else {
        Helper.showToast(val.message);
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }

    return returnValue;
  }

  Future<bool> waitUntilProfileImageUpdate(
      Map<String, String> body, String imagePath) async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await uploadProfileImage(body, imagePath);

      if (val.success && val.code == 200) {
        Fluttertoast.showToast(msg: val.message);
        returnValue = true;
        String image = '${val.data["profileImage"]}';
        print("val.data   ${val.data["profileImage"]}  $image");

        final prefs = await sharedPrefs;
        prefs.setString("profileImgUrl", image);
        // prefs.setString("profileImgUrl", {val.data["profileImage"].toString()});

      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilUploadGroupPhoto(
      Map<String, String> body, String imagePath) async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await uploadGroupImage(body, imagePath);

      if (val.success && val.code == 200) {
        Fluttertoast.showToast(msg: val.message);
        returnValue = true;
        //  print("val.data   ${val.data["profileImage"]}"   );
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilLeaveTribe(Map<String, dynamic> body) async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      // print("1111111");
      final val = await leaveTribe(body);

      if (val.success && val.code == 200) {
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilDeletePost(Map<String, dynamic> body) async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await deletePost(body);
     

      if (val.success && val.code == 200) {
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilDeleteChat(Map<String, dynamic> body) async {
    // print("body    $body");
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await deleteChat(body);

      if (val.success && val.code == 200) {
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilDeleteGroup(Map<String, dynamic> body) async {
    // print("body    $body");
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await deleteGroup(body);

      if (val.success && val.code == 200) {
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<Map<String, dynamic>> waitUntilLikePost(
      Map<String, dynamic> body) async {
    var val;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();

    if (netStatus == DataConnectionStatus.connected) {
      val = await likePost(body);
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return val;
  }

  Future<bool> waitUntilUnlikePost(Map<String, dynamic> body) async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();

    if (netStatus == DataConnectionStatus.connected) {
      final val = await unlikePost(body);
      if (val.success && val.code == 200) {
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilRemoveImage(Map<String, dynamic> body) async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();

    if (netStatus == DataConnectionStatus.connected) {
      final val = await removeImage(body);
      if (val.success && val.code == 200) {
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<Map<String, dynamic>> waitUntilCommentPost(
      Map<String, dynamic> body) async {
    var val;

    DataConnectionStatus netStatus = await InternetChecker.checkInternet();

    if (netStatus == DataConnectionStatus.connected) {
      val = await commentPost(body);
      //  print("inside..${val}");

    } else {
      Helper.showToast(hp.internetMsg);
    }
    return val;
  }

  Future<bool> waitUntilBlockTribe(Map<String, dynamic> body) async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await blockTribe(body);

      if (val.success && val.code == 200) {
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilAddInnerCircle(Map<String, dynamic> body) async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await addInnerCircleMember(body);

      if (val.success && val.code == 200) {
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilBlockUser(Map<String, dynamic> body) async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      // print("1111111   $body");
      final val = await blockUser(body);

      if (val.success && val.code == 200) {
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilBlockGroup(Map<String, dynamic> body) async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      // print("1111111   $body");
      final val = await blockGroup(body);

      if (val.success && val.code == 200) {
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilDeleteNotification(Map<String, dynamic> body) async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      //  print("1111111   $body");
      final val = await deleteNotification(body);

      if (val.success && val.code == 200) {
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilUnblockUser(Map<String, dynamic> body) async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await unblockUser(body);

      if (val.success && val.code == 200) {
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilUnblockTribe(Map<String, dynamic> body) async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await unblockTribe(body);

      if (val.success && val.code == 200) {
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilGetContent(String text) async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      try {
        final prefs = await sharedPrefs;
        if (prefs.containsKey("spUserID") &&
            prefs.containsKey("spLoginID") &&
            prefs.containsKey("spAppType")) {
          contentModel = await getContent({
            "userId": prefs.getString("spUserID") ?? "",
            "loginId": prefs.getString("spLoginID") ?? "",
            "appType": prefs.getString("spAppType") ?? "",
            "slug": text,
          });
          /* print("ddddd");
        print(homeData);*/
          //update();
        }
      } catch (e) {
        //print("e   $e");
        rethrow;
      }
    } else {
      // print("33333333333333");

      Helper.showToast(hp.internetMsg);
      //print("elssssssssss");
    }
    return returnValue;
  }

  Future<bool> waitUntilUpdateSetting(
      String profile, String notification) async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      try {
        final prefs = await sharedPrefs;
        if (prefs.containsKey("spUserID") &&
            prefs.containsKey("spLoginID") &&
            prefs.containsKey("spAppType")) {
          getUpdateSetting = await updateSetting({
            "userId": prefs.getString("spUserID") ?? "",
            "loginId": prefs.getString("spLoginID") ?? "",
            "appType": prefs.getString("spAppType") ?? "",
            "profile": profile,
            "notification": notification,
          });
          /* print("ddddd");
        print(homeData);*/
          //update();
        }
      } catch (e) {
        //print("e   $e");
        rethrow;
      }
      //print("1111111");
      //final val = await getContent(body);
      /* // final f =
      //     await Fluttertoast.showToast(msg: val.message + " !!!!!") ?? false;
      if (val.success && val.statuscode == 200) {
        homeData=val.responseData as ContentResponseModel;

        print("22222222");

        returnValue = true;
        // print("searchListHere" + searchResultList.toString());
      }*/
    } else {
      // print("33333333333333");

      Helper.showToast(hp.internetMsg);
      //print("elssssssssss");
    }
    return returnValue;
  }

  Future<bool> waitUntilGetSettingData() async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      try {
        final prefs = await sharedPrefs;
        if (prefs.containsKey("spUserID") &&
            prefs.containsKey("spLoginID") &&
            prefs.containsKey("spAppType")) {
          getSettingModel = await getSetting({
            "userId": prefs.getString("spUserID") ?? "",
            "loginId": prefs.getString("spLoginID") ?? "",
            "appType": prefs.getString("spAppType") ?? "",
          });
        }
      } catch (e) {
        rethrow;
      }
      // print("1111111");

    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilTrackOrder() async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      try {
        final prefs = await sharedPrefs;
        if (prefs.containsKey("spUserID")) {
          getTrackOrderModel = await trackOrder({
            "userId": prefs.getString("spUserID") ?? "",
          });
        }
      } catch (e) {
        rethrow;
      }
      // print("1111111");

    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<void> waitNotificationDetails(Map<String, dynamic> body) async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await getNotificationData(body);

      if (val.success && val.code == 200) {
        notificationList = val.data['userNot'];
        returnValue = true;
        // print("searchListHere" + val.toString());
      } else {
        Helper.showToast(val.message);

        // EasyLoading.showToast(val.message);
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
  }

  Future<bool> waitUntilSendMessage(Map<String, dynamic> body) async {
    print(body);
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await getSendMessagePost(body);

      //await Fluttertoast.showToast(msg: val.message + " !!!!!") ?? false;
      if (val.success && val.statuscode == 200) {
        returnValue = true;
        //print("searchListHere" + val.responseData.toString());
      } else {
        Helper.showToast(val.message);

        // EasyLoading.showToast(val.message);
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilSendMessageInGroup(Map<String, dynamic> body) async {
    print(body);
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await getSendMessageGroup(body);

      //await Fluttertoast.showToast(msg: val.message + " !!!!!") ?? false;
      // print("senddddd ${val.responseData}");

      if (val.success && val.statuscode == 200) {
        returnValue = true;
        //  print("responseofdelete....  ${val.statuscode}");

      } else {
        Helper.showToast(val.message);

        // EasyLoading.showToast(val.message);
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilGetReadMessage(Map<String, dynamic> body) async {
    // print(body);
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await getMessageRead(body);

      //await Fluttertoast.showToast(msg: val.message + " !!!!!") ?? false;

      if (val.success && val.code == 200) {
        returnValue = true;
      } else {
        //  print("val   ${val.message}  ${val.data}");

        Helper.showToast(val.message);

        // EasyLoading.showToast(val.message);
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilCreateGroupMsg(Map<String, dynamic> body) async {
    //print("hhhhhh  ${body}");
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await getCreateGroup(jsonEncode(body));
      // print("val....   $val");

      //await Fluttertoast.showToast(msg: val.message + " !!!!!") ?? false;
      if (val.success == true && val.statuscode == 200) {
        groupIdlocal = val.groupId;
        sucessCode = val.statuscode;
        // print("vvvvv  ${val.responseData.data.id}");
        // tribesList = val.responseData.data.;

        returnValue = true;
      } else {
        Helper.showToast(val.message);

        // EasyLoading.showToast(val.message);
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilDeleteChatMessage(Map<String, dynamic> body) async {
    // print(body);
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await deleteMessage(body);

      //await Fluttertoast.showToast(msg: val.message + " !!!!!") ?? false;
      // print("responseofdelete....  ${val.data}");

      if (val.success && val.code == 200) {
        returnValue = true;
      } else {
        Helper.showToast(val.message);

        // EasyLoading.showToast(val.message);
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilEditMessage(
      Map<String, dynamic> body, String comeFrom) async {
    // print(body);
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await editMessage(body, comeFrom);

      //await Fluttertoast.showToast(msg: val.message + " !!!!!") ?? false;
      //  print("responseofdelete....  ${val.data}");

      if (val.success && val.code == 200) {
        returnValue = true;
      } else {
        Helper.showToast(val.message);
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilDeleteMessageFromGroup(
      Map<String, dynamic> body) async {
    //  print(body);
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await deleteMessageFromGroup(body);

      //await Fluttertoast.showToast(msg: val.message + " !!!!!") ?? false;
      //  print("responseofdelete....  ${val.data}");

      if (val.success && val.code == 200) {
        returnValue = true;
      } else {
        Helper.showToast(val.message);

        // EasyLoading.showToast(val.message);
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilOneToOneMessageList(String toUserId) async {
    //print(body);
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      try {
        final prefs = await sharedPrefs;
        if (prefs.containsKey("spUserID") &&
            prefs.containsKey("spLoginID") &&
            prefs.containsKey("spAppType")) {
          oneToOneMessageModel = await getOneToOneMessageList({
            "userId": prefs.getString("spUserID"),
            "loginId": prefs.getString("spLoginID"),
            "appType": prefs.getString("spAppType"),
            "toUserId": toUserId,
          });
//print("oneToOneMessageModel....  ${oneToOneMessageModel.responseData.toJson()}");
        }
      } catch (e) {
        rethrow;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilGetAllGroupMessageList(String groupId) async {
    //print(body);
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      try {
        final prefs = await sharedPrefs;

        if (prefs.containsKey("spUserID")) {
          getAllGroupMessageResponse = await getAllGroupMessage({
            "user_id": prefs.getString("spUserID"),
            "group_id": groupId,
          });
          print(
              "getAllMessaga....  ${getAllGroupMessageResponse.responseData.toJson()}");
        }
      } catch (e) {
        rethrow;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<bool> waitUntilAllFriendList() async {
    bool returnValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      try {
        final prefs = await sharedPrefs;
        if (prefs.containsKey("spUserID")) {
          allFriendListResponseModel = await getAllFriendsList({
            "user_id": prefs.getString("spUserID"),
          });
          print(
              "allFriendList....  ${allFriendListResponseModel.responseData.toJson()}");
        }
      } catch (e) {
        rethrow;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
    return returnValue;
  }

  Future<void> waitUntilAddAdvertisement(
      String filePath,
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
      String targetAudienceController) async {
    /*bool returnValue = false;
    //print("body..    $body");
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await addAdvertisement(body,filePath);
      if (val.success && val.code == 200) {
        print("valval  ${val}");
        Fluttertoast.showToast(msg: val.message);
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }*/

    DataConnectionStatus netStatus = await InternetChecker.checkInternet();

    if (netStatus == DataConnectionStatus.connected) {
      try {
        final prefs = await sharedPrefs;
        String userID = prefs.getString("spUserID");
        String loginId = prefs.getString("spLoginID");
        if (prefs.containsKey("spUserID") && prefs.containsKey("spLoginID")) {
          addAdsResponse = await addAdvertisement(
              filePath,
              companyName,
              contactPerson,
              email,
              countryCode,
              phone,
              address,
              purposeOdAdv,
              discription,
              link,
              title,
              validFromController,
              validTillController,
              targetAudienceController,
              userID,
              loginId);

          //update();
        }
        if (addAdsResponse.sTATUSCODE == 403) {
          //print("qqqqqqqq");
          user.value = User("", "", "", "", "", "", "", "", "");
          hp.logout();
          prefs.setBool("loggedIn", false);
        }
      } catch (e) {
        rethrow;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
  }

  Future<void> waitUntilEditAdvertisement(
      String filePath,
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
      String targetAudienceController,String advertisementId) async {

    print("22222222222...");
    /*bool returnValue = false;
    //print("body..    $body");
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await addAdvertisement(body,filePath);
      if (val.success && val.code == 200) {
        print("valval  ${val}");
        Fluttertoast.showToast(msg: val.message);
        returnValue = true;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }*/

    DataConnectionStatus netStatus = await InternetChecker.checkInternet();

    if (netStatus == DataConnectionStatus.connected) {
      try {
        final prefs = await sharedPrefs;
        String userID = prefs.getString("spUserID");
        String loginId = prefs.getString("spLoginID");
        if (prefs.containsKey("spUserID") && prefs.containsKey("spLoginID")) {
          print("3333333333333...");
          editAdsResponse = await editAdvertisement(
              filePath,
              companyName,
              contactPerson,
              email,
              countryCode,
              phone,
              address,
              purposeOdAdv,
              discription,
              link,
              title,
              validFromController,
              validTillController,
              targetAudienceController,
              userID,
              loginId,
             advertisementId);

          //update();
        }
        if (editAdsResponse.sTATUSCODE == 403) {
          //print("qqqqqqqq");
          user.value = User("", "", "", "", "", "", "", "", "");
          hp.logout();
          prefs.setBool("loggedIn", false);
        }
        else{
          Get.back();
        }
      } catch (e) {
        rethrow;
      }
    } else {
      Helper.showToast(hp.internetMsg);
    }
  }

  @override
  void onInit() {
    // called immediately after the widget is allocated memory
    super.onInit();
    waitForUserDetails();
  }

  @override
  void onReady() {
    // called after the widget is rendered on screen
    super.onReady();
    waitForUserDetails();
  }

  // @override
  // void onClose() {
  //   // called just before the Controller is deleted from memory
  //   closeStream();
  //   super.onClose();
  // }
}
