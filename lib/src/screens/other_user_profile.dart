import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/formated_date_time.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';
import 'package:griot_legacy_social_media_app/src/helpers/helper.dart';
import 'package:griot_legacy_social_media_app/src/repos/other_user_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_activity.dart';
import 'full_iamge_for_profile.dart';
import 'other_profile_details_page.dart';

class OtherProfilePage extends StatefulWidget {
  final OtherProfilePageInterface mListener;
  final String id;
  const OtherProfilePage({
    Key key,
    this.id,
    this.mListener,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OtherProfilePageState();
  }
}

class OtherProfilePageState extends State<OtherProfilePage> {
  UserController controller;
  var otherUserModel = OtherUserProfileResponseModel();
  bool flag = true;

  List otherProfileList = [];
  CarouselSliderController sliderController;

  Widget pageBuilder(UserController con) {
    final hp = con.hp;

    hp.lockScreenRotation();
    return SafeArea(
        child: Scaffold(
      backgroundColor: hp.theme.primaryColor,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.screenWidth * .03,
                right: SizeConfig.screenWidth * .03),
            child: isShowData
                ?
            ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 11),
                        child: SizedBox(
                            child: Card(
                              elevation: 0,
                              color: const Color(0xff141414),
                                child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 9, bottom: 9),
                              child: Column(children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              Navigator.push(
                                                  hp.context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        FullImageForProfileActivity(
                                                          image: otherUserModel
                                                              .responseData
                                                              .profileImage,
                                                        ),
                                                  ));
                                            },onDoubleTap: (){},
                                            child:  Container(
                                                decoration:
                                                BoxDecoration(
                                                  shape: BoxShape
                                                      .circle,
                                                  border: Border.all(
                                                      color: hp
                                                          .theme
                                                          .secondaryHeaderColor,
                                                      width: 1.5),
                                                  image: DecorationImage(
                                                      fit: BoxFit
                                                          .contain,
                                                      image: NetworkImage(otherUserModel
                                                          .responseData
                                                          .profileImage)),
                                                ),
                                                height:
                                                hp.height /
                                                    9,
                                                width:
                                                hp.width /
                                                    5,
                                                margin: EdgeInsets.only(
                                                    right:
                                                    hp.width /
                                                        32))
                                           /* Container(
                                              height: SizeConfig.screenHeight*.1,
                                              width: SizeConfig.screenHeight*.1,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: hp
                                                        .theme.selectedRowColor,
                                                    width: 2),
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(10.0)),
                                                image: otherUserModel
                                                    .responseData
                                                    .profileImage ==
                                                    null ||otherUserModel
                                                    .responseData
                                                    .profileImage ==
                                                    ""?DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/dummy.jpeg')): DecorationImage(
                                                  fit: BoxFit.contain,
                                                  image:
                                                  NetworkImage(otherUserModel
                                                      .responseData
                                                      .profileImage),
                                                ),
                                              ),
                                            ),*/
                                            /*Container(
                                                child: ClipRRect(
                                                  child: otherUserModel
                                                              .responseData
                                                              .profileImage ==
                                                          null
                                                      ? Container(
                                                          decoration:
                                                              const BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    'assets/images/dummy.jpeg')),
                                                          ),
                                                        )
                                                      : otherUserModel
                                                                  .responseData
                                                                  .profileImage ==
                                                              ""
                                                          ? Container(
                                                              decoration:
                                                                  const BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        'assets/images/dummy.jpeg')),
                                                              ),
                                                            )
                                                          : Padding(
                                                            padding: const EdgeInsets.all(1.0),
                                                            child: FadeInImage.assetNetwork(
                                                                fit: BoxFit.contain,
                                                                placeholder:
                                                                    'assets/images/dummy.jpeg',
                                                                image: otherUserModel
                                                                    .responseData
                                                                    .profileImage),
                                                          ),
                                                ),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: hp.theme
                                                            .selectedRowColor,
                                                        width: hp.width / 100),
                                                    borderRadius: BorderRadius
                                                        .all(Radius.circular(
                                                            hp.radius / 100))),
                                                height: hp.height / 9,
                                                width: hp.width / 4,
                                                margin: EdgeInsets.only(
                                                    right: hp.width / 32)),*/
                                          ),
                                          Expanded(
                                              child: Padding(
                                                padding:  EdgeInsets.only(left: SizeConfig.screenWidth*.02),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                  Text(
                                                      otherUserModel
                                                          .responseData.fullName,
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
                                                          otherUserModel
                                                              .responseData.email,
                                                          style: TextStyle(
                                                              color:Colors.transparent),
                                                          overflow: TextOverflow
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
                                    ),
                                    PopupMenuButton(
                                      color: Colors.white,
                                      icon: CircleAvatar(
                                          child: const Icon(Icons.more_vert),
                                          backgroundColor:
                                              hp.theme.secondaryHeaderColor,
                                          foregroundColor:
                                              hp.theme.primaryColor),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: Text(
                                            "Block",
                                            style: TextStyle(
                                                fontSize: SizeConfig
                                                        .safeBlockHorizontal *
                                                    3.5,
                                                fontFamily: "Avenir_Heavy",
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                                fontWeight: FontWeight.w400),
                                            textScaleFactor: 1.2,
                                            textAlign: TextAlign.center,
                                          ),
                                          value: 0,
                                        )
                                      ],
                                      onSelected: (val) async {
                                        if (val == 0) {
                                          setState(() {
                                            flag = false;
                                          });
                                          final prefs = await con.sharedPrefs;
                                          Map<String, dynamic> body = {
                                            "userId":
                                                prefs.getString("spUserID"),
                                            "blockedUserId": widget.id,
                                            "appType":
                                                prefs.getString("spAppType"),
                                            "loginId":
                                                prefs.getString("spLoginID"),
                                          };
                                          await con
                                              .waitUntilBlockUser(body)
                                              .then((value) {
                                            setState(() {
                                              flag = true;
                                              if (value) {
                                                if (widget.mListener != null) {
                                                  widget.mListener.addScreen();
                                                }
                                              }
                                            });
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: hp.size.height * 0.01)),
                                Divider(color: Colors.white.withOpacity(0.2)),


                                Padding(
                                    padding: EdgeInsets.only(
                                        top: hp.size.height * 0.01)),
                                Text(
                                  "Gender             :  " +
                                      otherUserModel.responseData.gender,
                                  style: TextStyle(

                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 3.8,
                                      color: con.hp.theme.secondaryHeaderColor),
                                  textScaleFactor: 1.1,
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: hp.size.height * 0.01)),
                                Text(
                                  "Birth Date         :  " +
                                      FormatedDateTime.formatedDateNotYear(
                                          otherUserModel
                                              .responseData.dateOfBirth
                                              .toString()) ,
                                  style: TextStyle(

                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 3.8,
                                      color: con.hp.theme.secondaryHeaderColor),
                                  textScaleFactor: 1.1,
                                )
                              ], crossAxisAlignment: CrossAxisAlignment.start),
                            )),
                            width: hp.width),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.screenHeight * .015),
                        child: GestureDetector(
                          onTap: () async {
                            if (otherUserModel.responseData.INNERCRCL ==
                                "NO") {
                              setState(() {
                                flag = false;
                              });
                              final prefs = await con.sharedPrefs;
                              Map<String, dynamic> body = {
                                "userId": prefs.getString("spUserID"),
                                "people": widget.id,
                                "appType": prefs.getString("spAppType"),
                                "loginId": prefs.getString("spLoginID"),
                              };
                              await con
                                  .waitUntilAddInnerCircle(body)
                                  .then((value) {
                                setState(() {
                                  flag = true;
                                  if (value) {
                                    if(widget.mListener!=null) {
                                      widget.mListener.addScreen();
                                    }
                                  }
                                });
                              });
                            }

                          },
                          onDoubleTap: () {},
                          child: Container(
                            height: SizeConfig.screenHeight * 0.06,
                            decoration: const BoxDecoration(
                                color: Color(0xff141414),

                                // color: hp.theme.cardColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                )),
                            child: Padding(
                              padding:  EdgeInsets.only(left: SizeConfig.screenWidth *.03,right: SizeConfig.screenWidth *.03),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    otherUserModel.responseData.INNERCRCL=="NO"?"Add to Inner Circle":
                                    "Added in Inner Circle",
                                    style: TextStyle(

                                        fontSize: SizeConfig.blockSizeHorizontal *4.0,
                                        color: con
                                            .hp.theme.secondaryHeaderColor),
                                    textScaleFactor: 1.0,
                                  ),
                                  Icon(Icons.arrow_forward,color: Colors.white,
                                    size: SizeConfig.screenHeight *0.025,)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: SizeConfig.screenHeight * .015),
                        child: GestureDetector(
                          onTap: () async {

                            if (otherUserModel.responseData.circle ==
                                "NO") {
                              setState(() {
                                flag = false;
                              });
                              final prefs = await con.sharedPrefs;
                              Map<String, dynamic> body = {
                                "userId": prefs.getString("spUserID"),
                                "toUserId": widget.id,
                                "appType": prefs.getString("spAppType"),
                                "loginId": prefs.getString("spLoginID"),
                              };
                              await con
                                  .waitUntilSendInvitation(body)
                                  .then((value) {
                                setState(() {
                                  flag = true;
                                  if (value) {
                                    if(widget.mListener!=null) {
                                      widget.mListener.addScreen();
                                    }
                                  }
                                });
                              });
                            }
                            else{
                              Navigator.push(
                                  hp.context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChatActivity(otherUserId: otherUserModel.responseData.post.elementAt(0).userId,
                                          name: otherUserModel.responseData.fullName,profilePic:otherUserModel.responseData.profileImage,),
                                  ));
                            }
                          },
                          onDoubleTap: () {},
                          child: Container(
                            height: SizeConfig.screenHeight * 0.06,
                          //  width: SizeConfig.screenHeight * .2,
                            decoration: const BoxDecoration(
                                color: Color(0xff141414),

                                // color: hp.theme.cardColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                )),
                            child: Padding(
                              padding:  EdgeInsets.only(left: SizeConfig.screenWidth *.03,right: SizeConfig.screenWidth *.03),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  otherUserModel.responseData.circle == "NO"
                                      ? Text("Send Invitation",
                                    style: TextStyle(

                                        fontSize: SizeConfig.blockSizeHorizontal *4.0,
                                        color: con.hp.theme
                                            .secondaryHeaderColor),
                                    textScaleFactor: 1.0,
                                  )
                                      : Text(
                                    "Message",
                                    style: TextStyle(

                                        fontSize: SizeConfig.blockSizeHorizontal *4.0,
                                        color: con.hp.theme
                                            .secondaryHeaderColor),
                                    textScaleFactor: 1.0,
                                  ),
                                  Icon(Icons.arrow_forward,color: Colors.white,
                                    size: SizeConfig.screenHeight *0.025,)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      otherUserModel.responseData.post.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:otherUserModel.responseData.post.length,
                              itemBuilder: (BuildContext context, int index) {
                                OtherUserPost model = otherUserModel.responseData.post.elementAt(index);
                              //  print("index   $index");

                                return otherUserModel.responseData.post.isNotEmpty
                                    ? getItemLayout(SizeConfig.screenHeight,
                                        SizeConfig.screenWidth, hp, model,index)
                                    : Container();
                              })
                          : Container()
                    ],
                  )
                : Container(
              child: Center(
                child: Text("No Data found", style: TextStyle(
                    fontSize: SizeConfig
                        .safeBlockHorizontal *
                        5.0,
                    fontFamily: "Avenir_Heavy",
                    color: Colors.white,
                    fontWeight: FontWeight.w400),),
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


  Widget getItemLayout(
      double parentHeight, double parentWidth, Helper hp, OtherUserPost model,int index) {
      return
        model.isBlocked==true?Container(
        ):Padding(
        padding: EdgeInsets.only(
            left: SizeConfig.screenWidth * .04,
            right: SizeConfig.screenWidth * .04,
            top: SizeConfig.screenHeight * .02,
            bottom: SizeConfig.screenHeight * .02),
        child: Container(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
              model.album,
                style: const TextStyle(
                    fontSize: 20, color: Colors.white),
              ),


              Container(
                height: 235,
                color: Colors.black,
                child: ListView.builder(
                    padding: const EdgeInsets.all(0.0),

                    itemBuilder: (BuildContext context,int index){
                      return GestureDetector(
                        onDoubleTap: (){},
                        onTap: (){
                          Navigator.push(
                              hp.context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OtherUserPostDetailsPage(list:
                                    model,index: index,otherUserModel: otherUserModel,otherUserID: widget.id,
                                    ),
                              ));

                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                           child: Hero(
                            tag: "other Profile",
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                model.imageArr.elementAt(index).type == "IMAGE"
                                    ?
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container(
                                    //margin: EdgeInsets.only(bottom: hp.width / 50),
                                    //  padding: EdgeInsets.only(left: 8, top: 8, right: 8),
                                    width: 130,
                                    height: 180,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),

                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: CachedNetworkImage(
                                        imageUrl:  model.imageArr.elementAt(index).image,
                                        fit: BoxFit.cover,
                                        placeholder: (BuildContext context,url){
                                          return const Image(image: AssetImage('assets/images/noimage.png'));
                                        },
                                      ),
                                    ),
                                  ),
                                ):
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container(

                                    width: 130,
                                    height: 180,
                                    decoration: BoxDecoration(

                                      borderRadius: BorderRadius.circular(8.0),

                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: CachedNetworkImage(
                                        imageUrl:model.imageArr.elementAt(index).thumb,
                                        fit: BoxFit.cover,
                                        placeholder: (BuildContext context,url){
                                          return const Image(image:
                                          AssetImage('assets/images/videoplaceholder.png'),
                                          );
                                        },
                                      ),

                                    ),
                                  ),
                                ),


                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    children: [
                                      Text(FormatedDateTime.formatedDateTimeTo(model.postDate.toString()),
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 11)),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                          width: 16,
                                          height: 16,
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: AssetImage(
                                                      "assets/images/timer.png")))),
                                      Text(FormatedDateTime.formatedTime(model.postDate.toString()),
                                          style: const TextStyle(
                                              fontSize: 11, color: Colors.grey)),
                                    ], //mainAxisAlignment: MainAxisAlignment.spaceBetween
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: model.imageArr.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal),
              ),


              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  height: 0.5,
                  //width: 100,
                  color: Colors.grey.withOpacity(0.8),
                ),
              )
           /*   Padding(
                padding: EdgeInsets.only(top: SizeConfig.screenHeight * .015),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        InkWell(
                          onTap: () async{

                            final state =context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
                                GetBuilderState<UserController>();
                            controller = UserController(context, state);

                            final prefs = await controller.sharedPrefs;

                            final body = {
                              "userId": prefs.getString("spUserID") ?? "",
                              "loginId": prefs.getString("spLoginID") ?? "",
                              "appType": prefs.getString("spAppType") ?? "",
                              "postId": model.postId,
                            };

                            if(model.isliked!=null && model.isliked) {
                              await controller.waitUntilUnlikePost(body).then((value) {
                                print("Unlike data..$value");

                                setState( () {

                                  otherUserModel.responseData.post[index].isliked=false;

                                  for (int j = 0;j < model.like.length;j++) {
                                    if (otherUserModel.responseData.post[index].likedId == otherUserModel.responseData.post[index].like[j].id)
                                      otherUserModel.responseData.post[index].like.removeAt(j);
                                  }

                                });
                              });
                            }
                            else {
                              await controller.waitUntilLikePost(body).then((value) {
                                print("like data..$value");

                                setState( () {
                                  if (value["success"] && value["STATUSCODE"] == 200) {

                                    otherUserModel.responseData.post[index].isliked =true;

                                    var data =
                                    {
                                      "_id":"${value["response_data"]["_id"]}",
                                    };

                                    otherUserModel.responseData.post[index].like.insert( 0, LikeModel.fromJson(data));
                                    otherUserModel.responseData.post[index].likedId="${value["response_data"]["_id"]}";
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
                                Image(
                                  image: const AssetImage("assets/images/Like.png"),
                                  height: SizeConfig.screenHeight * .025,
                                  width: SizeConfig.screenHeight * .025,
                                  color:otherUserModel.responseData.post[index].isliked!=null && otherUserModel.responseData.post[index].isliked ? Colors.blue: hp.theme.hintColor,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: SizeConfig.screenWidth * .02),
                                  child: Text("${otherUserModel.responseData.post[index].like.length}",
                                    style: TextStyle(
                                        color: hp.theme.hintColor,fontWeight: FontWeight.w500,
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal * 3.8),
                                    textScaleFactor: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                       InkWell(
                         onTap: (){

                           showModalBottomSheet(
                               shape: RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top: Radius.circular(25.0)), ),
                               context:context,
                               elevation: 8,
                               isDismissible:  true,
                               isScrollControlled: true,
                               //  backgroundColor:Color(0xff141414),
                               builder: (BuildContext buildContext) {

                                 return Container(
                                     decoration: BoxDecoration(
                                         color:Color(0xff141414),
                                         borderRadius: BorderRadius.vertical(top:Radius.circular(25)),
                                         border: Border.all(
                                             width: 1,
                                             color: Colors.white
                                         )
                                     ),
                                     height: MediaQuery.of(context).size.height / 1.12,
                                     child: Comments(postId: model.postId,comments:model.comment,userName:model.name));

                               }).whenComplete(() {  setState(    () {});    });

                         },
                         child: Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.screenWidth * .07),
                            child: Container(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Image(
                                    image: const AssetImage(
                                        "assets/images/comment.png"),
                                    height: SizeConfig.screenHeight * .023,
                                    width: SizeConfig.screenHeight * .023,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: SizeConfig.screenWidth * .02),
                                    child: Text(
                                      "${model.comment.length}",
                                      style: TextStyle(
                                          color: hp.theme.hintColor,fontWeight:FontWeight.w500,
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal * 3.8),
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
                        model.caption,
                        //"widget.modelData jd hbhdv dbhd nf hbdfdbh ndnbd fbdhfdn nfdhdfdf dsndhfdf" ?? "",
                        style: TextStyle(
                            color: hp.theme.secondaryHeaderColor,
                            fontSize: SizeConfig.blockSizeHorizontal * 3.8),
                        textScaleFactor: 1.0,
                      ),
                    ),
                  ],
                ),
              )*/


            ],
          ),
        ),
      );
  }

  bool isShowData = false;
  Future getOtherUSerDetails() async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
     final prefs = await controller.sharedPrefs;

    if (mounted) {
      setState(() {
        flag = false;
      });
    }
    controller.waitForOtherUserDetails(widget.id).then((value) {
      if (mounted) {
        setState(() {
          flag = true;

        });
      }
      otherUserModel = controller.otherUser;
      if(otherUserModel.statuscode==200){
       setState(() {
         isShowData = true;
       });
        if (!otherUserModel.responseData.isBlank) {
          if (mounted) {
            setState(() {
              isShowData = true;


              for (int i = 0; i < otherUserModel.responseData.post.length; i++) {
                if (otherUserModel.responseData.post[i].like != null && otherUserModel.responseData.post[i].like.isNotEmpty) {
                  for (int j = 0; j < otherUserModel.responseData.post[i].like.length; j++) {
                    if (prefs.getString("spUserID") == otherUserModel.responseData.post[i].like[j].likedBy.sId) {
                      otherUserModel.responseData.post[i].isliked = true;
                      otherUserModel.responseData.post[i].likedId = "${otherUserModel.responseData.post[i].like[j].id}";
                    } else {
                      otherUserModel.responseData.post[i].isliked = false;
                      otherUserModel.responseData.post[i].likedId = "0";
                    }
                  }
                }//if

              }

            });
          }
        }

      }
    });
  }

  String userID = "";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    return pageBuilder(UserController(context, state));
  }

  getData() async {
    Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();
    final prefs = await sharedPrefs;
    userID = prefs.getString("spUserID");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
    getOtherUSerDetails();
  }
}

abstract class OtherProfilePageInterface {
  addScreen();
}
