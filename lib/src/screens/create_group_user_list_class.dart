import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/helpers/helper.dart';
import 'package:griot_legacy_social_media_app/src/utils/common_color.dart';
import 'package:griot_legacy_social_media_app/src/utils/constant_class.dart';

import '../../size_config.dart';
import '../controllers/user_controller.dart';
import '../models/all_friends_list_response_model.dart';
import 'create_group_screen.dart';

class CreateGroupUserList extends StatefulWidget {
  const CreateGroupUserList({Key key}) : super(key: key);

  @override
  _CreateGroupUserListState createState() => _CreateGroupUserListState();
}

class _CreateGroupUserListState extends State<CreateGroupUserList> {
  bool flag = true;

  var allFriendListResponseModelLocal = AllFriendListResponseModel();
  bool isShowData=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allFriendsListApi();
  }

  List<SelectUser> arrayList=[];


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    return pageBuilder(UserController(context, state));
  }

  UserController controller;

  //List selectUserList = [];


  Future allFriendsListApi() async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    if (mounted) {
      setState(() {
        flag = false;
       // isShowData=true;
      });
    }

    controller.waitUntilAllFriendList().then((value) {
      if (mounted) {
        setState(() {
          flag = true;
          isShowData=true;
        });
      }
      allFriendListResponseModelLocal = controller.allFriendListResponseModel;
      if (allFriendListResponseModelLocal.responseData.data.isNotEmpty) {

      }
    });
  }




  Widget getCustomAppBar(double parentHeight, double parentWidth) {
    return Row(
      children: [
        Text(
          "New group",
          style: TextStyle(
              color: Colors.white,
              fontSize: SizeConfig.blockSizeHorizontal * 4.2),
          textScaleFactor: 1.0,
        )
      ],
    );
  }

  Widget pageBuilder(UserController con) {
    final hp = con.hp;

    hp.lockScreenRotation();
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            title: getCustomAppBar(
                SizeConfig.screenHeight, SizeConfig.screenWidth),
          ),
          body: Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.screenWidth * .03,
                right: SizeConfig.screenWidth * .03),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isShowData ?
                    Expanded(
                      child: ListView.builder(
                        // controller: _scrollController,
                        itemCount: allFriendListResponseModelLocal.responseData.data.length,
                        itemBuilder: (context, index) {

                          return Card(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: SizeConfig.screenWidth * .02,
                                    right: SizeConfig.screenWidth * .02,
                                    top: SizeConfig.screenHeight * .015,
                                    bottom: SizeConfig.screenHeight * .025),
                                child: Row(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: <Widget>[
                                            Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
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
                                                    right: hp.width / 32)),
                                            Container(
                                                child: AspectRatio(
                                                  aspectRatio: 1 / 1,
                                                  child: ClipOval(
                                                      child: FadeInImage.assetNetwork(
                                                          fit: BoxFit.fill,
                                                          placeholder:
                                                              'assets/images/noimage.png',
                                                          image:Constant.userPicServerUrl+allFriendListResponseModelLocal.responseData.data.elementAt(index).profileImage)),
                                                ),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: hp.theme
                                                          .secondaryHeaderColor,
                                                      width: hp.width / 100),
                                                ),
                                                height: hp.height / 12,
                                                width: hp.width / 6,
                                                margin: EdgeInsets.only(
                                                    right: hp.width / 32)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding: EdgeInsets.only(
                                          left: SizeConfig.screenWidth * .02),
                                      child: Column(
                                          children: [
                                            Text(
                                              allFriendListResponseModelLocal.responseData.data.elementAt(index).userName,
                                              style: TextStyle(
                                                  color:
                                                      hp.theme.secondaryHeaderColor,
                                                  fontSize: SizeConfig
                                                          .blockSizeHorizontal *
                                                      4.1),
                                              textScaleFactor: 1.1,
                                            ),
                                          ],
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start),
                                    )),
                                    GestureDetector(
                                      onTap: (){

                                          if(allFriendListResponseModelLocal.responseData.data.elementAt(index).isSelected){
                                            if(mounted) {
                                              setState(() {
                                                allFriendListResponseModelLocal.responseData.data.elementAt(index).isSelected=false;
                                              });
                                            }
                                            for(int i=0;i<arrayList.length;i++){
                                              arrayList.removeAt(i);

                                            }
                                       //     print("ifffff   ${arrayList.length}");

                                          }
                                        else{
                                            if(mounted) {
                                              setState(() {
                                                allFriendListResponseModelLocal.responseData.data.elementAt(index).isSelected=true;
                                              });
                                            }
                                            arrayList.add(SelectUser(allFriendListResponseModelLocal.responseData.data.elementAt(index).userId,allFriendListResponseModelLocal.responseData.data.elementAt(index).userName
                                            ,allFriendListResponseModelLocal.responseData.data.elementAt(index).profileImage));
                                            /*selectUserList.add(allFriendListResponseModelLocal.responseData.data.elementAt(index).userId);
                                            selectUserList.add(allFriendListResponseModelLocal.responseData.data.elementAt(index).profileImage);
                                            selectUserList.add(allFriendListResponseModelLocal.responseData.data.elementAt(index).userName);*/

                                      //      print("elssssssss   ${arrayList.length}");

                                          //print("selectUserList  ${selectUserList.length}");

                                        }

                                      },
                                      onDoubleTap: (){},
                                      child: Container(
                                        height: SizeConfig.screenHeight*.025,
                                        width: SizeConfig.screenHeight*.025,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey),
                                          shape: BoxShape.circle,
                                          color: allFriendListResponseModelLocal.responseData.data.elementAt(index).isSelected?CommonColor.goldenColor:Colors.transparent
                                        ),
                                        child: Image(image: const AssetImage("assets/images/check.png"),
                                          color: allFriendListResponseModelLocal.responseData.data.elementAt(index).isSelected ?
                                          Colors.white:Colors.transparent,

                                        ),
                                      ),
                                    )
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                ),
                              ),
                              color: hp.theme.primaryColor);
                        },
                      ),
                    ):Container()
                  ],
                ),
                GestureDetector(
                  onTap: (){
                   // print("arrayList   ${arrayList.length}");
                    if(arrayList.isNotEmpty) {
                      Navigator.push(
                        hp.context,
                        MaterialPageRoute(
                            builder: (context) => CreateGroupScreen(
                              list: arrayList,)),
                      );
                    }else{
                      Helper.showToast("At least add one friend");
                    }
                  },
                  onDoubleTap: (){},
                  child: Padding(
                    padding:  EdgeInsets.only(bottom: SizeConfig.screenHeight*.02),
                    child: Container(
                      height: SizeConfig.screenHeight*.055,
                      width: SizeConfig.screenHeight*.055,
                      decoration: BoxDecoration(
                        color: CommonColor.goldenColor,
                        shape: BoxShape.circle
                      ),
                      child: Icon(Icons.arrow_forward,color: Colors.white,),
                    ),
                  ),
                )
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
    );
  }
}

class SelectUser{
  String id;
  String name;

  SelectUser(this.id, this.name, this.profilePic);

  String profilePic;
}
