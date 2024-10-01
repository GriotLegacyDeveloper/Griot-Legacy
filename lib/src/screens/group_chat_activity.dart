import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:griot_legacy_social_media_app/formated_date_time.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/helpers/helper.dart';
import '../../main.dart';
import '../controllers/user_controller.dart';
import '../models/get_all_group_message_response_model.dart';
import '../utils/constant_class.dart';
import 'group_chat_option_dailog.dart';


class GroupChatActivity extends StatefulWidget {
  final GroupChatActivityInterface mListener;
  final String groupID;
  final String name;
  final String profilePic;
  final String coming;
  final String textSub;
  const GroupChatActivity({Key key, this.groupID,
    this.name, this.profilePic, this.mListener, this.coming, this.textSub}) : super(key: key);

  @override
  _GroupChatActivityState createState() => _GroupChatActivityState();
}

class _GroupChatActivityState extends State<GroupChatActivity> with GroupChatOptionDialogInterface{
  TextEditingController msgController = TextEditingController();
  final _scrollController = ScrollController();
  UserController controller;


  // List messagesResponseList = [];
  var getAllMassage = GetAllGroupMessageResponseModel();

  /* List<ChatMessage> messages = [

  ];*/
  bool flag=true;
  bool isQuoteShow=false;

  String groupIDlocal="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

   // print("profilePic    ${widget.profilePic}");

    getAllMassageApi(false);


//    oneToOneMessageListingApi(widget.otherUserId);
    Future.delayed(const Duration(seconds: 2)).then((value) {

      iniPref();
    });

  }

  iniPref(){
    final prefs = sharedPreferences;

    String forward= prefs.getString(Constant.forwardMsg);
    if(forward=="forward") {
      sendGroupMessageApi(widget.textSub,"").then((value) {
        prefs.setString(Constant.forwardMsg, "");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    return pageBuilder(UserController(context, state));
  }

  _scrollToBottom(){
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  Widget getCustomAppBar(double parentHeight,double parentWidth){
    return Row(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: SizeConfig.screenHeight*.045,
              width: SizeConfig.screenHeight*.045,
              child: ClipOval(
                  child: FadeInImage.assetNetwork(
                      fit:
                      BoxFit.fill,
                      placeholder:
                      "assets/images/noimage.png",
                      image: widget.profilePic)),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white,width: 1),
              ),
            )
/*
                                          margin: EdgeInsets.only(
                                              right:
                                              hp.width / 32)*//*
            ),*/
          ],
        ),
        Padding(
          padding:  EdgeInsets.only(left: parentWidth *0.04),
          child: Text(widget.name,style:
          TextStyle(color: Colors.white,fontSize: SizeConfig.blockSizeHorizontal *4.2),
            textScaleFactor: 1.0,
          ),
        )
      ],
    );
  }


  Widget pageBuilder(UserController con){
    final hp = con.hp;

    hp.lockScreenRotation();
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            title: getCustomAppBar(SizeConfig.screenHeight,SizeConfig.screenWidth),


          ),
          body:
          Padding(
            padding:  EdgeInsets.only(left: SizeConfig.screenWidth *.03,
                right: SizeConfig.screenWidth *.03),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(

                  child: Column(
                    children: [
                      const Divider(
                        color: Colors.grey,
                      ),

                      isShowData? Expanded(

                        child:

                        getAllMassage.responseData!=null ?
                        ListView.builder(
                          controller: _scrollController,
                          itemCount: getAllMassage.responseData.message.length,
                          itemBuilder: (context, index){
                            /*  print("idddddddddd  ${oneToOneMessageModelLocal.responseData.
                            message.elementAt(index).id}");*/
                            return  Padding(
                              padding:  EdgeInsets.only(top: SizeConfig.screenHeight *.02),
                              child: GestureDetector(
                                onTap: (){
                                  setState(() {
                                     groupIDlocal=widget.groupID;
                                  });
                                  if(id==getAllMassage.responseData.message.elementAt(index).id) {
                                    showGeneralDialog(
                                        barrierColor: Colors.black.withOpacity(0.8),
                                        transitionBuilder: (context, a1, a2, widget) {
                                          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                                          return Transform(
                                            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                                            child: Opacity(
                                              opacity: a1.value,
                                              child:   GroupChatOptionDialog(copyText: getAllMassage.responseData.
                                              message.elementAt(index).message,mListener: this,
                                                comeFrom: "loguser",msgId: getAllMassage.responseData.
                                                message.elementAt(index).msgId,index: index,groupId: groupIDlocal,),
                                            ),
                                          );
                                        },
                                        transitionDuration: const Duration(milliseconds: 200),
                                        barrierDismissible: false,
                                        barrierLabel: '',
                                        context: context,
                                        pageBuilder: (context, animation2, animation1) {});
                                  }
                                  else{
                                    showGeneralDialog(
                                        barrierColor: Colors.black.withOpacity(0.8),
                                        transitionBuilder: (context, a1, a2, widget) {
                                          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                                          return Transform(
                                            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                                            child: Opacity(
                                              opacity: a1.value,
                                              child:   GroupChatOptionDialog(copyText: getAllMassage.responseData.
                                              message.elementAt(index).message,mListener: this,
                                                comeFrom: "otheruser",msgId: getAllMassage.responseData.
                                                message.elementAt(index).msgId,index: index,groupId: groupIDlocal,),
                                            ),
                                          );
                                        },
                                        transitionDuration: const Duration(milliseconds: 200),
                                        barrierDismissible: false,
                                        barrierLabel: '',
                                        context: context,
                                        pageBuilder: (context, animation2, animation1) {});
                                  }
                                },
                                onDoubleTap: (){},
                                child: Row(
                                  mainAxisAlignment: id==getAllMassage.responseData.message.elementAt(index).id?
                                  MainAxisAlignment.end:MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Visibility(
                                      visible: id==getAllMassage.responseData.message.elementAt(index).id?false:true,

                                      child: Padding(
                                        padding:  EdgeInsets.only(right: SizeConfig.screenWidth *.03),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: SizeConfig.screenHeight*.045,
                                              width: SizeConfig.screenHeight*.045,
                                              child: ClipOval(
                                                  child: FadeInImage.assetNetwork(
                                                      fit:
                                                      BoxFit.fill,
                                                      placeholder:
                                                      'assets/images/dummy.jpeg',
                                                      image:
                                                      Constant.userPicServerUrl+getAllMassage.responseData.message.elementAt(index).profileImage)),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: hp.theme
                                                        .secondaryHeaderColor,
                                                    width:
                                                    hp.width / 100),
                                              ),
/*
                                                margin: EdgeInsets.only(
                                                    right:
                                                    hp.width / 32)*/
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    getAllMassage.responseData.
                                    message.elementAt(index).message.length>30?
                                    Expanded(

                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(getAllMassage.responseData.message.elementAt(index).fullName,
                                            style:
                                            TextStyle(color: Colors.white,
                                                fontSize: SizeConfig.blockSizeHorizontal *3.5),
                                            maxLines: null,
                                          ),

                                          Container(

                                            decoration:  BoxDecoration(
                                                color: id==getAllMassage.responseData.message.elementAt(index).id?Colors.grey:Colors.white,
                                                borderRadius: id==getAllMassage.responseData.message.elementAt(index).id?
                                                const BorderRadius.only(topLeft: Radius.circular(10),
                                                    topRight:Radius.circular(10),
                                                    bottomLeft: Radius.circular(10)
                                                ):const BorderRadius.only(topLeft: Radius.circular(10),
                                                    topRight:Radius.circular(10),
                                                    bottomRight: Radius.circular(10))

                                            ),
                                            child: Padding(
                                              padding:  EdgeInsets.only(left: SizeConfig.screenWidth *.07,
                                                  right: SizeConfig.screenWidth *.07,
                                                  top: SizeConfig.screenHeight *.015,
                                                  bottom: SizeConfig.screenHeight *.015),
                                              child: Row(
                                                children: [
                                                  Expanded(

                                                    child:
                                                    getAllMassage.responseData.
                                                    message.elementAt(index).quoteMsgID!="" ?
                                                    Row(
                                                      children: [
                                                        Container(
                                                          height: SizeConfig.screenHeight*.06,
                                                          width: SizeConfig.screenWidth*.02,
                                                          decoration: const BoxDecoration(
                                                            color: Colors.green,

                                                            borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:  EdgeInsets.only(left: SizeConfig.screenWidth*.01),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Padding(
                                                                padding:  EdgeInsets.only(top: SizeConfig.screenHeight*.005,
                                                                    left: SizeConfig.screenWidth*.0),
                                                                child: Row(
                                                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Text("You",
                                                                      style: TextStyle(color: Colors.black,
                                                                          fontSize: SizeConfig.safeBlockHorizontal *4.0,
                                                                          fontWeight: FontWeight.w500),),

                                                                  ],
                                                                ),
                                                              ),
                                                              Text(quoteText,
                                                                style: TextStyle(color: Colors.black,
                                                                    fontSize: SizeConfig.safeBlockHorizontal *4.0),),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ):

                                                    Padding(
                                                      padding:  EdgeInsets.only(left: SizeConfig.screenWidth *.07,
                                                          right: SizeConfig.screenWidth *.07,
                                                          top: SizeConfig.screenHeight *.015,
                                                          bottom: SizeConfig.screenHeight *.015),

                                                      child: Text(
                                                        getAllMassage.responseData.message.elementAt(index).message,
                                                        style:
                                                        TextStyle(
                                                            color:  id==getAllMassage.responseData.message.elementAt(index).id?Colors.white:Colors.black,

                                                            fontSize: SizeConfig.blockSizeHorizontal *3.5),
                                                        maxLines: null,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:  EdgeInsets.only(top: SizeConfig.screenHeight *.01),
                                            child: Row(
                                              children: [
                                                Text(FormatedDateTime.formatedTime(getAllMassage.responseData.message.elementAt(index).
                                                createdAt.toString()) +" | ",
                                                    style: TextStyle(color: Colors.grey,
                                                        fontSize: SizeConfig.blockSizeHorizontal *2.8)),

                                                Text(FormatedDateTime.formatedDateTimeTo(getAllMassage.responseData.message.elementAt(index).createdAt.toString()),
                                                    style: TextStyle( color: Colors.grey,
                                                        fontSize: SizeConfig.blockSizeHorizontal *2.8)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ):
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:  EdgeInsets.only(bottom: SizeConfig.screenHeight*0.01,
                                              left: SizeConfig.screenWidth*.01),
                                          child: Text(getAllMassage.responseData.message.elementAt(index).fullName,
                                            style:
                                            TextStyle(color: Colors.white,
                                                fontSize: SizeConfig.blockSizeHorizontal *3.5),
                                            maxLines: null,
                                          ),
                                        ),
                                        Container(

                                          decoration:  BoxDecoration(
                                              color: id==getAllMassage.responseData.message.elementAt(index).id?Colors.grey:Colors.white,
                                              borderRadius: id==getAllMassage.responseData.message.elementAt(index).id?
                                              const BorderRadius.only(topLeft: Radius.circular(10),
                                                  topRight:Radius.circular(10),
                                                  bottomLeft: Radius.circular(10)
                                              ):const BorderRadius.only(topLeft: Radius.circular(10),
                                                  topRight:Radius.circular(10),
                                                  bottomRight: Radius.circular(10))

                                          ),
                                          child: Padding(
                                            padding:  getAllMassage.responseData.message.elementAt(index).quoteMsgID==""?
                                            EdgeInsets.only(left: SizeConfig.screenWidth *.07,
                                                right: SizeConfig.screenWidth *.07,
                                                top: SizeConfig.screenHeight *.015,
                                                bottom: SizeConfig.screenHeight *.015):EdgeInsets.only(left: SizeConfig.screenWidth *.02,
                                                right: SizeConfig.screenWidth *.07,
                                                top: SizeConfig.screenHeight *.01,
                                                bottom: SizeConfig.screenHeight *.015),

                                            child: Row(
                                              children: [

                                                getAllMassage.responseData.message.elementAt(index).quoteMsgID!=""?
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: SizeConfig.screenHeight*.05,
                                                      width: SizeConfig.screenWidth*.3,
                                                      decoration:  BoxDecoration(
                                                        color: Colors.white.withOpacity(0.6),


                                                        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                                                      ),
                                                      //width: SizeConfig.screenWidth*.6,
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            height: SizeConfig.screenHeight*.06,
                                                            width: SizeConfig.screenWidth*.02,
                                                            decoration: const BoxDecoration(
                                                              color: Colors.green,

                                                              borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:  EdgeInsets.only(left: SizeConfig.screenWidth*.01),
                                                            child: Padding(
                                                              padding:  EdgeInsets.only(top: SizeConfig.screenHeight*.005,
                                                                  left: SizeConfig.screenWidth*.0),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Row(
                                                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text("you",
                                                                        style:  TextStyle(color: Colors.transparent,
                                                                            fontSize: SizeConfig.blockSizeHorizontal *3.5),
                                                                      ),

                                                                    ],
                                                                  ),
                                                                  Text(getAllMassage.responseData.message.elementAt(index).quoteMsg,
                                                                    style:  TextStyle(color: Colors.black,
                                                                        fontSize: SizeConfig.blockSizeHorizontal *3.5),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:  EdgeInsets.only(top: SizeConfig.screenHeight*.01,left: SizeConfig.screenWidth*.01),
                                                      child: Text(getAllMassage.responseData.message.elementAt(index).message,
                                                        style:  TextStyle(
                                                            color: Colors.white,
                                                            fontSize: SizeConfig.blockSizeHorizontal *3.5),
                                                      ),
                                                    ),
                                                  ],
                                                ):
                                                Text(getAllMassage.responseData.
                                                message.elementAt(index).message,
                                                  style:
                                                  TextStyle(
                                                    color:  id==getAllMassage.responseData.message.elementAt(index).id?Colors.white:Colors.black,

                                                      fontSize: SizeConfig.blockSizeHorizontal *3.5),
                                                  maxLines: 3,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:  EdgeInsets.only(top: SizeConfig.screenHeight *.01),
                                          child: Row(
                                            children: [
                                              Text(FormatedDateTime.formatedTime(getAllMassage.responseData.message.elementAt(index).
                                              createdAt.toString()) +" | ",
                                                  style: TextStyle(color: Colors.grey,
                                                      fontSize: SizeConfig.blockSizeHorizontal *2.8)),

                                              Text(FormatedDateTime.formatedDateTimeTo(getAllMassage.responseData.message.elementAt(index).createdAt.toString()),
                                                  style: TextStyle( color: Colors.grey,
                                                      fontSize: SizeConfig.blockSizeHorizontal *2.8)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Visibility(
                                      visible: id==getAllMassage.responseData.message.elementAt(index).id?true:false,

                                      child: Padding(
                                        padding:  EdgeInsets.only(left: SizeConfig.screenWidth *.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: SizeConfig.screenHeight*.045,
                                              width: SizeConfig.screenHeight*.045,
                                              child: ClipOval(
                                                  child: FadeInImage.assetNetwork(
                                                      fit:
                                                      BoxFit.fill,
                                                      placeholder:
                                                      'assets/images/dummy.jpeg',
                                                      image: Constant.userPicServerUrl+getAllMassage.responseData.message.elementAt(index).profileImage)),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: hp.theme
                                                        .secondaryHeaderColor,
                                                    width:
                                                    hp.width / 100),
                                              ),
/*
                                                margin: EdgeInsets.only(
                                                    right:
                                                    hp.width / 32)*/
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ): Container(),
                      ) :Container(),

                    ],
                  ),
                ),
                Container(
                  color: Colors.grey,

                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        Visibility(
                          visible: isQuoteShow,
                          child: Padding(
                            padding:  EdgeInsets.only(right: SizeConfig.screenWidth*.13),
                            child: Container(
                              height: SizeConfig.screenHeight*.06,
                              decoration: const BoxDecoration(
                                color: Colors.white,

                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              ),
                              //width: SizeConfig.screenWidth*.6,
                              child: Row(
                                children: [
                                  Container(
                                    height: SizeConfig.screenHeight*.06,
                                    width: SizeConfig.screenWidth*.02,
                                    decoration: const BoxDecoration(
                                      color: Colors.green,

                                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                    ),
                                  ),
                                  Padding(
                                    padding:  EdgeInsets.only(left: SizeConfig.screenWidth*.01),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:  EdgeInsets.only(top: SizeConfig.screenHeight*.005,
                                              left: SizeConfig.screenWidth*.0),
                                          child: Row(
                                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("You",
                                                style: TextStyle(color: Colors.black,
                                                    fontSize: SizeConfig.safeBlockHorizontal *4.0,
                                                    fontWeight: FontWeight.w500),),
                                              Padding(
                                                padding:  EdgeInsets.only(left: SizeConfig.screenWidth*.6),
                                                child: GestureDetector(
                                                  onTap: (){
                                                    setState(() {
                                                      isQuoteShow=false;
                                                    });
                                                  },
                                                  onDoubleTap: (){},
                                                  child: Container(
                                                      color: Colors.transparent,

                                                      child: Icon(Icons.cancel,size:SizeConfig.screenHeight*.025,color: Colors.grey,)),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Text(quoteText,
                                          style: TextStyle(color: Colors.black,
                                              fontSize: SizeConfig.safeBlockHorizontal *4.0),),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                autocorrect: false,
                                enableSuggestions: false,
                                controller: msgController,
                                maxLines: null,
                                decoration: const InputDecoration(

                                  border: OutlineInputBorder(
                                      borderSide:  BorderSide(color: Colors.teal)
                                  ),
                                  focusedBorder:OutlineInputBorder(
                                      borderSide:  BorderSide(color: Colors.black)
                                  ) ,
                                  labelStyle: TextStyle(color: Colors.black),
                                  hintText: "Type message...",

                                ),
                                cursorColor: Colors.black,
                              ),
                            ),
                            IconButton(
                                onPressed: (){
                                  FocusScope.of(context).requestFocus(FocusNode());


                                 // sendMessageApi(widget.otherUserId,msgController.text,localMsgId);
                                  bool status=true;


                                 if(msgController.text.isEmpty){
                                   status=false;
                                   Helper.showToast("Message can not be blank");
                                 }
                                 if(status)
                                   {
                                     if(isCome=="edit"){
                                       editGroupMessageChatApi(localMsgId,msgController.text,localGroupId);
                                     }else{
                                       sendGroupMessageApi(msgController.text,localMsgId);

                                     }
                                     setState(() {

                                       Timer.periodic(const Duration(milliseconds: 100), (timer) {
                                         if (mounted) {
                                           _scrollToBottom();
                                           timer.cancel();
                                         } else {

                                         }
                                       });
                                       msgController.text = "";
                                     });
                                   }




                                },
                                icon: const Icon(IconData(0xe571, fontFamily: 'MaterialIcons', matchTextDirection: true)
                                )
                            )
                          ],
                        ),
                      ],
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
    );
  }


  Future sendGroupMessageApi(String text,String msgId) async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    final obj = {
      "sender": prefs.getString("spUserID"),
      "group_id": widget.groupID,
      "message": text,
      "quotedMsgId":msgId

    };
    setState(() {
      flag = false;

    });
    //print(obj);
    controller.waitUntilSendMessageInGroup(obj).then((value) {

      setState(() {
        localMsgId="";

        if(isQuoteShow){
          isQuoteShow=false;
        }
        flag = true;
        getAllMassageApi(true);

      });

    });
  }



  String id="";


  bool isShowData=false;
  int count = 0;

  Future getAllMassageApi(bool loader) async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    id=prefs.getString("spUserID");
  //  print("loginUserId   $id");
    if (mounted) {
      setState(() {
        flag = loader;
      });
    }

    controller.waitUntilGetAllGroupMessageList(widget.groupID).then((value) {
      if (mounted) {
        setState(() {
          flag = true;
          isShowData = true;
        });
      }
      getAllMassage = controller.getAllGroupMessageResponse;
      if (getAllMassage.responseData.message.isNotEmpty) {
        if(count < 5){
          _scrollToBottom();
          _scrollToBottom();
          _scrollToBottom();
          _scrollToBottom();
          _scrollToBottom();
          _scrollToBottom();
        }
        count++;
        if (mounted) {
          setState(() {
            isShowData = true;



          });
        }
      }

    });
  }


  Future removeGroupMessageApi(String msgId,int index,String groupId) async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    final obj = {
      "user_id": prefs.getString("spUserID"),
      "group_id": groupId,
      "msgId": msgId,
    };
    setState(() {
      // flag = false;

    });
    //print(obj);
    controller.waitUntilDeleteMessageFromGroup(obj).then((value) {
      setState(() {
        getAllMassageApi(true);
        //oneToOneMessageListingApi(widget.otherUserId);
        // flag = true;
      });

    });
  }

  Future editGroupMessageChatApi(String msgId,String messageStr,String groupId) async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    final obj = {
      "message": messageStr,
      "msgId": msgId,
      "groupId": groupId,
    };
    setState(() {
      // flag = false;

    });
    //print(obj);
    controller.waitUntilEditMessage(obj,"group").then((value) {
      setState(() {
        localMsgId="";
        localGroupId="";
        getAllMassageApi(true);
        //oneToOneMessageListingApi(widget.otherUserId);
        // flag = true;

      });

    });
  }
  String isCome="";

  @override
  editTextFunction(String copiedText,String msgId,String groupId) {
    // TODO: implement copyTextFunction

    if(mounted) {
      setState(() {
        msgController.text = copiedText;
        isCome="edit";
        localMsgId=msgId;
        localGroupId=groupId;
      });
    }




  }

  String quoteText="";
  String localMsgId="";
  String localGroupId="";
  @override
  quotedMessage(String copiedText,String come,String msgId) {
    // TODO: implement quotedMessage
    setState(() {
      isQuoteShow=true;
      quoteText=copiedText;
      localMsgId=msgId;
      //sendMessageApi(widget.otherUserId, widget.textSub,msgId);
    });

  }

  @override
  forwardMessage(String text,String comeFrom) {
    // TODO: implement forwardMessage
    if(widget.mListener!=null){
      widget.mListener.forwardGroupMessage(text, comeFrom);
    }
    Navigator.pop(context,false);


  }

  @override
  removeChat(String msgId,int index,String groupId) {
    // TODO: implement removeChat
    removeGroupMessageApi(msgId, index,groupId);
  }
}

abstract class GroupChatActivityInterface{
  forwardGroupMessage(String text,String comeFrom);

}
