import 'dart:convert';
import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/helpers/helper.dart';
import 'package:griot_legacy_social_media_app/src/models/alluserlistmodel.dart';
import 'package:griot_legacy_social_media_app/src/models/home_data_model.dart';
import 'package:griot_legacy_social_media_app/src/repos/post_repos.dart';
import 'package:griot_legacy_social_media_app/src/repos/user_repos.dart';
import 'package:griot_legacy_social_media_app/src/screens/internet_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class PostController extends GetxController {
  TabController tabCon;
  BuildContext buildContext;
  GetBuilderState<PostController> getBuilderState;
  int index = 2;
  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
  String value = "TRIBE";
  TextEditingController tec = TextEditingController();
  TextEditingController albumText = TextEditingController();
  // List<Post> posts = <Post>[
  //   Post(1, "Hii Friends", "img1.jpg", "Daniel Craig", "22/07/2021", "14:53"),
  //   Post(2, "Hii Prendz", "img2.jpg", "Tom Cruise", "24/07/2021", "17:53")
  // ];
  Helper get hp => Helper.of(buildContext, getBuilderState);
  PostController(BuildContext context, GetBuilderState<PostController> state) {
    buildContext = context;
    getBuilderState = state;
  }
  List searchResultList = [];
  String userImageUrl = "";
  List tribesList = [];
  List tribeMembersList = [];
  var allUserModelData = AllUserListModel();
  var homeData = HomeResponseModel();
  // ValueNotifier<HomeResponseModel> homeData =
  //     ValueNotifier(HomeResponseModel());
  void onChanged(String val) {
    value = val;
  }

//sTATUSCODE: 0, success: false, message: "No Data"


  Future<bool> waitUntilCreateNormalPost(Map<String, dynamic> body,bool isEdit) async {
    bool retrunValue = false;
   // print("body     $body");
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await createNormalPost(body,isEdit);
      /*final f =
        await Fluttertoast.showToast(msg: val.message + " !!!!!") ?? false;*/
      if (val.success && val.code == 200) {
        //  Fluttertoast.showToast(msg: val.message + " !!!!!");
        retrunValue = true;
        //print(val.data);
        Navigator.pop(buildContext);

        return retrunValue;
      }

    }
    else{
      Helper.showToast(hp.internetMsg);

    }
    return retrunValue;
  }

  Future<bool> waitUntilCreateFilePost(
      Map<String, dynamic> body, List<File> filePath,bool isEdit) async {
    bool retrunValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
    final val = await uploadMultipleImage(body, filePath,isEdit);
    /*final f =
        await Fluttertoast.showToast(msg: val.message + " !!!!!") ?? false;*/
    if (val.success && val.code == 200) {
      Fluttertoast.showToast(msg: val.message);
      retrunValue = true;
    //  print("val.data");
     // Navigator.pop(buildContext);

    }}
    else{
      Helper.showToast(hp.internetMsg);

    }
    return retrunValue;
  }
  Future<bool> waitUntilPostImageListAndVideoUrl(
      Map<String, dynamic> body, List<File> filePath, String thumb,bool isEdit) async {
    bool retrunValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await uploadMultipleImageWithThumb(body, filePath,thumb,isEdit);
      /*final f =
        await Fluttertoast.showToast(msg: val.message + " !!!!!") ?? false;*/
      if (val.success && val.code == 200) {
        Fluttertoast.showToast(msg: val.message);
        retrunValue = true;
       // print("val.data");
        // Navigator.pop(buildContext);

      }}
    else{
      Helper.showToast(hp.internetMsg);

    }
    return retrunValue;
  }

  Future<bool> waitUntilCreateFilePostSingleImage(
      Map<String, dynamic> body, String filePath,bool isEdit) async {
    bool retrunValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await createFilePost(body, filePath,isEdit);
      /*final f =
        await Fluttertoast.showToast(msg: val.message + " !!!!!") ?? false;*/
      if (val.success && val.code == 200) {
        Fluttertoast.showToast(msg: val.message);
        retrunValue = true;
        //print(val.data);
        Navigator.pop(buildContext);

      }

    }
    else{
      Helper.showToast(hp.internetMsg);

    }
    return retrunValue;
  }

  Future<bool> waitUntilUploadThumb(
      Map<String, dynamic> body, String filePath,String thumb,bool isEdit) async {
    bool retrunValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      //print("11111111111");
      final val = await createFileWithThumbUrl(body, filePath,thumb,isEdit);

      if (val.success && val.code == 200) {
        //print("q222222222222");

        Fluttertoast.showToast(msg: val.message);
        retrunValue = true;
        //print(val.data);
        Navigator.pop(buildContext);

      }

    }
    else{
      Helper.showToast(hp.internetMsg);

    }
    return retrunValue;
  }


/*  Future<bool> waitUntilGetAllUser(
      Map<String, dynamic> body, String filePath) async {
    bool retrunValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
    final val = await createFilePost(body, filePath);
    *//*final f =
        await Fluttertoast.showToast(msg: val.message + " !!!!!") ?? false;*//*
    if (val.success && val.code == 200) {
      Fluttertoast.showToast(msg: val.message + " !!!!!");
      retrunValue = true;
      //print(val.data);
    }}
    else{
      Helper.showToast(hp.internetMsg);

    }
    return retrunValue;
  }*/

  Future<bool> waitUntilGetTribesList(Map<String, dynamic> body) async {
   // print(body);
    bool retrunValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await getTribeList(body);

      //await Fluttertoast.showToast(msg: val.message + " !!!!!") ?? false;
      if (val.code == 403) {
        waitUntilLogout(body);
      } else if (val.success && val.code == 200) {
        tribesList = val.data["data"];
        retrunValue = true;
        //print("searchListHere" + val.toString());
      } else {
        Helper.showToast(val.message);
        //EasyLoading.showToast(val.message);
      }
    }
    else{
      Helper.showToast(hp.internetMsg);

    }
    return retrunValue;
  }

  Future<bool> waitUntilLogout(Map<String, dynamic> body) async {
    bool returnValue = false;

    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
    final prefs = await sharedPrefs;
    final value = await logout(body);
    final f =
        await Fluttertoast.showToast(msg: value.message) ?? false;
    if (value.success && f && value.code == 200) {
      returnValue = true;

      hp.logout();
      prefs.setBool("loggedIn", false);
    }
    }else{
      Helper.showToast(hp.internetMsg);

    }

    return returnValue;
  }

  Future<void> waitHomePostDetails() async {
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {

      try {
        final prefs = await sharedPrefs;
        if (prefs.containsKey("spUserID") &&
            prefs.containsKey("spLoginID") &&
            prefs.containsKey("spAppType")) {
          homeData = await getHomeData({
            "userId": prefs.getString("spUserID"),
            "loginId": prefs.getString("spLoginID"),
            "appType": Platform.isAndroid
                ? "ANDROID"
                : (Platform.isIOS ? "IOS" : "BROWSER")
          });

        }
        if (homeData.sTATUSCODE==403) {
         print("qqqqqqqq  $homeData");
          user.value = User("", "", "", "", "", "", "", "", "");
          hp.logout();
          prefs.setBool("loggedIn", false);
        }
      } catch (e) {
       // print("e   $e");
        rethrow;
      }
    }
    else{
      Helper.showToast(hp.internetMsg);
    }
  }



  Future<bool> waitUntilGetAllUserList(Map<String, dynamic> body) async {
   // print(body);
    bool retrunValue = false;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await getAllUserData(body);

      //await Fluttertoast.showToast(msg: val.message + " !!!!!") ?? false;
      if (val.sTATUSCODE == 403) {
        waitUntilLogout(body);
      } else if (val.success && val.sTATUSCODE == 200) {
        allUserModelData = val;
        retrunValue = true;
       // print("searchListHere" + val.toString());
      } else {
        Helper.showToast(val.message);

        //EasyLoading.showToast(val.message);
      }
    }else{
      Helper.showToast(hp.internetMsg);

    }
    return retrunValue;
  }

  ValueNotifier<User> user =
  ValueNotifier(User("", "", "", "", "", "", "", "", ""));
  Future<bool> waitUntilShowUsage(Map<String, dynamic> body) async {
    // print(body);
    bool retrunValue = false;
    final prefs = await sharedPrefs;
    DataConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == DataConnectionStatus.connected) {
      final val = await getShowUsage(body);
      retrunValue = true;
      if (val.success==false) {
        user.value = User("", "", "", "", "", "", "", "", "");
        hp.logout();
        prefs.setBool("loggedIn", false);
      }
    }else{
      Helper.showToast(hp.internetMsg);

    }
    return retrunValue;
  }


}
