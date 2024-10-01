import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/utils/common_color.dart';

import '../../size_config.dart';
import '../controllers/user_controller.dart';
import '../models/get_storage_list_response_model.dart';
import '../widgets/my_button.dart';

class StorageListScreen extends StatefulWidget {
  final StorageListScreenInterface mListerner;
  const StorageListScreen({
    Key key,
    this.mListerner,
  }) : super(key: key);
  @override
  State<StorageListScreen> createState() => _StorageListScreenState();
}

class _StorageListScreenState extends State<StorageListScreen> {
  UserController controller;
  bool flag = false;
  bool isShowData = false;

  GetStoragePackageResponseModel getStorageListLocal =
      GetStoragePackageResponseModel();

  Future getStorageListAPi() async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);

    if (mounted) {
      setState(() {
        flag = true;
      });
    }
    controller.waitForGetStorageList().then((value) {
      if (mounted) {
        setState(() {
          flag = false;
        });
      }
      getStorageListLocal = controller.getStorageList;

      //  print("dashboardModel.responseData    ${dashboardModel.responseData}");
      if (getStorageListLocal.responseData != null) {
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
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStorageListAPi();
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
    return Stack(
      children: [
        isShowData
            ? Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.screenWidth * .05,
                    right: SizeConfig.screenWidth * .05,
                    top: SizeConfig.screenHeight * .025),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Packages are a One Time Payment.",
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 4.8,
                              fontWeight: FontWeight.normal,
                              fontFamily: "Poppins",
                              color: Colors.white),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: SizeConfig.screenHeight * .02),
                        child: ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: SizeConfig.screenHeight * .02),
                              child: GestureDetector(
                                // onTap: () {
                                //   widget.mListerner
                                //       .addPaymentScreenForStorage();
                                // },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: CommonColor.blackoff,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: SizeConfig.screenHeight * .015,
                                        bottom: SizeConfig.screenHeight * .015,
                                        left: SizeConfig.screenWidth * .02,
                                        right: SizeConfig.screenWidth * .02),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height:
                                                      SizeConfig.screenHeight *
                                                          .09,
                                                  width:
                                                      SizeConfig.screenWidth *
                                                          .25,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: Colors.white,
                                                      )),
                                                  child: Image.asset(
                                                    "assets/images/gbimage.png",
                                                    scale: 2.7,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: SizeConfig
                                                              .screenWidth *
                                                          .02),
                                                  child: Text(
                                                    getStorageListLocal
                                                            .responseData
                                                            .elementAt(index)
                                                            .size +
                                                        getStorageListLocal
                                                            .responseData
                                                            .elementAt(index)
                                                            .unit,
                                                    style: TextStyle(
                                                        fontSize: SizeConfig
                                                                .safeBlockHorizontal *
                                                            4.8,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily: "Poppins",
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "\$" +
                                                  getStorageListLocal
                                                      .responseData
                                                      .elementAt(index)
                                                      .price,
                                              style: TextStyle(
                                                  fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                      4.8,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: "Poppins",
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: SizeConfig.screenHeight *
                                                  .02),
                                          child: MyButton(
                                              label: "Buy Now",
                                              labelWeight: FontWeight.w500,
                                              textStyle: TextStyle(
                                                  fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                      4.0,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: "Poppins",
                                                  color: Colors.black),
                                              onPressed: () async {
                                                widget.mListerner
                                                    .addPaymentScreenForStorage(
                                                        getStorageListLocal
                                                            .responseData
                                                            .elementAt(index)
                                                            .id,
                                                        getStorageListLocal
                                                            .responseData
                                                            .elementAt(index));
                                              },
                                              heightFactor: 60,
                                              widthFactor: 3.5,
                                              radiusFactor: 100),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: getStorageListLocal.responseData.length,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    )
                  ],
                ),
              )
            : Container(),
        flag
            ? Container(
                height: hp.height,
                width: hp.width,
                color: Colors.black87,
                child: const SpinKitFoldingCube(color: Colors.white),
              )
            : Container()
      ],
    );
  }
}

abstract class StorageListScreenInterface {
  addPaymentScreenForStorage(String id, ResponseDatum model);
}
