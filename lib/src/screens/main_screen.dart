import 'dart:async';
import 'dart:math';
import 'package:griot_legacy_social_media_app/src/screens/edit_advertisement_page.dart';

import '../models/get_advertisement_response_model.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/controllers/my_tab_controller.dart';
import 'package:griot_legacy_social_media_app/src/controllers/post_controller.dart';
import 'package:griot_legacy_social_media_app/src/models/get_storage_list_response_model.dart';
import 'package:griot_legacy_social_media_app/src/models/home_data_model.dart';
import 'package:griot_legacy_social_media_app/src/screens/account_settings_page.dart';
import 'package:griot_legacy_social_media_app/src/screens/friends_screen.dart';
import 'package:griot_legacy_social_media_app/src/screens/other_user_profile.dart';
import 'package:griot_legacy_social_media_app/src/screens/payment_screen.dart';
import 'package:griot_legacy_social_media_app/src/screens/payment_screen_for_storage.dart';
import 'package:griot_legacy_social_media_app/src/screens/search_screen.dart';
import 'package:griot_legacy_social_media_app/src/screens/storage_list_screen.dart';
import 'package:griot_legacy_social_media_app/src/screens/storage_screen.dart';
import 'package:griot_legacy_social_media_app/src/widgets/chat_list_widget.dart';
import 'package:griot_legacy_social_media_app/src/widgets/notification_list_widget.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../size_config.dart';
import '../utils/common_color.dart';
import 'advertisement_add_page.dart';
import 'advertisment_list_page.dart';
import 'dashboard_screen.dart';
import 'home_page.dart';
import 'profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreen>
    with
        ProfilePageInterface,
        HomePageInterface,
        OtherProfilePageInterface,
        SearchScreenInterface,
        WidgetsBindingObserver,
        AccountSettingsPageInterface,
        AdvertisementListInterface,
        AdvertisementAddPageInterface,
        PaymentScreenInterface,
        StorageScreenInterface,
        StorageListScreenInterface,
        PaymentScreenForStorageInterface,
        AdvertisementEditPageInterface{
  PageController _pageController = PageController(initialPage: 2);
  int _currentIndexBottomBar = 8;

  @override
  void initState() {
    super.initState();
    notificationData();
    getDate();
    setState(() {
      _pageController = PageController();
      Timer(const Duration(milliseconds: 200), () {
        _pageController?.jumpToPage(_currentIndexBottomBar);
      });
    });

    getShowUsage(todayInTime, "");
    WidgetsBinding.instance.addObserver(this);
  }

  void didChange(GetBuilderState<PostController> state) {
    state.controller.hp.lockScreenRotation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //index==3 on scroll down

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // user returned to our app
      /*  getDate();
      getShowUsage(todayInTime, "");*/

      //print("didChangeAppLifecycleState  in  resumed");

    } else if (state == AppLifecycleState.inactive) {
      getOutDate();
      getShowUsage("", todayOutTime);
      // app is inactive

      /// print("didChangeAppLifecycleState    in inactive");
    } else if (state == AppLifecycleState.paused) {
      // user is about quit our app temporally
      //print("didChangeAppLifecycleState  in paused");
    }
  }

  notificationData() {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = const IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin?.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      setState(() {
        isNotificationBell = true;
      });

      _showNotification(flutterLocalNotificationsPlugin,
          title: event.notification?.title, message: event.notification?.body);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      //print('Message clicked!');
    });
  }

  Future onSelectNotification(payload) async {
    try {
      WidgetsBinding.instance?.addPostFrameCallback((_) {});

      // Navigator.pushNamed(context, "/dashBoard");
      /* print("Select Noti Click trigger");
       return Navigator.pushAndRemoveUntil(myContext,
          MaterialPageRoute(
            builder: (_) => DashBoardScreen(comeFrom: 'Push',),
          ),
              (route) => false);*/
      //print("Select Noti Click trigger ");
    } catch (e) {
      // print(e);
      // print(s);
    }
  }

  Future _showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      {String title,
      message}) async {
    var rng = Random();
    var androidDetails = AndroidNotificationDetails(
        "Channel ID${rng.nextInt(10000)}", message,
        importance: Importance.max);
    var iSODetails = const IOSNotificationDetails();
    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iSODetails);

    await flutterLocalNotificationsPlugin.show(
        0, title, "$message", generalNotificationDetails,
        payload: "Event");
  }

  Future<bool> _onWillPop() async {
    //print("currentindex   $_currentIndexBottomBar");
    return false;
    /*return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(),
    )) ?? false;*/
  }

  Widget pageBuilder(PostController con) {
    SizeConfig().init(context);
    final hp = con.hp;
    final MyTabController tc =
        Get.put(MyTabController(5, hp.context, hp.state));
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            appBar: _currentIndexBottomBar == 3 ||
                    _currentIndexBottomBar == 5 ||
                    _currentIndexBottomBar == 4 ||
                    _currentIndexBottomBar == 6
                ? null
                : _currentIndexBottomBar == 9 ||
                        _currentIndexBottomBar == 11 ||
                        _currentIndexBottomBar == 12 ||
                        _currentIndexBottomBar == 13
                    ? AppBar(
                        backgroundColor: hp.theme.primaryColor,
                        foregroundColor: hp.theme.secondaryHeaderColor,
                        leading: GestureDetector(
                            onTap: () {
                              print("ffhfhfb $_currentIndexBottomBar");
                              if (_currentIndexBottomBar == 9 ||
                                  _currentIndexBottomBar == 12) {
                                if (mounted) {
                                  setState(() {
                                    _currentIndexBottomBar = 3;
                                  });
                                }
                                _pageController
                                    .jumpToPage(_currentIndexBottomBar);
                              } else if (_currentIndexBottomBar == 11) {
                                if (mounted) {
                                  setState(() {
                                    _currentIndexBottomBar = 9;
                                  });
                                }
                                _pageController
                                    .jumpToPage(_currentIndexBottomBar);
                              } else if (_currentIndexBottomBar == 13) {
                                if (mounted) {
                                  setState(() {
                                    _currentIndexBottomBar = 12;
                                  });
                                }
                                _pageController
                                    .jumpToPage(_currentIndexBottomBar);
                              }
                            },
                            onDoubleTap: () {},
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                        title: Text(
                          _currentIndexBottomBar == 9
                              ? "Advertisements"
                              : _currentIndexBottomBar == 11
                                  ? "Payment"
                                  : _currentIndexBottomBar == 12
                                      ? "Storage"
                                      : _currentIndexBottomBar == 13
                                          ? "Packages"
                                          : "",
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 5.2,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ))
                    : AppBar(
                        backgroundColor: hp.theme.primaryColor,
                        foregroundColor: hp.theme.secondaryHeaderColor,
                        title: _currentIndexBottomBar == 7
                            ? null
                            : GestureDetector(
                                onTap: () {
                                  if (mounted) {
                                     FocusScope.of(context).requestFocus(FocusNode());
                                    setState(() {
                                      _currentIndexBottomBar = 8;
                                      isNotificationBell = false;
                                    });
                                  }
                                  _pageController
                                      .jumpToPage(_currentIndexBottomBar);
                                },
                                onDoubleTap: () {},
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16),
                                        child: Image.asset(
                                            "assets/images/title.png",
                                            alignment: Alignment.centerLeft,
                                            fit: BoxFit.fill,
                                            width: hp.width / 2.5,
                                            height: hp.height / 40),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        leadingWidth: 0,
                        titleSpacing: 0,
                        actions: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (mounted) {
                                        setState(() {
                                          _currentIndexBottomBar = 5;
                                          isNotificationBell = false;
                                        });
                                      }
                                      _pageController
                                          .jumpToPage(_currentIndexBottomBar);
                                      //print("notification6666");
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: CircleAvatar(
                                          child: Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              const Icon(
                                                Icons.notifications_rounded,
                                                color: Colors.white,
                                              ),
                                              Visibility(
                                                visible: isNotificationBell,
                                                child: Container(
                                                  height:
                                                      SizeConfig.screenHeight *
                                                          .015,
                                                  width:
                                                      SizeConfig.screenHeight *
                                                          .015,
                                                  decoration: const BoxDecoration(
                                                      color: CommonColor
                                                          .notificationAlertColor,
                                                      shape: BoxShape.circle),
                                                ),
                                              )
                                            ],
                                          ),
                                          backgroundColor: Colors.white24,
                                          foregroundColor:
                                              hp.theme.primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
            body: SizedBox.expand(
                child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (index) {
                //print("index....... $index");
                setState(() => _currentIndexBottomBar = index);
              },
              children: <Widget>[
                SearchScreen(
                  mListener: this,
                ),
                ProfilePage(
                  mListener: this,
                ),
                HomePage(
                  mListener: this,
                ),
                AccountSettingsPage(
                  mListener: this,
                ),
                const ChatListWidget(),
                const NotificationListWidget(),
                const FriendsScreen(isTribe: true),
                OtherProfilePage(
                  id: otheruserId,
                  mListener: this,
                ),
                const DashBoardScreen(),
                AdvertisementList(
                  mListener: this,
                ),
                AdvertisementAddPage(
                  mListener: this,
                ),
                PaymentScreen(
                  id: advId,
                  mListener: this,
                ),
                StorageScreen(
                  mListener: this,
                ),
                StorageListScreen(
                  mListerner: this,
                ),
                PaymentScreenForStorage(
                  mListener: this,
                  id: packageId,
                  packageModel: packageModel,
                ),
                AdvertisementEditPage(
                  mListener: this,
                  advertisementData:advertisementDataValue
                ),

                // PostDetailsPage(),
              ],
            )),
            backgroundColor: hp.theme.primaryColor,
            bottomNavigationBar: ConvexAppBar(
                disableDefaultTabController: true,
                controller: tc.tabCon,
                onTap: (int b) {
                  setState(() {
                    _currentIndexBottomBar = b;
                    isNotificationBell = false;
                  });
                  _pageController?.jumpToPage(_currentIndexBottomBar);
                },
                items: [
                  const TabItem(icon: Icons.search),
                  const TabItem(icon: Icons.person),
                  TabItem(
                      icon: CircleAvatar(
                          backgroundColor: tc.tabCon.index == 2
                              ? hp.theme.splashColor
                              : hp.theme.backgroundColor,
                          backgroundImage:
                              const AssetImage("assets/images/logic.png"))),
                  const TabItem(icon: Icons.settings),
                  const TabItem(icon: Icons.message)
                ],
                style: TabStyle.fixedCircle,
                initialActiveIndex: con.index,
                backgroundColor: hp.theme.backgroundColor),
          )),
    );
  }

  PostController controller;
  String todayDate = "", todayInTime = "", todayOutTime = "";

  getDate() {
    var now = DateTime.now();
    //print("nnnnn $now");

    var formatter = DateFormat('dd-MM-yyyy');
    var formatterOne = DateFormat('HH:mm:ss');
    String formattedDate = formatter.format(now);
    String formattedTime = formatterOne.format(now);

    setState(() {
      todayDate = formattedDate;
      todayInTime = formattedTime;
    });
    // print("formattedDate  $formattedTime");
  }

  getOutDate() {
    var now = DateTime.now();
    //print("nnnnn $now");

    var formatter = DateFormat('dd-MM-yyyy');
    var formatterOne = DateFormat('HH:mm:ss');
    String formattedDate = formatter.format(now);
    String formattedTime = formatterOne.format(now);

    setState(() {
      todayDate = formattedDate;
      todayOutTime = formattedTime;
    });
    // print("formattedDate  $formattedTime");
  }

  getShowUsage(String inTime, String outTime) async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<PostController>>() ??
            GetBuilderState<PostController>();
    controller = PostController(context, state);
    final prefs = await controller.sharedPrefs;
    final obj = {
      "id": prefs.getString("spUserID"),
      "IN": inTime,
      "OUT": outTime,
      "date": todayDate,
    };
    // print(obj);
    controller.waitUntilShowUsage(obj).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final state =
        context.findAncestorStateOfType<GetBuilderState<PostController>>() ??
            GetBuilderState<PostController>();
    return pageBuilder(PostController(context, state));
  }

  @override
  addFriendScreen() {
    // TODO: implement addFriendScreen
    if (mounted) {
      setState(() {
        _currentIndexBottomBar = 6;
      });
    }
    _pageController.jumpToPage(_currentIndexBottomBar);
  }

  DashboardData newmodelData;
  String otheruserId = "";
  @override
  addDetailsPage(String id) {
    // TODO: implement addDetailsPage
    //throw UnimplementedError();
    if (mounted) {
      setState(() {
        _currentIndexBottomBar = 7;
        otheruserId = id;
      });
    }
    _pageController.jumpToPage(_currentIndexBottomBar);
  }

  @override
  addScreen() {
    // TODO: implement addScreen
    //print("ffffff");
    if (mounted) {
      setState(() {
        _currentIndexBottomBar = 2;
      });
    }
    _pageController.jumpToPage(_currentIndexBottomBar);
  }

  @override
  addAdvertesmentScreen() {
    // TODO: implement addAdvertesmentScreen
    if (mounted) {
      setState(() {
        _currentIndexBottomBar = 9;
      });
    }
    _pageController.jumpToPage(_currentIndexBottomBar);
  }

  @override
  addAddAdvertismentScreen() {
    // TODO: implement addAddAdvertismentScreen
    if (mounted) {
      setState(() {

        _currentIndexBottomBar = 10;

      });
    }
    _pageController.jumpToPage(_currentIndexBottomBar);
  }

  @override
  editAdvertismentScreen(ResponseData advertisementData) {
    // TODO: implement addAddAdvertismentScreen
    if (mounted) {
      setState(() {
        advertisementDataValue=advertisementData;
        _currentIndexBottomBar = 16;
      });
    }
    _pageController.jumpToPage(_currentIndexBottomBar);
  }

  String advId = "", titleOfAds = "";
  String packageId = "";
  ResponseDatum packageModel;
ResponseData advertisementDataValue;

  @override
  addPaymentScreen(String id, String name) {
    // TODO: implement addPaymentScreen
    if (mounted) {
      setState(() {
        _currentIndexBottomBar = 11;
        advId = id;
        titleOfAds = name;
      });
    }
    _pageController.jumpToPage(_currentIndexBottomBar);
  }

  @override
  addBackPaymentScreen() {
    // TODO: implement addBackPaymentScreen
    if (mounted) {
      setState(() {
        _currentIndexBottomBar = 9;
      });
    }
    _pageController.jumpToPage(_currentIndexBottomBar);
  }

  @override
  addBackSearchScreen() {
    // TODO: implement addBackPaymentScreen
    if (mounted) {
      setState(() {
        _currentIndexBottomBar = 8;
      });
    }
    _pageController.jumpToPage(_currentIndexBottomBar);
  }

  @override
  addStorageScreen() {
    // TODO: implement addStorageScreen
    if (mounted) {
      setState(() {
        _currentIndexBottomBar = 12;
      });
    }
    _pageController.jumpToPage(_currentIndexBottomBar);
  }

  @override
  addListScreen() {
    // TODO: implement addListScreen
    if (mounted) {
      setState(() {
        _currentIndexBottomBar = 13;
      });
    }
    _pageController.jumpToPage(_currentIndexBottomBar);
  }

  @override
  addPaymentScreenForStorage(String id, ResponseDatum model) {
    // print("addPaymentScreenForStorage >> ${id}");
    // print("addPaymentScreenForStorage >> ${model.toJson()}");
    setState(() {
      packageId = id;
      packageModel = model;
    });

    if (mounted) {
      setState(() {
        _currentIndexBottomBar = 14;
      });
    }
    _pageController.jumpToPage(_currentIndexBottomBar);
  }

}
