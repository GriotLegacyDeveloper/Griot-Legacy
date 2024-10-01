import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/controllers/post_controller.dart';
import 'package:griot_legacy_social_media_app/formated_date_time.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/controllers/other_controller.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';
import 'package:griot_legacy_social_media_app/src/models/home_data_model.dart';
import 'package:griot_legacy_social_media_app/src/models/like_model.dart';
import 'package:griot_legacy_social_media_app/src/screens/comments.dart';
import 'package:griot_legacy_social_media_app/src/screens/confirmation_dialog.dart';
import 'package:griot_legacy_social_media_app/src/screens/full_view_image_activity.dart';
import 'package:griot_legacy_social_media_app/src/screens/upload_post_page.dart';
import 'package:griot_legacy_social_media_app/src/utils/constant_class.dart';

import 'full_video_screen.dart';

class PostDetailsPage extends StatefulWidget {
  final PostDetailsPageInterface mListener;
  final List<DashboardData> list;
  final String modelData;
  final Dashboard postData;
  final String name;
  final String createDate;
  final String profilePic;
  final String images;
  final String type;
  final String thumb;
  final int index;
  final String postID;

  const PostDetailsPage({
    Key key,
    this.modelData,
    this.name,
    this.createDate,
    this.profilePic,
    this.images,
    this.list,
    this.type,
    this.thumb,
    this.index,
    this.postData,
    this.mListener, this.postID,
  }) : super(key: key);

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage>
    with ConfirmationDialogInterface,UploadPostPageInterface {
  void didChange(GetBuilderState<PostController> state) {
    state.controller.hp.lockScreenRotation();
  }

  bool isLiked = false;

  Widget pageBuilder(OtherController con) {
  //  print("daaaa ${widget.profilePic}");
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
                                            NetworkImage(Constant.userPicServerUrl+widget.profilePic),
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
                                            widget.name,
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
                                                  widget.createDate),
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


                              PopupMenuButton(
                                color: Colors.white,
                                icon: Container(
                                    decoration: BoxDecoration(
                                        color: hp.theme.cardColor,
                                        shape: BoxShape.circle),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Icon(
                                        Icons.more_vert_outlined,
                                        color: hp.theme.secondaryHeaderColor,
                                      ),
                                    )),
                                itemBuilder: (context) {
                                  List<dynamic> options;

                                  options = [
                                   {"value": 1, "name": "Edit"},
                                    {"value": 2, "name": "Delete"},
                                  ];

                                  return options.map((dynamic choice) {
                                    return PopupMenuItem(
                                      child: Text(
                                        "${choice["name"]}",
                                        style: TextStyle(
                                            fontSize:
                                            SizeConfig.safeBlockHorizontal *
                                                3.5,
                                            fontFamily: "Avenir_Heavy",
                                            color:
                                            Colors.black.withOpacity(0.8),
                                            fontWeight: FontWeight.w400),
                                        textScaleFactor: 1.2,
                                        textAlign: TextAlign.center,
                                      ),
                                      value: choice["value"],
                                    );
                                  }).toList();
                                },
                                onSelected: (val) {
                               //   print("val...  $val");

                                  if (val == 2) {
                                    setState(() {
                                      id = widget.postID;
                                   //   print("id.......    $id");

                                      showGeneralDialog(
                                          barrierColor:
                                          Colors.black.withOpacity(0.8),
                                          transitionBuilder:
                                              (context, a1, a2, widget) {
                                            final curvedValue = Curves
                                                .easeInOutBack
                                                .transform(a1.value) -
                                                1.0;
                                            return Transform(
                                              transform:
                                              Matrix4.translationValues(0.0,
                                                  curvedValue * 200, 0.0),
                                              child: Opacity(
                                                opacity: a1.value,
                                                child: ConfirmationDialog(
                                                  tribeId: id,
                                                  mListener: this,
                                                  msg:
                                                  "Do you really want to delete post.",
                                                  comeFrom: "3",
                                                ),
                                              ),
                                            );
                                          },
                                          transitionDuration:
                                          const Duration(milliseconds: 200),
                                          barrierDismissible: false,
                                          barrierLabel: '',
                                          context: context,
                                          pageBuilder: (context, animation2,
                                              animation1) {});
                                    });

                                  }

                                  else if (val == 1) {
                                    List<Map<String, dynamic>> imageList =
                                    [];

                                    //print("image...${imageList.length}");

                                    if (widget.list != null &&
                                        widget.list.length > 0) {
                                      for (int i = 0;
                                      i < widget.list.length;
                                      i++) {
                                       // print("iiiiiiiiii  ${widget.list[i].file}");
                                        imageList.add({
                                          "id": "${widget.list[i].sId}",
                                          "file": "${widget.list[i].file}"
                                        });
                                      }
                                    }
                                    print("hhhhhhhh   ${imageList}");
                                   // Navigator.pop(context,false);
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                        builder: (context) =>
                                            UploadPostPage(
                                              imgURL: widget.profilePic ?? "assets/images/dummy.jpeg",
                                              postType: widget
                                                  .list[widget.index].type,
                                              album: widget
                                                  .list[widget.index].album,
                                              caption: widget
                                                  .list[widget.index]
                                                  .caption,
                                              name: widget.name,
                                              file: widget
                                                  .list[widget.index].file,
                                              isEdit: true,
                                              postId: widget
                                                  .list[widget.index]
                                                  .postId,
                                              thumb: widget
                                                  .list[widget.index].thumb,
                                              imageList: imageList,
                                              tribeId: widget.postData.tribe,
                                              mListener: this,
                                            )));

                                       /* .then((value) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const MainScreen()));
                                    });*/
                                  }
                                },
                              )

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
                                      top: SizeConfig.screenHeight *
                                          .02),
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      widget.list.elementAt(index).type=="IMAGE" ?
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              hp.context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FullImageActivity(
                                                      image: /*Constant.SERVER_URL +*/
                                                          widget.list
                                                              .elementAt(index)
                                                              .file,
                                                    ),
                                              ));
                                        },
                                        onDoubleTap: () {},
                                        child: Container(
                                          width: SizeConfig.screenWidth,
                                          // alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    hp.radius / 80)),
                                          ),
                                          child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(10.0),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                               /* Constant.SERVER_URL +*/
                                                    widget.list
                                                        .elementAt(index)
                                                        .file,
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
                                      ) :
                                      /*ShowVideoApp(
                                        videoUrl:
                                        *//*Constant.SERVER_URL + *//*widget.list.elementAt(index).file,
                                        thumb:widget.list.elementAt(index).thumb,
                                        come: "2",
                                      ),*/

                                      GestureDetector(
                                        onTap: (){
                                          Navigator.push(
                                              hp.context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FullVideoScreen(videoUrl:widget.list.elementAt(index).file,
                                                      thumb:widget.list.elementAt(index).thumb,
                                                    ),
                                              ));
                                        },
                                        onDoubleTap: (){

                                        },
                                        child: SizedBox(
                                            height: SizeConfig.screenHeight * .5,
                                            width: SizeConfig.screenWidth,
                                            child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(10.0),
                                                child: CachedNetworkImage(
                                                  imageUrl:

                                                      widget.list
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
                                                )
                                            ),

                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          final state =context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
                                              GetBuilderState<UserController>();
                                          controller= UserController(context, state);

                                          final prefs = await controller.sharedPrefs;
                                          setState(() {
                                            loaderFlag=true;

                                          });

                                          final body = {
                                            "userId": prefs.getString("spUserID") ?? "",
                                            "loginId": prefs.getString("spLoginID") ?? "",
                                            "appType": prefs.getString("spAppType") ?? "",
                                            "imageId": widget.list.elementAt(widget.index).sId,
                                          };

                                          await controller.waitUntilRemoveImage(body).then((value) {

                                            setState( () {
                                              loaderFlag=false;

                                              Navigator.pop(context);
                                              if (widget.mListener != null) {
                                                widget.mListener.callApi();
                                              }
                                            });
                                          });

                                        },
                                        onDoubleTap: (){},
                                        child:  const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Icon(Icons.delete,color: Colors.white,),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              slideTransform: const ParallaxTransform(),


                              itemCount: widget.list.length,
                              initialPage: widget.index,
                              enableAutoSlider: false,
                            ),
                          ),


                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.screenHeight * .015),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      InkWell(
                                        onTap:()async{
                                         // print("call");
                                          final state =context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
                                              GetBuilderState<UserController>();
                                          controller= UserController(context, state);

                                          final prefs = await controller.sharedPrefs;

                                          final body = {
                                            "userId": prefs.getString("spUserID") ?? "",
                                            "loginId": prefs.getString("spLoginID") ?? "",
                                            "appType": prefs.getString("spAppType") ?? "",
                                            "postId": widget.list.elementAt(widget.index).postId,
                                          };

                                          if( widget.postData.isLiked!=null &&  widget.postData.isLiked) {
                                            await controller.waitUntilUnlikePost(body).then((value) {
                                          //    print("Unlike data..$value");

                                              setState( () {
                                                widget.postData.isLiked =false;
                                                for (int j = 0;j < widget.postData.likes.length;j++) {
                                                  if (widget.postData.likedId == widget.postData.likes[j].id)
                                                    widget.postData.likes.removeAt(j);
                                                }
                                              });
                                            });
                                          }
                                          else {
                                            await controller.waitUntilLikePost(body).then((value) {
                                   /*           print("like data..${value["STATUSCODE"]}");*/
                                              setState( () {

                                                if (value["success"] && value["STATUSCODE"] == 200) {

                                                  widget.postData.isLiked =true;

                                                  var data =
                                                  {
                                                    "_id":"${value["response_data"]["_id"]}",
                                                  };

                                                  widget.postData.likes.insert( 0, LikeModel.fromJson(data));
                                                  widget.postData.likedId="${value["response_data"]["_id"]}";
                                                }//if

                                              });
                                            });

                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image(image: const AssetImage("assets/images/Like.png"),
                                                height: SizeConfig.screenHeight *.025,
                                                width: SizeConfig.screenHeight *.025,
                                                color: widget.postData.isLiked!=null &&  widget.postData.isLiked ? Colors.blue: hp.theme.secondaryHeaderColor.
                                                withOpacity(0.3),
                                              ),
                                              Text(" ${widget.postData.likes.length}",
                                                style: TextStyle(color: hp.theme.secondaryHeaderColor.
                                                withOpacity(0.3),fontWeight: FontWeight.w500,
                                                    fontSize: SizeConfig.blockSizeHorizontal *3.8),
                                                textScaleFactor: 1.0,

                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      InkWell(
                                        onTap: () {
                      /*                    print("kkkkk   ${widget.list.length}  ${widget.index}");*/
                                          showModalBottomSheet(
                                              shape: RoundedRectangleBorder(
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
                                                        color:
                                                        Color(0xff141414),
                                                        borderRadius:
                                                        BorderRadius.vertical(
                                                            top: Radius
                                                                .circular(
                                                                25)),
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                            Colors.white)),
                                                    height:
                                                    MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                        1.12,
                                                    child: Comments(
                                                        postId: widget
                                                            .list.elementAt(widget.index)

                                                            .postId,
                                                        comments:
                                                        widget.postData.comments,
                                                        userName: widget.name,
                                                      profileImag: widget.profilePic,
                                                      comeFrom: "1",otherUserId: "",));
                                              }).whenComplete(() {
                                            setState(() {});
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left:
                                              SizeConfig.screenWidth * .07),
                                          child: Row(
                                            children: [
                                              Image(
                                                image: const AssetImage(
                                                    "assets/images/comment.png"),
                                                height:
                                                SizeConfig.screenHeight *
                                                    .023,
                                                width: SizeConfig.screenHeight *
                                                    .023,
                                                color: hp.theme
                                                    .secondaryHeaderColor
                                                    .withOpacity(0.3),
                                              ),
                                              Text(
                                                " ${widget.postData.comments.length}",
                                                style: TextStyle(
                                                    color: hp.theme
                                                        .secondaryHeaderColor
                                                        .withOpacity(0.3),fontWeight: FontWeight.w500,
                                                    fontSize: SizeConfig
                                                        .blockSizeHorizontal *
                                                        3.8),
                                                textScaleFactor: 1.0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  /* Image(image: const AssetImage("assets/images/Share.png"),
                                height: SizeConfig.screenHeight *.025,
                                width: SizeConfig.screenHeight *.025,
                              ),*/
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.screenHeight * .02,
                                bottom: SizeConfig.screenHeight * .03),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.modelData ?? "",
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
    if(widget.mListener!=null)
      widget.mListener.callApi();
  }
}

abstract class PostDetailsPageInterface {
  callApi();
}
