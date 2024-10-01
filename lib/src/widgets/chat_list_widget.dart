import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/screens/chat_activity.dart';
import '../controllers/user_controller.dart';
import '../models/chat_listing_response_model.dart';
import '../screens/confirmation_dialog.dart';
import '../screens/create_group_user_list_class.dart';
import '../screens/group_chat_activity.dart';



class ChatListWidget extends StatefulWidget {
  const ChatListWidget({Key key}) : super(key: key);

  @override
  ChatListWidgetState createState() => ChatListWidgetState();
}

class ChatListWidgetState extends State<ChatListWidget>
    with
        ConfirmationDialogInterface,
        ChatActivityInterface,
        GroupChatActivityInterface {
  UserController controller;
  var chatListingResponseModelLocal = ChatListResponseModel();

  @override
  void initState() {
    super.initState();
    getChatUserList();
  }

  String id = "";
  bool isShowData = false;
  bool flag = true;
  int localIndex;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    return pageBuilder(UserController(context, state));
  }

  List<Map<String, dynamic>> list = [];

  Future getChatUserList() async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    id = prefs.getString("spUserID");
    print("1111111111111");
    if (mounted) {
      setState(() {
        flag = false;
      });
    }
    print("22222222222");
    controller.waitUntilChatUserList().then((value) {
      if (mounted) {
        setState(() {
          flag = true;
          isShowData = true;
        });
      }
      chatListingResponseModelLocal = controller.chatListingResponseModel;
      if (chatListingResponseModelLocal.responseData.message.isNotEmpty ||
          chatListingResponseModelLocal.responseData.group.isNotEmpty) {
        if (mounted) {
          setState(() {
            isShowData = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isShowData = false;
            flag = true;
            print("djbffh");
          });
        }
      }

      print(
          "chatListingResponseModelLocal    ${chatListingResponseModelLocal.responseData.message.length}"
          " ${chatListingResponseModelLocal.responseData.group.length}");

      if (chatListingResponseModelLocal.responseData.message.isNotEmpty &&
          chatListingResponseModelLocal.responseData.group.isNotEmpty) {
        var len1 = chatListingResponseModelLocal.responseData.message.length;
        var mergedArr =
            chatListingResponseModelLocal.responseData.message.sublist(0);
        //var mergedGroupArr = chatListingResponseModelLocal.responseData.group.sublist(0);

        var rng = Random();
        for (int j = 0; j < mergedArr.length; j++) {
          list.add(mergedArr[j].toJson());
        }
        for (var i = 0;
            i < chatListingResponseModelLocal.responseData.group.length;
            i++) {
          var rand = (rng.nextDouble() * (len1 - 0)).floor() + 1;

          list.insert(rand,
              chatListingResponseModelLocal.responseData.group[i].toJson());
        }

        debugPrint("llll   ${list[0]}");
        // debugPrint("llll111   ${list[1]}");
        //debugPrint("llll2222  ${list[2]}");
      }
    });
  }

  Widget pageBuilder(UserController con) {
    final hp = con.hp;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 2,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.screenWidth * .02,
                right: SizeConfig.screenWidth * .01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Message",
                  style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                      fontWeight: FontWeight.normal),
                  textScaleFactor: 1.1,
                ),
                PopupMenuButton(
                  color: Colors.white,
                  icon: Container(
                      decoration: BoxDecoration(
                          color: hp.theme.cardColor, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.more_vert_outlined,
                          color: hp.theme.secondaryHeaderColor,
                        ),
                      )),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text(
                        "New group",
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                            fontFamily: "Avenir_Heavy",
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                        textScaleFactor: 1.2,
                        textAlign: TextAlign.center,
                      ),
                      value: 1,
                    ),
                  ],
                  onSelected: (val) async {
                    if (val == 1) {
                      Navigator.push(
                        hp.context,
                        MaterialPageRoute(
                            builder: (context) => const CreateGroupUserList()),
                      );
                      /*Navigator.push(
                          hp.context,
                          MaterialPageRoute(
                            builder: (context) => CreateGroupUserList(),
                          ));*/
                    }
                  },
                ),
              ],
            ),
          )),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            children: [
              Divider(
                color: Colors.grey.withOpacity(0.4),
              ),
              isShowData
                  ? list.isNotEmpty
                      ? Expanded(
                          child: ListView.builder(
                              itemBuilder: (BuildContext cont, int index) {
                                localIndex = index;
                                return list[index]['isGroup'] == false
                                    ? list[index]['touser']!=null || !list[index]['touser'].isBlank?Container()
                                    : GestureDetector(
                                        onTap: () {
                                          if (list[index]['isGroup'] == false) {
                                            Navigator.push(
                                                hp.context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatActivity(
                                                    otherUserId: id ==
                                                            list[index]
                                                                ['fromUserId']
                                                        ? list[index]['touser']
                                                            [0]['_id']
                                                        : list[index]
                                                                ['fromuser'][0]
                                                            ['_id'],
                                                    name: id ==
                                                            list[index]
                                                                ['fromUserId']
                                                        ? list[index]['touser']
                                                            [0]['fullName']
                                                        : list[index]
                                                                ['fromuser'][0]
                                                            ['fullName'],
                                                    profilePic: id ==
                                                            list[index]
                                                                ['fromUserId']
                                                        ? "https://54.177.127.20:2109/img/profile-pic/" +
                                                            list[index][
                                                                    'touser'][0]
                                                                ['profileImage']
                                                        : "https://54.177.127.20:2109/img/profile-pic/" +
                                                            list[index][
                                                                    'fromuser'][0]
                                                                [
                                                                'profileImage'],
                                                    mListener: this,
                                                    textSub: msgText,
                                                    coming: localStrCome,
                                                  ),
                                                ));
                                          }
                                        },
                                        onDoubleTap: () {},
                                        child: Card(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: SizeConfig.screenWidth *
                                                      .02,
                                                  right:
                                                      SizeConfig.screenWidth *
                                                          .02,
                                                  top: SizeConfig.screenHeight *
                                                      .015,
                                                  bottom:
                                                      SizeConfig.screenHeight *
                                                          .025),
                                              child: Row(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Stack(
                                                        children: <Widget>[
                                                          Container(
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
                                                              height:
                                                                  hp.height /
                                                                      12,
                                                              width:
                                                                  hp.width / 6,
                                                              margin: EdgeInsets.only(
                                                                  right:
                                                                      hp.width /
                                                                          32)),
                                                          list[index]['touser']!=null || !list[index]['touser'].isBlank?Container():
                                                          Container(
                                                              child:
                                                                  AspectRatio(
                                                                aspectRatio:
                                                                    1 / 1,
                                                                child: ClipOval(
                                                                    child: FadeInImage.assetNetwork(
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        placeholder:
                                                                            'assets/images/noimage.png',
                                                                        image: list[index]['touser']!=null || !list[index]['touser'].isBlank?
                                                                        id == list[index]['fromUserId']
                                                                            ? "https://54.177.127.20:2109/img/profile-pic/" +
                                                                                list[index]['touser'][0]['profileImage']
                                                                            : "https://54.177.127.20:2109/img/profile-pic/" + list[index]['fromuser'][0]['profileImage']
                                                                            :"assets/images/noimage.png")),
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
                                                              height:
                                                                  hp.height /
                                                                      12,
                                                              width:
                                                                  hp.width / 6,
                                                              margin: EdgeInsets.only(
                                                                  right:
                                                                      hp.width /
                                                                          32)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  list[index]['touser']!=null || !list[index]['touser'].isBlank?Container(): Expanded(
                                                      child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: SizeConfig
                                                                .screenWidth *
                                                            .02),
                                                    child: Column(
                                                        children: [
                                                          Text(
                                                            id ==
                                                                    list[index][
                                                                        'fromUserId']
                                                                ? list[index][
                                                                        'touser'][0]
                                                                    ['fullName']
                                                                : list[index][
                                                                        'fromuser'][0]
                                                                    [
                                                                    'fullName'],
                                                            style: TextStyle(
                                                                color: hp.theme
                                                                    .secondaryHeaderColor,
                                                                fontSize: SizeConfig
                                                                        .blockSizeHorizontal *
                                                                    4.1),
                                                            textScaleFactor:
                                                                1.1,
                                                          ),
                                                        ],
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start),
                                                  )),
                                                  PopupMenuButton(
                                                    color: Colors.white,
                                                    icon: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                color: hp.theme
                                                                    .cardColor,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Icon(
                                                            Icons
                                                                .more_vert_outlined,
                                                            color: hp.theme
                                                                .secondaryHeaderColor,
                                                          ),
                                                        )),
                                                    itemBuilder: (context) => [
                                                      PopupMenuItem(
                                                        child: Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              fontSize: SizeConfig
                                                                      .safeBlockHorizontal *
                                                                  3.5,
                                                              fontFamily:
                                                                  "Avenir_Heavy",
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          textScaleFactor: 1.2,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        value: 1,
                                                      ),
                                                      PopupMenuItem(
                                                        child: Text(
                                                          "Block",
                                                          style: TextStyle(
                                                              fontSize: SizeConfig
                                                                      .safeBlockHorizontal *
                                                                  3.5,
                                                              fontFamily:
                                                                  "Avenir_Heavy",
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          textScaleFactor: 1.2,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        value: 2,
                                                      )
                                                    ],
                                                    onSelected: (val) async {
                                                      if (val == 1) {
                                                        showGeneralDialog(
                                                            barrierColor: Colors
                                                                .black
                                                                .withOpacity(
                                                                    0.8),
                                                            transitionBuilder:
                                                                (context,
                                                                    a1,
                                                                    a2,
                                                                    widget) {
                                                              final curvedValue = Curves
                                                                      .easeInOutBack
                                                                      .transform(
                                                                          a1.value) -
                                                                  1.0;
                                                              return Transform(
                                                                transform: Matrix4
                                                                    .translationValues(
                                                                        0.0,
                                                                        curvedValue *
                                                                            200,
                                                                        0.0),
                                                                child: Opacity(
                                                                  opacity:
                                                                      a1.value,
                                                                  child:
                                                                      ConfirmationDialog(
                                                                    tribeId: id ==
                                                                            list[index]
                                                                                [
                                                                                'fromUserId']
                                                                        ? list[index]['touser'][0]
                                                                            [
                                                                            '_id']
                                                                        : list[index]['fromuser'][0]
                                                                            [
                                                                            '_id'],
                                                                    mListener:
                                                                        this,
                                                                    msg:
                                                                        "Do you really want to delete chat.",
                                                                    comeFrom:
                                                                        "4",
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            transitionDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        200),
                                                            barrierDismissible:
                                                                false,
                                                            barrierLabel: '',
                                                            context: context,
                                                            pageBuilder: (context,
                                                                animation2,
                                                                animation1) {});
                                                      } else if (val == 2) {
                                                        setState(() {
                                                          flag = false;
                                                        });
                                                        final prefs = await con
                                                            .sharedPrefs;
                                                        Map<String, dynamic>
                                                            body = {
                                                          "userId":
                                                              prefs.getString(
                                                                  "spUserID"),
                                                          "blockedUserId": id ==
                                                                  list[index][
                                                                      'fromUserId']
                                                              ? list[index]
                                                                      ['touser']
                                                                  [0]['_id']
                                                              : list[index][
                                                                      'fromuser']
                                                                  [0]['_id'],
                                                          "appType":
                                                              prefs.getString(
                                                                  "spAppType"),
                                                          "loginId":
                                                              prefs.getString(
                                                                  "spLoginID"),
                                                        };
                                                        await con
                                                            .waitUntilBlockUser(
                                                                body)
                                                            .then((value) {
                                                          setState(() {
                                                            flag = true;
                                                            if (value) {}
                                                          });
                                                        });
                                                      }
                                                    },
                                                  )
                                                ],
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                              ),
                                            ),
                                            color: hp.theme.primaryColor),
                                      )
                                    : GestureDetector(
                                        onDoubleTap: () {},
                                        onTap: () {
                                          if (list[index]['isGroup'] == true) {
                                            Navigator.push(
                                                hp.context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      GroupChatActivity(
                                                    groupID: list[index]
                                                        ['groupId'],
                                                    name: list[index]
                                                        ['groupName'],
                                                    profilePic: list[index]
                                                        ['groupImage'],
                                                    mListener: this,
                                                    textSub: msgText,
                                                    coming: localStrCome,
                                                  ),
                                                ));
                                          }
                                        },
                                        child: Card(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: SizeConfig.screenWidth *
                                                      .02,
                                                  right:
                                                      SizeConfig.screenWidth *
                                                          .02,
                                                  top: SizeConfig.screenHeight *
                                                      .015,
                                                  bottom:
                                                      SizeConfig.screenHeight *
                                                          .025),
                                              child: Row(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Stack(
                                                        children: <Widget>[
                                                          Container(
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
                                                              height:
                                                                  hp.height /
                                                                      12,
                                                              width:
                                                                  hp.width / 6,
                                                              margin: EdgeInsets.only(
                                                                  right:
                                                                      hp.width /
                                                                          32)),
                                                          Container(
                                                              child:
                                                                  AspectRatio(
                                                                aspectRatio:
                                                                    1 / 1,
                                                                child: ClipOval(
                                                                    child: FadeInImage.assetNetwork(
                                                                        fit: BoxFit
                                                                            .fill,
                                                                        placeholder:
                                                                            'assets/images/noimage.png',
                                                                        image: list[index]
                                                                            [
                                                                            'groupImage'])),
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
                                                              height:
                                                                  hp.height /
                                                                      12,
                                                              width:
                                                                  hp.width / 6,
                                                              margin: EdgeInsets.only(
                                                                  right:
                                                                      hp.width /
                                                                          32)),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(
                                                      child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: SizeConfig
                                                                .screenWidth *
                                                            .02),
                                                    child: Column(
                                                        children: [
                                                          Text(
                                                            list[index]
                                                                ['groupName'],
                                                            style: TextStyle(
                                                                color: hp.theme
                                                                    .secondaryHeaderColor,
                                                                fontSize: SizeConfig
                                                                        .blockSizeHorizontal *
                                                                    4.1),
                                                            textScaleFactor:
                                                                1.1,
                                                          ),
                                                        ],
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start),
                                                  )),
                                                  PopupMenuButton(
                                                    color: Colors.white,
                                                    icon: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                color: hp.theme
                                                                    .cardColor,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Icon(
                                                            Icons
                                                                .more_vert_outlined,
                                                            color: hp.theme
                                                                .secondaryHeaderColor,
                                                          ),
                                                        )),
                                                    itemBuilder: (context) => [
                                                      PopupMenuItem(
                                                        child: Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              fontSize: SizeConfig
                                                                      .safeBlockHorizontal *
                                                                  3.5,
                                                              fontFamily:
                                                                  "Avenir_Heavy",
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          textScaleFactor: 1.2,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        value: 1,
                                                      ),
                                                      PopupMenuItem(
                                                        child: Text(
                                                          "Block",
                                                          style: TextStyle(
                                                              fontSize: SizeConfig
                                                                      .safeBlockHorizontal *
                                                                  3.5,
                                                              fontFamily:
                                                                  "Avenir_Heavy",
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          textScaleFactor: 1.2,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        value: 2,
                                                      )
                                                    ],
                                                    onSelected: (val) async {
                                                      if (val == 1) {
                                                        showGeneralDialog(
                                                            barrierColor: Colors
                                                                .black
                                                                .withOpacity(
                                                                    0.8),
                                                            transitionBuilder:
                                                                (context,
                                                                    a1,
                                                                    a2,
                                                                    widget) {
                                                              final curvedValue = Curves
                                                                      .easeInOutBack
                                                                      .transform(
                                                                          a1.value) -
                                                                  1.0;
                                                              return Transform(
                                                                transform: Matrix4
                                                                    .translationValues(
                                                                        0.0,
                                                                        curvedValue *
                                                                            200,
                                                                        0.0),
                                                                child: Opacity(
                                                                  opacity:
                                                                      a1.value,
                                                                  child:
                                                                      ConfirmationDialog(
                                                                    tribeId: list[
                                                                            index]
                                                                        [
                                                                        'groupId'],
                                                                    mListener:
                                                                        this,
                                                                    msg:
                                                                        "Do you really want to delete this group.",
                                                                    comeFrom:
                                                                        "5",
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            transitionDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        200),
                                                            barrierDismissible:
                                                                false,
                                                            barrierLabel: '',
                                                            context: context,
                                                            pageBuilder: (context,
                                                                animation2,
                                                                animation1) {});
                                                      } else if (val == 2) {
                                                        setState(() {
                                                          flag = false;
                                                        });
                                                        final prefs = await con
                                                            .sharedPrefs;
                                                        Map<String, dynamic>
                                                            body = {
                                                          "user_id":
                                                              prefs.getString(
                                                                  "spUserID"),
                                                          "group_id":
                                                              list[index]
                                                                  ['groupId'],
                                                        };
                                                        await con
                                                            .waitUntilBlockGroup(
                                                                body)
                                                            .then((value) {
                                                          setState(() {
                                                            flag = true;
                                                            if (value) {
                                                              list.clear();
                                                              //list.removeAt(localIndex);
                                                              getChatUserList();
                                                            }
                                                          });
                                                        });
                                                      }
                                                    },
                                                  )
                                                ],
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                              ),
                                            ),
                                            color: hp.theme.primaryColor),
                                      );
                              },
                              itemCount: list.length))
                      : chatListingResponseModelLocal
                              .responseData.message.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      if (chatListingResponseModelLocal
                                              .responseData.message
                                              .elementAt(index)
                                              .isGroup ==
                                          false) {
                                        Navigator.push(
                                            hp.context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChatActivity(
                                                otherUserId: id ==
                                                        chatListingResponseModelLocal
                                                            .responseData
                                                            .message
                                                            .elementAt(index)
                                                            .fromUserId
                                                    ? chatListingResponseModelLocal
                                                        .responseData.message
                                                        .elementAt(index)
                                                        .touser
                                                        .elementAt(0)
                                                        .id
                                                    : chatListingResponseModelLocal
                                                        .responseData.message
                                                        .elementAt(index)
                                                        .fromuser
                                                        .elementAt(0)
                                                        .id,
                                                name: id ==
                                                        chatListingResponseModelLocal
                                                            .responseData
                                                            .message
                                                            .elementAt(index)
                                                            .fromUserId
                                                    ? chatListingResponseModelLocal
                                                        .responseData.message
                                                        .elementAt(index)
                                                        .touser
                                                        .elementAt(0)
                                                        .fullName
                                                    : chatListingResponseModelLocal
                                                        .responseData.message
                                                        .elementAt(index)
                                                        .fromuser
                                                        .elementAt(0)
                                                        .fullName,
                                                profilePic: id ==
                                                        chatListingResponseModelLocal
                                                            .responseData
                                                            .message
                                                            .elementAt(index)
                                                            .fromUserId
                                                    ? "https://54.177.127.20:2109/img/profile-pic/" +
                                                        chatListingResponseModelLocal
                                                            .responseData
                                                            .message
                                                            .elementAt(index)
                                                            .touser
                                                            .elementAt(0)
                                                            .profileImage
                                                    : "https://54.177.127.20:2109/img/profile-pic/" +
                                                        chatListingResponseModelLocal
                                                            .responseData
                                                            .message
                                                            .elementAt(index)
                                                            .fromuser
                                                            .elementAt(0)
                                                            .profileImage,
                                                mListener: this,
                                                textSub: msgText,
                                                coming: localStrCome,
                                              ),
                                            ));
                                      }
                                    },
                                    onDoubleTap: () {},
                                    child: Card(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left:
                                                  SizeConfig.screenWidth * .02,
                                              right:
                                                  SizeConfig.screenWidth * .02,
                                              top: SizeConfig.screenHeight *
                                                  .015,
                                              bottom: SizeConfig.screenHeight *
                                                  .025),
                                          child: Row(
                                            children: [
                                              chatListingResponseModelLocal.responseData.message.elementAt(index).fromuser.isNotEmpty?
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Stack(
                                                    children: <Widget>[
                                                      Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: hp.theme
                                                                    .secondaryHeaderColor,
                                                                width: 1),
                                                            image: const DecorationImage(
                                                                fit:
                                                                    BoxFit.fill,
                                                                image: AssetImage(
                                                                    "assets/images/noimage.png")),
                                                          ),
                                                          height:
                                                              hp.height / 12,
                                                          width: hp.width / 6,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right:
                                                                      hp.width /
                                                                          32)),
                                                      Container(
                                                          child: AspectRatio(
                                                            aspectRatio: 1 / 1,
                                                            child: ClipOval(
                                                                child: FadeInImage.assetNetwork(
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    placeholder:
                                                                        'assets/images/noimage.png',
                                                                    image: id ==
                                                                            chatListingResponseModelLocal.responseData.message
                                                                                .elementAt(
                                                                                    index)
                                                                                .fromUserId
                                                                        ? "https://54.177.127.20:2109/img/profile-pic/" +
                                                                            chatListingResponseModelLocal.responseData.message.elementAt(index).touser.elementAt(0).profileImage
                                                                        : "https://54.177.127.20:2109/img/profile-pic/" + chatListingResponseModelLocal.responseData.message.elementAt(index).fromuser.elementAt(0).profileImage)),
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: hp.theme
                                                                    .secondaryHeaderColor,
                                                                width:
                                                                    hp.width /
                                                                        100),
                                                          ),
                                                          height:
                                                              hp.height / 12,
                                                          width: hp.width / 6,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right:
                                                                      hp.width /
                                                                          32)),
                                                    ],
                                                  ),
                                                ],
                                              ):Container(),
                                              chatListingResponseModelLocal.responseData.message.elementAt(index).fromuser.isNotEmpty?
                                              Expanded(
                                                  child: Padding(
                                                padding: EdgeInsets.only(
                                                    left:
                                                        SizeConfig.screenWidth *
                                                            .02),
                                                child: Column(
                                                    children: [
                                                      Text(
                                                        id ==
                                                                chatListingResponseModelLocal
                                                                    .responseData
                                                                    .message
                                                                    .elementAt(
                                                                        index)
                                                                    .fromUserId
                                                            ? chatListingResponseModelLocal
                                                                .responseData
                                                                .message
                                                                .elementAt(
                                                                    index)
                                                                .touser
                                                                .elementAt(0)
                                                                .fullName
                                                            : chatListingResponseModelLocal
                                                                .responseData
                                                                .message
                                                                .elementAt(
                                                                    index)
                                                                .fromuser
                                                                .elementAt(0)
                                                                .fullName,
                                                        style: TextStyle(
                                                            color: hp.theme
                                                                .secondaryHeaderColor,
                                                            fontSize: SizeConfig
                                                                    .blockSizeHorizontal *
                                                                4.1),
                                                        textScaleFactor: 1.1,
                                                      ),
                                                    ],
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start),
                                              )):
                                              Container(),
                                              PopupMenuButton(
                                                color: Colors.white,
                                                icon: Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            hp.theme.cardColor,
                                                        shape: BoxShape.circle),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Icon(
                                                        Icons
                                                            .more_vert_outlined,
                                                        color: hp.theme
                                                            .secondaryHeaderColor,
                                                      ),
                                                    )),
                                                itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                    child: Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          fontSize: SizeConfig
                                                                  .safeBlockHorizontal *
                                                              3.5,
                                                          fontFamily:
                                                              "Avenir_Heavy",
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      textScaleFactor: 1.2,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    value: 1,
                                                  ),
                                                  PopupMenuItem(
                                                    child: Text(
                                                      "Block",
                                                      style: TextStyle(
                                                          fontSize: SizeConfig
                                                                  .safeBlockHorizontal *
                                                              3.5,
                                                          fontFamily:
                                                              "Avenir_Heavy",
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      textScaleFactor: 1.2,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    value: 2,
                                                  )
                                                ],
                                                onSelected: (val) async {
                                                  if (val == 1) {
                                                    showGeneralDialog(
                                                        barrierColor: Colors
                                                            .black
                                                            .withOpacity(0.8),
                                                        transitionBuilder:
                                                            (context, a1, a2,
                                                                widget) {
                                                          final curvedValue = Curves
                                                                  .easeInOutBack
                                                                  .transform(a1
                                                                      .value) -
                                                              1.0;
                                                          return Transform(
                                                            transform: Matrix4
                                                                .translationValues(
                                                                    0.0,
                                                                    curvedValue *
                                                                        200,
                                                                    0.0),
                                                            child: Opacity(
                                                              opacity: a1.value,
                                                              child:
                                                                  ConfirmationDialog(
                                                                tribeId: id ==
                                                                        chatListingResponseModelLocal
                                                                            .responseData
                                                                            .message
                                                                            .elementAt(
                                                                                index)
                                                                            .fromUserId
                                                                    ? chatListingResponseModelLocal
                                                                        .responseData
                                                                        .message
                                                                        .elementAt(
                                                                            index)
                                                                        .touser
                                                                        .elementAt(
                                                                            0)
                                                                        .id
                                                                    : chatListingResponseModelLocal
                                                                        .responseData
                                                                        .message
                                                                        .elementAt(
                                                                            index)
                                                                        .fromuser
                                                                        .elementAt(
                                                                            0)
                                                                        .id,
                                                                mListener: this,
                                                                msg:
                                                                    "Do you really want to delete chat.",
                                                                comeFrom: "4",
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        transitionDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    200),
                                                        barrierDismissible:
                                                            false,
                                                        barrierLabel: '',
                                                        context: context,
                                                        pageBuilder: (context,
                                                            animation2,
                                                            animation1) {});
                                                  } else if (val == 2) {
                                                    setState(() {
                                                      flag = false;
                                                    });
                                                    final prefs =
                                                        await con.sharedPrefs;
                                                    Map<String, dynamic> body =
                                                        {
                                                      "userId": prefs.getString(
                                                          "spUserID"),
                                                      "blockedUserId": id ==
                                                              chatListingResponseModelLocal
                                                                  .responseData
                                                                  .message
                                                                  .elementAt(
                                                                      index)
                                                                  .fromUserId
                                                          ? chatListingResponseModelLocal
                                                              .responseData
                                                              .message
                                                              .elementAt(index)
                                                              .touser
                                                              .elementAt(0)
                                                              .id
                                                          : chatListingResponseModelLocal
                                                              .responseData
                                                              .message
                                                              .elementAt(index)
                                                              .fromuser
                                                              .elementAt(0)
                                                              .id,
                                                      "appType":
                                                          prefs.getString(
                                                              "spAppType"),
                                                      "loginId":
                                                          prefs.getString(
                                                              "spLoginID"),
                                                    };
                                                    await con
                                                        .waitUntilBlockUser(
                                                            body)
                                                        .then((value) {
                                                      setState(() {
                                                        flag = true;
                                                        if (value) {}
                                                      });
                                                    });
                                                  }
                                                },
                                              )
                                            ],
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                          ),
                                        ),
                                        color: hp.theme.primaryColor),
                                  );
                                },
                                itemCount: chatListingResponseModelLocal
                                    .responseData.message.length,
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onDoubleTap: () {},
                                    onTap: () {
                                      if (chatListingResponseModelLocal
                                              .responseData.group
                                              .elementAt(index)
                                              .isGroup ==
                                          true) {
                                        Navigator.push(
                                            hp.context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  GroupChatActivity(
                                                groupID:
                                                    chatListingResponseModelLocal
                                                        .responseData.group
                                                        .elementAt(index)
                                                        .groupId,
                                                name:
                                                    chatListingResponseModelLocal
                                                        .responseData.group
                                                        .elementAt(index)
                                                        .groupName,
                                                profilePic:
                                                    chatListingResponseModelLocal
                                                        .responseData.group
                                                        .elementAt(index)
                                                        .groupImage,
                                                mListener: this,
                                                textSub: msgText,
                                                coming: localStrCome,
                                              ),
                                            ));
                                      }
                                    },
                                    child: Card(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left:
                                                  SizeConfig.screenWidth * .02,
                                              right:
                                                  SizeConfig.screenWidth * .02,
                                              top: SizeConfig.screenHeight *
                                                  .015,
                                              bottom: SizeConfig.screenHeight *
                                                  .025),
                                          child: Row(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Stack(
                                                    children: <Widget>[
                                                      Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: hp.theme
                                                                    .secondaryHeaderColor,
                                                                width: 1),
                                                            image: const DecorationImage(
                                                                fit:
                                                                    BoxFit.fill,
                                                                image: AssetImage(
                                                                    "assets/images/noimage.png")),
                                                          ),
                                                          height:
                                                              hp.height / 12,
                                                          width: hp.width / 6,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right:
                                                                      hp.width /
                                                                          32)),
                                                      Container(
                                                          child: AspectRatio(
                                                            aspectRatio: 1 / 1,
                                                            child: ClipOval(
                                                                child: FadeInImage.assetNetwork(
                                                                    fit: BoxFit
                                                                        .fill,
                                                                    placeholder:
                                                                        'assets/images/noimage.png',
                                                                    image: chatListingResponseModelLocal
                                                                        .responseData
                                                                        .group
                                                                        .elementAt(
                                                                            index)
                                                                        .groupImage)),
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: hp.theme
                                                                    .secondaryHeaderColor,
                                                                width:
                                                                    hp.width /
                                                                        100),
                                                          ),
                                                          height:
                                                              hp.height / 12,
                                                          width: hp.width / 6,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right:
                                                                      hp.width /
                                                                          32)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                  child: Padding(
                                                padding: EdgeInsets.only(
                                                    left:
                                                        SizeConfig.screenWidth *
                                                            .02),
                                                child: Column(
                                                    children: [
                                                      Text(
                                                        chatListingResponseModelLocal
                                                            .responseData.group
                                                            .elementAt(index)
                                                            .groupName,
                                                        style: TextStyle(
                                                            color: hp.theme
                                                                .secondaryHeaderColor,
                                                            fontSize: SizeConfig
                                                                    .blockSizeHorizontal *
                                                                4.1),
                                                        textScaleFactor: 1.1,
                                                      ),
                                                    ],
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start),
                                              )),
                                              PopupMenuButton(
                                                color: Colors.white,
                                                icon: Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            hp.theme.cardColor,
                                                        shape: BoxShape.circle),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4.0),
                                                      child: Icon(
                                                        Icons
                                                            .more_vert_outlined,
                                                        color: hp.theme
                                                            .secondaryHeaderColor,
                                                      ),
                                                    )),
                                                itemBuilder: (context) => [
                                                  PopupMenuItem(
                                                    child: Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          fontSize: SizeConfig
                                                                  .safeBlockHorizontal *
                                                              3.5,
                                                          fontFamily:
                                                              "Avenir_Heavy",
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      textScaleFactor: 1.2,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    value: 1,
                                                  ),
                                                  PopupMenuItem(
                                                    child: Text(
                                                      "Block",
                                                      style: TextStyle(
                                                          fontSize: SizeConfig
                                                                  .safeBlockHorizontal *
                                                              3.5,
                                                          fontFamily:
                                                              "Avenir_Heavy",
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      textScaleFactor: 1.2,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    value: 2,
                                                  )
                                                ],
                                                onSelected: (val) async {
                                                  if (val == 1) {
                                                    showGeneralDialog(
                                                        barrierColor: Colors
                                                            .black
                                                            .withOpacity(0.8),
                                                        transitionBuilder:
                                                            (context, a1, a2,
                                                                widget) {
                                                          final curvedValue = Curves
                                                                  .easeInOutBack
                                                                  .transform(a1
                                                                      .value) -
                                                              1.0;
                                                          return Transform(
                                                            transform: Matrix4
                                                                .translationValues(
                                                                    0.0,
                                                                    curvedValue *
                                                                        200,
                                                                    0.0),
                                                            child: Opacity(
                                                              opacity: a1.value,
                                                              child:
                                                                  ConfirmationDialog(
                                                                tribeId: chatListingResponseModelLocal
                                                                    .responseData
                                                                    .group
                                                                    .elementAt(
                                                                        index)
                                                                    .groupId,
                                                                mListener: this,
                                                                msg:
                                                                    "Do you really want to delete this group.",
                                                                comeFrom: "5",
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        transitionDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    200),
                                                        barrierDismissible:
                                                            false,
                                                        barrierLabel: '',
                                                        context: context,
                                                        pageBuilder: (context,
                                                            animation2,
                                                            animation1) {});
                                                  } else if (val == 2) {
                                                    setState(() {
                                                      flag = false;
                                                    });
                                                    final prefs =
                                                        await con.sharedPrefs;
                                                    Map<String, dynamic> body =
                                                        {
                                                      "user_id":
                                                          prefs.getString(
                                                              "spUserID"),
                                                      "group_id":
                                                          chatListingResponseModelLocal
                                                              .responseData
                                                              .group
                                                              .elementAt(index)
                                                              .groupId,
                                                    };
                                                    await con
                                                        .waitUntilBlockGroup(
                                                            body)
                                                        .then((value) {
                                                      setState(() {
                                                        flag = true;
                                                        if (value) {
                                                          list.clear();
                                                          //list.removeAt(localIndex);
                                                          getChatUserList();
                                                          //getChatUserList();
                                                        }
                                                      });
                                                    });
                                                  }
                                                },
                                              )
                                            ],
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                          ),
                                        ),
                                        color: hp.theme.primaryColor),
                                  );
                                },
                                itemCount: chatListingResponseModelLocal
                                    .responseData.group.length,
                              ),
                            )
                  : Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "No data found",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      SizeConfig.safeBlockHorizontal * 5.0),
                              textScaleFactor: 1.0,
                            ),
                          ],
                        ),

                        //   color: Colors.green,
                        //  color: Colors.green,
                      ),
                    ),
            ],
          ),
          flag
              ? Container()
              : Container(
                  height: hp.height,
                  width: hp.width,
                  color: Colors.black87,
                  child: const SpinKitFoldingCube(color: Colors.white),
                ),
        ],
      ),
    );
  }

  @override
  callApiForLeaveTribe(String tribeId, String comeFrom) {
    // TODO: implement callApiForLeaveTribe
    if (comeFrom == "4") {
      deleteChatFunction(tribeId);
    } else if (comeFrom == "5") {
      deleteGroupChatFunction(tribeId);
    }
  }

  deleteChatFunction(String id) async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    if (mounted) {
      setState(() {
        //loaderFlag = true;
      });
    }
    final body = {
      "userId": prefs.getString("spUserID") ?? "",
      "loginId": prefs.getString("spLoginID") ?? "",
      "appType": prefs.getString("spAppType") ?? "",
      "toUserId": id,
    };
    await controller.waitUntilDeleteChat(body).then((value) {
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          // loaderFlag = false;
        });
        if (value) {
          list.clear();
          getChatUserList();
          //getChatUserList();
        }
      });
    });
  }

  deleteGroupChatFunction(String id) async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    if (mounted) {
      setState(() {
        //loaderFlag = true;
      });
    }
    final body = {
      "user_id": prefs.getString("spUserID") ?? "",
      "group_id": id,
    };
    await controller.waitUntilDeleteGroup(body).then((value) {
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          // loaderFlag = false;
        });
        if (value) {
          list.clear();
          getChatUserList();

          // getChatUserList();
        }
      });
    });
  }

  String msgText = "", localStrCome = "";

  @override
  forwardMessage(String text, String comeFrom) {
    // TODO: implement forwardMessage
    setState(() {
      msgText = text;
      localStrCome = comeFrom;
    });
  }

  @override
  forwardGroupMessage(String text, String comeFrom) {
    // TODO: implement forwardGroupMessage
    setState(() {
      msgText = text;
      localStrCome = comeFrom;
    });
  }
}
