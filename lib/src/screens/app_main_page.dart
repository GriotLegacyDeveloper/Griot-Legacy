import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/controllers/my_tab_controller.dart';
import 'package:griot_legacy_social_media_app/src/controllers/post_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';

class AppMainPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  //AppMainPage({Key key}) : super(key: key);
  final String profileImg;
  final String profileName;

  const AppMainPage(
      {Key key, @required this.profileImg, @required this.profileName})
      : super(key: key);
  @override
  State<AppMainPage> createState() => _AppMainPageState();
}

class _AppMainPageState extends State<AppMainPage> {
  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
//final prefs = await con.sharedPrefs;

  void didChange(GetBuilderState<PostController> state) {
    state.controller.hp.lockScreenRotation();
  }

  Widget pageBuilder(PostController con) {
    final hp = con.hp;
    //print("INMAINPAGE");
    //print(widget.profileImg);
    final MyTabController tc =
        Get.put(MyTabController(5, hp.context, hp.state));
    return Container(
      color: Colors.black,
      child: SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            appBar: AppBar(
                leading: Container(),
                backgroundColor: hp.theme.primaryColor,
                foregroundColor: hp.theme.secondaryHeaderColor,
                title: Image.asset("assets/images/title.png",
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.fill,
                    width: hp.width,

                    /// 3.2
                    height: hp.height / 40),
                actions: [
                  IconButton(
                      onPressed: () {

                      }, icon: const Icon(Icons.notifications))
                ]),
            body: tc.page,
            backgroundColor: hp.theme.primaryColor,
            bottomNavigationBar: ConvexAppBar(
                disableDefaultTabController: true,
                controller: tc.tabCon,
                onTap: (int b) {
                  con.index = b;
                  tc.tabCon.animateTo(b);
                  switch (b) {
                    case 1:
                      tc.page = ProfilePage(key: hp.k);
                      break;
                    case 3:
                      tc.page = SettingsPage(key: hp.k1);
                      break;
                    case 0:
                      tc.page = const HomePage();
                      break;
                    case 4:
                      tc.page = const HomePage();
                      break;
                    case 2:
                      tc.page = const HomePage();
                      break;
                    default:
                      tc.page = const HomePage();
                      break;
                  }
                  con.update();
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

  @override
  Widget build(BuildContext context) {
    final state =
        context.findAncestorStateOfType<GetBuilderState<PostController>>() ??
            GetBuilderState<PostController>();
    return GetBuilder<PostController>(
        //autoRemove: false,
        builder: pageBuilder,
        init: PostController(context, state),
        didChangeDependencies: didChange);
  }
}
