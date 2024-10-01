import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:griot_legacy_social_media_app/src/helpers/helper.dart';
import 'package:griot_legacy_social_media_app/src/screens/create_tribe.dart';
import 'package:griot_legacy_social_media_app/src/utils/constant_class.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/user_controller.dart';
import 'full_view_image_activity.dart';

class TribeMembersScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final tribeMembersList;
  // ignore: prefer_typing_uninitialized_variables
  final tribeName;
  const TribeMembersScreen({Key key, this.tribeMembersList, this.tribeName})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TribeMembersScreenState();
  }
}

class TribeMembersScreenState extends State<TribeMembersScreen> {
  bool isTribe = false;
  bool loaderFlag = true;
  List tribeMembersList = [];
  UserController con;
  @override
  void initState() {
    super.initState();
    setState(() {
      tribeMembersList = widget.tribeMembersList;
    });
    getLocalData();
  }
  String userLocalId="";

  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();

  getLocalData() async {
    final prefs = await sharedPrefs;
    setState(() {
      userLocalId= prefs.getString("spUserID");
    });

  }

  @override
  Widget build(BuildContext context) {
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
                      ListView.builder(
                        itemCount: tribeMembersList.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          /*print("piccccccc   ${tribeMembersList[
                          index][
                          "profileImage"]}");*/
                          return
                          tribeMembersList[0]!=null ?
                            GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          tribeMembersList[index]["profileImage"] ==
                                                      "" ||
                                                  tribeMembersList[index]
                                                          ["profileImage"] ==
                                                      null
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: hp.theme
                                                            .secondaryHeaderColor,
                                                        width: 1),
                                                    image: const DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: AssetImage(
                                                            "assets/images/dummy.jpeg")),
                                                  ),
                                                  height: hp.height / 12,
                                                  width: hp.width / 6,
                                                  margin: EdgeInsets.only(
                                                      right: hp.width / 32))
                                              : GestureDetector(
                                            onTap: (){
                                              Navigator.push(
                                                  hp.context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        FullImageActivity(
                                                          image:
                                                          Constant.userPicServerUrl +
                                                              tribeMembersList[
                                                              index][
                                                              "profileImage"],
                                                        ),
                                                  ));
                                            },
                                            onDoubleTap: (){},
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: hp.theme
                                                              .secondaryHeaderColor,
                                                          width: hp.width / 100),
                                                      image: DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: NetworkImage(
                                                             Constant.userPicServerUrl +
                                                                  tribeMembersList[
                                                                          index][
                                                                      "profileImage"])),
                                                    ),
                                                    height: hp.height / 10,
                                                    width: hp.width / 6,
                                                    margin: EdgeInsets.only(
                                                        right: hp.width / 32)),
                                              ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                tribeMembersList[index]
                                                    ["fullName"] ?? "",
                                                style: TextStyle(
                                                    color: hp.theme
                                                        .secondaryHeaderColor,
                                                    fontSize: 13),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: hp.height * 0.003)),
                                              Text(
                                                "Active ${tribeMembersList[index]["status"] == 'ACTIVE' ? 'Now' : tribeMembersList[index]["status"]}",
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
                                      userLocalId==tribeMembersList[index]
                                      ["_id"] ? Container():PopupMenuButton(
                                        color: Colors.white,
                                        icon: Container(
                                            decoration: BoxDecoration(
                                                color: hp.theme.cardColor,
                                                shape: BoxShape.circle),
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(
                                                  4.0),
                                              child: Icon(
                                                Icons.more_vert_outlined,
                                                color: hp.theme
                                                    .secondaryHeaderColor,
                                              ),
                                            )),
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            child: Text(
                                              "Block",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontFamily:
                                                  "Avenir_Heavy",
                                                  color: Colors.black,
                                                  fontWeight:
                                                  FontWeight
                                                      .w600),
                                              textScaleFactor: 1.2,
                                              textAlign:
                                              TextAlign.center,
                                            ),
                                            value: 1,
                                          )
                                        ],
                                        onSelected: (val) async {
                                          final state =
                                              context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
                                                  GetBuilderState<UserController>();
                                          con = UserController(context, state);
                                           if(val==1){
                                            setState(() {
                                            //  flag = false;
                                            });
                                            final prefs = await con.sharedPrefs;
                                            Map<String, dynamic> body = {
                                              "userId":
                                              prefs.getString("spUserID"),
                                              "blockedUserId":  tribeMembersList[index]
                                              ["_id"],
                                              "appType":
                                              prefs.getString("spAppType"),
                                              "loginId":
                                              prefs.getString("spLoginID"),
                                            };
                                            await con
                                                .waitUntilBlockUser(body)
                                                .then((value) {
                                              setState(() {
                                               // flag = true;
                                                if (value) {
                                                  Navigator.pop(context);

                                                }
                                              });
                                            });
                                          }
                                        },
                                      )
                                     /* CircleAvatar(
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.more_vert_outlined,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                //data.removeAt(index);
                                              });
                                            },
                                          ),
                                          backgroundColor: Colors.white12,
                                          foregroundColor: hp.theme.primaryColor
                                          //foregroundColor: Colors.transparent
                                          ),*/
                                    ],
                                  ),
                                  Divider(
                                    color: hp.theme.secondaryHeaderColor,
                                    thickness: 0.1,
                                  )
                                ],
                              ),
                            ),
                          ):Container();
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
              title: Text(widget.tribeName ?? ""),
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const CreateTribeScreen()));
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
}
