import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/helpers/helper.dart';

class RouteGenerator {
  BuildContext context;
  GetBuilderState state;
  RouteGenerator(this.context, this.state);
  Helper get hp =>
      Helper.of(context, context.findAncestorStateOfType<GetBuilderState>());
  Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.arguments;
    Widget Function(BuildContext) builder;
    switch (settings.name) {
      case '/login':
        builder = hp.getLoginPage;
        break;
      case '/register':
        builder = hp.getRegisterPage;
        break;
      case '/changePassword':
        builder = hp.getResetPasswordPage;
        break;
      case '/profileUpdate':
        builder = hp.getProfileEditPage;
        break;
      case '/screens':
        builder = hp.getMainPage;
        break;
      case '/mobileLogin':
        builder = hp.getMobileLoginPage;
        break;
      case '/aboutUs':
        builder = hp.getAboutUsPage;
        break;
      case '/accountSettings':
        builder = hp.getAccountSettingsPage;
        break;
      case '/privacyPolicy':
        builder = hp.getPrivacyPolicyPage;
        break;
      case '/faq':
        builder = hp.getFaqPage;
        break;
      case '/termsAndConditions':
        builder = hp.getTermsAndConditionsPage;
        break;
      case '/contactUs':
        builder = hp.getContactUsPage;
        break;
      case '/verifyOTP':
        builder = hp.getOTPPage;
        break;
      case '/inviteFriends':
        builder = hp.getInviteFriendsPage;
        break;
      case '/uploadPost':
        builder = hp.getPostUploadPage;
        break;
      case '/notification':
        builder = hp.getNotificationSceeen;
        break;
      case '/innerPasswordChange':
        builder = hp.getChangePasswordScreen;
        break;
      default:
        // If there is no such named route in the switch statement, e.g. /third
        builder =
            (_) => const Scaffold(body: SafeArea(child: Text('Route Error')));
        break;
    }
    return MaterialPageRoute(builder: builder);
  }
}
