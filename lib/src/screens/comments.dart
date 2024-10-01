import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/models/comment_model.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';
import 'package:griot_legacy_social_media_app/src/utils/constant_class.dart';
import 'package:griot_legacy_social_media_app/src/controllers/post_controller.dart';

import '../models/home_data_model.dart';


class Comments extends StatefulWidget {
  final String postId;
  final List<CommentsModel> comments;
  final String userName;
  final String profileImag;
  final String comeFrom;
  final String otherUserId;
  const Comments({Key key,this.postId,this.comments,this.userName, this.profileImag, this.comeFrom, this.otherUserId}) : super(key: key);

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {

  final _commentController=TextEditingController();

  UserController controller;
  PostController postController;

  bool flag=false;

  HomeResponseModel homeModelData;


  Future getHomeList() async {

    final state =context.findAncestorStateOfType<GetBuilderState<PostController>>() ??
        GetBuilderState<PostController>();
    postController = PostController(context, state);
    final prefs = await postController.sharedPrefs;

  /*  if (mounted) {
      setState(() {
        flag = true;
      });
    }*/
    postController.waitHomePostDetails().then((value) {
    /*  if (mounted) {
        setState(() {
          flag = false;
        });
      }*/
      homeModelData = postController.homeData;
      if (homeModelData.responseData.dashboard.isNotEmpty) {
        if (mounted) {
          setState(() {
           // didGetResponse = true;


            for (int i = 0; i < homeModelData.responseData.dashboard.length; i++) {
              if (homeModelData.responseData.dashboard[i].likes!= null &&
                  homeModelData.responseData.dashboard[i].likes.isNotEmpty) {
                for (int j = 0; j < homeModelData.responseData.dashboard[i].likes.length; j++) {


                  if (prefs.getString("spUserID") == homeModelData.responseData.dashboard[i].likes[j].likedBy.sId) {
                    homeModelData.responseData.dashboard[i].isLiked = true;
                    homeModelData.responseData.dashboard[i].likedId = homeModelData.responseData.dashboard[i].likes[j].id;
                  } else {
                    homeModelData.responseData.dashboard[i].isLiked = false;
                    homeModelData.responseData.dashboard[i].likedId = "0";
                  }
                }
              }
            }


          });
        }
      }
      if (homeModelData.responseData.trending.isNotEmpty) {

      } else {

      }
    });
  }

  @override
  Widget build(BuildContext context) {

   // print("profileImagprofileImagprofileImag  ${widget.profileImag}");

    SizeConfig().init(context);

    // TODO: implement build
    return GetBuilder<UserController>(
      //didChangeDependencies: didChange,
        builder: pageBuilder,
        init: UserController(
            context,context.findAncestorStateOfType<GetBuilderState<UserController>>()));
  }


  Widget pageBuilder(UserController con) {
    final hp = con.hp;

    return  flag
        ? Container(
            height: MediaQuery.of(context).size.height,
            width: hp.width,
            decoration: BoxDecoration(
                color:const Color(0xff141414),
                borderRadius: const BorderRadius.vertical(top:Radius.circular(25)),
                border: Border.all(
                    width: 1,
                    color: Colors.black
                )
             ),
            child: const SpinKitFoldingCube(color: Colors.white),
          )
      :Container(
       padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
       child: Column(
        children: [

          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child:widget.comments.isNotEmpty && widget.comments.isNotEmpty
               ?ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
               itemCount:widget.comments.isNotEmpty && widget.comments.isNotEmpty  ? widget.comments.length : 0,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context,index){
                 /*   print("llllllll ${widget.comments[index].commentedBy.profileImage}");*/

                    return Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          CircleAvatar(
                            radius: 20.5,
                            backgroundColor:const Color(0XFFFFb0b0b0),
                            child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child:
                                widget.comments[index].commentedBy.profileImage==""?
                                  const CircleAvatar(
                                    radius: 17,
                                    backgroundColor: Colors.white,
                                    backgroundImage:AssetImage("assets/images/profile.jpg",),
                                 )
                                : widget.comeFrom=="2" ?CircleAvatar(
                                    radius: 17,
                                    backgroundColor: Colors.white,
                                    backgroundImage:NetworkImage(
                                        Constant.userPicServerUrl+widget.comments[index].commentedBy.profileImage)
                                ):CircleAvatar(
                                    radius: 17,
                                    backgroundColor: Colors.white,
                                    backgroundImage:NetworkImage(Constant.userPicServerUrl+
                                        widget.comments[index].commentedBy.profileImage)
                                )
                            ),
                          ),

                          const SizedBox(width: 15,),

                          Flexible(
                            child: Container(
                              padding:const EdgeInsets.only(top:8,bottom: 8,left: 15,right: 15),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey,width: 0.2),
                                  color: Colors.grey[200],
                                  borderRadius: const BorderRadius.all(Radius.circular(20))
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(widget.comments[index].commentedBy.fullName,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      height: (17 / 14),
                                      fontFamily: "Roboto",
                                    ),
                                  ),

                                  Text(widget.comments[index].comment,
                                    softWrap: true,style: const TextStyle(
                                    color:Color(0XFFFF808080),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    height: (17 / 14),
                                    fontFamily: "Roboto",
                                  ),
                                  )

                                ],
                              ),
                            ),
                          )

                        ],
                      ),
                    );

                  }
              )
                  :Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width/2,
                  margin: const EdgeInsets.only(top:10,bottom: 10,left: 20,right: 20),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: RichText(
                      text: const TextSpan(
                          text: 'No Comments Yet',
                          style: TextStyle(
                            color: Color(0XFFFFb0b0b0),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Roboto",
                          ),
                          children: [

                            TextSpan(
                              text: '\nBe the first to comment',
                              style:TextStyle(
                                color: Color(0XFFFFb0b0b0),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                height: (17 / 14),
                                fontFamily: "Roboto",
                              ),
                            )


                          ]
                      ),
                    ),
                  )

              ),
            ),
          ),

          const Divider(color: Colors.white,thickness: 2,),

          Container(
            margin: const EdgeInsets.only(bottom: 6,left: 10,right: 10),
            child: Row(
              children: [

                Expanded(
                  child: Container(
                    //height: MediaQuery.of(context).size.height/15,
                    padding: const EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey,width: 0.2),
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                    ),
                    child:TextFormField(
                      autocorrect: false,
                      enableSuggestions: false,
                      controller: _commentController,
                      keyboardType: TextInputType.multiline,
                      // maxLength: null,
                      maxLines: null,
                      autofocus: true,
                      decoration: const InputDecoration(
                        isDense: true, // important line
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        border: InputBorder.none,
                        hintText: 'Write a public comment',
                        hintStyle: TextStyle(
                          color: Color(0XFFFFb0b0b0),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          height: (15 / 12),
                          fontFamily: "Roboto",
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10,),

                InkWell(
                  onTap: ()async{

                    if(_commentController.text!="") {

                      FocusScope.of(context).requestFocus( FocusNode());

                      setState(() {
                        flag=true;
                      });

                      final state =context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
                          GetBuilderState<UserController>();
                      controller = UserController(context, state);

                      final prefs = await controller.sharedPrefs;

                      final body = {
                        "userId": prefs.getString("spUserID") ?? "",
                        "loginId": prefs.getString("spLoginID") ?? "",
                        "appType": prefs.getString("spAppType") ?? "",
                        "postId": widget.postId,
                        "comment":_commentController.text
                      };
                    //  print("hhhhh $body");
                      await controller.waitUntilCommentPost(body).then((value) {
                       // print("Comment data..${value["STATUSCODE"]}");
                        //getHomeList();
                        setState(() {
                          _commentController.text="";

                          if (value["success"] && value["STATUSCODE"] == 200) {
                            var data={
                              "created_At": "${value["response_data"]["created_At"]}",
                              "_id": "${value["response_data"]["_id"]}",
                              "comment": "${value["response_data"]["comment"]}",
                              "commentedBy": {
                                "fullName": "${value["response_data"]["fullName"]}",
                                "_id": "${value["response_data"]["comment"]}",
                                "profileImage":  widget.comeFrom=="2"? "${value["response_data"]["image"]}" :"${value["response_data"]["image"]}",
                                //widget.profileImag,
                                //"${value["response_data"]["profileImage"]}",
                              }
                            };
                            widget.comments.insert(0,CommentsModel.fromJson(data));
                          }//if

                          flag=false;


                        });
                      });

                    }//if
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 8,right: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white
                    ),
                    child: const Icon(Icons.send,color: Colors.black,),
                  ),
                )

              ],
            ),
          )

        ],
      ),
    );
  }
}
