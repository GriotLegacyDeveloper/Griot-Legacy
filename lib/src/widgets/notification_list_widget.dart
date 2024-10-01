import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';
import 'package:griot_legacy_social_media_app/src/widgets/notification_item_widget.dart';

class NotificationListWidget extends StatefulWidget {
  const NotificationListWidget({Key key}) : super(key: key);

  @override
  NotificationListWidgetState createState() => NotificationListWidgetState();
}

class NotificationListWidgetState extends State<NotificationListWidget> with NotificationItemWidgetInterface{
  bool isShowNoData=false;
  bool isShowData=true;
  bool isFlag=false;
 // NotificationResponseModel notificationData;

  List notificationList = [];
  bool didGetResponse = false;

  UserController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotificationList();
    //notificationData= NotificationResponseModel(false,"","","");
  }

  Future getNotificationList() async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    final obj = {
      "userId": prefs.getString("spUserID"),
      "loginId": prefs.getString("spLoginID"),
      "appType": prefs.getString("spAppType"),
    };
    //print(obj);
    controller.waitNotificationDetails(obj).then((value) {
      setState(() {
        isFlag = true;
        notificationList=controller.notificationList;
      });
    /*  notificationData=controller.notificationData;

      if (notificationData.responseData.userNot.isNotEmpty) {
        if (mounted) {
          setState(() {

            didGetResponse =
            true;
          });
        }
      }else{
        setState(() {
          notificationData=controller.notificationData;

          didGetResponse =false;
          isShowNoData=true;
        });
      }*/
    });
  }
  void didChange(GetBuilderState<UserController> state) {
    state.controller.hp.lockScreenRotation();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    return pageBuilder(UserController(context, state));
  }


/*  @override
  Widget build(BuildContext context) {
    final hp = con.hp;
    SizeConfig().init(context);

  }*/

  Widget pageBuilder(UserController con){
    final hp = con.hp;
    return  Scaffold(
      appBar: AppBar(
          leadingWidth: 0,
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          title: Padding(
            padding:  EdgeInsets.only(left: SizeConfig.screenWidth *.02,
                right: SizeConfig.screenWidth *.02),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Text(
                  "Notifications",
                  style: TextStyle(
                      fontSize: SizeConfig.safeBlockHorizontal *4.5,
                      fontWeight: FontWeight.normal),
                  textScaleFactor: 1.1,
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      isFlag = false;
                    });
                    final prefs = await con.sharedPrefs;
                    Map<String, dynamic> body = {
                      "userId": prefs.getString("spUserID"),
                      "notificationId": "",
                      "appType": prefs.getString("spAppType"),
                      "loginId": prefs.getString("spLoginID"),
                    };
                    await con.waitUntilDeleteNotification(body).then((value) {
                      setState(() {
                        isFlag = true;

                        if (value) {
                          getNotificationList();

                        }
                      });
                    });
                   /* if(mounted){
                      setState(() {
                        isShowNoData=true;
                        isShowData=false;
                      });
                    }*/
                  },
                  onDoubleTap: (){},
                  child: Text(
                    "Clear All",
                    style: TextStyle(
                        color: hp.theme.errorColor,
                        fontSize: SizeConfig.safeBlockHorizontal *3.8,
                        fontWeight: FontWeight.normal),
                    textScaleFactor: 1.0,

                  ),
                ),
              ],
            ),
          )),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            children: [
              const Divider(
                color: Colors.grey,
              ),
              Expanded(
                child: ListView.builder(
                    itemBuilder: (BuildContext context, int index){
                      return Column(
                        children:  [
                           NotificationItemWidget(index: index,notificationList: notificationList,mListener: this,),
                        ],
                      );
                    },
                    itemCount: notificationList.length),
              ),
            ],
          ),
          Visibility(
            visible: notificationList.isNotEmpty ?false:true,
            child: Padding(
              padding:  EdgeInsets.only(top: SizeConfig.screenHeight *.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  image: const DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          "assets/images/back-img.png")),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(hp.radius / 100))),
                              height: SizeConfig.screenHeight *.13,
                              width: SizeConfig.screenHeight *.13,
                              margin: EdgeInsets.only(right: hp.width / 32)),
                          SizedBox(
                            height: SizeConfig.screenHeight *.07,
                            width: SizeConfig.screenHeight *.07,
                            //
                            child: Container(
                              decoration: BoxDecoration(
                                  image: const DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          "assets/images/notification.png")),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(hp.radius / 100))),
                              // height: 150,
                              // width: 150,
                              // margin: EdgeInsets.only(right: hp.width / 32)
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding:  EdgeInsets.only(left: SizeConfig.screenWidth *.15,
                        right: SizeConfig.screenWidth *.15,top: SizeConfig.screenHeight *.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(

                          child: Text(
                            "There is no notification on your app.",
                            style: TextStyle(
                              color: Colors.white,
                                fontSize: SizeConfig.safeBlockHorizontal *4.2,
                                fontWeight: FontWeight.normal),
                            textScaleFactor: 1.1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          isFlag
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

  @override
  callApiFunction() {
    // TODO: implement callApiFunction
    getNotificationList();
  }


}
