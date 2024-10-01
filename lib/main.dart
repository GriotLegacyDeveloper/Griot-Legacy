import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:griot_legacy_social_media_app/route_generator.dart';
import 'package:griot_legacy_social_media_app/src/services/service_locator.dart';
import 'package:griot_legacy_social_media_app/src/utils/common_color.dart';
import 'package:griot_legacy_social_media_app/src/utils/notification_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'src/screens/splash_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

SharedPreferences sharedPreferences;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
RemoteMessage notificationMessage;

bool isNotificationBell = false;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  flutterLocalNotificationsPlugin?.show(
      message.data.hashCode,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
        ),
      )
  );
}


const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  'channel name',
  importance: Importance.high,
);


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}



void main() async {
  HttpOverrides.global = MyHttpOverrides();
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Set your publishable key here
    Stripe.publishableKey = "pk_test_51N1xgHKwvFDB6eSfrAHsKGiAsXE4lbYHjDejkvUdqwq08PQPsvXnkkVLmfvjMXbXv9ORaZxUd0M8xLiLoloVNEYM00rESJl7KM";

    await Firebase.initializeApp();
    await NotificationService().init();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    sharedPreferences = await SharedPreferences.getInstance();


    await flutterLocalNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await NotificationService().init();


    configLoading();
    setupLocator();
    WidgetsFlutterBinding.ensureInitialized();
    MobileAds.instance.initialize();
    
    runApp(MyApp());
  }

  catch (e) {
    // throw(e);
    rethrow;
  }
}



void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 60.0
    ..radius = 6.0
    ..progressColor = Colors.grey
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.black.withOpacity(0.6)
    ..maskType = EasyLoadingMaskType.custom
    ..userInteractions = false
    ..dismissOnTap = false;
}




class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {


  @override
  void initState() {
    getToken();
  }

  getToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String token = await FirebaseMessaging.instance.getToken();
    print("token     $token");
    SharePrefrence.setToken(token);
  }

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
        title: 'Griot Legacy',
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        onGenerateRoute: RouteGenerator(
                context,
                context.findAncestorStateOfType<GetBuilderState>() ??
                    GetBuilderState())
            .generateRoute,
        theme: ThemeData(
            fontFamily: "Work Sans",
            primarySwatch: Colors.grey,
            primaryColor: Colors.black,
            secondaryHeaderColor: Colors.white,
            hintColor: const Color(0xff7b7b7b),
            errorColor: const Color(0xff434343),
            disabledColor: const Color(0xffDFDFDF),
            cardColor: const Color(0xff2f2f2f),
            hoverColor: const Color(0xff1a1a1a),
            splashColor: const Color(0xff2F2F2F),
            shadowColor: const Color(0xffd7d3ce),
            canvasColor: const Color(0xffb2b2b2),
            dividerColor: const Color(0xff0A0A0A),
            highlightColor: const Color(0xff0c0c0c),
            indicatorColor: const Color(0xff6c6c6c),
            backgroundColor: const Color(0xff141414),
            selectedRowColor: const Color(0xff555454),
            primaryColorLight: const Color(0xff5a5a5a),
            bottomAppBarColor: const Color(0xff191919),
            unselectedWidgetColor: const Color(0xff827A7D),
            scaffoldBackgroundColor: const Color(0xff7e7e7e)));
  }
}
