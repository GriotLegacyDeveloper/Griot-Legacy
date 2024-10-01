import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/controllers/post_controller.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/controllers/other_controller.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';
import 'package:griot_legacy_social_media_app/src/models/like_model.dart';
import 'package:griot_legacy_social_media_app/src/screens/comments.dart';
import 'package:griot_legacy_social_media_app/src/screens/confirmation_dialog.dart';
import 'package:griot_legacy_social_media_app/src/screens/full_view_image_activity.dart';
import 'package:griot_legacy_social_media_app/src/screens/upload_post_page.dart';
import '../../formated_date_time.dart';
import '../repos/other_user_response_model.dart';
import 'full_video_screen.dart';


class OtherUserPostDetailsPage extends StatefulWidget {
  final OtherUserPostDetailsPageInterface mListener;
  final OtherUserPost list;
  final OtherUserProfileResponseModel otherUserModel;
  final int index;
  final String otherUserID;

  const OtherUserPostDetailsPage({
    Key key,
    this.mListener,
    this.list,
    this.index,
    this.otherUserModel, this.otherUserID,
  }) : super(key: key);

  @override
  State<OtherUserPostDetailsPage> createState() =>
      _OtherUserPostDetailsPageState();
}


class _OtherUserPostDetailsPageState extends State<OtherUserPostDetailsPage>
    with ConfirmationDialogInterface, UploadPostPageInterface {

  void didChange(GetBuilderState<PostController> state) {
    state.controller.hp.lockScreenRotation();
  }




  bool isLiked = false;

  Widget pageBuilder(OtherController con) {
    CarouselSliderController sliderController;

    final hp = con.hp;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: hp.theme.primaryColor,
        foregroundColor: hp.theme.secondaryHeaderColor,
      ),
      backgroundColor: hp.theme.primaryColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: SizeConfig.screenHeight * .0),
          child: Stack(
            children: [
              ListView(
                children: [
                  Container(
                    color: Colors.white.withOpacity(0.1),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: SizeConfig.screenHeight * 0.02,
                          left: SizeConfig.screenWidth * .06,
                          right: SizeConfig.screenWidth * .06),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: <Widget>[
                                      Container(
                                        height: SizeConfig.screenHeight * .05,
                                        width: SizeConfig.screenHeight * .05,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  "assets/images/dummy.jpeg")),
                                        ),
                                      ),
                                      Container(
                                        height: SizeConfig.screenHeight * .05,
                                        width: SizeConfig.screenHeight * .05,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image:
                                            NetworkImage(widget.otherUserModel.responseData.profileImage),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: SizeConfig.screenWidth * .03),
                                    child: Column(
                                        children: [
                                          Text(
                                            widget.otherUserModel.responseData.fullName,
                                            style: TextStyle(
                                                color:
                                                hp.theme.secondaryHeaderColor,
                                                fontSize:
                                                SizeConfig.blockSizeHorizontal *
                                                    4.1),
                                            textScaleFactor: 1.1,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top:
                                                SizeConfig.screenHeight * .005),
                                            child: Text(
                                              FormatedDateTime.formatedDateTimeTo(
                                                  widget.otherUserModel.responseData.dateOfBirth.toString()),
                                              style: TextStyle(
                                                  color: hp
                                                      .theme.secondaryHeaderColor
                                                      .withOpacity(0.2),
                                                  fontSize: SizeConfig
                                                      .blockSizeHorizontal *
                                                      3.4),
                                              textScaleFactor: 1.0,
                                            ),
                                          )
                                        ],
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start),
                                  )),




                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight * .5,
                            child: CarouselSlider.builder(
                              unlimitedMode: true,
                              controller: sliderController,
                              slideBuilder: (index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.screenHeight * .02),
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      widget.list.imageArr
                                                  .elementAt(index)
                                                  .type ==
                                              "IMAGE"
                                          ? GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    hp.context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          FullImageActivity(
                                                        image: widget
                                                            .list.imageArr
                                                            .elementAt(index)
                                                            .image,
                                                      ),
                                                    ));
                                              },
                                              onDoubleTap: () {},
                                              child: Container(
                                                width: SizeConfig.screenWidth,
                                                // alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              hp.radius / 80)),
                                                ),
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    child: CachedNetworkImage(
                                                      imageUrl: widget
                                                          .list.imageArr
                                                          .elementAt(index)
                                                          .image,
                                                      fit: BoxFit.contain,
                                                      placeholder:
                                                          (BuildContext context,
                                                              url) {
                                                        return const Image(
                                                            image: AssetImage(
                                                                'assets/images/noimage.png'));
                                                      },
                                                    )),
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    hp.context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          FullVideoScreen(
                                                            thumb:  widget
                                                                .list.imageArr
                                                                .elementAt(index)
                                                                .thumb,
                                                        videoUrl: widget
                                                            .list.imageArr
                                                            .elementAt(index)
                                                            .image,
                                                      ),
                                                    ));

                                              },
                                              onDoubleTap: () {},
                                              child: SizedBox(
                                                height:
                                                    SizeConfig.screenHeight *
                                                        .5,
                                                width: SizeConfig.screenWidth,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    child: CachedNetworkImage(
                                                      imageUrl: widget
                                                          .list.imageArr
                                                          .elementAt(index)
                                                          .thumb,
                                                      fit: BoxFit.contain,
                                                      placeholder:
                                                          (BuildContext context,
                                                              url) {
                                                        return const Image(
                                                            image: AssetImage(
                                                                'assets/images/noimage.png'));
                                                      },
                                                    )),

                                              ),
                                            ),
                                    ],
                                  ),
                                );
                              },
                              slideTransform: const ParallaxTransform(),
                              itemCount: widget.list.imageArr.length,
                              initialPage: widget.index,
                              enableAutoSlider: false,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.screenHeight * .015),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final state = context
                                                .findAncestorStateOfType<
                                                    GetBuilderState<
                                                        UserController>>() ??
                                            GetBuilderState<UserController>();
                                        controller =
                                            UserController(context, state);

                                        final prefs =
                                            await controller.sharedPrefs;

                                        final body = {
                                          "userId":
                                              prefs.getString("spUserID") ?? "",
                                          "loginId":
                                              prefs.getString("spLoginID") ??
                                                  "",
                                          "appType":
                                              prefs.getString("spAppType") ??
                                                  "",
                                          "postId": widget.list.postId,
                                        };

                                        if (widget.list.isliked != null &&
                                            widget.list.isliked) {
                                          await controller
                                              .waitUntilUnlikePost(body)
                                              .then((value) {
                                          //  print("Unlike data..$value");

                                            setState(() {
                                              widget.list.isliked = false;

                                              for (int j = 0;
                                                  j < widget.list.like.length;
                                                  j++) {
                                                if (widget.list.likedId ==
                                                    widget.list.like[j].id) {
                                                  widget.list.like.removeAt(j);
                                                }
                                              }
                                            });
                                          });
                                        } else {
                                          await controller
                                              .waitUntilLikePost(body)
                                              .then((value) {
                                            //print("like data..$value");

                                            setState(() {
                                              if (value["success"] &&
                                                  value["STATUSCODE"] == 200) {
                                                widget.list.isliked = true;

                                                var data = {
                                                  "_id":
                                                      "${value["response_data"]["_id"]}",
                                                };

                                                widget.list.like.insert(0,
                                                    LikeModel.fromJson(data));
                                                widget.list.likedId =
                                                    "${value["response_data"]["_id"]}";
                                              } //if
                                            });
                                          });
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Image(
                                              image: const AssetImage(
                                                  "assets/images/Like.png"),
                                              height: SizeConfig.screenHeight *
                                                  .025,
                                              width: SizeConfig.screenHeight *
                                                  .025,
                                              color:
                                                  widget.list.isliked != null &&
                                                          widget.list.isliked
                                                      ? Colors.blue
                                                      : hp.theme.hintColor,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: SizeConfig.screenWidth *
                                                      .02),
                                              child: Text(
                                                "${widget.list.like.length}",
                                                style: TextStyle(
                                                    color: hp.theme.hintColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: SizeConfig
                                                            .blockSizeHorizontal *
                                                        3.8),
                                                textScaleFactor: 1.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            shape: const RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(
                                                          25.0)),
                                            ),
                                            context: context,
                                            elevation: 8,
                                            isDismissible: true,
                                            isScrollControlled: true,
                                            //  backgroundColor:Color(0xff141414),
                                            builder:
                                                (BuildContext buildContext) {
                                              return Container(
                                                  decoration: BoxDecoration(
                                                      color: const Color(0xff141414),
                                                      borderRadius:
                                                          const BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      25)),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors.white)),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      1.12,
                                                  child: Comments(
                                                      postId:
                                                          widget.list.postId,
                                                      comments:
                                                          widget.list.comment,
                                                      userName:
                                                          widget.list.name,comeFrom: "2"
                                                    ,otherUserId: widget.otherUserID,
                                                    profileImag: widget.otherUserModel.responseData.profileImage,));
                                            }).whenComplete(() {
                                          setState(() {});
                                        });
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .07),
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image(
                                                image: const AssetImage(
                                                    "assets/images/comment.png"),
                                                height:
                                                    SizeConfig.screenHeight *
                                                        .023,
                                                width: SizeConfig.screenHeight *
                                                    .023,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left:
                                                        SizeConfig.screenWidth *
                                                            .02),
                                                child: Text(
                                                  "${widget.list.comment.length}",
                                                  style: TextStyle(
                                                      color: hp.theme.hintColor,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: SizeConfig
                                                              .blockSizeHorizontal *
                                                          3.8),
                                                  textScaleFactor: 1.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.screenHeight * .015,
                                bottom: SizeConfig.screenHeight * .01),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.list.caption,
                                    //"widget.modelData jd hbhdv dbhd nf hbdfdbh ndnbd fbdhfdn nfdhdfdf dsndhfdf" ?? "",
                                    style: TextStyle(
                                        color: hp.theme.secondaryHeaderColor,
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal *
                                                3.8),
                                    textScaleFactor: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              loaderFlag
                  ? Container(
                      height: hp.height,
                      width: hp.width,
                      color: Colors.black87,
                      child: const SpinKitFoldingCube(color: Colors.white),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  String id = "";
  UserController controller;
  bool loaderFlag = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    // TODO: implement build
    return GetBuilder<OtherController>(
        //didChangeDependencies: didChange,
        builder: pageBuilder,
        init: OtherController(
            context,
            context
                .findAncestorStateOfType<GetBuilderState<OtherController>>()));
  }


  deletePostApiFUnction(String id) async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    if (mounted) {
      setState(() {
        loaderFlag = true;
      });
    }
    final body = {
      "userId": prefs.getString("spUserID") ?? "",
      "loginId": prefs.getString("spLoginID") ?? "",
      "appType": prefs.getString("spAppType") ?? "",
      "postId": id,
    };
    await controller.waitUntilDeletePost(body).then((value) {
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() {
          loaderFlag = false;
        });
        if (value) {
          Navigator.pop(context);
          if (widget.mListener != null) {
            widget.mListener.callApi();
          }
        }
      });
    });
  }

  @override
  callApiForLeaveTribe(String tribeId, String comeFrom) {
    // TODO: implement callApiForLeaveTribe
    deletePostApiFUnction(tribeId);
  }

  @override
  apiCallFunction() {
    // TODO: implement apiCallFunction
    if (widget.mListener != null) widget.mListener.callApi();
  }
}

abstract class OtherUserPostDetailsPageInterface {
  callApi();
}
