

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/screens/app_main_page.dart';
import 'package:griot_legacy_social_media_app/src/screens/home_page.dart';
import 'package:griot_legacy_social_media_app/src/screens/profile_page.dart';
import 'package:griot_legacy_social_media_app/src/screens/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

//TickerProviderStateMixin
//
class MyTabController extends GetxController with SingleGetTickerProviderMixin {
  final int count;
  final GetBuilderState state;
  final BuildContext buildContext;
  String imgURL = "";
  String fullName = "";
  // TabController tabCon = TabController(vsync: this, length: 3, initialIndex: 2);
  TabController tabCon;
  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
  Widget page = Container();
  MyTabController(this.count, this.buildContext, this.state);

  void onTap(int a) {
    // tabCon.animateTo(a);
    switch (a) {
      case 1:
        page = const ProfilePage();
        break;
      case 3:
        page = const SettingsPage();
        break;
      case 0:
        page = const HomePage();
        break;
      case 4:
        page = const HomePage();
        break;
      case 2:
        page = const HomePage();
        break;
      default:
        page = const HomePage();
        break;
    }
    state.controller.update();
  }

  void assignControl() {
    tabCon = TabController(vsync: this, length: count, initialIndex: 2);
    if (buildContext.widget ==
        AppMainPage(profileImg: imgURL, profileName: fullName)) {
      page = const HomePage();
    }
  }

  @override
  void onInit() {
    super.onInit();
    initialiseProfileValue();
    tabCon = TabController(length: 5, vsync: this);

    tabCon.index = 2;
    Future.delayed(const Duration(seconds: 1), assignControl);
  }

  void initialiseProfileValue() async {
    final prefs = await sharedPrefs;
    imgURL = prefs.getString("profileImgUrl");
    fullName = prefs.getString("profileFullName");
    //print("IN TAB");
    //print(imgURL);
  }

  @override
  void onClose() {
    tabCon.dispose();
    super.onClose();
  }
}
