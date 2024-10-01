import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonColor{
  static const Boxcolors =  Color(0xffC4C4C4);
  static const goldenColor =  Color(0xffDFC964);
  static const notificationAlertColor =  Color(0xffFF3D3D);
  static const boxColor =  Color(0xff2F2F2F);
  static const cardColor =  Color(0xffD9D9D9);
  static const greenColor =  Color(0xff69A812);
  static const iconCOlor =  Color(0xff5A5A5A);
  static const textColor =  Color(0xff595959);
  static const offWhiteColor =  Color(0xffD7D3CE);
  static const brownColor =  Color(0xffB4893C);
  static const pinkColor =  Color(0xffEF4694);
  static const darkBrownColor =  Color(0xffF49D00);
  static const blackoff =  Color(0xff1B1A1A);
  static const yellowColor =  Color(0xffD0B62E);
  static const redColor =  Color(0xffEF1F1F);
  static const offRedColor =  Color(0xffC53B3B);
  static const yellowOffColor =  Color(0xffC5913B);
 // static const yellowOffColor =  Color(0xff191919);

}


class SharePrefrence {
  static Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString("deviceToken") ?? '';
  }

  /*set language value form SharedPreferences*/
  static setToken(String deviceToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("deviceToken", deviceToken);
  }
}