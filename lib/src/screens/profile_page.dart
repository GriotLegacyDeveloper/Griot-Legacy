import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/controllers/my_tab_controller.dart';
import 'package:griot_legacy_social_media_app/src/controllers/post_controller.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';
import 'confirmation_for_delete_account_dailog.dart';
import 'full_iamge_for_profile.dart';



class ProfilePage extends StatefulWidget {
  final ProfilePageInterface mListener;
  const ProfilePage({Key key, this.mListener}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> with ConfirmationDialogForDeleteAccountInterface{
  bool flag = false;

  Widget pageBuilder(UserController con) {
    final hp = con.hp;
    final user = con.user.value;
    //print(user.imageURL + "<>><><><><><><>><><>");
    hp.lockScreenRotation();
    return SafeArea(
        child: Scaffold(
      backgroundColor: hp.theme.primaryColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: hp.width * 0.02),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 11),
                    child: SizedBox(
                        child: Card(
                            color: const Color(0xff141414),
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 9, bottom: 9),
                              child: Column(children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      hp.context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            FullImageForProfileActivity(
                                                          image:
                                                          user.imageURL,
                                                        ),
                                                      ));
                                                },
                                                onDoubleTap: () {},
                                                child: Container(
                                                  height: SizeConfig.screenHeight*.1,
                                                  width: SizeConfig.screenHeight*.1,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: hp
                                                            .theme.selectedRowColor,
                                                        width: 2),
                                                    borderRadius:  const BorderRadius.all(
                                                        Radius.circular(10.0)),
                                                    image: user.imageURL ==
                                                        null ||user.imageURL ==
                                                        ""?const DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/dummy.jpeg')):
                                                    DecorationImage(
                                                      fit: BoxFit.contain,
                                                      image:
                                                      NetworkImage(user.imageURL),
                                                    ),

                                                  ),

                                                ),
                                                /*Container(
                                                    child: ClipRRect(
                                                      child: user.imageURL ==
                                                              null
                                                          ? Container(
                                                              decoration:
                                                                  const BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        'assets/images/dummy.jpeg')),
                                                              ),
                                                            )
                                                          : user.imageURL == ""
                                                              ? Container(
                                                                  decoration:
                                                                      const BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: AssetImage(
                                                                            'assets/images/dummy.jpeg')),
                                                                  ),
                                                                )
                                                              : Padding(
                                                                padding: const EdgeInsets.all(1.5),
                                                                child: FadeInImage.assetNetwork(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    placeholder:
                                                                        'assets/images/dummy.jpeg',
                                                                    image: user
                                                                        .imageURL),
                                                              ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: hp.theme
                                                                .selectedRowColor,
                                                            width:
                                                                hp.width / 100),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    hp.radius /
                                                                        100))),
                                                    height: hp.height / 9,
                                                    width: hp.width / 4,
                                                    margin: EdgeInsets.only(
                                                        right: hp.width / 32)),*/
                                              ),
                                              Expanded(
                                                  child: Padding(
                                                    padding:  EdgeInsets.only(left: SizeConfig.screenWidth*.03),
                                                    child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                      Text(user.fullName,
                                                          style: TextStyle(
                                                              color: hp.theme
                                                                  .secondaryHeaderColor,
                                                              fontSize:
                                                                  hp.size.height *
                                                                      0.025)),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              user.emailID,
                                                              style: TextStyle(
                                                                  color: hp.theme
                                                                      .secondaryHeaderColor),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ]),
                                                  )),
                                            ],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                hp
                                                    .goToRoute("/profileUpdate")
                                                    .then((value) {
                                                  setState(() {
                                                    flag = false;
                                                    con
                                                        .waitForUserDetails()
                                                        .then((value) {
                                                      setState(() {
                                                        flag = true;
                                                      });
                                                    });
                                                  });
                                                });
                                              },
                                              child: Padding(
                                                  child: CircleAvatar(
                                                      child: const Icon(
                                                          Icons.edit_outlined),
                                                      backgroundColor: hp.theme
                                                          .secondaryHeaderColor,
                                                      foregroundColor: hp
                                                          .theme.primaryColor),
                                                  padding: EdgeInsets.only(
                                                      left: hp.width / 15,
                                                      bottom: hp.height / 15)))
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: hp.size.height * 0.01)),
                                Divider(
                                    color: hp.theme.secondaryHeaderColor
                                        .withOpacity(0.2)),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: hp.size.height * 0.01)),
                                Text(
                                  "Mobile No.        : " +
                                      user.countryCode +
                                      " " +
                                      user.phone,
                                  style: TextStyle(
                                      /* fontFamily: "Gotham Rounded",
                                          fontWeight: FontWeight.w300,*/
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 3.8,
                                      color: con.hp.theme.secondaryHeaderColor),
                                  textScaleFactor: 1.1,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: hp.size.height * 0.01)),
                                Text(
                                  "Gender             :   " + user.gender,
                                  style: TextStyle(
                                      /* fontFamily: "Gotham Rounded",
                                          fontWeight: FontWeight.w300,*/
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 3.8,
                                      color: con.hp.theme.secondaryHeaderColor),
                                  textScaleFactor: 1.1,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: hp.size.height * 0.01)),
                                Text(
                                  "Birth Date         :   " +
                                      user.dateOfBirth.split('T')[0],
                                  style: TextStyle(
                                      /* fontFamily: "Gotham Rounded",
                                          fontWeight: FontWeight.w300,*/
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 3.8,
                                      color: con.hp.theme.secondaryHeaderColor),
                                  textScaleFactor: 1.1,
                                )
                              ], crossAxisAlignment: CrossAxisAlignment.start),
                            )),
                        width: hp.width),
                  ),
                  Padding(padding: EdgeInsets.only(top: hp.size.height * 0.02)),
                  GestureDetector(
                    onTap: () {
                      if (widget.mListener != null) {
                        widget.mListener.addFriendScreen();
                      }
                      /*Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const FriendsScreen(isTribe: true)));*/
                    },
                    onDoubleTap: () {},
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: SizeConfig.screenWidth * .015),
                      child: Container(
                        height: SizeConfig.screenHeight * 0.06,
                        decoration: const BoxDecoration(
                            color: Color(0xff141414),

                            //color: hp.theme.cardColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            )),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.screenWidth * .03,
                              right: SizeConfig.screenWidth * .03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Friends",
                                style: TextStyle(
                                    /* fontFamily: "Gotham Rounded",
                                          fontWeight: FontWeight.w300,*/
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4.0,
                                    color: con.hp.theme.secondaryHeaderColor),
                                textScaleFactor: 1.1,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: SizeConfig.screenHeight * 0.025,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      hp.goToRoute("/inviteFriends");
                    },
                    onDoubleTap: () {},
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.screenWidth * .015,
                          top: SizeConfig.screenHeight * .012),
                      child: Container(
                        height: SizeConfig.screenHeight * 0.06,
                        decoration: const BoxDecoration(
                            color: Color(0xff141414),

                            // color: hp.theme.cardColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            )),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.screenWidth * .03,
                              right: SizeConfig.screenWidth * .03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Invite Friends",
                                style: TextStyle(
                                    /* fontFamily: "Gotham Rounded",
                                          fontWeight: FontWeight.w300,*/
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4.0,
                                    color: con.hp.theme.secondaryHeaderColor),
                                textScaleFactor: 1.1,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: SizeConfig.screenHeight * 0.025,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showGeneralDialog(
                          barrierColor: Colors.black.withOpacity(0.8),
                          transitionBuilder: (context, a1, a2, widget) {
                            final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                            return Transform(
                              transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                              child: Opacity(
                                opacity: a1.value,
                                child: ConfirmationDialogForDeleteAccount(context: hp.context ,mListener: this,msg: "Do you really want to delete this account? You can not use this account after deletion. All of your data will be deleted. Agree?",state: hp.state,controller: con,),
                              ),
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 200),
                          barrierDismissible: false,
                          barrierLabel: '',
                          context: context,
                          pageBuilder: (context, animation2, animation1) {});
                    },
                    onDoubleTap: () {},
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.screenWidth * .015,
                          top: SizeConfig.screenHeight * .012),
                      child: Container(
                        height: SizeConfig.screenHeight * 0.06,
                        decoration: const BoxDecoration(
                            color: Color(0xff141414),

                            // color: hp.theme.cardColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            )),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.screenWidth * .03,
                              right: SizeConfig.screenWidth * .03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Delete Account",
                                style: TextStyle(
                                  /* fontFamily: "Gotham Rounded",
                                          fontWeight: FontWeight.w300,*/
                                    fontSize:
                                    SizeConfig.blockSizeHorizontal * 4.0,
                                    color: Colors.red),
                                textScaleFactor: 1.1,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.red,
                                size: SizeConfig.screenHeight * 0.025,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      setState(() {
                        flag = false;
                      });
                      final prefs = await con.sharedPrefs;
                      final body = {
                        "userId": prefs.getString("spUserID"),
                        "loginId": prefs.getString("spLoginID"),
                        "appType": prefs.getString("spAppType")
                      };
                      con.waitUntilLogout(body).then((value) {
                        if (value) {
                          Get.put(MyTabController(5, hp.context, hp.state))
                              .tabCon
                              .index = 2;
                          setState(() {
                            flag = true;
                          });
                        }
                      });
                    },
                    onDoubleTap: () {},
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.screenWidth * .015,
                          top: SizeConfig.screenHeight * .012),
                      child: Container(
                        height: SizeConfig.screenHeight * 0.06,
                        decoration: const BoxDecoration(
                            color: Color(0xff141414),

                            // color: hp.theme.cardColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            )),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.screenWidth * .03,
                              right: SizeConfig.screenWidth * .03),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Logout",
                                style: TextStyle(
                                    /* fontFamily: "Gotham Rounded",
                                          fontWeight: FontWeight.w300,*/
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 4.0,
                                    color: con.hp.theme.secondaryHeaderColor),
                                textScaleFactor: 1.1,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: SizeConfig.screenHeight * 0.025,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
          flag
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

  void didChange(GetBuilderState<UserController> state) {
    state.controller.waitForUserDetails().then((value) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          setState(() {
            flag = true;
          });
        }
      });
    });
    PostController(state.context, GetBuilderState<PostController>()).update();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    SizeConfig().init(context);
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    return GetBuilder<UserController>(
        // autoRemove: false,
        builder: pageBuilder,
        init: UserController(context, state),
        didChangeDependencies: didChange);
  }


  hitDeleteAccountApi(BuildContext context,state,controller) async {
    if(mounted) {
      setState(() {
      flag = false;
    });
    }
    final prefs = await controller.sharedPrefs;
   // print("preff   $prefs");
    final body = {
      "userId": prefs.getString("spUserID"),
      "loginId": prefs.getString("spLoginID"),
      "appType": prefs.getString("spAppType")
    };
    //print("preff1111   $prefs");

    controller.waitUntilDeleteAccount(body).then((value) {
      if (value) {
        Get.put(MyTabController(5, context, state))
            .tabCon
            .index = 2;
        if(mounted) {
          setState(() {
          flag = true;
        });
        }
      }
    });
  }



  @override
  callApiDeleteAccount(context, state,con) {
    // TODO: implement callApiDeleteAccount
    hitDeleteAccountApi(context,state,con);
  }
}

abstract class ProfilePageInterface {
  addFriendScreen();
}
