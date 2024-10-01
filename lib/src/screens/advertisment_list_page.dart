import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:griot_legacy_social_media_app/src/utils/common_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../formated_date_time.dart';
import '../../size_config.dart';
import '../controllers/user_controller.dart';
import '../helpers/helper.dart';
import '../models/get_advertisement_response_model.dart';
import 'confirmation_dialog.dart';
import '../models/add_advertisment_response_model.dart';


class AdvertisementList extends StatefulWidget {
  final AdvertisementListInterface mListener;
  const AdvertisementList({Key key, this.mListener}) : super(key: key);

  @override
  _AdvertisementListState createState() => _AdvertisementListState();
}

class _AdvertisementListState extends State<AdvertisementList> with ConfirmationDialogInterface {
  UserController controller;

  GetAdvertisementResponsemodel adsModel = GetAdvertisementResponsemodel();
  bool flag = false;
  bool isShowData = false;
  int localIndex;
  Future getAdsAPi() async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    //final prefs = await controller.sharedPrefs;

    if (mounted) {
      setState(() {
        flag = true;
      });
    }
    controller.waitForGetAdvertisement().then((value) {
      if (mounted) {
        setState(() {
          flag = false;
        });
      }
      adsModel = controller.adsModel;

      if (adsModel.responseData.isNotEmpty) {
        if (mounted) {
          setState(() {
            isShowData = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isShowData = false;
          });
        }
        //print("hhhhhh $isShowData");
      }
    });
  }


  deleteAdsApi(String adsId,) async {
    Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();

    final prefs = await sharedPrefs;
    if (mounted) {
      setState(() {
        flag = true;
      });
    }
    Map<String, dynamic> body = {
      "userId": prefs.getString("spUserID"),
      "loginId": prefs.getString("spLoginID"),
      "advertisementId": adsId,
    };
    controller.waitUntilAdsDeleteApi(body).then((value) {
      if (mounted) {
        setState(() {
          flag = false;
          adsModel.responseData.removeAt(localIndex);
        });
      }



    });
  }

  cancelAdsApi(String adsId,) async {
    Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();

    final prefs = await sharedPrefs;
    if (mounted) {
      setState(() {
        flag = true;
      });
    }
    Map<String, dynamic> body = {
      "userId": prefs.getString("spUserID"),
      "loginId": prefs.getString("spLoginID"),
      "advertisementId": adsId,
    };
    controller.waitUntilAdsCancelApi(body).then((value) {
      if (mounted) {
        setState(() {
          flag = false;
          adsModel.responseData.elementAt(localIndex).status="CANCELLED";
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAdsAPi();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    return pageBuilder(UserController(context, state));
  }

  Widget pageBuilder(UserController con) {
    final hp = con.hp;
    hp.lockScreenRotation();
    return Stack(
      children: [
        Column(
          children: [
            Divider(
              color: Colors.white.withOpacity(0.1),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  isShowData
                      ? Container(
                          color: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.screenHeight * .01,
                                right: SizeConfig.screenWidth * .03,
                                left: SizeConfig.screenWidth * .03,
                                bottom: SizeConfig.screenHeight * .04),
                            child: Container(
                                decoration: const BoxDecoration(
                                  color: CommonColor.boxColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                ),
                                child: ListView.builder(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: SizeConfig.screenWidth * .02,
                                          right: SizeConfig.screenWidth * .02,
                                          top: SizeConfig.screenHeight * .005,
                                          bottom:
                                              SizeConfig.screenHeight * .005),
                                      child: GestureDetector(
                                        onDoubleTap: (){},
                                        onTap: (){
                                         if(adsModel.responseData.elementAt(index).status == "UNPAID"){
                                           widget.mListener.addPaymentScreen( adsModel.responseData
                                               .elementAt(index)
                                               .sId,adsModel.responseData
                                               .elementAt(index)
                                               .title);
                                         }

                                        },
                                        child: Card(
                                          color: CommonColor.cardColor,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: SizeConfig.screenHeight *
                                                    .005,
                                                bottom: SizeConfig.screenHeight *
                                                    .005),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                adsModel.responseData
                                                            .elementAt(index)
                                                            .image ==
                                                        ""
                                                    ? Container(
                                                        height: SizeConfig
                                                                .screenHeight *
                                                            .15,
                                                        width: SizeConfig
                                                                .screenWidth *
                                                            .25,
                                                        decoration: const BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                                    image:
                                                                        AssetImage(
                                                                      "assets/images/placeholder.png",
                                                                    ),
                                                                    fit: BoxFit
                                                                        .cover)),
                                                      )
                                                    : SizedBox(
                                                        height: SizeConfig
                                                                .screenHeight *
                                                            .15,
                                                        width: SizeConfig
                                                                .screenWidth *
                                                            .25,
                                                        child: Image.network(
                                                          adsModel.responseData
                                                              .elementAt(index)
                                                              .image,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: SizeConfig
                                                                .screenWidth *
                                                            .02,
                                                        right: SizeConfig
                                                                .screenWidth *
                                                            .01),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              adsModel
                                                                  .responseData
                                                                  .elementAt(
                                                                      index)
                                                                  .title,
                                                              style: TextStyle(
                                                                  fontSize: SizeConfig
                                                                          .blockSizeHorizontal *
                                                                      3.6,
                                                                  color: Colors
                                                                      .black),
                                                              textScaleFactor:
                                                                  1.0,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  adsModel
                                                                      .responseData
                                                                      .elementAt(
                                                                          index)
                                                                      .status,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          SizeConfig.blockSizeHorizontal *
                                                                              3.0,
                                                                      color: Colors
                                                                          .black),
                                                                  textScaleFactor:
                                                                      1.0,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: SizeConfig
                                                                              .screenWidth *
                                                                          .01),
                                                                  child: adsModel.responseData.elementAt(index).status == "APPROVED"
                                                                      ? Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            border:
                                                                                Border.all(color: CommonColor.greenColor),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(2.0),
                                                                            child:
                                                                                Icon(
                                                                              Icons.check,
                                                                              size:
                                                                                  SizeConfig.screenHeight * .015,
                                                                              color:
                                                                                  CommonColor.greenColor,
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : adsModel.responseData.elementAt(index).status == "PENDING"
                                                                          ? Container(
                                                                              decoration:
                                                                                  BoxDecoration(
                                                                                shape: BoxShape.circle,
                                                                                border: Border.all(color: CommonColor.yellowColor),
                                                                              ),
                                                                              child:
                                                                                  Padding(
                                                                                padding: const EdgeInsets.all(6.0),
                                                                                child: Image.asset(
                                                                                  "assets/images/exclimetry.png",
                                                                                  scale: 1.5,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : /*adsModel.responseData.elementAt(index).status == "REJECTED"
                                                                              ? GestureDetector(
                                                                                onTap: (){
                                                                                  if(mounted) {
                                                                                    setState(() {
                                                                                    localIndex=index;
                                                                                  });
                                                                                  }
                                                                                  showGeneralDialog(
                                                                                      barrierColor: Colors.black.withOpacity(0.8),
                                                                                      transitionBuilder: (context, a1, a2, widget) {
                                                                                        final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                                                                                        return Transform(
                                                                                          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                                                                                          child: Opacity(
                                                                                            opacity: a1.value,
                                                                                            child: ConfirmationDialog(tribeId:adsModel.responseData.elementAt(index).sId ,mListener: this,
                                                                                              msg: "Do you really want to delete this ads.",comeFrom: "8",),
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                      transitionDuration: const Duration(milliseconds: 200),
                                                                                      barrierDismissible: false,
                                                                                      barrierLabel: '',
                                                                                      context: context,
                                                                                      pageBuilder: (context, animation2, animation1) {});
                                                                                 // deleteAdsApi(adsModel.responseData.elementAt(index).sId);
                                                                    },
                                                                    onDoubleTap: (){},
                                                                                child: Container(
                                                                    color: Colors.transparent,
                                                                                  child: Icon(
                                                                                    Icons.delete,
                                                                                    size: SizeConfig.screenHeight * .025,
                                                                                    color: CommonColor.notificationAlertColor,
                                                                                  ),
                                                                                ),
                                                                              )
                                                                              :*/ adsModel.responseData.elementAt(index).status == "UNPAID"
                                                                                  ? Container()
                                                                                  : Container(),
                                                                ),
                                                                PopupMenuButton(
                                                                  child: Icon(Icons.more_vert, color: Colors.black,),
                                                                  onSelected:  (value) async {
                                                                    if(mounted) {
                                                                      setState(() {
                                                                        localIndex=index;
                                                                      });
                                                                    }
                                                                    if (value == 1) {
                                                                      showGeneralDialog(
                                                                          barrierColor: Colors.black.withOpacity(0.8),
                                                                          transitionBuilder: (context, a1, a2, widget) {
                                                                            final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                                                                            return Transform(
                                                                              transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                                                                              child: Opacity(
                                                                                opacity: a1.value,
                                                                                child: ConfirmationDialog(tribeId:adsModel.responseData.elementAt(index).sId ,mListener: this,
                                                                                  msg: "Do you really want to delete this ads.",comeFrom: "8",),
                                                                              ),
                                                                            );
                                                                          },
                                                                          transitionDuration: const Duration(milliseconds: 200),
                                                                          barrierDismissible: false,
                                                                          barrierLabel: '',
                                                                          context: context,
                                                                          pageBuilder: (context, animation2, animation1) {});
                                                                    }
                                                                    else if(value==2){
                                                                      showGeneralDialog(
                                                                          barrierColor: Colors.black.withOpacity(0.8),
                                                                          transitionBuilder: (context, a1, a2, widget) {
                                                                            final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                                                                            return Transform(
                                                                              transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                                                                              child: Opacity(
                                                                                opacity: a1.value,
                                                                                child: ConfirmationDialog(tribeId:adsModel.responseData.elementAt(index).sId ,mListener: this,
                                                                                  msg: "Do you really want to cancel this ads.",comeFrom: "9",),
                                                                              ),
                                                                            );
                                                                          },
                                                                          transitionDuration: const Duration(milliseconds: 200),
                                                                          barrierDismissible: false,
                                                                          barrierLabel: '',
                                                                          context: context,
                                                                          pageBuilder: (context, animation2, animation1) {});
                                                                    }
                                                                   else if(value==3){
                                                                      widget.mListener.editAdvertismentScreen(adsModel.responseData.elementAt(index));
                                                                   }
                                                                  },
                                                                  itemBuilder: (BuildContext
                                                                  context) {
                                                                    List<dynamic> options;
                                                                    adsModel.responseData.elementAt(index).status == "APPROVED" || adsModel.responseData.elementAt(index).status == "REJECTED"
                                                                        || adsModel.responseData.elementAt(index).status == "CANCELLED"
                                                                        ? options = [ { "value": 1, "name":"Delete"},{ "value": 3, "name":"Edit"},]
                                                                        : options = [  {"value": 2, "name":"Cancel"},{ "value": 3, "name":"Edit"},];

                                                                    return options.map((dynamic choice) {
                                                                      return PopupMenuItem(
                                                                        value:choice["value"],
                                                                        child: Row(
                                                                          children: [
                                                                            Container(child: Icon(choice["value"] == 1
                                                                                ? Icons .delete_outline
                                                                                :choice["value"] == 2
                                                                                        ?Icons .close
                                                                                        :Icons .edit,
                                                                              color:choice["value"] == 3?  CommonColor.goldenColor : Colors.red,),
                                                                            ),
                                                                            SizedBox(    width: 5, ),
                                                                            Container(
                                                                                child: Text( choice["name"],
                                                                                    style: TextStyle( fontFamily: "Roboto",color: Colors.white))
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }).toList();
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              top: SizeConfig
                                                                      .screenHeight *
                                                                  .005),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  adsModel
                                                                      .responseData
                                                                      .elementAt(
                                                                          index)
                                                                      .description,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          SizeConfig.blockSizeHorizontal *
                                                                              3.5,
                                                                      color: Colors
                                                                          .black),
                                                                  textScaleFactor:
                                                                      1.0,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              top: SizeConfig
                                                                      .screenHeight *
                                                                  .01),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Image.asset(
                                                                "assets/images/world.png",
                                                                scale: 3.5,
                                                                color: CommonColor
                                                                    .iconCOlor,
                                                              ),
                                                              Expanded(

                                                                child: Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: SizeConfig
                                                                              .screenWidth *
                                                                          .01),
                                                                  child: Text(
                                                                    adsModel
                                                                        .responseData
                                                                        .elementAt(
                                                                            index)
                                                                        .link,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            SizeConfig.blockSizeHorizontal *
                                                                                3.5,
                                                                        color: Colors
                                                                            .black),
                                                                    textScaleFactor:
                                                                        1.0,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: EdgeInsets.only(
                                                              top: SizeConfig
                                                                      .screenHeight *
                                                                  .01),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Image.asset(
                                                                "assets/images/calender.png",
                                                                scale: 3.5,
                                                                color: CommonColor
                                                                    .iconCOlor,
                                                              ),
                                                              Padding(
                                                                padding: EdgeInsets.only(
                                                                    left: SizeConfig
                                                                            .screenWidth *
                                                                        .01),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      "Valid Till: ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              SizeConfig.blockSizeHorizontal *
                                                                                  3.5,
                                                                          color: Colors
                                                                              .black),
                                                                      textScaleFactor:
                                                                          1.0,
                                                                    ),
                                                                    Text(
                                                                      FormatedDateTime.formatedDateTime(adsModel
                                                                          .responseData
                                                                          .elementAt(
                                                                              index)
                                                                          .validTill
                                                                          .toString()),
                                                                      //FormatedDateTime(formatedDateTime(adsModel.responseData.elementAt(index).validTill.toString())),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              SizeConfig.blockSizeHorizontal *
                                                                                  3.5,
                                                                          color: Colors
                                                                              .black),
                                                                      textScaleFactor:
                                                                          1.0,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: adsModel.responseData.length,
                                )),
                          ),
                        )
                      : Center(
                          child: Text(
                            "No data Found",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.safeBlockHorizontal * 5.5),
                          ),
                        ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: SizeConfig.screenWidth * .05,
                        bottom: SizeConfig.screenHeight * .025),
                    child: GestureDetector(
                      onDoubleTap: () {},
                      onTap: () {
                        if (adsModel.advertisementCount == 3) {
                          Helper.showToast(
                              "You can only add 3 ads after if any one expired then you can add nect one");
                        } else {
                          widget.mListener.addAddAdvertismentScreen();
                        }
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: CommonColor.goldenColor,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(9.0),
                          child: Icon(Icons.add),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        flag
            ? Container(
                height: hp.height,
                width: hp.width,
                color: Colors.black87,
                child: const SpinKitFoldingCube(color: Colors.white),
              )
            : Container(),
      ],
    );
  }

  @override
  callApiForLeaveTribe(String tribeId, String comeFrom) {
    // TODO: implement callApiForLeaveTribe
    if(comeFrom=="8" )deleteAdsApi(tribeId);
    else if(comeFrom=="9")cancelAdsApi(tribeId);
  }

}

abstract class AdvertisementListInterface {
  addAddAdvertismentScreen();
  editAdvertismentScreen(ResponseData advertisementData);
  addPaymentScreen(String id,String name);
}
