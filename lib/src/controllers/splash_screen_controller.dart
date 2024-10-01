import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/helpers/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenController extends GetxController {
  BuildContext buildContext;
  GetBuilderState getBuilderState;
  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
  Helper get hp => Helper.of(buildContext, getBuilderState);
  SplashScreenController(BuildContext context, GetBuilderState state) {
    buildContext = context;
    getBuilderState = state;
  }

  void proceed() async {
    final prefs = await sharedPrefs;
    //print(prefs.getKeys());
    hp.goToRouteWithNoWayBack(
        "/" +
            (prefs.containsKey("spUserID") &&
                    prefs.containsKey("spLoginID") &&
                    prefs.containsKey("spAuthToken")
                ? "screens"
                : "login"),
        true);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Future.delayed(Helper.duration, proceed);
  }
}
