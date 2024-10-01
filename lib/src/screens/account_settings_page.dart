import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';
import 'package:griot_legacy_social_media_app/src/models/get_content_model.dart';
import 'package:griot_legacy_social_media_app/src/screens/about_us_page.dart';
import 'package:griot_legacy_social_media_app/src/screens/block_list_screen.dart';
import 'package:griot_legacy_social_media_app/src/screens/block_tribe_list_page.dart';
import 'package:griot_legacy_social_media_app/src/screens/storage_screen.dart';
import 'package:griot_legacy_social_media_app/src/widgets/custom_switch_widget.dart';
import '../models/get_setting_response_model.dart';


class AccountSettingsPage extends StatefulWidget {
  final AccountSettingsPageInterface mListener;
  const AccountSettingsPage({Key key, this.mListener}) : super(key: key);

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  UserController controller;
  bool notification = true;
  bool profilePrivacy = true;
  bool loaderFlag = true;
  String notificationText="ON";
  String profileText="PUBLIC";

  Widget pageBuilder(UserController controller) {
    final hp = controller.hp;
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: hp.theme.primaryColor,
            foregroundColor: hp.theme.secondaryHeaderColor,
            title: Container(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Settings",
                    style: TextStyle(color: hp.theme.secondaryHeaderColor,
                        fontSize: SizeConfig.blockSizeHorizontal *5.2),
                    textScaleFactor: 1.2,
                  ),
                ],
              ),
            ),
          ),
      backgroundColor: hp.theme.primaryColor,
      body: Stack(
        children: [
          Padding(
            padding:  EdgeInsets.only(left: SizeConfig.screenWidth *.05,
                right: SizeConfig.screenWidth *.03),
            child: ListView(
              padding: EdgeInsets.zero,
               // verticalDirection: VerticalDirection.down,
                children: [
             // Padding(padding: EdgeInsets.only(top: hp.height * 0.01)),
              Container(
              height: SizeConfig.screenHeight *0.08,

                decoration: BoxDecoration(
                  color: hp.theme.primaryColor,
                  border: Border(
                      bottom: BorderSide(
                          color: hp.theme.hoverColor, width: hp.radius / 800)),
                ),
                child: Row(children: [
                  Text(
                      "Notification " "- " + (notification ? "On" : "off"),
                      style: TextStyle(
                         /* fontFamily: "Gotham Rounded",
                          fontWeight: FontWeight.w300,*/
                        fontSize: SizeConfig.blockSizeHorizontal *4.0,
                          color: controller.hp.theme.secondaryHeaderColor),
                    textScaleFactor: 1.1,
                  ),
                  CustomSwitch(
                    value: notification,
                    activeColor: notification?Colors.white:Colors.grey,
                    inactiveColor:!notification?Colors.white:Colors.grey,

                    onChanged: (bool val) {

                      setState(() {
                      //  print("val... $val");
                        notification = val;
                        if(val){
                          notificationText="ON";
                        }else{
                          notificationText="OFF";
                        }
                        updateSettingApi(profileText,val?"ON":"OFF");
                      });
                    },
                  ),
                  /* MySwitch(
                      value: controller.notFlag, onChanged: controller.setNot)*/
                ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
              ),
             /* Container(
                height: 0.05,
                color: Colors.grey,
              ),*/
              //Padding(padding: EdgeInsets.only(top: hp.height * 0.02)),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          hp.context,
                          MaterialPageRoute(
                            builder: (context) =>  const BlockListScreen(
                            ),
                          ));
                    },
                    onDoubleTap: (){},
                    child: Container(
                      height: SizeConfig.screenHeight *0.08,
                      decoration: BoxDecoration(
                        color: hp.theme.primaryColor,
                        border: Border(
                            bottom: BorderSide(
                                color: hp.theme.hoverColor, width: hp.radius / 800)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Block List",
                              style: TextStyle(
                                /* fontFamily: "Gotham Rounded",
                                        fontWeight: FontWeight.w300,*/
                                  fontSize: SizeConfig.blockSizeHorizontal *4.0,
                                  color: controller.hp.theme.secondaryHeaderColor),
                            textScaleFactor: 1.1,
                          ),
                          Icon(Icons.arrow_forward,color: Colors.white,
                            size: SizeConfig.screenHeight *0.025,)

                        ],
                      ),
                    ),
                  ),
                 // Padding(padding: EdgeInsets.only(top: hp.height * 0.02)),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          hp.context,
                          MaterialPageRoute(
                            builder: (context) =>  const BlockTribeListScreen(
                            ),
                          ));
                    },
                    onDoubleTap: (){},
                    child: Container(
                      height: SizeConfig.screenHeight *0.08,
                      decoration: BoxDecoration(
                        color: hp.theme.primaryColor,
                        border: Border(
                            bottom: BorderSide(
                                color: hp.theme.hoverColor, width: hp.radius / 800)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Block Tribe List",
                            style: TextStyle(
                              /* fontFamily: "Gotham Rounded",
                                        fontWeight: FontWeight.w300,*/
                                fontSize: SizeConfig.blockSizeHorizontal *4.0,
                                color: controller.hp.theme.secondaryHeaderColor),
                            textScaleFactor: 1.1,
                          ),
                          Icon(Icons.arrow_forward,color: Colors.white,
                            size: SizeConfig.screenHeight *0.025,)

                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onDoubleTap: (){},
                    onTap: (){
                      hp.goToRoute("/innerPasswordChange");

                    },
                    child: Container(
                      height: SizeConfig.screenHeight *0.08,

                      decoration: BoxDecoration(
                        color:
                        hp.theme.primaryColor,
                        border: Border(
                            bottom: BorderSide(
                                color: hp.theme.hoverColor, width: hp.radius / 800)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Text("Change Password",
                              style: TextStyle(
                                  fontSize: SizeConfig.blockSizeHorizontal *4.0,
                                  color: controller.hp.theme.secondaryHeaderColor),
                            textScaleFactor: 1.1,
                          ),
                          Icon(Icons.arrow_forward,color: Colors.white,
                            size: SizeConfig.screenHeight *0.025,)
                        ],
                      ),
                    ),
                  ),
             /* Expanded(
                  child: SettingsListWidget(links: [
                    QuickLink("Block List", () {}),
                    QuickLink("Reset Password", () {
                      // hp.goToRoute("/changePassword");
                    })
                  ],come: "1",),
                  flex: 44),*/
             // Padding(padding: EdgeInsets.only(top: hp.height * 0.01)),
              Container(
                height: SizeConfig.screenHeight *0.08,

                decoration: BoxDecoration(
                  color:
                  hp.theme.primaryColor,
                  border: Border(
                      bottom: BorderSide(
                          color: hp.theme.hoverColor, width: hp.radius / 800)),
                ),
                child: Row(children: [
                  Text(
                      "Profile Privacy" "- " +
                          (profilePrivacy ? "Public" : "Private"),
                      style:
                          TextStyle(color: hp.theme.secondaryHeaderColor,
                            fontSize: SizeConfig.blockSizeHorizontal *4.0,
                          ),textScaleFactor: 1.1,),
                  CustomSwitch(
                    value: profilePrivacy,
                    activeColor: Colors.white,
                    inactiveColor: Colors.grey,
                    onChanged: (bool val) {
                      setState(() {
                        profilePrivacy = val;
                        if(val){
                          profileText="PUBLIC";
                        }else{
                          profileText="PRIVATE";
                        }
                        updateSettingApi(val?"PUBLIC":"PRIVATE",notificationText);
                      });
                    },
                  ),
                  /*  MySwitch(
                      value: controller.profFlag,
                      onChanged: controller.setProfileVisibility)*/
                ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
              ),
                  GestureDetector(
                    onDoubleTap: (){},
                    onTap: (){
                      settingContentAPi("aboutus");
                      //hp.goToRoute("/aboutUs");
                    },
                    child: Container(
                      height: SizeConfig.screenHeight *0.08,

                      decoration: BoxDecoration(
                        color:
                        hp.theme.primaryColor,
                        border: Border(
                            bottom: BorderSide(
                                color: hp.theme.hoverColor, width: hp.radius / 800)),
                      ),
                      child: Row(
                        children: [
                          Text("About Us",
                              style: TextStyle(
                                /* fontFamily: "Gotham Rounded",
                                        fontWeight: FontWeight.w300,*/
                                  fontSize: SizeConfig.blockSizeHorizontal *4.0,
                                  color: controller.hp.theme.secondaryHeaderColor),
                          textScaleFactor: 1.1,),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onDoubleTap: (){},
                    onTap: (){
                      settingContentAPi("termsandconditions");
                      //hp.goToRoute("/termsAndConditions");
                    },
                    child: Container(
                      height: SizeConfig.screenHeight *0.08,

                      decoration: BoxDecoration(
                        color:
                        hp.theme.primaryColor,
                        border: Border(
                            bottom: BorderSide(
                                color: hp.theme.hoverColor, width: hp.radius / 800)),
                      ),
                      child: Row(
                        children: [
                          Text("Terms & Conditions",
                              style: TextStyle(
                                /* fontFamily: "Gotham Rounded",
                                        fontWeight: FontWeight.w300,*/
                                  fontSize: SizeConfig.blockSizeHorizontal *4.0,
                                  color: controller.hp.theme.secondaryHeaderColor),
                          textScaleFactor: 1.1,),
                        ],
                      ),
                    ),
                  ),
             GestureDetector(
                    onDoubleTap: (){},
                    onTap: (){
                      settingContentAPi("privacy");

                      //hp.goToRoute("/privacyPolicy");
                    },
                    child: Container(
                      height: SizeConfig.screenHeight *0.08,

                      decoration: BoxDecoration(
                        color:
                        hp.theme.primaryColor,
                        border: Border(
                            bottom: BorderSide(
                                color: hp.theme.hoverColor, width: hp.radius / 800)),
                      ),
                      child: Row(
                        children: [
                          Text("Privacy & Policy",
                              style: TextStyle(
                                /* fontFamily: "Gotham Rounded",
                                        fontWeight: FontWeight.w300,*/
                                  fontSize: SizeConfig.blockSizeHorizontal *4.0,
                                  color: controller.hp.theme.secondaryHeaderColor),
                          textScaleFactor: 1.1,),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onDoubleTap: (){},
                    onTap: (){
                      settingContentAPi("faq");
                      //hp.goToRoute("/faq");
                      },
                    child: Container(
                      height: SizeConfig.screenHeight *0.08,

                      decoration: BoxDecoration(
                        color:
                        hp.theme.primaryColor,
                        border: Border(
                            bottom: BorderSide(
                                color: hp.theme.hoverColor, width: hp.radius / 800)),
                      ),
                      child: Row(
                        children: [
                          Text("FAQ",
                              style: TextStyle(
                                /* fontFamily: "Gotham Rounded",
                                        fontWeight: FontWeight.w300,*/
                                  fontSize: SizeConfig.blockSizeHorizontal *4.0,
                                  color: controller.hp.theme.secondaryHeaderColor),
                          textScaleFactor: 1.1,),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onDoubleTap: (){},
                    onTap: (){
                      widget.mListener.addAdvertesmentScreen();
                     /* Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            AdvertisementList()),
                      );*/
                    },
                    child: Container(
                      height: SizeConfig.screenHeight *0.08,

                      decoration: BoxDecoration(
                        color:
                        hp.theme.primaryColor,
                        border: Border(
                            bottom: BorderSide(
                                color: hp.theme.hoverColor, width: hp.radius / 800)),
                      ),
                      child: Row(
                        children: [
                          Text("Advertisement",
                            style: TextStyle(
                              /* fontFamily: "Gotham Rounded",
                                        fontWeight: FontWeight.w300,*/
                                fontSize: SizeConfig.blockSizeHorizontal *4.0,
                                color: controller.hp.theme.secondaryHeaderColor),
                            textScaleFactor: 1.1,),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onDoubleTap: (){},
                    onTap: (){
                      hp.goToRoute("/contactUs");                },
                    child: Container(
                      height: SizeConfig.screenHeight *0.08,

                      decoration: BoxDecoration(
                        color:
                        hp.theme.primaryColor,
                        border: Border(
                            bottom: BorderSide(
                                color: hp.theme.hoverColor, width: hp.radius / 800)),
                      ),
                      child: Row(
                        children: [
                          Text("Contact Us",
                              style: TextStyle(
                                /* fontFamily: "Gotham Rounded",
                                        fontWeight: FontWeight.w300,*/
                                  fontSize: SizeConfig.blockSizeHorizontal *4.0,
                                  color: controller.hp.theme.secondaryHeaderColor),
                          textScaleFactor: 1.1,),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onDoubleTap: (){},
                    onTap: (){
                      widget.mListener.addStorageScreen();

                      //hp.goToRoute("/contactUs");
                      },
                    child: Container(
                      height: SizeConfig.screenHeight *0.08,

                      decoration: BoxDecoration(
                        color:
                        hp.theme.primaryColor,
                        border: Border(
                            bottom: BorderSide(
                                color: hp.theme.hoverColor, width: hp.radius / 800)),
                      ),
                      child: Row(
                        children: [
                          Text("Storage",
                            style: TextStyle(
                              /* fontFamily: "Gotham Rounded",
                                        fontWeight: FontWeight.w300,*/
                                fontSize: SizeConfig.blockSizeHorizontal *4.0,
                                color: controller.hp.theme.secondaryHeaderColor),
                            textScaleFactor: 1.1,),
                        ],
                      ),
                    ),
                  ),


            //  Padding(padding: EdgeInsets.only(top: hp.height * 0.03)),
             /* Expanded(
                child: SettingsListWidget(links: [
                  QuickLink("About Us", () {
                    hp.goToRoute("/aboutUs");
                  }),
                  QuickLink("Terms & Conditions", () {
                    hp.goToRoute("/termsAndConditions");
                  }),
                  QuickLink("Privacy & Policy", () {
                    hp.goToRoute("/privacyPolicy");
                  }),
                  QuickLink("FAQ", () async {
                    hp.goToRoute("/faq");
                  }),
                  QuickLink(
                    "Contact Us",
                    () {
                      hp.goToRoute("/contactUs");
                    },
                  )
                ],come: "2",),
                flex: 100,
              )*/
            ]),
          ),
          loaderFlag
              ? Container()
              : Container(
            height: hp.height,
            width: hp.width,
            color: Colors.black87,
            child: const SpinKitFoldingCube(color: Colors.white),
          )
        ],
      ),
    ));
  }

  ContentResponseModel contentModel;
  GetSettingResponseModel getSettingModelLocal;


  settingContentAPi(String text) async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    final hp = controller.hp;

    if(mounted){
      setState(() {
        loaderFlag=false;
      });
    }

    await controller
        .waitUntilGetContent(text)
        .then((value) {
      contentModel = controller.contentModel;
      if (contentModel.responseData.content.description.isNotEmpty) {

        if (mounted) {
          setState(() {
            loaderFlag = true;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  AboutUsPage(data:contentModel.responseData.content.description ,
                    titleText: contentModel.responseData.content.title,)),
            );


            //didGetResponse = true;
          });
        }
      }
    });
  }


  getSettingAPi() async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    final hp = controller.hp;

    if(mounted){
      setState(() {
        loaderFlag=false;
      });
    }

    await controller
        .waitUntilGetSettingData()
        .then((value) {
          if(mounted) {
            setState(() {
            loaderFlag=true;

            getSettingModelLocal=controller.getSettingModel;
            if(getSettingModelLocal.responseData.isBlank){
             /* print("getSettingModelLocal  ${getSettingModelLocal.responseData.notification}");*/


            }else{
             /* print("getSettingModelLocal1111  ${getSettingModelLocal.responseData.notification}");*/
              notificationText=getSettingModelLocal.responseData.notification;
              profileText=getSettingModelLocal.responseData.profile;
              if(getSettingModelLocal.responseData.notification=="ON"){
             setState(() {
               notification=true;
             });

              }else
              {
               setState(() {
                 notification=false;
               });

              }

              if(getSettingModelLocal.responseData.profile=="PUBLIC"){
                profilePrivacy=true;
              }else
              {
                profilePrivacy=false;

              }

            }
          });
          }


    });
  }

  updateSettingApi(String profile,String notification) async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    final hp = controller.hp;

    if(mounted){
      setState(() {
        loaderFlag=true;
      });
    }

    await controller
        .waitUntilUpdateSetting(profile,notification)
        .then((value) {
      //getSettingAPi();
    });
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    return pageBuilder(UserController(context, state));
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSettingAPi();
  }




}


abstract class AccountSettingsPageInterface{
addAdvertesmentScreen();
addStorageScreen();
}


