import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';
import 'package:griot_legacy_social_media_app/src/helpers/helper.dart';
import 'package:griot_legacy_social_media_app/src/screens/confirmation_dialog.dart';
import 'package:griot_legacy_social_media_app/src/screens/create_tribe.dart';
import 'package:griot_legacy_social_media_app/src/screens/tribe_members_screen.dart';
import 'package:griot_legacy_social_media_app/src/utils/constant_class.dart';

class FriendsScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final isTribe;
  const FriendsScreen({Key key, this.isTribe}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FriendsScreenState();
  }
}

class FriendsScreenState extends State<FriendsScreen> with ConfirmationDialogInterface{
  UserController controller;
  bool isTribe = false;
  bool loaderFlag = false;
  List tribesList = [];
  List innerCircleList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      isTribe = widget.isTribe;
    });
    getTribesList();
    getInnerCircleList();
  }

  Future getTribesList() async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    final obj = {
      "userId": prefs.getString("spUserID"),
      "loginId": prefs.getString("spLoginID"),
      "appType": prefs.getString("spAppType"),
    };
    //print(obj);
    controller.waitUntilGetTribesList(obj).then((value) {
      if(mounted) {
        setState(() {
        loaderFlag = true;
        tribesList = controller.tribesList;
      });
      }
    });
  }


  Future getInnerCircleList() async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    final obj = {
      "userId": prefs.getString("spUserID"),
      "loginId": prefs.getString("spLoginID"),
      "appType": prefs.getString("spAppType"),
    };
    //print(obj);
    controller.waitUntilGetInnerCirclesList(obj).then((value) {
      if(mounted) {
        setState(() {
        loaderFlag = true;
        innerCircleList = controller.innerCircleList;
        //print("innerCircleListlenght    ${innerCircleList.length}");
      });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final hp =
        Helper.of(context, context.findAncestorStateOfType<GetBuilderState>());

    hp.lockScreenRotation();
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: hp.theme.primaryColor,
          body: Stack(
            children: [
              SingleChildScrollView(
                  child: Column(
                    children: [
                      const Divider(
                        color: Colors.grey,
                      ),
                      Padding(
                        padding: EdgeInsets.all(hp.width * 0.02),
                        child: Column(
                          children: [
                            Padding(
                                padding:
                                    EdgeInsets.only(top: hp.height * 0.02)),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(right: hp.width * 0.01),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isTribe = false;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: hp.width * 0.035),
                                        decoration: BoxDecoration(
                                            color: Colors.white24,
                                            border: Border.all(
                                                color: isTribe
                                                    ? Colors.transparent
                                                    : Colors.white),
                                            borderRadius: BorderRadius.circular(
                                                hp.height * 0.01)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Inner Circle",
                                              style: TextStyle(
                                                  color: isTribe
                                                      ? Colors.white38
                                                      : Colors.white,
                                                  fontSize: hp.height * 0.024),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(left: hp.width * 0.01),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isTribe = true;
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: hp.width * 0.035),
                                        decoration: BoxDecoration(
                                            color: Colors.white24,
                                            border: Border.all(
                                                color: isTribe
                                                    ? Colors.white
                                                    : Colors.transparent),
                                            borderRadius: BorderRadius.circular(
                                                hp.height * 0.01)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Tribe",
                                              style: TextStyle(
                                                  color: isTribe
                                                      ? Colors.white
                                                      : Colors.white38,
                                                  fontSize: hp.height * 0.024),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      !isTribe
                          ? innerCircleList.isEmpty ?
                      Container(
                        height: SizeConfig.screenHeight*.60,
                        alignment: Alignment.center,
                             // padding: const EdgeInsets.only(top: 128),
                              child:  Text(
                                "No Data Found",
                                style: TextStyle(color: Colors.white,fontSize: SizeConfig.safeBlockHorizontal* 5.5),
                              ),
                            ):
                      ListView.builder(
                          itemCount: innerCircleList.length,
                          shrinkWrap: true,
                          controller: ScrollController(),
                          itemBuilder: (BuildContext context, int index){
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [

                                              innerCircleList[index]["image"] ==
                                                  ""
                                                  ? Container(
                                                  decoration:
                                                  BoxDecoration(
                                                    shape: BoxShape
                                                        .circle,
                                                    border: Border.all(
                                                        color: hp
                                                            .theme
                                                            .secondaryHeaderColor,
                                                        width: 1),
                                                    image: const DecorationImage(
                                                        fit: BoxFit
                                                            .fill,
                                                        image: AssetImage(
                                                            "assets/images/noimage.png")),
                                                  ),
                                                  height: hp.height /
                                                      12,
                                                  width: hp.width / 6,
                                                  margin:
                                                  EdgeInsets.only(
                                                      right:
                                                      hp.width /
                                                          32))
                                                  :
                                              Container(
                                                  child: AspectRatio(
                                                    aspectRatio:
                                                    1 / 1,
                                                    child: ClipOval(
                                                        child: FadeInImage.assetNetwork(
                                                            fit: BoxFit
                                                                .fill,
                                                            placeholder:
                                                            'assets/images/noimage.png',
                                                            image: Constant.SERVER_URL +
                                                                innerCircleList[index]
                                                                [
                                                                "image"])),
                                                  ),
                                                  decoration:
                                                  BoxDecoration(
                                                    shape: BoxShape
                                                        .circle,
                                                    border: Border.all(
                                                        color: hp
                                                            .theme
                                                            .secondaryHeaderColor,
                                                        width:
                                                        hp.width /
                                                            100),
                                                  ),
                                                  height: hp.height /
                                                      12,
                                                  width: hp.width / 6,
                                                  margin:
                                                  EdgeInsets.only(
                                                      right:
                                                      hp.width /
                                                          32)),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Text(
                                                    innerCircleList[index]
                                                    ["name"],
                                                    style: TextStyle(
                                                        color: hp.theme
                                                            .secondaryHeaderColor,
                                                        fontSize:
                                                        hp.height *
                                                            0.024),
                                                  ),
                                                  Padding(
                                                      padding:
                                                      EdgeInsets.only(
                                                          top: hp.height *
                                                              0.003)),
                                                  Text(
                                                    innerCircleList[index]
                                                    ["countPeople"].toString() + " "+"People",
                                                    style: TextStyle(
                                                        color: hp.theme
                                                            .secondaryHeaderColor,
                                                        fontSize:
                                                        hp.height *
                                                            0.017),
                                                  ),
                                                  Text(
                                                    innerCircleList[index]["status"]=="ACTIVE"?"Active now":"",
                                                    style: TextStyle(
                                                      color: hp.theme
                                                          .secondaryHeaderColor,
                                                      //fontSize: hp.height * 0.024
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        PopupMenuButton(
                                          color: Colors.white,
                                          icon: Container(
                                              decoration: BoxDecoration(
                                                  color: hp.theme.cardColor,
                                                  shape: BoxShape.circle
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Icon(Icons.more_vert_outlined,
                                                  color: hp.theme.secondaryHeaderColor,),
                                              )),
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              child:  Text(
                                                "Tribe info",
                                                style:  TextStyle(
                                                    fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                    fontFamily: "Avenir_Heavy",
                                                    color: Colors.black.withOpacity(0.8),

                                                    fontWeight: FontWeight.w400
                                                ),
                                                textScaleFactor: 1.2,
                                                textAlign: TextAlign.center,
                                              ),
                                              value: 0,
                                            ),
                                            PopupMenuItem(
                                              child:  Text(
                                                "Leave tribe",
                                                style:  TextStyle(
                                                    fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                    fontFamily: "Avenir_Heavy",
                                                    color: Colors.black.withOpacity(0.8),
                                                    fontWeight: FontWeight.w400
                                                ),
                                                textScaleFactor: 1.2,
                                                textAlign: TextAlign.center,
                                              ),
                                              value: 1,
                                            ),

                                            PopupMenuItem(
                                              child:  Text(
                                                "Block",
                                                style:  TextStyle(
                                                    fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                    fontFamily: "Avenir_Heavy",
                                                    color: Colors.black.withOpacity(0.8),
                                                    fontWeight: FontWeight.w400
                                                ),
                                                textScaleFactor: 1.2,
                                                textAlign: TextAlign.center,
                                              ),
                                              value: 2,
                                            )
                                          ],
                                          onSelected: (val){
                                            if(mounted) {
                                              setState(() {
                                                if(val==1){
                                                  showGeneralDialog(
                                                      barrierColor: Colors.black.withOpacity(0.8),
                                                      transitionBuilder: (context, a1, a2, widget) {
                                                        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                                                        return Transform(
                                                          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                                                          child: Opacity(
                                                            opacity: a1.value,
                                                            child: ConfirmationDialog(tribeId:tribesList[index]
                                                            ["_id"] ,mListener: this,msg: "Do you really want to leave from this tribe.",comeFrom: "1",),
                                                          ),
                                                        );
                                                      },
                                                      transitionDuration: const Duration(milliseconds: 200),
                                                      barrierDismissible: false,
                                                      barrierLabel: '',
                                                      context: context,
                                                      pageBuilder: (context, animation2, animation1) {});
                                                }
                                                else if(val==2){
                                                  showGeneralDialog(
                                                      barrierColor: Colors.black.withOpacity(0.8),
                                                      transitionBuilder: (context, a1, a2, widget) {
                                                        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                                                        return Transform(
                                                          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                                                          child: Opacity(
                                                            opacity: a1.value,
                                                            child: ConfirmationDialog(tribeId:tribesList[index]
                                                            ["_id"] ,mListener: this,msg: "Do you really want to block this tribe.",comeFrom: "2",),
                                                          ),
                                                        );
                                                      },
                                                      transitionDuration: const Duration(milliseconds: 200),
                                                      barrierDismissible: false,
                                                      barrierLabel: '',
                                                      context: context,
                                                      pageBuilder: (context, animation2, animation1) {});
                                                }
                                                else if(val==0){
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              TribeMembersScreen(
                                                                  tribeMembersList:
                                                                  tribesList[index]
                                                                  ["tribeUserData"],
                                                                  tribeName:
                                                                  tribesList[index]
                                                                  ["name"])));
                                                }
                                              });
                                            }
                                            //        print(val);
                                          },
                                        )
                                        /*PopupMenuButton(
                                          color: Colors.white,
                                          icon: Container(
                                              decoration: BoxDecoration(
                                                  color: hp.theme.cardColor,
                                                  shape: BoxShape.circle
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Icon(Icons.more_vert_outlined,
                                                  color: hp.theme.secondaryHeaderColor,),
                                              )),
                                          itemBuilder: (context) => [


                                            PopupMenuItem(
                                              child:  Text(
                                                "Block",
                                                style:  TextStyle(
                                                    fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                    fontFamily: "Avenir_Heavy",
                                                    color: Colors.black.withOpacity(0.8),
                                                    fontWeight: FontWeight.w400
                                                ),
                                                textScaleFactor: 1.2,
                                                textAlign: TextAlign.center,
                                              ),
                                              value: 1,
                                            )
                                          ],
                                          onSelected: (val) async {
                                            if(val==1){
                                              setState(() {
                                                //  flag = false;
                                              });
                                              final prefs = await controller.sharedPrefs;
                                              Map<String, dynamic> body = {
                                                "userId":
                                                prefs.getString("spUserID"),
                                                "blockedUserId":  innerCircleList[index]
                                                ["_id"],
                                                "appType":
                                                prefs.getString("spAppType"),
                                                "loginId":
                                                prefs.getString("spLoginID"),
                                              };
                                              await controller
                                                  .waitUntilBlockUser(body)
                                                  .then((value) {
                                                setState(() {
                                                  // flag = true;
                                                  if (value) {

                                                  }
                                                });
                                              });
                                            }
                                          },
                                        )*/
                                      ],
                                    ),
                                    Divider(
                                      color:
                                      hp.theme.secondaryHeaderColor,
                                      thickness: 0.1,
                                    )
                                  ],
                                ),
                              );
                      })

                       : tribesList.isEmpty
                         ? Container(
                        height: SizeConfig.screenHeight*.60,
                        alignment: Alignment.center,

                        child:  Text(
                                    "No Data Found",
                                    style: TextStyle(color: Colors.white,fontSize: SizeConfig.safeBlockHorizontal*5.5),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: tribesList.length,
                                  shrinkWrap: true,
                                  controller: ScrollController(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TribeMembersScreen(
                                                        tribeMembersList:
                                                            tribesList[index]
                                                                ["tribeUserData"],
                                                        tribeName:
                                                            tribesList[index]
                                                                ["name"])));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(

                                                  child: Row(
                                                    children: [

                                                      tribesList[index]["image"] ==
                                                              ""
                                                          ? Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border.all(
                                                                    color: hp
                                                                        .theme
                                                                        .secondaryHeaderColor,
                                                                    width: 1),
                                                                image: const DecorationImage(
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    image: AssetImage(
                                                                        "assets/images/noimage.png")),
                                                              ),
                                                              height: hp.height /
                                                                  12,
                                                              width: hp.width / 6,
                                                              margin:
                                                                  EdgeInsets.only(
                                                                      right:
                                                                          hp.width /
                                                                              32))
                                                          :
                                                       Container(
                                                              child: AspectRatio(
                                                                aspectRatio:
                                                                    1 / 1,
                                                                child: ClipOval(
                                                                    child: FadeInImage.assetNetwork(
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        placeholder:
                                                                            'assets/images/noimage.png',
                                                                        image: tribesList[index]
                                                                                [
                                                                                "tribeImageUrl"] +
                                                                            tribesList[index]
                                                                                [
                                                                                "image"])),
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border.all(
                                                                    color: hp
                                                                        .theme
                                                                        .secondaryHeaderColor,
                                                                    width:
                                                                        hp.width /
                                                                            100),
                                                              ),
                                                              height: hp.height /
                                                                  12,
                                                              width: hp.width / 6,
                                                              margin:
                                                                  EdgeInsets.only(
                                                                      right:
                                                                          hp.width /
                                                                              32)),
                                                      Expanded(

                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Expanded(


                                                                  child: Text(
                                                                    tribesList[index]
                                                                        ["name"],
                                                                    style: TextStyle(
                                                                        color: hp.theme
                                                                            .secondaryHeaderColor,
                                                                        fontSize:
                                                                            hp.height *
                                                                                0.024),
                                                                    maxLines: 2,
                                                                    //overflow: T,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                                padding:
                                                                    EdgeInsets.only(
                                                                        top: hp.height *
                                                                            0.003)),
                                                            Text(
                                                              tribesList[index][
                                                                          "countPeople"]
                                                                      .toString() +
                                                                  (tribesList[index]
                                                                              [
                                                                              "countPeople"] >
                                                                          1
                                                                      ? " Members"
                                                                      : " Member"),
                                                              style: TextStyle(
                                                                color: hp.theme
                                                                    .secondaryHeaderColor,
                                                                //fontSize: hp.height * 0.024
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuButton(
                                                    color: Colors.white,
                                                    icon: Container(
                                                        decoration: BoxDecoration(
                                                            color: hp.theme.cardColor,
                                                            shape: BoxShape.circle
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(4.0),
                                                          child: Icon(Icons.more_vert_outlined,
                                                            color: hp.theme.secondaryHeaderColor,),
                                                        )),
                                                    itemBuilder: (context) => [
                                                      PopupMenuItem(
                                                        child:  Text(
                                                          "Tribe info",
                                                          style:  TextStyle(
                                                              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                              fontFamily: "Avenir_Heavy",
                                                              color: Colors.black.withOpacity(0.8),

                                                              fontWeight: FontWeight.w400
                                                          ),
                                                          textScaleFactor: 1.2,
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        value: 0,
                                                      ),
                                                      PopupMenuItem(
                                                        child:  Text(
                                                          "Leave tribe",
                                                          style:  TextStyle(
                                                              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                              fontFamily: "Avenir_Heavy",
                                                              color: Colors.black.withOpacity(0.8),
                                                              fontWeight: FontWeight.w400
                                                          ),
                                                          textScaleFactor: 1.2,
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        value: 1,
                                                      ),

                                                      PopupMenuItem(
                                                        child:  Text(
                                                          "Block",
                                                          style:  TextStyle(
                                                              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                                                              fontFamily: "Avenir_Heavy",
                                                              color: Colors.black.withOpacity(0.8),
                                                              fontWeight: FontWeight.w400
                                                          ),
                                                          textScaleFactor: 1.2,
                                                          textAlign: TextAlign.center,
                                                        ),
                                                        value: 2,
                                                      )
                                                    ],
                                                  onSelected: (val){
                                                      if(mounted) {
                                                        setState(() {
                                                          if(val==1){
                                                            showGeneralDialog(
                                                                barrierColor: Colors.black.withOpacity(0.8),
                                                                transitionBuilder: (context, a1, a2, widget) {
                                                                  final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                                                                  return Transform(
                                                                    transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                                                                    child: Opacity(
                                                                      opacity: a1.value,
                                                                      child: ConfirmationDialog(tribeId:tribesList[index]
                                                                      ["_id"] ,mListener: this,msg: "Do you really want to leave from this tribe.",comeFrom: "1",),
                                                                    ),
                                                                  );
                                                                },
                                                                transitionDuration: const Duration(milliseconds: 200),
                                                                barrierDismissible: false,
                                                                barrierLabel: '',
                                                                context: context,
                                                                pageBuilder: (context, animation2, animation1) {});
                                                          }
                                                          else if(val==2){
                                                            showGeneralDialog(
                                                                barrierColor: Colors.black.withOpacity(0.8),
                                                                transitionBuilder: (context, a1, a2, widget) {
                                                                  final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                                                                  return Transform(
                                                                    transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                                                                    child: Opacity(
                                                                      opacity: a1.value,
                                                                      child: ConfirmationDialog(tribeId:tribesList[index]
                                                                      ["_id"] ,mListener: this,msg: "Do you really want to block this tribe.",comeFrom: "2",),
                                                                    ),
                                                                  );
                                                                },
                                                                transitionDuration: const Duration(milliseconds: 200),
                                                                barrierDismissible: false,
                                                                barrierLabel: '',
                                                                context: context,
                                                                pageBuilder: (context, animation2, animation1) {});
                                                          }
                                                          else if(val==0){
                                                            Navigator.of(context).push(
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        TribeMembersScreen(
                                                                            tribeMembersList:
                                                                            tribesList[index]
                                                                            ["tribeUserData"],
                                                                            tribeName:
                                                                            tribesList[index]
                                                                            ["name"])));
                                                          }
                                                        });
                                                      }
                                              //        print(val);
                                                  },
                                                )
                                              ],
                                            ),
                                            Divider(
                                              color:
                                                  hp.theme.secondaryHeaderColor,
                                              thickness: 0.1,
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: hp.width / 32)),
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
          appBar: AppBar(
              title: const Text("Inner Circle/Tribe"),
              foregroundColor: hp.theme.secondaryHeaderColor,
              backgroundColor: hp.theme.primaryColor,
              actions: [
                Row(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: hp.width * 0.04),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) =>
                                      const CreateTribeScreen()))
                              .then((value) {
                            //tribesList.clear();

                            getTribesList();
                            getInnerCircleList();

                          });
                        },
                        child: CircleAvatar(
                            child: Icon(
                              Icons.add,
                              color: hp.theme.primaryColor,
                            ),
                            backgroundColor: Colors.white,
                            foregroundColor: hp.theme.secondaryHeaderColor),
                      ),
                    ),
                  ],
                )
              ]),
        ));
  }

  leaveTribeApiFunction(String id) async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    if(mounted){
      setState(() {
        loaderFlag=false;
      });
    }
    final body = {
      "userId": prefs.getString("spUserID") ?? "",
      "loginId": prefs.getString("spLoginID") ?? "",
      "appType": prefs.getString("spAppType") ?? "",
      "tribeId": id,
    };
    await controller
        .waitUntilLeaveTribe(body)
        .then((value) {
      Future.delayed(
          const Duration(milliseconds: 100),
              () {
            setState(() {
              loaderFlag = true;
            });
            if (value) {
              tribesList.clear();

              getTribesList();
            }
          });
    });
  }

  blockTribeGroupApiFunction(String id) async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    if(mounted){
      setState(() {
        loaderFlag=false;
      });
    }
    final body = {
      "userId": prefs.getString("spUserID") ?? "",
      "loginId": prefs.getString("spLoginID") ?? "",
      "appType": prefs.getString("spAppType") ?? "",
      "tribeId": id,
    };
    await controller
        .waitUntilBlockTribe(body)
        .then((value) {
      Future.delayed(
          const Duration(milliseconds: 100),
              () {
            setState(() {
              loaderFlag = true;
            });
            if (value) {
              tribesList.clear();

              getTribesList();
            }
          });
    });
  }

  @override
  callApiForLeaveTribe(String tribeId,String comeFrom) {
    // TODO: implement callApiForLeaveTribe
    if(comeFrom=="1"){
      leaveTribeApiFunction(tribeId);

    }else{
      blockTribeGroupApiFunction(tribeId);
    }
  }
}
