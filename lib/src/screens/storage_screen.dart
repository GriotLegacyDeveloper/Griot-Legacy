import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/utils/common_color.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../size_config.dart';
import '../controllers/user_controller.dart';
import '../models/track_order_response_model.dart';
import '../widgets/my_button.dart';

class StorageScreen extends StatefulWidget {
  final StorageScreenInterface mListener;
  const StorageScreen({
    Key key,
    this.mListener,
  }) : super(key: key);

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  bool showFull = false;
  bool loaderFlag = true;
  UserController controller;

  var getTrackOrderModel = TrackOrderResponseModel();

  getOrderTrackApi() async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);

    if (mounted) {
      setState(() {
        loaderFlag = false;
      });
    }

    await controller.waitUntilTrackOrder().then((value) {
      if (mounted) {
        setState(() {
          loaderFlag = true;

          getTrackOrderModel = controller.getTrackOrderModel;
          if(getTrackOrderModel.statuscode==400){
             ScaffoldMessenger.of(context).showSnackBar((SnackBar( content: Text('Something went wrong, Please check!', ))));
          }

          print( "fjdbgdbg   ${getTrackOrderModel.responseData.usedStoragePercentage}..${getTrackOrderModel.statuscode==400}");
          showFull = true;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrderTrackApi();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    return pageBuilder(UserController(context, state));
  }

  Widget pageBuilder(UserController controller) {
    final hp = controller.hp;
    hp.lockScreenRotation();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          showFull
              ? getTrackOrderModel.responseData.usedStoragePercentage!=null
                 ?SingleChildScrollView(
                  child: double.parse(getTrackOrderModel
                              .responseData.usedStoragePercentage) >=
                          80
                      ? Column(
                          children: [
                            Padding(
                                padding:
                                    EdgeInsets.only(top: hp.height * 0.09)),
                            CircularPercentIndicator(
                                radius: SizeConfig.screenWidth * .2,
                                arcType: ArcType.FULL,
                                lineWidth: 11.1,
                                percent: double.parse(getTrackOrderModel
                                    .responseData.usedPercentage),
                                center: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      (getTrackOrderModel.responseData
                                                  .usedStoragePercentage)
                                              .toString() +
                                          "%",
                                      style: TextStyle(
                                          fontSize:
                                              SizeConfig.safeBlockHorizontal *
                                                  3.7,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Poppins",
                                          color: Colors.white),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: SizeConfig.screenHeight * .01),
                                      child: Text(
                                        "You are almost out\nof storage.",
                                        // getTrackOrderModel.responseData.totalStorageUsed+ " of "+getTrackOrderModel.responseData.totalStorage,
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    3.0,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: "Poppins",
                                            color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: CommonColor.iconCOlor,
                                arcBackgroundColor: CommonColor.iconCOlor,
                                progressColor: CommonColor.offRedColor,
                                rotateLinearGradient: true,
                                circularStrokeCap: CircularStrokeCap.round),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.screenHeight * .06,
                                  left: SizeConfig.screenWidth * .04,
                                  right: SizeConfig.screenWidth * .04),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: CommonColor.boxColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: SizeConfig.screenHeight * .03,
                                      right: SizeConfig.screenHeight * .03,
                                      top: SizeConfig.screenHeight * .02,
                                      bottom: SizeConfig.screenHeight * .02),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/images/alert.png",
                                            scale: 2.5,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: SizeConfig.screenWidth *
                                                    .04),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Please purchase more storage to\ncontinue adding to your Legacy.",
                                                  style: TextStyle(
                                                      fontSize: SizeConfig
                                                              .safeBlockHorizontal *
                                                          4.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontFamily: "Poppins",
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.screenHeight * .25),
                              child: MyButton(
                                  label: "Buy Now",
                                  labelWeight: FontWeight.w500,
                                  textStyle: TextStyle(
                                      fontSize:
                                          SizeConfig.safeBlockHorizontal * 4.0,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: "Poppins",
                                      color: Colors.black),
                                  onPressed: () async {
                                    widget.mListener.addListScreen();
                                  },
                                  heightFactor: 40,
                                  widthFactor: 3.0,
                                  radiusFactor: 100),
                            )
                          ],
                        )
                      : Column(
                          children: [
                            const Divider(
                              color: Colors.grey,
                            ),
                            Padding(
                                padding:
                                    EdgeInsets.only(top: hp.height * 0.15)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularPercentIndicator(
                                    radius: SizeConfig.screenWidth * .2,
                                    arcType: ArcType.FULL,
                                    lineWidth: 11.1,
                                    percent: double.parse(getTrackOrderModel
                                        .responseData.usedPercentage),
                                    center: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          (getTrackOrderModel.responseData
                                                      .usedStoragePercentage)
                                                  .toString() +
                                              "%",
                                          style: TextStyle(
                                              fontSize: SizeConfig
                                                      .safeBlockHorizontal *
                                                  3.7,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Poppins",
                                              color: Colors.white),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: SizeConfig.screenHeight *
                                                  .01),
                                          child: Text(
                                            getTrackOrderModel.responseData
                                                    .totalStorageUsed +
                                                " of " +
                                                getTrackOrderModel
                                                    .responseData.totalStorage,
                                            style: TextStyle(
                                                fontSize: SizeConfig
                                                        .safeBlockHorizontal *
                                                    3.0,
                                                fontWeight: FontWeight.w300,
                                                fontFamily: "Poppins",
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    backgroundColor: CommonColor.iconCOlor,
                                    arcBackgroundColor: CommonColor.iconCOlor,
                                    progressColor: CommonColor.yellowOffColor,
                                    rotateLinearGradient: true,
                                    circularStrokeCap: CircularStrokeCap.round),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.screenHeight * .08),
                              child: Row(
                                children: [
                                  Text(
                                    "File Type",
                                    style: TextStyle(
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal *
                                                4.5,
                                        color: Colors.white),
                                    textScaleFactor: 1.1,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.screenHeight * .02),
                              child: GestureDetector(
                                onTap: () {
                                  widget.mListener.addListScreen();
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: CommonColor.boxColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: SizeConfig.screenHeight * .05,
                                        right: SizeConfig.screenHeight * .05,
                                        top: SizeConfig.screenHeight * .02,
                                        bottom: SizeConfig.screenHeight * .02),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Photos",
                                              style: TextStyle(
                                                  fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                      4.0,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: "Poppins",
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              getTrackOrderModel.responseData
                                                  .photoStorageUsed,
                                              style: TextStyle(
                                                  fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                      3.7,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: "Poppins",
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: SizeConfig.screenHeight *
                                                  .015),
                                          child: LinearPercentIndicator(
                                            lineHeight: 5,
                                            percent: double.parse(
                                                    getTrackOrderModel
                                                        .responseData
                                                        .photoPercentage) /
                                                100,
                                            backgroundColor:
                                                CommonColor.iconCOlor,
                                            progressColor: Colors.white,
                                            width: SizeConfig.screenWidth * 0.7,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.screenHeight * .02),
                              child: GestureDetector(
                                onTap: () {
                                  widget.mListener.addListScreen();
                                },
                                child: Container(
                                  decoration: const BoxDecoration(
                                      color: CommonColor.boxColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: SizeConfig.screenHeight * .05,
                                        right: SizeConfig.screenHeight * .05,
                                        top: SizeConfig.screenHeight * .02,
                                        bottom: SizeConfig.screenHeight * .02),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Video",
                                              style: TextStyle(
                                                  fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                      4.0,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: "Poppins",
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              getTrackOrderModel.responseData
                                                  .videoStorageUsed,
                                              style: TextStyle(
                                                  fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                      3.7,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: "Poppins",
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: SizeConfig.screenHeight *
                                                  .015),
                                          child: LinearPercentIndicator(
                                            lineHeight: 5,
                                            percent: double.parse(
                                                    getTrackOrderModel
                                                        .responseData
                                                        .videoPercentage) /
                                                100,
                                            backgroundColor:
                                                CommonColor.iconCOlor,
                                            progressColor: Colors.white,
                                            width: SizeConfig.screenWidth * 0.7,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  padding: EdgeInsets.symmetric(horizontal: hp.width / 32))
                  : Container( )
              :Container(),
          loaderFlag
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
}

abstract class StorageScreenInterface {
  addListScreen();
}
