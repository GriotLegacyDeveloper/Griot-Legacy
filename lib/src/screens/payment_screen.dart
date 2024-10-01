import 'package:pay/pay.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
//import 'package:flutter_pay/flutter_pay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/models/get_storage_list_response_model.dart';
import 'package:griot_legacy_social_media_app/src/utils/common_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../size_config.dart';
import '../controllers/user_controller.dart';
import '../helpers/helper.dart';
import '../models/apple_pay_response_model.dart';
import '../models/card_list_response_model.dart';
import '../models/check_fare_response_model.dart';
import '../models/paypal_response_model.dart';
import '../widgets/my_button.dart';
import 'add_debit_credit_card_screen.dart';
import 'full_image_activity_webview.dart';

class PaymentScreen extends StatefulWidget {
  final String id;
  final String name;
  final PaymentScreenInterface mListener;
  // final bool isPackage;
  // final ResponseDatum packageModel;

  const PaymentScreen({
    Key key,
    this.id,
    this.mListener,
    this.name,
    // this.packageModel,
    // this.isPackage = false
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with AddCreditDebitCardDetailsInterface, FullImageActivityWebViewInterface {
  final cardNumber = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();
  UserController controller;
  CheckFareResponseModel checkFareModel = CheckFareResponseModel();
  CardListResponseModel cardListModelArr = CardListResponseModel();

  bool flag = false;
  bool isShowData = false;
  bool isShowListData = false;
  bool isPayNowShow = false;
  bool isApplePayShow = false;
  bool isPaypalShow = false;
  int localIndex;

  Future checkFareApiCheck() async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);

    if (mounted) {
      setState(() {
        flag = true;
      });
    }
    controller.waitForGetCheckFareApi(widget.id).then((value) {
      if (mounted) {
        setState(() {
          flag = false;
        });
      }
      checkFareModel = controller.checkFareModel;
      if (checkFareModel.responseData != null) {
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

  callCardAPi() {
    controller.waitForCardList().then((value) {
      cardListModelArr = controller.cardListModel;
      Future.delayed(const Duration(seconds: 1)).then((value) {
        if (cardListModelArr.responseData.isNotEmpty) {
          if (mounted) {
            setState(() {
              isShowListData = true;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isShowListData = false;
            });
          }
        }
      });
    });
  }

  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();

  //FlutterPay flutterPay = FlutterPay();

  String result = "Result will be shown here";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkFareApiCheck();
    callCardAPi();
  }

  enabelPayment() async {
    /*  try {
      bool result = await flutterPay.canMakePayments();
      setState(() {
        this.result = "Can make payments: $result";
      });
    } catch (e) {
      setState(() {
        result = "$e";
      });
    }

    try {
      bool result = await flutterPay.canMakePaymentsWithActiveCard(
        allowedPaymentNetworks: [
          PaymentNetwork.visa,
          PaymentNetwork.masterCard,
        ],
      );
      setState(() {
        this.result = "$result";
      });
    } catch (e) {
      setState(() {
        result = "Error: $e";
      });
    }*/
  }

  /*void makePayment(var totalAmount) async {
   // List<PaymentItem> items = [PaymentItem(name: "Advertisement", price: 1)];

    ApplePayButton(
      //paymentConfiguration: 'assets/payment_configuration.json',
      paymentItems: [
            PaymentItem(
              label: 'Advertisement',
              amount: '1',
              status: PaymentItemStatus.final_price,
            )
          ],
      style: ApplePayButtonStyle.black,
      type: ApplePayButtonType.buy,
      margin: const EdgeInsets.only(top: 15.0),
      onPaymentResult: (paymentResult){
        Fluttertoast.showToast( msg: "Apple Pay done $paymentResult");
      },
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
    );
   Fluttertoast.showToast( msg: "Apple Pay Started");
    flutterPay.setEnvironment(environment: PaymentEnvironment.Production);

    List<PaymentItem> items = [PaymentItem(name: "Advertisement", price: 1)];

    String token = await flutterPay.requestPayment(
      appleParameters: AppleParameters(merchantIdentifier: "merchant.com.griotLegacySocialMediaApp"),
      allowedPaymentNetworks: [PaymentNetwork.masterCard,PaymentNetwork.visa],
      currencyCode: "USD",
      countryCode: "US",
      paymentItems: items,
    );
    Fluttertoast.showToast( msg: "Error $token");
    if(token!=null){
      var result=json.decode(token);
      print("token    ${result["data"]}");
     // makeApplyPayPaymentAPi("${totalAmount}", result["data"]);
    }

  }*/

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final hp =
    Helper.of(context, context.findAncestorStateOfType<GetBuilderState>());
    return Stack(
      children: [
        Column(
          children: [
            Divider(
              color: Colors.white.withOpacity(0.1),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.screenWidth * .05,
                    top: SizeConfig.screenHeight * .02),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Row(
                      children: [
                        Text(
                          "How would you like to pay?",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 5.2,
                              color: CommonColor.offWhiteColor),
                          textScaleFactor: 1.0,
                        ),
                      ],
                    ),
                    isShowData
                        ? Padding(
                      padding: EdgeInsets.only(
                          top: SizeConfig.screenHeight * .012),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.screenWidth * .05,
                              right: SizeConfig.screenWidth * .05,
                              top: SizeConfig.screenHeight * .02,
                              bottom: SizeConfig.screenHeight * .02),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Price Per Day",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: SizeConfig
                                                .safeBlockHorizontal *
                                                4.0,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Nunito"),
                                        textAlign: TextAlign.center,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: SizeConfig.screenHeight *
                                                .01),
                                        child: Text(
                                          "Number Of Days",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: SizeConfig
                                                  .safeBlockHorizontal *
                                                  4.0,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Nunito"),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: SizeConfig.screenHeight *
                                                .01),
                                        child: Text(
                                          "Total Cost",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: SizeConfig
                                                  .safeBlockHorizontal *
                                                  4.0,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Nunito"),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        checkFareModel
                                            .responseData.pricePerDay,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: SizeConfig
                                                .safeBlockHorizontal *
                                                3.7,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Nunito"),
                                        textAlign: TextAlign.center,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: SizeConfig.screenHeight *
                                                .01),
                                        child: Text(
                                          checkFareModel
                                              .responseData.numberOfDays
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: SizeConfig
                                                  .safeBlockHorizontal *
                                                  3.7,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Nunito"),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: SizeConfig.screenHeight *
                                                .01),
                                        child: Row(
                                          children: [
                                            Text(
                                              '\$',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: SizeConfig
                                                      .safeBlockHorizontal *
                                                      3.7,
                                                  fontWeight:
                                                  FontWeight.w700,
                                                  fontFamily: "Nunito"),
                                              textAlign: TextAlign.center,
                                            ),
                                            Text(
                                              checkFareModel
                                                  .responseData.totalCost
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: SizeConfig
                                                      .safeBlockHorizontal *
                                                      3.7,
                                                  fontWeight:
                                                  FontWeight.w700,
                                                  fontFamily: "Nunito"),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                        : Center(
                      child: Text(
                        "No data Found",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:
                            SizeConfig.safeBlockHorizontal * 5.5),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.only(top: SizeConfig.screenHeight * .02),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: CommonColor.boxColor,
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0))),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.screenHeight * .02,
                              bottom: SizeConfig.screenHeight * .02,
                              right: SizeConfig.screenWidth * .02,
                              left: SizeConfig.screenWidth * .03),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (mounted) {
                                    setState(() {
                                      isPaypalShow = false;
                                      isApplePayShow = false;
                                      isPayNowShow = true;
                                    });
                                  }
                                },
                                onDoubleTap: () {},
                                child: Row(
                                  children: [
                                    Container(
                                      height: SizeConfig.screenHeight * .05,
                                      width: SizeConfig.screenWidth * .07,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: Visibility(
                                        visible: isPayNowShow,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Container(
                                            height:
                                            SizeConfig.screenHeight * .02,
                                            width: SizeConfig.screenWidth * .03,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: CommonColor.brownColor,
                                                border: Border.all(
                                                    color:
                                                    CommonColor.pinkColor)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: SizeConfig.screenWidth * .03),
                                      child: Text(
                                        "Pay Now",
                                        style: TextStyle(
                                            fontSize:
                                            SizeConfig.safeBlockHorizontal *
                                                4.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.screenHeight * .02),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: CommonColor.darkBrownColor
                                        .withOpacity(0.12),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: SizeConfig.screenHeight * .02,
                                        bottom: SizeConfig.screenHeight * .02,
                                        left: SizeConfig.screenWidth * .04,
                                        right: SizeConfig.screenWidth * .03),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Credit / Debit Card",
                                          style: TextStyle(
                                              fontSize: SizeConfig
                                                  .safeBlockHorizontal *
                                                  3.5,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/visa.png",
                                              scale: 2.5,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: SizeConfig.screenWidth *
                                                      .01),
                                              child: Image.asset(
                                                "assets/images/mastercard.png",
                                                scale: 2.5,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: SizeConfig.screenWidth *
                                                      .01),
                                              child: Image.asset(
                                                "assets/images/americanExpress.png",
                                                scale: 2.5,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.screenHeight * .015),
                                child: Divider(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                              isShowListData
                                  ? ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top: SizeConfig.screenHeight *
                                            .01),
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        Stack(
                                          alignment:
                                          Alignment.bottomRight,
                                          children: [
                                            Card(
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: SizeConfig
                                                        .screenWidth *
                                                        .03,
                                                    right: SizeConfig
                                                        .screenWidth *
                                                        .03,
                                                    top: SizeConfig
                                                        .screenHeight *
                                                        .01,
                                                    bottom: SizeConfig
                                                        .screenHeight *
                                                        .015),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: SizeConfig
                                                              .screenHeight *
                                                              .01),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "xxxxxxxxxx" +
                                                                cardListModelArr
                                                                    .responseData
                                                                    .elementAt(
                                                                    index)
                                                                    .last4,
                                                            style: TextStyle(
                                                                fontSize:
                                                                SizeConfig.safeBlockHorizontal *
                                                                    4.0,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: SizeConfig
                                                              .screenHeight *
                                                              .015),
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            "assets/images/visa.png",
                                                            scale: 2.5,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onDoubleTap: () {},
                                              onTap: () {
                                                setState(() {
                                                  localIndex = index;
                                                });
                                                deleteCardApiCalling(
                                                    cardListModelArr
                                                        .responseData
                                                        .elementAt(index)
                                                        .cardId);
                                              },
                                              child: Container(
                                                height: SizeConfig
                                                    .screenHeight *
                                                    .03,
                                                width: SizeConfig
                                                    .screenWidth *
                                                    .07,
                                                decoration:
                                                const BoxDecoration(
                                                  color: Colors.white,
                                                  shape:
                                                  BoxShape.rectangle,
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          6.0)),
                                                ),
                                                child: Icon(
                                                  Icons.delete,
                                                  size: SizeConfig
                                                      .screenHeight *
                                                      .022,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Checkbox(
                                          onChanged: (bool value) {
                                            setState(() {
                                              for (var element
                                              in cardListModelArr
                                                  .responseData) {
                                                element.isDefault = "no";
                                              }
                                              if (value) {
                                                cardListModelArr
                                                    .responseData
                                                    .elementAt(index)
                                                    .isDefault = "yes";
                                                markDefaultCard(
                                                    cardListModelArr
                                                        .responseData
                                                        .elementAt(index)
                                                        .cardId);
                                              } else {
                                                cardListModelArr
                                                    .responseData
                                                    .elementAt(index)
                                                    .isDefault = "no";
                                              }
                                            });
                                          },
                                          value: cardListModelArr
                                              .responseData
                                              .elementAt(index)
                                              .isDefault ==
                                              "yes"
                                              ? true
                                              : false,
                                          activeColor: Colors.blue,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                itemCount:
                                cardListModelArr.responseData.length,
                              )
                                  : Container(),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: MyButton(
                                      label: "Add Credit/Debit Card",
                                      labelWeight: FontWeight.w500,
                                      onPressed: () async {
                                        if (isPayNowShow) {
                                          Navigator.push(
                                              hp.context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddCreditDebitCardDetails(
                                                      mListener: this,
                                                      comeFrom: "1",
                                                    ),
                                              ));
                                        } else {
                                          Helper.showToast(
                                              "Select Pay now Option then add card details");
                                        }
                                      },
                                      heightFactor: 50,
                                      widthFactor: 4.5,
                                      radiusFactor: 160),
                                ),
                              ),
                              Visibility(
                                visible:Platform.isIOS ? true : false,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.screenHeight * .015),
                                  child: Divider(
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                              ),
                              Visibility(
                                  visible:Platform.isIOS ? true : false,
                                  child:  ApplePayButton(
                                    paymentConfigurationAsset: 'payment_configuration.json',
                                    paymentItems: [
                                      PaymentItem(
                                        label: 'Advertisement',
                                        amount: '${checkFareModel.responseData.totalCost}',
                                        status: PaymentItemStatus.final_price,
                                      )
                                    ],
                                    style: ApplePayButtonStyle.black,
                                    type: ApplePayButtonType.buy,
                                    margin: const EdgeInsets.only(top: 15.0),
                                    onPaymentResult: (paymentResult){
                                      if (mounted) {
                                        setState(() {
                                          isPaypalShow = false;
                                          isApplePayShow = true;
                                          isPayNowShow = false;
                                        });
                                      }
                                      if(paymentResult!=null){
                                        print("token    ${paymentResult["data"]}");
                                        // Fluttertoast.showToast( msg: "Apple Pay done ${paymentResult["token"]["data"]}");
                                        makeApplyPayPaymentAPi("${checkFareModel.responseData.totalCost}", paymentResult["token"]["data"]);

                                      }

                                    },
                                    loadingIndicator: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                /*GestureDetector(
                                  onTap: () {
                                    if (mounted) {
                                      setState(() {
                                        isPaypalShow = false;
                                        isApplePayShow = true;
                                        isPayNowShow = false;
                                      });
                                    }
                                  },
                                  onDoubleTap: () {},
                                  child: Row(
                                    children: [
                                      Container(
                                        height: SizeConfig.screenHeight * .05,
                                        width: SizeConfig.screenWidth * .07,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: Visibility(
                                          visible: isApplePayShow,
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Container(
                                              height:
                                                  SizeConfig.screenHeight * .02,
                                              width: SizeConfig.screenWidth * .03,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: CommonColor.brownColor,
                                                  border: Border.all(
                                                      color:
                                                          CommonColor.pinkColor)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .03),
                                        child: GestureDetector(
                                          onDoubleTap: () {},
                                          onTap: () {
                                            if (mounted) {
                                              setState(() {
                                                isPaypalShow = false;
                                                isApplePayShow = true;
                                                isPayNowShow = false;
                                              });
                                            }
                                            enabelPayment();
                                          },
                                          child: Text(
                                            "Apple Pay",
                                            style: TextStyle(
                                                fontSize: SizeConfig
                                                        .safeBlockHorizontal *
                                                    4.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                             */ ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.screenHeight * .015),
                                child: Divider(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (mounted) {
                                    setState(() {
                                      isPaypalShow = true;
                                      isApplePayShow = false;
                                      isPayNowShow = false;
                                    });
                                  }
                                },
                                onDoubleTap: () {},
                                child: Row(
                                  children: [
                                    Container(
                                      height: SizeConfig.screenHeight * .05,
                                      width: SizeConfig.screenWidth * .07,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: Visibility(
                                        visible: isPaypalShow,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Container(
                                            height:
                                            SizeConfig.screenHeight * .02,
                                            width: SizeConfig.screenWidth * .03,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: CommonColor.brownColor,
                                                border: Border.all(
                                                    color:
                                                    CommonColor.pinkColor)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: SizeConfig.screenWidth * .03),
                                      child: Text(
                                        "Paypal",
                                        style: TextStyle(
                                            fontSize:
                                            SizeConfig.safeBlockHorizontal *
                                                4.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.screenHeight * .02),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: CommonColor.blackoff,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8.0)),
                                      border: Border.all(
                                          color: CommonColor.brownColor
                                              .withOpacity(0.2))),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: SizeConfig.screenHeight * .02,
                                        bottom: SizeConfig.screenHeight * .02,
                                        left: SizeConfig.screenWidth * .04,
                                        right: SizeConfig.screenWidth * .03),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          "assets/images/suffle.png",
                                          scale: 4.0,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "\$${checkFareModel.responseData!=null ?  checkFareModel.responseData.totalCost : ""} will be charged to verify your card. The amount will be refunded immediately.",
                                            style: TextStyle(
                                                fontSize: SizeConfig
                                                    .safeBlockHorizontal *
                                                    3.3,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: MyButton(
                                      label: "Make Payment",
                                      labelWeight: FontWeight.w500,
                                      onPressed: () async {
                                        if (isPayNowShow) {
                                          String id = "";
                                          if (isShowListData) {
                                            cardListModelArr.responseData
                                                .forEach((e) {
                                              print("eiii ${e.cardId}");

                                              if (e.isDefault == "yes") {
                                                if (mounted) {
                                                  setState(() {
                                                    id = e.cardId;
                                                  });
                                                }
                                              }
                                            });
                                            //print("hhhhh $id");
                                            makePaymentApiCall(
                                                id,
                                                checkFareModel
                                                    .responseData.totalCost
                                                    .toString());
                                          }
                                        } else if (isPaypalShow) {
                                          // print("fbdbfdbf");
                                          makePaypalPaymnetAPi(checkFareModel
                                              .responseData.totalCost
                                              .toString());
                                        } else if (isApplePayShow) {
                                          //makePayment(checkFareModel.responseData.totalCost);
                                        } else {
                                          Helper.showToast(
                                              "Select any payment type to make payment");
                                        }
                                      },
                                      heightFactor: 50,
                                      widthFactor: 4.2,
                                      radiusFactor: 160),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: SizedBox(
                                    width: double.infinity, child: Container()),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
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

  makePaymentApiCall(String cardId, String totalAmount) async {
    Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();

    final prefs = await sharedPrefs;
    if (mounted) {
      setState(() {
        flag = true;
      });
    }
    Map<String, dynamic> body = {
      "customerId": prefs.getString("spUserID"),
      "loginId": prefs.getString("spLoginID"),
      "card_id": cardId,
      "total_amount": totalAmount,
      "advertisementId": widget.id,
      "paymentType": "advertisement"
    };
    controller.waitUntilMakePayment(body).then((value) {
      if (mounted) {
        setState(() {
          flag = false;
        });
      }
      if (widget.mListener != null) {
        widget.mListener.addBackPaymentScreen();
      }
    });
  }

  deleteCardApiCalling(String cardId) async {
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
      "cardId": cardId,
    };
    controller.waitUntilDeleteCard(body).then((value) {
      if (mounted) {
        setState(() {
          flag = false;
          cardListModelArr.responseData.removeAt(localIndex);
        });
      }
    });
  }

  markDefaultCard(String cardId) async {
    Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();

    final prefs = await sharedPrefs;
    if (mounted) {
      setState(() {
        flag = true;
      });
    }
    Map<String, dynamic> body = {
      "customerId": prefs.getString("spUserID"),
      "loginId": prefs.getString("spLoginID"),
      "cardId": cardId,
    };
    controller.waitUntilSetDefaultCard(body).then((value) {
      if (mounted) {
        setState(() {
          flag = false;
          // cardListModelArr.responseData.removeAt(localIndex);
        });
      }
    });
  }

  PayPalResponseModel payPalModel = PayPalResponseModel();
  ApplePayResponseModel applePayModel = ApplePayResponseModel();

  makePaypalPaymnetAPi(String totalAmount) async {
    if (mounted) {
      setState(() {
        flag = true;
      });
    }

    controller.waitUntilMakePaypalPayment(totalAmount, widget.id).then((value) {
      if (mounted) {
        setState(() {
          flag = false;
        });
      }

      payPalModel = controller.payPalModel;
      if (payPalModel.responseData.link != "") {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullImageActivityWebView(
                  comingFrom: "2",
                  mListner: this,
                  imageUrl: payPalModel.responseData.link),
            ));
      }
    });
  }

  makeApplyPayPaymentAPi(String totalAmount, String token) async {
    if (mounted) {
      setState(() {
        flag = true;
      });
    }

    controller
        .waitUntilMakeApplePay(totalAmount, token, widget.id,"advertisement")
        .then((value) {
      if (mounted) {
        setState(() {
          flag = false;
        });
      }

      applePayModel = controller.applePayModel;
    });
  }

  @override
  addBackFunction() {
    // TODO: implement addBackFunction
    callCardAPi();
  }

  @override
  addBackPaymentScreen() {
    // TODO: implement addBackPaymentScreen
    if (widget.mListener != null) {
      widget.mListener.addBackPaymentScreen();
    }
  }
}

abstract class PaymentScreenInterface {
  addBackPaymentScreen();
}

/*


import 'dart:io';
import 'package:pay/pay.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_pay/flutter_pay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/models/get_storage_list_response_model.dart';
import 'package:griot_legacy_social_media_app/src/utils/common_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../size_config.dart';
import '../controllers/user_controller.dart';
import '../helpers/helper.dart';
import '../models/apple_pay_response_model.dart';
import '../models/card_list_response_model.dart';
import '../models/check_fare_response_model.dart';
import '../models/paypal_response_model.dart';
import '../widgets/my_button.dart';
import 'add_debit_credit_card_screen.dart';
import 'full_image_activity_webview.dart';

class PaymentScreen extends StatefulWidget {
  final String id;
  final String name;
  final PaymentScreenInterface mListener;
  // final bool isPackage;
  // final ResponseDatum packageModel;

  const PaymentScreen({
    Key key,
    this.id,
    this.mListener,
    this.name,
    // this.packageModel,
    // this.isPackage = false
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with AddCreditDebitCardDetailsInterface, FullImageActivityWebViewInterface {
  final cardNumber = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();
  UserController controller;
  CheckFareResponseModel checkFareModel = CheckFareResponseModel();
  CardListResponseModel cardListModelArr = CardListResponseModel();

  bool flag = false;
  bool isShowData = false;
  bool isShowListData = false;
  bool isPayNowShow = false;
  bool isApplePayShow = false;
  bool isPaypalShow = false;
  int localIndex;

  Future checkFareApiCheck() async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);

    if (mounted) {
      setState(() {
        flag = true;
      });
    }
    controller.waitForGetCheckFareApi(widget.id).then((value) {
      if (mounted) {
        setState(() {
          flag = false;
        });
      }
      checkFareModel = controller.checkFareModel;
      if (checkFareModel.responseData != null) {
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

  callCardAPi() {
    controller.waitForCardList().then((value) {
      cardListModelArr = controller.cardListModel;
      Future.delayed(const Duration(seconds: 1)).then((value) {
        if (cardListModelArr.responseData.isNotEmpty) {
          if (mounted) {
            setState(() {
              isShowListData = true;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isShowListData = false;
            });
          }
        }
      });
    });
  }

  Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();

  //FlutterPay flutterPay = FlutterPay();

  String result = "Result will be shown here";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkFareApiCheck();
    callCardAPi();
  }

  enabelPayment() async {
   */
/* try {
      bool result = await flutterPay.canMakePayments();
      setState(() {
        this.result = "Can make payments: $result";
      });
    } catch (e) {
      setState(() {
        result = "$e";
      });
    }

    try {
      bool result = await flutterPay.canMakePaymentsWithActiveCard(
        allowedPaymentNetworks: [
          PaymentNetwork.visa,
          PaymentNetwork.masterCard,
        ],
      );
      setState(() {
        this.result = "$result";
      });
    } catch (e) {
      setState(() {
        result = "Error: $e";
      });
    }*//*

  }

  void makePayment(var totalAmount) async {

    
     ApplePayButton(
     // paymentConfiguration: 'assets/payment_configuration.json',
      paymentItems:  [
            PaymentItem(
              label: 'Total',
              amount: '1.99',
              status: PaymentItemStatus.final_price,
            )
          ],
    //  style: ApplePayButtonStyle.black,
      //type: ApplePayButtonType.buy,
      width: MediaQuery.of(context).size.width*0.1,
      height:MediaQuery.of(context).size.height*0.2,
      margin: const EdgeInsets.only(top: 15.0),
      onPaymentResult: (value){
        Fluttertoast.showToast( msg: "Apple Pay done");
      },
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
    );
    */
/*Fluttertoast.showToast( msg: "Apple Pay Started");
    flutterPay.setEnvironment(environment: PaymentEnvironment.Production);

    List<PaymentItem> items = [PaymentItem(name: "Advertisement", price: 1)];

    String token = await flutterPay.requestPayment(
      appleParameters: AppleParameters(merchantIdentifier: "merchant.com.griotLegacySocialMediaApp"),
      allowedPaymentNetworks: [PaymentNetwork.masterCard,PaymentNetwork.visa],
      currencyCode: "USD",
      countryCode: "US",
      paymentItems: items,
    );
    Fluttertoast.showToast( msg: "Error $token");
    if(token!=null){
      var result=json.decode(token);
      print("token    ${result["data"]}");
     // makeApplyPayPaymentAPi("${totalAmount}", result["data"]);
    }*//*


  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final hp =
        Helper.of(context, context.findAncestorStateOfType<GetBuilderState>());
    return Stack(
      children: [
        Column(
          children: [
            Divider(
              color: Colors.white.withOpacity(0.1),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.screenWidth * .05,
                    top: SizeConfig.screenHeight * .02),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Row(
                      children: [
                        Text(
                          "How would you like to pay?",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 5.2,
                              color: CommonColor.offWhiteColor),
                          textScaleFactor: 1.0,
                        ),
                      ],
                    ),
                    isShowData
                        ? Padding(
                            padding: EdgeInsets.only(
                                top: SizeConfig.screenHeight * .012),
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: SizeConfig.screenWidth * .05,
                                    right: SizeConfig.screenWidth * .05,
                                    top: SizeConfig.screenHeight * .02,
                                    bottom: SizeConfig.screenHeight * .02),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Price Per Day",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                      4.0,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "Nunito"),
                                              textAlign: TextAlign.center,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: SizeConfig.screenHeight *
                                                      .01),
                                              child: Text(
                                                "Number Of Days",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: SizeConfig
                                                            .safeBlockHorizontal *
                                                        4.0,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Nunito"),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: SizeConfig.screenHeight *
                                                      .01),
                                              child: Text(
                                                "Total Cost",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: SizeConfig
                                                            .safeBlockHorizontal *
                                                        4.0,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Nunito"),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              checkFareModel
                                                  .responseData.pricePerDay,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: SizeConfig
                                                          .safeBlockHorizontal *
                                                      3.7,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "Nunito"),
                                              textAlign: TextAlign.center,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: SizeConfig.screenHeight *
                                                      .01),
                                              child: Text(
                                                checkFareModel
                                                    .responseData.numberOfDays
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: SizeConfig
                                                            .safeBlockHorizontal *
                                                        3.7,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Nunito"),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: SizeConfig.screenHeight *
                                                      .01),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    '\$',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: SizeConfig
                                                                .safeBlockHorizontal *
                                                            3.7,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily: "Nunito"),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    checkFareModel
                                                        .responseData.totalCost
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: SizeConfig
                                                                .safeBlockHorizontal *
                                                            3.7,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily: "Nunito"),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              "No data Found",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      SizeConfig.safeBlockHorizontal * 5.5),
                            ),
                          ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: SizeConfig.screenHeight * .02),
                      child: Container(
                        decoration: const BoxDecoration(
                            color: CommonColor.boxColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: SizeConfig.screenHeight * .02,
                              bottom: SizeConfig.screenHeight * .02,
                              right: SizeConfig.screenWidth * .02,
                              left: SizeConfig.screenWidth * .03),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (mounted) {
                                    setState(() {
                                      isPaypalShow = false;
                                      isApplePayShow = false;
                                      isPayNowShow = true;
                                    });
                                  }
                                },
                                onDoubleTap: () {},
                                child: Row(
                                  children: [
                                    Container(
                                      height: SizeConfig.screenHeight * .05,
                                      width: SizeConfig.screenWidth * .07,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: Visibility(
                                        visible: isPayNowShow,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Container(
                                            height:
                                                SizeConfig.screenHeight * .02,
                                            width: SizeConfig.screenWidth * .03,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: CommonColor.brownColor,
                                                border: Border.all(
                                                    color:
                                                        CommonColor.pinkColor)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: SizeConfig.screenWidth * .03),
                                      child: Text(
                                        "Pay Now",
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    4.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.screenHeight * .02),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: CommonColor.darkBrownColor
                                        .withOpacity(0.12),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0)),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: SizeConfig.screenHeight * .02,
                                        bottom: SizeConfig.screenHeight * .02,
                                        left: SizeConfig.screenWidth * .04,
                                        right: SizeConfig.screenWidth * .03),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Credit / Debit Card",
                                          style: TextStyle(
                                              fontSize: SizeConfig
                                                      .safeBlockHorizontal *
                                                  3.5,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/images/visa.png",
                                              scale: 2.5,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: SizeConfig.screenWidth *
                                                      .01),
                                              child: Image.asset(
                                                "assets/images/mastercard.png",
                                                scale: 2.5,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: SizeConfig.screenWidth *
                                                      .01),
                                              child: Image.asset(
                                                "assets/images/americanExpress.png",
                                                scale: 2.5,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.screenHeight * .015),
                                child: Divider(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                              isShowListData
                                  ? ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              top: SizeConfig.screenHeight *
                                                  .01),
                                          child: Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              Stack(
                                                alignment:
                                                    Alignment.bottomRight,
                                                children: [
                                                  Card(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: SizeConfig
                                                                  .screenWidth *
                                                              .03,
                                                          right: SizeConfig
                                                                  .screenWidth *
                                                              .03,
                                                          top: SizeConfig
                                                                  .screenHeight *
                                                              .01,
                                                          bottom: SizeConfig
                                                                  .screenHeight *
                                                              .015),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                top: SizeConfig
                                                                        .screenHeight *
                                                                    .01),
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  "xxxxxxxxxx" +
                                                                      cardListModelArr
                                                                          .responseData
                                                                          .elementAt(
                                                                              index)
                                                                          .last4,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          SizeConfig.safeBlockHorizontal *
                                                                              4.0,
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                top: SizeConfig
                                                                        .screenHeight *
                                                                    .015),
                                                            child: Row(
                                                              children: [
                                                                Image.asset(
                                                                  "assets/images/visa.png",
                                                                  scale: 2.5,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onDoubleTap: () {},
                                                    onTap: () {
                                                      setState(() {
                                                        localIndex = index;
                                                      });
                                                      deleteCardApiCalling(
                                                          cardListModelArr
                                                              .responseData
                                                              .elementAt(index)
                                                              .cardId);
                                                    },
                                                    child: Container(
                                                      height: SizeConfig
                                                              .screenHeight *
                                                          .03,
                                                      width: SizeConfig
                                                              .screenWidth *
                                                          .07,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.white,
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    6.0)),
                                                      ),
                                                      child: Icon(
                                                        Icons.delete,
                                                        size: SizeConfig
                                                                .screenHeight *
                                                            .022,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Checkbox(
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    for (var element
                                                        in cardListModelArr
                                                            .responseData) {
                                                      element.isDefault = "no";
                                                    }
                                                    if (value) {
                                                      cardListModelArr
                                                          .responseData
                                                          .elementAt(index)
                                                          .isDefault = "yes";
                                                      markDefaultCard(
                                                          cardListModelArr
                                                              .responseData
                                                              .elementAt(index)
                                                              .cardId);
                                                    } else {
                                                      cardListModelArr
                                                          .responseData
                                                          .elementAt(index)
                                                          .isDefault = "no";
                                                    }
                                                  });
                                                },
                                                value: cardListModelArr
                                                            .responseData
                                                            .elementAt(index)
                                                            .isDefault ==
                                                        "yes"
                                                    ? true
                                                    : false,
                                                activeColor: Colors.blue,
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      itemCount:
                                          cardListModelArr.responseData.length,
                                    )
                                  : Container(),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: MyButton(
                                      label: "Add Credit/Debit Card",
                                      labelWeight: FontWeight.w500,
                                      onPressed: () async {
                                        if (isPayNowShow) {
                                          Navigator.push(
                                              hp.context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    AddCreditDebitCardDetails(
                                                  mListener: this,
                                                  comeFrom: "1",
                                                ),
                                              ));
                                        } else {
                                          Helper.showToast(
                                              "Select Pay now Option then add card details");
                                        }
                                      },
                                      heightFactor: 50,
                                      widthFactor: 4.5,
                                      radiusFactor: 160),
                                ),
                              ),
                              Visibility(
                                visible:Platform.isIOS ? true : false,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.screenHeight * .015),
                                  child: Divider(
                                    color: Colors.white.withOpacity(0.1),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible:Platform.isIOS ? true : false,
                                child: GestureDetector(
                                  onTap: () {
                                    if (mounted) {
                                      setState(() {
                                        isPaypalShow = false;
                                        isApplePayShow = true;
                                        isPayNowShow = false;
                                      });
                                    }
                                  },
                                  onDoubleTap: () {},
                                  child: Row(
                                    children: [
                                      Container(
                                        height: SizeConfig.screenHeight * .05,
                                        width: SizeConfig.screenWidth * .07,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle),
                                        child: Visibility(
                                          visible: isApplePayShow,
                                          child: Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Container(
                                              height:
                                                  SizeConfig.screenHeight * .02,
                                              width: SizeConfig.screenWidth * .03,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: CommonColor.brownColor,
                                                  border: Border.all(
                                                      color:
                                                          CommonColor.pinkColor)),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: SizeConfig.screenWidth * .03),
                                        child: GestureDetector(
                                          onDoubleTap: () {},
                                          onTap: () {
                                            if (mounted) {
                                              setState(() {
                                                isPaypalShow = false;
                                                isApplePayShow = true;
                                                isPayNowShow = false;
                                              });
                                            }
                                            enabelPayment();
                                          },
                                          child: Text(
                                            "Apple Pay",
                                            style: TextStyle(
                                                fontSize: SizeConfig
                                                        .safeBlockHorizontal *
                                                    4.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.screenHeight * .015),
                                child: Divider(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (mounted) {
                                    setState(() {
                                      isPaypalShow = true;
                                      isApplePayShow = false;
                                      isPayNowShow = false;
                                    });
                                  }
                                },
                                onDoubleTap: () {},
                                child: Row(
                                  children: [
                                    Container(
                                      height: SizeConfig.screenHeight * .05,
                                      width: SizeConfig.screenWidth * .07,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle),
                                      child: Visibility(
                                        visible: isPaypalShow,
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Container(
                                            height:
                                                SizeConfig.screenHeight * .02,
                                            width: SizeConfig.screenWidth * .03,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: CommonColor.brownColor,
                                                border: Border.all(
                                                    color:
                                                        CommonColor.pinkColor)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: SizeConfig.screenWidth * .03),
                                      child: Text(
                                        "Paypal",
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.safeBlockHorizontal *
                                                    4.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.screenHeight * .02),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: CommonColor.blackoff,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(8.0)),
                                      border: Border.all(
                                          color: CommonColor.brownColor
                                              .withOpacity(0.2))),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: SizeConfig.screenHeight * .02,
                                        bottom: SizeConfig.screenHeight * .02,
                                        left: SizeConfig.screenWidth * .04,
                                        right: SizeConfig.screenWidth * .03),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          "assets/images/suffle.png",
                                          scale: 4.0,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "\$${checkFareModel.responseData!=null ?  checkFareModel.responseData.totalCost : ""} will be charged to verify your card. The amount will be refunded immediately.",
                                            style: TextStyle(
                                                fontSize: SizeConfig
                                                        .safeBlockHorizontal *
                                                    3.3,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: MyButton(
                                      label: "Make Payment",
                                      labelWeight: FontWeight.w500,
                                      onPressed: () async {
                                        if (isPayNowShow) {
                                          String id = "";
                                          if (isShowListData) {
                                            cardListModelArr.responseData
                                                .forEach((e) {
                                              print("eiii ${e.cardId}");

                                              if (e.isDefault == "yes") {
                                                if (mounted) {
                                                  setState(() {
                                                    id = e.cardId;
                                                  });
                                                }
                                              }
                                            });
                                            //print("hhhhh $id");
                                            makePaymentApiCall(
                                                id,
                                                checkFareModel
                                                    .responseData.totalCost
                                                    .toString());
                                          }
                                        } else if (isPaypalShow) {
                                          // print("fbdbfdbf");
                                          makePaypalPaymnetAPi(checkFareModel
                                              .responseData.totalCost
                                              .toString());
                                        } else if (isApplePayShow) {
                                        //  makePayment(checkFareModel.responseData.totalCost);
                                        } else {
                                          Helper.showToast(
                                              "Select any payment type to make payment");
                                        }
                                      },
                                      heightFactor: 50,
                                      widthFactor: 4.2,
                                      radiusFactor: 160),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: SizedBox(
                                    width: double.infinity, child: Container()),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
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

  makePaymentApiCall(String cardId, String totalAmount) async {
    Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();

    final prefs = await sharedPrefs;
    if (mounted) {
      setState(() {
        flag = true;
      });
    }
    Map<String, dynamic> body = {
      "customerId": prefs.getString("spUserID"),
      "loginId": prefs.getString("spLoginID"),
      "card_id": cardId,
      "total_amount": totalAmount,
      "advertisementId": widget.id,
      "paymentType": "advertisement"
    };
    controller.waitUntilMakePayment(body).then((value) {
      if (mounted) {
        setState(() {
          flag = false;
        });
      }
      if (widget.mListener != null) {
        widget.mListener.addBackPaymentScreen();
      }
    });
  }

  deleteCardApiCalling(String cardId) async {
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
      "cardId": cardId,
    };
    controller.waitUntilDeleteCard(body).then((value) {
      if (mounted) {
        setState(() {
          flag = false;
          cardListModelArr.responseData.removeAt(localIndex);
        });
      }
    });
  }

  markDefaultCard(String cardId) async {
    Future<SharedPreferences> sharedPrefs = SharedPreferences.getInstance();

    final prefs = await sharedPrefs;
    if (mounted) {
      setState(() {
        flag = true;
      });
    }
    Map<String, dynamic> body = {
      "customerId": prefs.getString("spUserID"),
      "loginId": prefs.getString("spLoginID"),
      "cardId": cardId,
    };
    controller.waitUntilSetDefaultCard(body).then((value) {
      if (mounted) {
        setState(() {
          flag = false;
          // cardListModelArr.responseData.removeAt(localIndex);
        });
      }
    });
  }

  PayPalResponseModel payPalModel = PayPalResponseModel();
  ApplePayResponseModel applePayModel = ApplePayResponseModel();

  makePaypalPaymnetAPi(String totalAmount) async {
    if (mounted) {
      setState(() {
        flag = true;
      });
    }

    controller.waitUntilMakePaypalPayment(totalAmount, widget.id).then((value) {
      if (mounted) {
        setState(() {
          flag = false;
        });
      }

      payPalModel = controller.payPalModel;
      if (payPalModel.responseData.link != "") {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullImageActivityWebView(
                  comingFrom: "2",
                  mListner: this,
                  imageUrl: payPalModel.responseData.link),
            ));
      }
    });
  }

  makeApplyPayPaymentAPi(String totalAmount, String token) async {
    if (mounted) {
      setState(() {
        flag = true;
      });
    }

    controller.waitUntilMakeApplePay(totalAmount, token, widget.id,"advertisement")
        .then((value) {
      if (mounted) {
        setState(() {
          flag = false;
        });
      }

      applePayModel = controller.applePayModel;
    });
  }

  @override
  addBackFunction() {
    // TODO: implement addBackFunction
    callCardAPi();
  }

  @override
  addBackPaymentScreen() {
    // TODO: implement addBackPaymentScreen
    if (widget.mListener != null) {
      widget.mListener.addBackPaymentScreen();
    }
  }
}

abstract class PaymentScreenInterface {
  addBackPaymentScreen();
}
*/
