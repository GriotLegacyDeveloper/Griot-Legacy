import 'dart:io';

class AdHelper {



  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7774621943932197/4831879762";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7774621943932197/1305081189";
    } else {
      throw  UnsupportedError("Unsupported platform");
    }
  }


}