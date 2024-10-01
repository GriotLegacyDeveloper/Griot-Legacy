/*
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';
import 'package:griot_legacy_social_media_app/src/models/like_model.dart';

class LikeUnlikeOperation extends StatefulWidget {
  final String postId;
  final List<LikeModel> likes;
  final String userName;
  bool isLiked;
  LikeUnlikeOperation({Key key,this.postId,this.likes,this.userName,this.isLiked}) : super(key: key);

  @override
  _LikeUnlikeOperationState createState() => _LikeUnlikeOperationState();
}

class _LikeUnlikeOperationState extends State<LikeUnlikeOperation> {

  UserController controller;

  bool flag=true;

  bool isLiked=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    operation();
    if(widget.isLiked!=null) isLiked=widget.isLiked;
  }

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

    // TODO: implement build
    return GetBuilder<UserController>(
      //didChangeDependencies: didChange,
        builder: pageBuilder,
        init: UserController(
            context,context.findAncestorStateOfType<GetBuilderState<UserController>>()));
  }


  @override
  Widget pageBuilder(UserController con) {
    final hp = con.hp;

    return flag
        ? Container(
            height: MediaQuery.of(context).size.height,
            width: hp.width,
            decoration: BoxDecoration(
                color:Color(0xff141414),
                borderRadius: BorderRadius.vertical(top:Radius.circular(25)),
                border: Border.all(
                    width: 1,
                    color: Colors.black
                )
            ),
            child: const SpinKitFoldingCube(color: Colors.white),
          )
        :Container(

    );
}

Future operation() async {

  final state =context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
      GetBuilderState<UserController>();
  controller = UserController(context, state);

  final prefs = await controller.sharedPrefs;

  final body = {
    "userId": prefs.getString("spUserID") ?? "",
    "loginId": prefs.getString("spLoginID") ?? "",
    "appType": prefs.getString("spAppType") ?? "",
    "postId": widget.postId,
  };

  if(widget.isLiked!=null && widget.isLiked) {
    await controller.waitUntilUnlikePost(body).then((value) {
      print("Unlike data..$value");

      setState( () {

        widget.isLiked =false;
        Navigator.of(context).pop();
        */
/* for (int j = 0;j < widget.likes.length;j++) {
                             if (widget.likedId ==
                                 postList[index].likes[j].id)
                               postList[index].likes.removeAt(j);
                            }*//*

      });
    });
  }
  else {
    await controller.waitUntilLikePost(body).then((value) {
      print("like data..$value");

      setState( () {

        widget.isLiked =true;
        Navigator.of(context).pop();

        // var data = {  };
        //widget.likes.insert( 0, LikeModel.fromJson(data));

      });
    });

  }
 }

}
*/
