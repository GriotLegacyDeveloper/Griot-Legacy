import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/screens/report_user_confirmation_dailog.dart';
import '../../formated_date_time.dart';
import '../controllers/post_controller.dart';
import '../controllers/user_controller.dart';
import '../helpers/ads_helper.dart';
import '../repos/dashboardResponseModel.dart';
import '../utils/constant_class.dart';
import 'confirmation_dialog.dart';
import 'full_iamge_for_profile.dart';
import 'full_image_activity_webview.dart';
import 'full_video_screen.dart';
import 'full_view_image_activity.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

const int maxFailedLoadAttempts = 3;

class _DashBoardScreenState extends State<DashBoardScreen> with
    ConfirmationDialogInterface,
    ReportUserConfirmationDialogInterface{
  bool flag = true;
  UserController controller;
  var dashboardModel = DashboardResponseModel();
  bool isShowData = false;
  List<Map<String, dynamic>> list = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createInterstitialAd();


    getDashboardApi();
    _scrollController.addListener(_scrollListener);
  }


  final ScrollController _scrollController = ScrollController();


/*  NativeAd _interstitialAd;


  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {},
          );

          setState(() {
             _interstitialAd = ad as NativeAd;
          });
        },
        onAdFailedToLoad: (err) {
          print("err.....   $err");
        },
      ),
    );

  }*/

  _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_interstitialAd != null) {
        _showInterstitialAd();
      }
    }
  }



  InterstitialAd _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
        /*adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/1033173712'
            : 'ca-app-pub-3940256099942544/4411468910',*/
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd.show();
    _interstitialAd = null;
  }



  Future getDashboardApi() async {
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
    controller.waitForDashboard().then((value) {
      if(mounted) {
        setState(() {
          flag = false;
        });
      }
      dashboardModel = controller.dashboardModel;

    //  print("dashboardModel.responseData    ${dashboardModel.responseData}");
      if (dashboardModel.responseData!=null) {
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

      var len1 = dashboardModel.responseData.length;
      var mergedArr = dashboardModel.responseData.sublist(0);
      var rng = Random();
      for (int j = 0; j < mergedArr.length; j++) {
        list.add(mergedArr[j].toJson());
      }
      for (var i = 0; i < dashboardModel.advertisementListArray.length; i++) {
        var rand = (rng.nextDouble() * (len1 - 0)).floor() + 1;

        list.insert(rand, dashboardModel.advertisementListArray[i].toJson());
      }
    });
  }

  Future reportPostApi(String postId) async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    final body = {
      "userId": prefs.getString("spUserID"),
      "loginId": prefs.getString("spLoginID"),
      "appType": Platform.isAndroid
          ? "ANDROID"
          : (Platform.isIOS
          ? "IOS"
          : "BROWSER"),
      "postId": postId,
    };

    if (mounted) {
      setState(() {
        flag = true;
      });
    }
    controller.waitUntilReportPost(body).then((value) {
      if(mounted) {
        setState(() {
          flag = false;
        });
      }
      list.clear();
      getDashboardApi();


    });
  }

  Future reportUserApi(String postId,String reason) async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;
    final body = {
      "userId": prefs.getString("spUserID"),
      "loginId": prefs.getString("spLoginID"),
      "appType": Platform.isAndroid
          ? "ANDROID"
          : (Platform.isIOS
          ? "IOS"
          : "BROWSER"),
      "postId": postId,
      "reportReason":reason,
    };

    if (mounted) {
      setState(() {
        flag = true;
      });
    }
    controller.waitUntilReportUser(body).then((value) {
      if(mounted) {
        setState(() {
          flag = false;
        });
      }
      list.clear();
      getDashboardApi();


    });
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    return pageBuilder(UserController(context, state));
  }

  void didChange(GetBuilderState<PostController> state) {
    state.controller.hp.lockScreenRotation();
  }



  Widget dashboardBuilder(UserController con) {
    CarouselSliderController sliderController;

    final hp = con.hp;
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              height: SizeConfig.screenHeight,
              color: Colors.black.withOpacity(0.1),
              child: Column(
                children: [
                  isShowData
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: list.length,
                            controller: _scrollController,
                            itemBuilder: (BuildContext context, int index) {
                              return list[index]["isBlocked"] == "true"
                                  ? Container()
                                  : list[index]['postType'] != "advertisement"
                                      ? Container(
                                          color: Colors.transparent,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15, bottom: 5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.center,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: (){
                                                            if(list[index]['user']['profileImage']!="") {
                                                              Navigator.push(
                                                                  hp.context,
                                                                  MaterialPageRoute(
                                                                    builder: (
                                                                        context) =>
                                                                        FullImageForProfileActivity(
                                                                          image: Constant
                                                                              .userPicServerUrl +
                                                                              list[index]['user']['profileImage'],
                                                                        ),
                                                                  ));
                                                            }
                                                          },
                                                          onDoubleTap: (){},
                                                          child: Container(
                                                            padding: const EdgeInsets
                                                                .fromLTRB(8, 4, 8, 4),
                                                            child: CircleAvatar(
                                                                radius: 22,
                                                                child: Container(
                                                                    child:
                                                                        AspectRatio(
                                                                      aspectRatio:
                                                                          1 / 1,
                                                                      child: list[index]['user']!=null ?
                                                                      list[index]['user']
                                                                                  [
                                                                                  'profileImage'] ==
                                                                              null
                                                                          ? Container(
                                                                              decoration:
                                                                                  const BoxDecoration(
                                                                                image:
                                                                                    DecorationImage(image: AssetImage('assets/images/dummy.jpeg')),
                                                                              ),
                                                                            )
                                                                          : list[index]['user']['profileImage'] ==
                                                                                  ""
                                                                              ? Container(
                                                                                  decoration:
                                                                                      const BoxDecoration(
                                                                                    image: DecorationImage(image: AssetImage('assets/images/dummy.jpeg')),
                                                                                  ),
                                                                                )
                                                                              : ClipOval(
                                                                                  child: FadeInImage.assetNetwork(
                                                                                      fit: BoxFit.cover,
                                                                                      placeholder: 'assets/images/dummy.jpeg',
                                                                                      image: Constant.userPicServerUrl + list[index]['user']['profileImage']),
                                                                                ): Container(
                                                                        decoration:
                                                                        const BoxDecoration(
                                                                          image:
                                                                          DecorationImage(image: AssetImage('assets/images/dummy.jpeg')),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border: Border.all(
                                                                          color: hp
                                                                              .theme
                                                                              .selectedRowColor,
                                                                          width: 1),
                                                                      borderRadius:
                                                                          const BorderRadius
                                                                                  .all(
                                                                              Radius.circular(
                                                                                  22)),
                                                                    )),
                                                                backgroundColor: hp
                                                                    .theme.cardColor,
                                                                foregroundColor: hp
                                                                    .theme
                                                                    .secondaryHeaderColor),
                                                          ),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              list[index]['user']!=null?list[index]['user']['fullName']:"",
                                                             // list[index]['album'],
                                                              style: TextStyle(
                                                                  fontSize: SizeConfig
                                                                          .safeBlockHorizontal *
                                                                      5.0,
                                                                  color:
                                                                      Colors.white),
                                                            ),
                                                            Text(
                                                              list[index]['album'],
                                                                 // ['audience'],
                                                              style: TextStyle(
                                                                  fontSize: SizeConfig
                                                                          .safeBlockHorizontal *
                                                                      4.0,
                                                                  color:
                                                                      Colors.white),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    PopupMenuButton(
                                                      color: Colors.white,
                                                      icon: Container(
                                                          decoration: BoxDecoration(
                                                              color: hp.theme.cardColor,
                                                              shape: BoxShape.circle),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(4.0),
                                                            child: Icon(
                                                              Icons.more_vert_outlined,
                                                              color: hp.theme.secondaryHeaderColor,
                                                            ),
                                                          )),
                                                      itemBuilder: (context) {
                                                        List<dynamic> options;

                                                        options = [
                                                          {"value": 1, "name": "Report this Post"},
                                                          {"value": 2, "name": "Report User"},
                                                        ];

                                                        return options.map((dynamic choice) {
                                                          return PopupMenuItem(
                                                           // padding: EdgeInsets.only(left: SizeConfig.screenWidth*.012,right: SizeConfig.screenWidth*.001),

                                                          // height: 0,

                                                            child: Text(
                                                              "${choice["name"]}",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  SizeConfig.safeBlockHorizontal *
                                                                      3.5,
                                                                  fontFamily: "Avenir_Heavy",
                                                                  color:
                                                                  Colors.black.withOpacity(0.8),
                                                                  fontWeight: FontWeight.w400),
                                                              textScaleFactor: 1.2,
                                                              textAlign: TextAlign.center,
                                                            ),
                                                            value: choice["value"],
                                                          );
                                                        }).toList();
                                                      },
                                                      onSelected: (val) {
                                                        if(val==1){
                                                          showGeneralDialog(
                                                              barrierColor: Colors.black.withOpacity(0.8),
                                                              transitionBuilder: (context, a1, a2, widget) {
                                                                final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                                                                return Transform(
                                                                  transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                                                                  child: Opacity(
                                                                    opacity: a1.value,
                                                                    child: ConfirmationDialog(tribeId:list[index]['data'][0]['postId'] ,mListener: this,msg: "Do you really want to report this post into spam.",comeFrom: "6",),
                                                                  ),
                                                                );
                                                              },
                                                              transitionDuration: const Duration(milliseconds: 200),
                                                              barrierDismissible: false,
                                                              barrierLabel: '',
                                                              context: context,
                                                              pageBuilder: (context, animation2, animation1) {});
                                                        }
                                                        else if(val==2){
                                                          showGeneralDialog(
                                                              barrierColor: Colors.black.withOpacity(0.8),
                                                              transitionBuilder: (context, a1, a2, widget) {
                                                                final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                                                                return Transform(
                                                                  transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                                                                  child: Opacity(
                                                                    opacity: a1.value,
                                                                    child: ReportUserConfirmationDialog(tribeId:list[index]['data'][0]['postId'] ,mListener: this,msg: "Do you really want to report this user.",),
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
                                                    )
                                                  ],
                                                ),
                                              ),

                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10,
                                                        left: SizeConfig
                                                                .screenWidth *
                                                            .02,
                                                        right: SizeConfig
                                                                .screenWidth *
                                                            .02),
                                                    child: Container(
                                                      width: SizeConfig
                                                          .screenWidth,
                                                      height: SizeConfig
                                                          .screenWidth,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      child: CarouselSlider
                                                          .builder(
                                                        unlimitedMode: true,
                                                        controller:
                                                            sliderController,

                                                        slideBuilder:
                                                            (indexOne) {
                                                          return list[index]['data']
                                                                          [
                                                                          indexOne]
                                                                      [
                                                                      'type'] ==
                                                                  "IMAGE"
                                                              ? GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        hp.context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              FullImageActivity(
                                                                            image:
                                                                                list[index]['data'][indexOne]['file'],
                                                                          ),
                                                                        ));
                                                                  },
                                                                  onDoubleTap:
                                                                      () {},
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl: list[index]['data']
                                                                              [
                                                                              indexOne]
                                                                          [
                                                                          'file'],
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      placeholder:
                                                                          (BuildContext context,
                                                                              url) {
                                                                        return const Image(
                                                                          image:
                                                                              AssetImage('assets/images/noimage.png'),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                )
                                                              : GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        hp.context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              FullVideoScreen(
                                                                            videoUrl:
                                                                                list[index]['data'][indexOne]['file'],
                                                                            thumb:
                                                                                list[index]['data'][indexOne]['thumb'],
                                                                          ),
                                                                        ));
                                                                  },
                                                                  onDoubleTap:
                                                                      () {},
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    child:
                                                                        CachedNetworkImage(
                                                                      imageUrl: list[index]['data']
                                                                              [
                                                                              indexOne]
                                                                          [
                                                                          'thumb'],
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      placeholder:
                                                                          (BuildContext context,
                                                                              url) {
                                                                        return const Image(
                                                                          image:
                                                                              AssetImage('assets/images/noimage.png'),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                );
                                                        },
                                                        slideTransform:
                                                            const ParallaxTransform(),
                                                        itemCount: list[index]
                                                                ['data']
                                                            .length,
                                                        initialPage: 0,
                                                        enableAutoSlider: false,
                                                        slideIndicator: CircularSlideIndicator(
                                                          padding: EdgeInsets.only(bottom: 32),
                                                          indicatorBorderColor: Colors.blue,
                                                          currentIndicatorColor: Colors.blue
                                                          //indicatorBackgroundColor: Colors.blue
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        FormatedDateTime
                                                            .formatedDateTimeTo(list[
                                                                            index]
                                                                        ['post']
                                                                    [
                                                                    'createdAt']
                                                                .toString()),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 11)),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Container(
                                                        // margin: EdgeInsets.only(bottom: hp.width / 50),
                                                        width: 16,
                                                        height: 16,
                                                        decoration: const BoxDecoration(
                                                            image: DecorationImage(
                                                                fit:
                                                                    BoxFit.fill,
                                                                image: AssetImage(
                                                                    "assets/images/timer.png")))),
                                                    Text(
                                                        FormatedDateTime
                                                            .formatedTime(list[
                                                                            index]
                                                                        ['post']
                                                                    [
                                                                    'createdAt']
                                                                .toString()),
                                                        style: const TextStyle(
                                                            fontSize: 11,
                                                            color:
                                                                Colors.grey)),
                                                  ], //mainAxisAlignment: MainAxisAlignment.spaceBetween
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10, top: 10),
                                                child: Container(
                                                  height: 0.5,
                                                  //width: 100,
                                                  color: Colors.grey
                                                      .withOpacity(0.8),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                hp.context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FullImageActivityWebView(
                                                    imageUrl: list[index]
                                                        ['link'],
                                                        comingFrom: "1",
                                                  ),
                                                ));
                                          },
                                          onDoubleTap: () {},
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 15, bottom: 5),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            list[index]
                                                                ['title'],
                                                            style: TextStyle(
                                                                fontSize: SizeConfig
                                                                        .safeBlockHorizontal *
                                                                    5.0,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          Text(
                                                            "Sponsored",
                                                            style: TextStyle(
                                                                fontSize: SizeConfig
                                                                        .safeBlockHorizontal *
                                                                    4.0,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10,
                                                          left: SizeConfig
                                                                  .screenWidth *
                                                              .02,
                                                          right: SizeConfig
                                                                  .screenWidth *
                                                              .02),
                                                      child: Container(
                                                        width: SizeConfig
                                                            .screenWidth,
                                                        height: SizeConfig
                                                            .screenWidth,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                list[index]
                                                                    ['image'],
                                                            fit: BoxFit.cover,
                                                            placeholder:
                                                                (BuildContext
                                                                        context,
                                                                    url) {
                                                              return const Image(
                                                                image: AssetImage(
                                                                    'assets/images/noimage.png'),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10, top: 10),
                                                  child: Container(
                                                    height: 0.5,
                                                    //width: 100,
                                                    color: Colors.grey
                                                        .withOpacity(0.8),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                            },
                            /* separatorBuilder: (context, index) {
                              return Container(
                                height: SizeConfig.screenHeight*.80,
                              );
                            },*/
                          ),
                        )
                      : Container(
                    height: SizeConfig.screenHeight*.80,

                    child: Center(
                      child: Text("No data Found",style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.safeBlockHorizontal*5.5
                      ),),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget pageBuilder(UserController con) {
    final hp = con.hp;
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: hp.theme.primaryColor,
          body: Stack(
            children: [
              Container(
                  // color: Colors.blue,
                  //padding: const EdgeInsets.only(bottom: 30, top: 20),
                  child: dashboardBuilder(con)),
              flag
                  ? Container(
                      height: hp.height,
                      width: hp.width,
                      color: Colors.black87,
                      child: const SpinKitFoldingCube(color: Colors.white),
                    )
                  : Container(),
            ],
          ),
        ));
  }


  @override
  void dispose() {
    _interstitialAd?.dispose();

    super.dispose();
  }

  @override
  callApiForLeaveTribe(String tribeId, String comeFrom) {
    // TODO: implement callApiForLeaveTribe
   // throw UnimplementedError();
    print("bbbbbb $tribeId $comeFrom");
  if (comeFrom=="6"){
      reportPostApi(tribeId);
    }
  }

  @override
  callApiForReportUser(String tribeId,String reason) {
    // TODO: implement callApiForReportUser
    reportUserApi(tribeId,reason);

  }
}
