import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/formated_date_time.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';
import 'package:griot_legacy_social_media_app/src/utils/common_color.dart';

class NotificationItemWidget extends StatefulWidget {
  final NotificationItemWidgetInterface mListener;
  final int index;
  final List notificationList;
  const NotificationItemWidget(
      {Key key, this.index, this.notificationList, this.mListener})
      : super(key: key);

  @override
  State<NotificationItemWidget> createState() => _NotificationItemWidgetState();
}

class _NotificationItemWidgetState extends State<NotificationItemWidget> {
  bool flag = true;

  Widget itemBuilder(UserController con) {
    final hp = con.hp;
    return Card(
      color: hp.theme.primaryColor,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
                right: SizeConfig.screenWidth * 0.0,
                left: SizeConfig.screenWidth * 0.04,
                top: SizeConfig.screenHeight * .01,
                bottom: SizeConfig.screenHeight * .01),
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Text(
                          FormatedDateTime.formatedTime(
                              widget.notificationList[widget.index]["date"]),

                          //"10:00AM",
                          style: TextStyle(
                              color: hp.theme.disabledColor,
                              fontSize: SizeConfig.blockSizeHorizontal * 3.6)),
                      VerticalDivider(
                        color: hp.theme.secondaryHeaderColor,
                        width: hp.width / 100,
                        thickness: hp.width / 500,
                      ),
                      Text(
                          //"15-hune-2022",
                          FormatedDateTime.formatedDateTimeTo(
                              widget.notificationList[widget.index]["date"]),
                          style: TextStyle(
                              color: hp.theme.disabledColor,
                              fontSize: SizeConfig.blockSizeHorizontal * 3.6)),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                            widget.notificationList[widget.index]["message"],
                            style: TextStyle(
                                color: hp.theme.secondaryHeaderColor,
                                fontSize:
                                    SizeConfig.blockSizeHorizontal * 3.8))),
                    IconButton(
                        onPressed: () async {
                          setState(() {
                            flag = false;
                          });
                          final prefs = await con.sharedPrefs;
                          Map<String, dynamic> body = {
                            "userId": prefs.getString("spUserID"),
                            "notificationId": widget.notificationList[widget.index]["_id"],
                            "appType": prefs.getString("spAppType"),
                            "loginId": prefs.getString("spLoginID"),
                          };
                          await con.waitUntilDeleteNotification(body).then((value) {
                            setState(() {
                              flag = true;
                              if (value) {
                                if (widget.mListener != null) {
                                  widget.mListener.callApiFunction();
                                }
                              }
                            });
                          });
                        },
                        icon: Icon(Icons.delete_outline,
                            color: hp.theme.secondaryHeaderColor))
                  ],
                ),
                Visibility(
                  visible: widget.notificationList[widget.index]
                              ["notificationType"] ==
                          "REQUEST_RECEIVE"
                      ? true
                      : false,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: SizeConfig.screenHeight * .01,
                        bottom: SizeConfig.screenHeight * .01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              flag = false;
                            });
                            final prefs = await con.sharedPrefs;
                            Map<String, dynamic> body = {
                              "userId": prefs.getString("spUserID"),
                              "toUserId": widget.notificationList[widget.index]
                                  ["otherData"],
                              "appType": prefs.getString("spAppType"),
                              "loginId": prefs.getString("spLoginID"),
                              "isAccept": "YES",
                            };
                            await con
                                .waitUntilAcceptRejectRequest(body)
                                .then((value) {
                              setState(() {
                                flag = true;
                                if (value) {
                                  if (widget.mListener != null) {
                                    widget.mListener.callApiFunction();
                                  }
                                }
                              });
                            });
                          },
                          onDoubleTap: () {},
                          child: Container(
                            decoration: const BoxDecoration(
                              color: CommonColor.goldenColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.screenHeight * .012,
                                  bottom: SizeConfig.screenHeight * .012,
                                  right: SizeConfig.screenWidth * .07,
                                  left: SizeConfig.screenWidth * .07),
                              child: Row(
                                children: [
                                  Text(
                                    "Accept",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal *
                                                3.0),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              flag = false;
                            });
                            final prefs = await con.sharedPrefs;
                            Map<String, dynamic> body = {
                              "userId": prefs.getString("spUserID"),
                              "toUserId": widget.notificationList[widget.index]
                                  ["otherData"],
                              "appType": prefs.getString("spAppType"),
                              "loginId": prefs.getString("spLoginID"),
                              "isAccept": "NO",
                            };
                            await con
                                .waitUntilAcceptRejectRequest(body)
                                .then((value) {
                              setState(() {
                                flag = true;
                                if (value) {
                                  if (widget.mListener != null) {
                                    widget.mListener.callApiFunction();
                                  }
                                }
                              });
                            });
                          },
                          onDoubleTap: () {},
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.screenWidth * .03),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: CommonColor.Boxcolors,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.screenHeight * .012,
                                    bottom: SizeConfig.screenHeight * .012,
                                    right: SizeConfig.screenWidth * .07,
                                    left: SizeConfig.screenWidth * .07),
                                child: Row(
                                  children: [
                                    Text(
                                      "Reject",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal *
                                                  3.0),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
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
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    return itemBuilder(UserController(context, state));
  }
}

abstract class NotificationItemWidgetInterface {
  callApiFunction();
}
