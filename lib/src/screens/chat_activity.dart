import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:griot_legacy_social_media_app/formated_date_time.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import '../../main.dart';
import '../controllers/user_controller.dart';
import '../helpers/helper.dart';
import '../models/one_to_one_message_list_response_model.dart';
import '../utils/constant_class.dart';
import 'chat_delete_block_dialog.dart';


class ChatActivity extends StatefulWidget {
  final ChatActivityInterface mListener;
  final String otherUserId;
  final String name;
  final String profilePic;
  final String coming;
  final String textSub;
  const ChatActivity({Key key, this.otherUserId,
    this.name, this.profilePic, this.mListener, this.coming, this.textSub}) : super(key: key);

  @override
  _ChatActivityState createState() => _ChatActivityState();
}

class _ChatActivityState extends State<ChatActivity> with ChatOptionDialogInterface{
  TextEditingController msgController = TextEditingController();
  final _scrollController = ScrollController();
  UserController controller;


 // List messagesResponseList = [];
  var oneToOneMessageModelLocal = OneToOneMessageListResponseModel();

  /* List<ChatMessage> messages = [

  ];*/
  bool flag=true;
  bool isQuoteShow=false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //print("profilePic    ${widget.profilePic}");


    oneToOneMessageListingApi(widget.otherUserId,false);
    Future.delayed(const Duration(seconds: 2)).then((value) {
      iniPref();
    });

    //functionToCallEverySec(true);
    readMessageApi(widget.otherUserId);
  }

  iniPref(){
    final prefs = sharedPreferences;

   String forward= prefs.getString(Constant.forwardMsg);
   if(forward=="forward") {
     sendMessageApi(widget.otherUserId, widget.textSub,"").then((value) {
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
                      'assets/images/dummy.png',
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
                right: SizeConfig.screenWidth *.03,bottom: SizeConfig.screenHeight*.03),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(

                  child: Column(
                    children: [
                      const Divider(
                        color: Colors.grey,
                      ),
                      if (isShowData) Expanded(

                        child:
                        oneToOneMessageModelLocal.responseData!=null ?
                        ListView.builder(
                          controller: _scrollController,
                          itemCount: oneToOneMessageModelLocal.responseData.message.length,
                          itemBuilder: (context, index){
                            return  Padding(
                              padding:  EdgeInsets.only(top: SizeConfig.screenHeight *.02),
                              child: GestureDetector(
                                onTap: (){

                                  if(id==oneToOneMessageModelLocal.responseData.message.elementAt(index).fromUserId.id) {
                                    //print("hhhhhhh");
                                     showGeneralDialog(
                                              barrierColor: Colors.black.withOpacity(0.8),
                                              transitionBuilder: (context, a1, a2, widget) {
                                                final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                                                return Transform(
                                                  transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                                                  child: Opacity(
                                                    opacity: a1.value,
                                                    child:   ChatOptionDialog(copyText: oneToOneMessageModelLocal.responseData.
                                                    message.elementAt(index).message,mListener: this,
                                                    comeFrom: "loguser",msgId: oneToOneMessageModelLocal.responseData.
                                                      message.elementAt(index).id,index: index,),
                                                  ),
                                                );
                                              },
                                              transitionDuration: const Duration(milliseconds: 200),
                                              barrierDismissible: false,
                                              barrierLabel: '',
                                              context: context,
                                              pageBuilder: (context, animation2, animation1) {});
                                  }else{
                                    showGeneralDialog(
                                        barrierColor: Colors.black.withOpacity(0.8),
                                        transitionBuilder: (context, a1, a2, widget) {
                                          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                                          return Transform(
                                            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                                            child: Opacity(
                                              opacity: a1.value,
                                              child:   ChatOptionDialog(copyText: oneToOneMessageModelLocal.responseData.
                                              message.elementAt(index).message,mListener: this,
                                                comeFrom: "otheruser",msgId: oneToOneMessageModelLocal.responseData.
                                                message.elementAt(index).id,index: index,),
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: id==oneToOneMessageModelLocal.responseData.message.elementAt(index).fromUserId.id?
                                      MainAxisAlignment.end:MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Visibility(
                                          visible: id==oneToOneMessageModelLocal.responseData.message.elementAt(index).fromUserId.id?false:true,
                                          child: Padding(
                                            padding:  EdgeInsets.only(right: SizeConfig.screenWidth *.03),
                                            child: Container(
                                              height: SizeConfig.screenHeight*.045,
                                              width: SizeConfig.screenHeight*.045,
                                              child: ClipOval(
                                                  child: FadeInImage.assetNetwork(
                                                      fit:
                                                      BoxFit.fill,
                                                      placeholder:
                                                      'assets/images/dummy.jpeg',
                                                      image: id ==
                                                          oneToOneMessageModelLocal
                                                              .responseData
                                                              .message
                                                              .elementAt(
                                                              index)
                                                              .fromUserId.id
                                                          ? "https://54.177.127.20:2109/img/profile-pic/" +
                                                          oneToOneMessageModelLocal
                                                              .responseData
                                                              .message
                                                              .elementAt(
                                                              index)
                                                              .toUserId

                                                              .profileImage
                                                          : "https://54.177.127.20:2109/img/profile-pic/" +
                                                          oneToOneMessageModelLocal
                                                              .responseData
                                                              .message
                                                              .elementAt(index)
                                                              .fromUserId
                                                              .profileImage)),
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
                                          ),
                                        ),
                                        oneToOneMessageModelLocal.responseData.
                                        message.elementAt(index).message.length>30?
                                        Expanded(

                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(

                                                decoration:  BoxDecoration(
                                                    color: id==oneToOneMessageModelLocal.responseData.message.elementAt(index).fromUserId.id?Colors.grey:Colors.white,
                                                    borderRadius: id==oneToOneMessageModelLocal.responseData.message.elementAt(index).fromUserId.id?
                                                    BorderRadius.only(topLeft: Radius.circular(10),
                                                        topRight:Radius.circular(10),
                                                        bottomLeft: Radius.circular(10)
                                                    ):BorderRadius.only(topLeft: Radius.circular(10),
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
                                                  oneToOneMessageModelLocal.responseData.
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

                                                        Text(oneToOneMessageModelLocal.responseData.
                                                        message.elementAt(index).message,
                                                          style:
                                                        TextStyle(color:
                                                        id==oneToOneMessageModelLocal.responseData.message.elementAt(index).fromUserId.id?Colors.white:Colors.black,
                                                            fontSize: SizeConfig.blockSizeHorizontal *3.5),
                                                          maxLines: null,
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
                                                    Text(FormatedDateTime.formatedTime(oneToOneMessageModelLocal.responseData.message.elementAt(index).
                                                    createdAt.toString()) +" | ",
                                                        style: TextStyle(color: Colors.grey,
                                                            fontSize: SizeConfig.blockSizeHorizontal *2.8)),

                                                    Text(FormatedDateTime.formatedDateTime(oneToOneMessageModelLocal.responseData.message.elementAt(index).createdAt.toString()),
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
                                            Row(
                                              children: [
                                                Container(

                                                  decoration:  BoxDecoration(
                                                      color: id==oneToOneMessageModelLocal.responseData.message.elementAt(index).fromUserId.id?Colors.grey:Colors.white,
                                                      borderRadius: id==oneToOneMessageModelLocal.responseData.message.elementAt(index).fromUserId.id?
                                                      BorderRadius.only(topLeft: Radius.circular(10),
                                                          topRight:Radius.circular(10),
                                                          bottomLeft: Radius.circular(10)
                                                      ):BorderRadius.only(topLeft: Radius.circular(10),
                                                          topRight:Radius.circular(10),
                                                          bottomRight: Radius.circular(10))
                                                      ),
                                                  child: Padding(
                                                    padding:  oneToOneMessageModelLocal.responseData.message.elementAt(index).quoteMsgID==""?
                                                    EdgeInsets.only(left: SizeConfig.screenWidth *.07,
                                                        right: SizeConfig.screenWidth *.07,
                                                        top: SizeConfig.screenHeight *.015,
                                                        bottom: SizeConfig.screenHeight *.015):
                                                    EdgeInsets.only(left: SizeConfig.screenWidth *.02,
                                                      right: SizeConfig.screenWidth *.07,
                                                      top: SizeConfig.screenHeight *.01,
                                                      bottom: SizeConfig.screenHeight *.015),

                                                    child: Row(
                                                      children: [

                                                        oneToOneMessageModelLocal.responseData.message.elementAt(index).quoteMsgID!=""?
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              height: SizeConfig.screenHeight*.05,
                                                              width: SizeConfig.screenWidth*.3,
                                                              decoration:  BoxDecoration(
                                                                color: Colors.white.withOpacity(0.6),


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
                                                                          Text(oneToOneMessageModelLocal.responseData.message.elementAt(index).quoteMsg,
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
                                                              child: Text(oneToOneMessageModelLocal.responseData.message.elementAt(index).message,
                                                                style:  TextStyle(color:
                                                                id==oneToOneMessageModelLocal.responseData.message.elementAt(index).fromUserId.id?Colors.white:Colors.black,
                                                                    fontSize: SizeConfig.blockSizeHorizontal *3.5),
                                                              ),
                                                            ),
                                                          ],
                                                        ):
                                                        Text(oneToOneMessageModelLocal.responseData.
                                                        message.elementAt(index).message,
                                                          style:
                                                          TextStyle(color: id==oneToOneMessageModelLocal.responseData.message.elementAt(index).fromUserId.id?Colors.white:Colors.black,
                                                              fontSize: SizeConfig.blockSizeHorizontal *3.5),
                                                          maxLines: null,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:  EdgeInsets.only(top: SizeConfig.screenHeight *.01),
                                              child: Row(
                                                mainAxisAlignment: id==oneToOneMessageModelLocal.responseData.message.elementAt(index).fromUserId.id?
                                                MainAxisAlignment.end:MainAxisAlignment.start,
                                                children: [
                                                  Text(FormatedDateTime.formatedTime(oneToOneMessageModelLocal.responseData.message.elementAt(index).
                                                  createdAt.toString()) +" | ",
                                                      style: TextStyle(color: Colors.grey,
                                                          fontSize: SizeConfig.blockSizeHorizontal *2.5)),

                                                  Text(FormatedDateTime.formatedDateTime(oneToOneMessageModelLocal.responseData.message.elementAt(index).createdAt.toString()),
                                                      style: TextStyle( color: Colors.grey,
                                                          fontSize: SizeConfig.blockSizeHorizontal *2.5)),
                                                ],
                                              ),
                                            ),

                                          ],
                                        ),
                                        Visibility(
                                          visible: id==oneToOneMessageModelLocal.responseData.message.elementAt(index).fromUserId.id?true:false,
                                          child: Padding(
                                            padding:  EdgeInsets.only(left: SizeConfig.screenWidth *.03),
                                            child: Container(
                                                height: SizeConfig.screenHeight*.045,
                                                width: SizeConfig.screenHeight*.045,
                                                child: ClipOval(
                                                    child: FadeInImage.assetNetwork(
                                                        fit:
                                                        BoxFit.fill,
                                                        placeholder:
                                                        'assets/images/dummy.jpeg',
                                                        image: id ==
                                                            oneToOneMessageModelLocal
                                                                .responseData
                                                                .message
                                                                .elementAt(
                                                                index)
                                                                .fromUserId.id
                                                            ? "https://54.177.127.20:2109/img/profile-pic/" +
                                                            oneToOneMessageModelLocal
                                                                .responseData
                                                                .message
                                                                .elementAt(
                                                                index)
                                                                .fromUserId

                                                                .profileImage
                                                            : "https://54.177.127.20:2109/img/profile-pic/" +
                                                            oneToOneMessageModelLocal
                                                                .responseData
                                                                .message
                                                                .elementAt(index)
                                                                .toUserId
                                                                .profileImage)),
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
                                          ),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            );
                          },
                        ) : Container(),
                      ) else Container(),

                    ],
                  ),
                ),
                Padding(
                  padding:  EdgeInsets.only(top: SizeConfig.screenHeight*.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,

                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),

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
                                    hintText: "Type message...",
                                    hintStyle: TextStyle(color: Colors.white),


                                  ),
                                  cursorColor: Colors.white,
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: (){
                                    FocusScope.of(context).requestFocus(FocusNode());



                                    bool status=true;


                                    if(msgController.text.isEmpty){
                                      status=false;
                                      Helper.showToast("Message can not be blank");
                                    }
                                    if(status)
                                    {
                                      if(isCome=="edit"){
                                      //  print("eddddcome");
                                        editChatApi(localMsgId, msgController.text);
                                      }else{
                                        sendMessageApi(widget.otherUserId,msgController.text,localMsgId);
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


  Future sendMessageApi(String toUserId,String text,msgId) async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    final obj = {
      "userId": prefs.getString("spUserID"),
      "loginId": prefs.getString("spLoginID"),
      "appType": prefs.getString("spAppType"),
      "toUserId": toUserId,
      "message": text,
      "quotedMsgId": msgId,
    };
    setState(() {
      flag = false;

    });
    //print(obj);
    controller.waitUntilSendMessage(obj).then((value) {
      setState(() {
        localMsgId="";
        if(isQuoteShow){
          isQuoteShow=false;

        }
        oneToOneMessageListingApi(widget.otherUserId,true);
       flag = true;

      });

    });
  }

  Future readMessageApi(String toUserId) async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    final obj = {
      "userId": prefs.getString("spUserID"),
      "loginId": prefs.getString("spLoginID"),
      "appType": prefs.getString("spAppType"),
      "toUserId": toUserId,
    };
    setState(() {
     // flag = false;

    });
    //print(obj);
    controller.waitUntilGetReadMessage(obj).then((value) {
      setState(() {
        //oneToOneMessageListingApi(widget.otherUserId);
       // flag = true;
      });

    });
  }

  String id="";


  bool isShowData=false;
  int count = 0;

  Future oneToOneMessageListingApi(String toUserId,bool show) async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    id=prefs.getString("spUserID");
    setState(() {
      flag = show;

    });
    controller.waitUntilOneToOneMessageList(toUserId).then((value) {
      if (mounted) {
        setState(() {
         flag = true;
         isShowData = true;
        });
      }
      oneToOneMessageModelLocal = controller.oneToOneMessageModel;
      if (oneToOneMessageModelLocal.responseData.message.isNotEmpty) {

        if (mounted) {
          setState(() {
            isShowData = true;
            _scrollToBottom();


          });
        }
      }

    });
  }
  Timer timerKey;

  functionToCallEverySec(bool show){
    timerKey = Timer.periodic(const Duration(seconds: 5), (timer) {
      oneToOneMessageListingApi(widget.otherUserId,show);

    });
  }


  Future removeChatApi(String msgId,int index) async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    final obj = {
      "userId": prefs.getString("spUserID"),
      "appType": prefs.getString("spAppType"),
      "msgId": msgId,
    };
    print("obj    $obj");

    setState(() {
       flag = false;

    });
    //print(obj);
    controller.waitUntilDeleteChatMessage(obj).then((value) {
      setState(() {
        flag = true;

        oneToOneMessageListingApi(widget.otherUserId,false);
        //oneToOneMessageListingApi(widget.otherUserId);
      });

    });
  }
  Future editChatApi(String msgId,String messageStr) async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    final obj = {
      "message": messageStr,
      "msgId": msgId,
    };
    setState(() {
      // flag = false;

    });
    //print(obj);
    controller.waitUntilEditMessage(obj,"single").then((value) {
      setState(() {
        localMsgId="";
        oneToOneMessageListingApi(widget.otherUserId,false);
        //oneToOneMessageListingApi(widget.otherUserId);
        // flag = true;

      });

    });
  }
  String isCome="";

  @override
  editTextFunction(String copiedText,String msgId) {
    // TODO: implement copyTextFunction

    if(mounted) {
      setState(() {
        msgController.text = copiedText;
        isCome="edit";
        localMsgId=msgId;
      });
    }





  }

  String quoteText="";
  String localMsgId="";
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
      widget.mListener.forwardMessage(text, comeFrom);
    }
    Navigator.pop(context,false);


  }

  @override
  removeChat(String msgId,int index) {
    // TODO: implement removeChat
    removeChatApi(msgId, index);
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timerKey?.cancel();
  }
}

abstract class ChatActivityInterface{
  forwardMessage(String text,String comeFrom);

}
