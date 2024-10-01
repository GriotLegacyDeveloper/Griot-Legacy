import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';

import '../models/block_tribe_list_response_model.dart';

class BlockTribeListScreen extends StatefulWidget {
  const BlockTribeListScreen({Key key}) : super(key: key);

  @override
  _BlockTribeListScreenState createState() => _BlockTribeListScreenState();
}

class _BlockTribeListScreenState extends State<BlockTribeListScreen> {
  bool flag = true;
//List blockListLocal = [];
  var blockTribeListModel = BlockTribeListResponseModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBlockListAPi();
  }

  UserController controller;

  bool isShowData = false;
  Future getBlockListAPi() async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
/*     final prefs = await controller.sharedPrefs;
     final obj = {
      "userId": prefs.getString("spUserID"),
      "loginId": prefs.getString("spLoginID"),
      "appType": prefs.getString("spAppType"),

     };*/
    //print("obj   $obj");
    //print(prefs.getString("spAuthToken"));
    if (mounted) {
      setState(() {
        flag = false;
      });
    }
    controller.waitForBlockTribeList(/*obj*/).then((value) {
      if (mounted) {
        setState(() {
          flag = true;
          isShowData = true;
        });
      }
      blockTribeListModel = controller.blockTribeListModel;
      if (blockTribeListModel.responseData.data.isNotEmpty) {
        if (mounted) {
          setState(() {
            isShowData = true;
          });
        }
      }
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

  Widget pageBuilder(UserController con) {
    final hp = con.hp;

    hp.lockScreenRotation();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Block List"),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          isShowData
              ? SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: blockTribeListModel.responseData.data.length,
                    shrinkWrap: true,
                    controller: ScrollController(),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: SizeConfig.screenWidth * .04,
                            right: SizeConfig.screenWidth * .04,
                            top: SizeConfig.screenHeight * .005,
                            bottom: SizeConfig.screenHeight * .005),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    blockTribeListModel.responseData.data
                                        .elementAt(index).image==
                                        ""
                                        ? Container(
                                        decoration:
                                        BoxDecoration(
                                          shape:
                                          BoxShape.circle,
                                          border: Border.all(
                                              color: hp.theme
                                                  .secondaryHeaderColor,
                                              width: 1),
                                          image: const DecorationImage(
                                              fit: BoxFit.fill,
                                              image: AssetImage(
                                                  "assets/images/noimage.png")),
                                        ),
                                        height: hp.height / 12,
                                        width: hp.width / 6,
                                        margin: EdgeInsets.only(
                                            right:
                                            hp.width / 32))
                                        : Container(
                                        child: AspectRatio(
                                          aspectRatio: 1 / 1,
                                          child: ClipOval(
                                              child: FadeInImage.assetNetwork(
                                                  fit: BoxFit
                                                      .fill,
                                                  placeholder:
                                                  'assets/images/noimage.png',
                                                  image: blockTribeListModel
                                                      .responseData
                                                      .data.elementAt(index).userImageUrl +
                      blockTribeListModel
                                                          .responseData
                                                          .data
                                                          .elementAt(
                                                          index)
                                                          .image)),
                                        ),
                                        decoration:
                                        BoxDecoration(
                                          shape:
                                          BoxShape.circle,
                                          border: Border.all(
                                              color: hp.theme
                                                  .secondaryHeaderColor,
                                              width: hp.width /
                                                  100),
                                        ),
                                        height: hp.height / 12,
                                        width: hp.width / 6,
                                        margin: EdgeInsets.only(
                                            right:
                                            hp.width / 32)),
                                    /*Container(
                                      decoration:
                                      BoxDecoration(
                                        shape: BoxShape
                                            .circle,
                                        border: Border.all(
                                            color: Colors.white,
                                            width: 1),
                                        image: const DecorationImage(
                                            fit: BoxFit
                                                .cover,
                                            image: AssetImage(
                                                "assets/images/noimage.png")),
                                      ),
                                      height:
                                      SizeConfig.screenHeight *.06,
                                      width: SizeConfig.screenHeight *.06,

                                    ),*/
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: SizeConfig
                                              .screenWidth *
                                              .025),
                                      child: Row(
                                        children: [
                                          Text(
                                            blockTribeListModel
                                                .responseData.data
                                                .elementAt(index)
                                                .name,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: SizeConfig
                                                    .blockSizeHorizontal *
                                                    4.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      flag = false;
                                    });
                                    final prefs =
                                    await con.sharedPrefs;
                                    Map<String, dynamic> body = {
                                      "userId": prefs
                                          .getString("spUserID"),
                                      "tribeId": blockTribeListModel
                                          .responseData.data
                                          .elementAt(index)
                                          .id,
                                      "appType": prefs
                                          .getString("spAppType"),
                                      "loginId": prefs
                                          .getString("spLoginID"),
                                    };
                                    await con
                                        .waitUntilUnblockTribe(body)
                                        .then((value) {
                                      setState(() {
                                        flag = true;
                                        if (value) {
                                          getBlockListAPi();
                                        }
                                      });
                                    });
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white12,
                                        borderRadius:
                                        BorderRadius.all(
                                          Radius.circular(8.0),
                                        )
                                      // shape: BoxShape.circle
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: SizeConfig
                                              .screenWidth *
                                              .06,
                                          right:
                                          SizeConfig
                                              .screenWidth *
                                              .06,
                                          top: SizeConfig
                                              .screenHeight *
                                              .013,
                                          bottom: SizeConfig
                                              .screenHeight *
                                              .013),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Unblock",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: SizeConfig
                                                    .blockSizeHorizontal *
                                                    3.8),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 0.1,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )

              ],
            ),
          )
              : Container(
            // color: Colors.green,
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
    );
  }



}
