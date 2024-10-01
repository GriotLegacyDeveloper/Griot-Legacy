import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/helpers/helper.dart';
import 'package:griot_legacy_social_media_app/src/repos/user_repos.dart';
import 'package:griot_legacy_social_media_app/src/screens/internet_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtherController extends GetxController {
  BuildContext buildContext;
  GetBuilderState getBuilderState;
  bool throughEmail = false;
  Helper get hp => Helper.of(buildContext, getBuilderState);
  OtherController(BuildContext context, GetBuilderState state) {
    buildContext = context;
    getBuilderState = state;
  }

  void setMode() {
    throughEmail = !throughEmail;
  }

}
