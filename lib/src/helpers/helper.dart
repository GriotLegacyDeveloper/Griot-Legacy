import 'dart:async';
import 'dart:math';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:griot_legacy_social_media_app/src/controllers/splash_screen_controller.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';
import 'package:griot_legacy_social_media_app/src/screens/change_password_screen.dart';
import 'package:griot_legacy_social_media_app/src/screens/faq_screen.dart';
import 'package:griot_legacy_social_media_app/src/screens/main_screen.dart';
import 'package:griot_legacy_social_media_app/src/widgets/notification_list_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/screens/about_us_page.dart';
import 'package:griot_legacy_social_media_app/src/screens/account_settings_page.dart';
import 'package:griot_legacy_social_media_app/src/screens/app_main_page.dart';
import 'package:griot_legacy_social_media_app/src/screens/contact_us_page.dart';
import 'package:griot_legacy_social_media_app/src/screens/invite_friends_page.dart';
import 'package:griot_legacy_social_media_app/src/screens/login_page.dart';
import 'package:griot_legacy_social_media_app/src/screens/mobile_login_page.dart';
import 'package:griot_legacy_social_media_app/src/screens/otp_verification_page.dart';
import 'package:griot_legacy_social_media_app/src/screens/privacy_policy_page.dart';
import 'package:griot_legacy_social_media_app/src/screens/profile_edit_page.dart';
import 'package:griot_legacy_social_media_app/src/screens/register_page.dart';
import 'package:griot_legacy_social_media_app/src/screens/reset_password_page.dart';
import 'package:griot_legacy_social_media_app/src/screens/terms_and_conditions_page.dart';
import 'package:griot_legacy_social_media_app/src/screens/upload_post_page.dart';
import 'package:griot_legacy_social_media_app/src/widgets/circular_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  BuildContext context;
  GetBuilderState state;
  int otpLength = 6;
  Key k = const Key("profile_page"),
      k1 = Key(
          "settings_page" + Random().nextInt(pow(10, 9).toInt()).toString());
  static const duration = Duration(seconds: 5);
  List<FocusNode> fcNs = <FocusNode>[];
  List<TextEditingController> tec = <TextEditingController>[];
  ThemeData get theme => Theme.of(context);
  MediaQueryData get dimensions => MediaQuery.of(context);
  FocusScopeNode get node => FocusScope.of(context);
  OverlayState get overlayState => Overlay.of(context);
  OverlayEntry get loader =>
      OverlayEntry(builder: getLoader, maintainState: true);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(height, 2) + pow(width, 2));
  double get textScaleFactor => dimensions.textScaleFactor;
  double get pixelRatio => dimensions.devicePixelRatio;
  double get aspectRatio => size.aspectRatio;
  String img, name,internetMsg="no internet check your connection!";
  num get factor => pow(
      pow(textScaleFactor, 3) + pow(pixelRatio, 3) + pow(aspectRatio, 3),
      1 / 3);
  Helper.of(BuildContext buildContext, GetBuilderState getBuilderState) {
    context = buildContext;
    state = getBuilderState ?? GetBuilderState();
    if (buildContext.widget == AppMainPage()) {
      loader.remove();
    }
  }

  void showLoader() {
    WidgetsBinding.instance.addPostFrameCallback(loaderScheduler);
  }

  void loaderScheduler(Duration dt) {
    SchedulerBinding.instance.addPostFrameCallback(bringLoader);
  }

  void bringLoader(Duration dt) {
    overlayState.insert(loader);
  }

  void hideLoader() {
    try {
      print(Overlay.of(context));
      Future.delayed(Duration.zero, loader.remove);
      print("Hi");
      // loader.mounted ? loader.remove() : print("Bye");
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static String limitString(String text,
      {int limit = 24, String hiddenText = "..."}) {
    return text.substring(0, min<int>(limit, text.length)) +
        (text.length > limit ? hiddenText : '');
  }

  Widget getLoader(BuildContext buildContext) {
    final size = MediaQuery.of(buildContext).size;
    final theme = Theme.of(buildContext);
    return Positioned(
        height: size.height,
        width: size.width,
        top: 0,
        left: 0,
        child: Material(
            color: theme.secondaryHeaderColor.withOpacity(0.85),
            child: CircularLoader(
                duration: duration,
                heightFactor: 16,
                color: theme.primaryColor,
                loaderType: LoaderType.pouringHourGlass)));
  }

  String putDateToString(DateTime dt) {
    final DateFormat formatter = DateFormat('MM-dd-yyyy');
    final String formatted = formatter.format(dt);
    // dt.day.toString() + "/" + dt.month.toString() + "/" + dt.year.toString();
    print("formatted....... $formatted");
    return formatted;
  }
  String putDateToServer(DateTime dt) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(dt);
    // dt.day.toString() + "/" + dt.month.toString() + "/" + dt.year.toString();
    print("newwwwwwwww....... $formatted");
    return formatted;
  }




  String putDateTimeToString(DateTime element) {
    String sep = "/";
    int ds = (element.millisecond * 1000) + element.microsecond;
    String str = element.year.toString() +
        sep +
        element.month.toString() +
        sep +
        element.day.toString() +
        "|" +
        element.hour.toString() +
        ":" +
        element.minute.toString() +
        ":" +
        element.second.toString() +
        "." +
        ds.toString();
    return str;
  }

  Future<DateTime> getDatePicker(TextEditingController tc, bool flag,TextEditingController forServer) async {
    try {
      //- 13
      final today = DateTime.now();
      final iDate =
          flag ? DateTime(today.year - 13, today.month, today.day - 1) : today;
      final picked = await showDatePicker(
          context: context,
          initialDate: DateTime(today.year-13, today.month, today.day),
          firstDate: flag
              ? DateTime(today.year - 99, today.month, today.day)
              : DateTime(today.year, today.month, today.day - 1),
          lastDate: flag
              ? DateTime(today.year, today.month, today.day)
              : DateTime(today.year + 50, today.month, today.day));
      tc.text = putDateToString(picked);
      forServer.text=putDateToServer(picked);
     // putDateToServer(picked);
      print("picked   $picked");
      return picked;
    } catch (e) {
      rethrow;
    }
  }

//
  Widget errorBuilder(
      BuildContext buildContext, Object object, StackTrace trace) {
    final size = MediaQuery.of(buildContext).size;
    return Image.asset("assets/images/loading.gif",
        matchTextDirection: true,
        height: size.height / 12.8,
        width: size.width / 6.4,
        fit: BoxFit.fill);
  }

  Widget getPlaceHolder(BuildContext buildContext, int val, bool flag) {
    final size = MediaQuery.of(buildContext).size;
    print(val);
    return Image.asset("assets/images/loading.gif",
        height: size.height / 12.8, width: size.width / 6.4, fit: BoxFit.fill);
  }

  bool isEmail(String email) {
    RegExp re = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return re.hasMatch(email) && re.allMatches(email).length == 1;
  }

  String validateEmail(String email) {
    return email != null && email.isNotEmpty && email.isEmail
        ? null
        : "Please enter valid email id";
  }

  String validateName(String name) {
    return name != null &&
            name.isNotEmpty &&
            !name.contains(RegExp(r'[0-9]')) &&
            name.length > 2
        ? null
        : "Please enter a valid name(number not allowed)";
  }

  String validateDate(String date) {
    return date != null && date.isNotEmpty //&& date.isDateTime
        ? null
        : "Invalid Date";
  }

  String validatePassword(String password) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return password != null && password.isNotEmpty && regExp.hasMatch(password)
        ? null
        : "Invalid Password";
  }

  Color getColorFromHex(String hex) {
    return Color(int.parse(
        hex.contains('#') ? hex.replaceAll("#", "0xFF") : ("0xFF" + hex)));
  }

  KeyEventResult getNodeResult(FocusNode a, RawKeyEvent b) {
    try {
      final flag =
          b.isKeyPressed(LogicalKeyboardKey.backspace) && fcNs.indexOf(a) != 1;
      if (flag) fcNs[fcNs.indexOf(a) - 1].requestFocus();
      return KeyEventResult.handled;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> goToRoute(String route) async {
    final p = await Get.toNamed(route);
    // Get.to<StatelessWidget>(page);
    print("p...... $p");
  }
  Future<void> goToAboutusRoute(String route,String text) async {
    final p = await Get.toNamed(route,arguments: text);
    // Get.to<StatelessWidget>(page);
    print("p...... $p");
  }


  void goBack({int id, dynamic result}) {
    Get.back(result: result, id: id);
  }

  void goToRouteWithNoWayBack(String route, bool flag) async {
    final p = flag
        ? await Get.offAllNamed(route, predicate: predicate)
        : await Get.offNamed(route);
    print(p);
  }

  bool predicate(Route route) {
    print(route);
    return false;
  }

  void logout() async {
    bool flag = true;
    final prefs = await SharedPreferences.getInstance();
    for (String key in prefs.getKeys()) {
      flag = flag &&
          (key == "spDeviceToken" ||
                  key == "spAppType" ||
                  key == "shownInviteFriend"
              ? true
              : await prefs.remove(key));
    }
    if (flag) goToRoute('/login');
  }

  void doNothing() {}

  void lockScreenRotation() async {
    await SystemChrome.setPreferredOrientations([
      // DeviceOrientation.landscapeRight,
      // DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
    ]);
  }

  String changeDateFormat(String dateString) {
    try {
      final str = dateString.split("/").reversed.join("-");
      final date = DateTime.parse(str);
      return DateFormat.yMMMMd().format(date);
    } catch (e) {
      print(e);
      return "";
    }
  }

  Widget getOTPPage(BuildContext context) {
    return Get.find<UserController>().initialized
        ? const OTPVerificationPage()
        : Container();
  }

  Widget getLoginPage(BuildContext context) {
    return LoginPage();
  }

  Widget getRegisterPage(BuildContext context) {
    return const RegisterPage();
  }

  Widget getMobileLoginPage(BuildContext context) {
    return MobileLoginPage();
  }

  Widget getMainPage(BuildContext context) {
    return const MainScreen();
  }

  Widget getPrivacyPolicyPage(BuildContext context) {
    return const PrivacyPolicyPage();
  }

  Widget getTermsAndConditionsPage(BuildContext context) {
    return const TermsAndConditionsPage();
  }

  Widget getAboutUsPage(BuildContext context) {
    return const AboutUsPage();
  }

  Widget getInviteFriendsPage(BuildContext context) {
    return InviteFriendsPage();
  }

  Widget getAccountSettingsPage(BuildContext context) {
    return const AccountSettingsPage();
  }

  Widget getContactUsPage(BuildContext context) {
    return const ContactUsPage();
  }

  Widget getFaqPage(BuildContext context) {
    return const FaqPage();
  }

  Widget getResetPasswordPage(BuildContext context) {
    return ResetPasswordPage();
  }

  Widget getProfileEditPage(BuildContext context) {
    return ProfileEditPage();
  }

  Widget getPostUploadPage(BuildContext context) {
    return  UploadPostPage();
  }
  Widget getNotificationSceeen(BuildContext context) {
    return const NotificationListWidget();
  }
  Widget getChangePasswordScreen(BuildContext context) {
    return const ChangePasswordPage();
  }

  static getProgressLoader(SplashScreenController con) {
    final hp = con.hp;
    return CircularLoader(
        heightFactor: 32,
        loaderType: LoaderType.fadingCube,
        duration: Helper.duration,
        color: hp.theme.secondaryHeaderColor);
  }


  static showToast(String message){
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0
    );
  }
}
