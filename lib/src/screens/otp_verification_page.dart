import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';
import 'package:griot_legacy_social_media_app/src/utils/constant_class.dart';
import 'package:griot_legacy_social_media_app/src/widgets/my_button.dart';
import 'package:griot_legacy_social_media_app/src/widgets/icon_image_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../utils/common_color.dart';

class OTPVerificationPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final emailPhone;
  // ignore: prefer_typing_uninitialized_variables
  final api;
  final String sId;
  final String userId;
  const OTPVerificationPage({Key key, this.emailPhone, this.api, this.sId, this.userId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OTPVerificationPageState();
  }
}

class OTPVerificationPageState extends State<OTPVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController textEditingController = TextEditingController();
  bool flag = true;
 // final int _pinLength = 6;
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  String currentText = "";

  @override
  void initState() {
    super.initState();
   // print("hhhhhhh")
    getToken();
  }

  getToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String token = await FirebaseMessaging.instance.getToken();

   // print("token     $token   ${widget.userId}");
   // ScaffoldMessenger.of(context).showSnackBar((SnackBar(content: Text('${token}',))));

    SharePrefrence.setToken(token);
    // sharedPreferences.setString(Constant.deviceToken, token);


  }
  Widget pageBuilder(UserController controller) {
    final hp = controller.hp;
    controller.getTEC(controller.count);
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
            backgroundColor: hp.theme.primaryColor,
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: hp.height * 0.09),
                          ),
                          SizedBox(
                              height: hp.height * 0.16,
                              child: const IconImageWidget(
                                imagePath: "assets/images/verify-otp-icon.svg",
                              )),
                          Padding(
                              padding: EdgeInsets.only(top: hp.height / 40),
                              child: Text("Verification",
                                  style: TextStyle(
                                      fontSize: hp.height * 0.029,
                                      color: hp.theme.shadowColor,
                                      fontWeight: FontWeight.w600))),
                          Padding(
                              padding: EdgeInsets.only(
                                  top: hp.height / 80, bottom: hp.height / 50),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      "Enter the code send to you via SMS / \nEmail",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: hp.theme.canvasColor),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                ],
                              )),
                          Container(
                              width: hp.width * 0.8,
                              padding: EdgeInsets.only(
                                  top: hp.height / 50, bottom: hp.height / 25),
                              child: PinCodeTextField(
                                textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        signed: false, decimal: false),
                                length: 6,
                                obscureText: false,
                                animationType: AnimationType.fade,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,

                                  borderRadius: BorderRadius.circular(5),
                                  //fieldHeight: 50,
                                  //fieldWidth: 40,
                                  activeColor: Colors.white24,
                                  activeFillColor: Colors.white24,
                                  selectedColor: Colors.white24,
                                  disabledColor: Colors.white24,
                                  inactiveColor: Colors.white24,
                                  inactiveFillColor: Colors.white24,
                                  selectedFillColor: Colors.white24,
                                ),
                                animationDuration:
                                    const Duration(milliseconds: 300),
                                //backgroundColor: Colors.blue.shade50,
                                backgroundColor: Colors.transparent,
                                enableActiveFill: true,
                                errorAnimationController: errorController,
                                controller: textEditingController,
                                onCompleted: (v) {
                                  //print("Completed");
                                },
                                onChanged: (value) {
                                 // print(value);
                                  setState(() {
                                    currentText = value;
                                  });
                                },
                                beforeTextPaste: (text) {
                                 // print("Allowing to paste $text");
                                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                  return true;
                                },
                                appContext: context,
                              )),
                          SizedBox(
                            width: hp.width * 0.8,
                            child: MyButton(
                                label: "Verify",
                                labelWeight: FontWeight.w600,
                                onPressed: () async {
                                  errorController.add(ErrorAnimationType.shake);
                                  if (currentText.length != 6) {
                                    errorController.add(ErrorAnimationType
                                        .shake); // Triggering error shake animation

                                  } else {
                                    setState(() {
                                      flag = false;
                                    });
                                    final prefs = await controller.sharedPrefs;
                                    // if (controller.val.length < controller.count) {
                                    //   for (TextEditingController i in controller.tec) {
                                    //     controller.val += i.text;
                                    //   }
                                    // }

                                    String token=await SharePrefrence.getToken();
                                    Map<String, dynamic> body;
                                    if (widget.api == "fpVerifyUser") {
                                      body = {
                                        "userId": prefs.getString("spUserID"),
                                        "otp": currentText,
                                        "sid": prefs.getString("spSID")
                                      };
                                    } else {
                                      body = {
                                        "userId": widget.userId!=""? widget.userId:prefs.getString("spUserID"),
                                        "otp": currentText,
                                        "sid": widget.sId!="" ?widget.sId:prefs.getString("spSID"),
                                        "deviceToken": token,
                                        "appType": Platform.isAndroid
                                            ? "ANDROID"
                                            : (Platform.isIOS
                                                ? "IOS"
                                                : "BROWSER")
                                      };
                                    }

                                   // print(body);
                                    controller
                                        .checkOTP(body, widget.api)
                                        .then((value) {
                                      setState(() {
                                        flag = true;
                                        if (!value) {
                                          errorController
                                              .add(ErrorAnimationType.shake);
                                          textEditingController.clear();
                                        }
                                      });
                                    });
                                  }
                                },
                                heightFactor: 50,
                                widthFactor: 3.2,
                                radiusFactor: 160),
                          ),
                          Padding(
                              padding:
                                  EdgeInsets.only(top: hp.height / 13.1072),
                              child: GestureDetector(
                                  child: Text("Resend OTP",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: hp.theme.shadowColor)),
                                  onTap: () async {
                                    FocusScope.of(context).previousFocus();
                                    setState(() {
                                      flag = false;
                                    });
                                    String url =Constant.RESENT_OTP_URL;
                                    String type = "";
                                    if (widget.api == "fpVerifyUser") {
                                      type = "FP";
                                    } else {
                                      type = "SIGN_UP";
                                    }
                                    final prefs = await controller.sharedPrefs;
                                    Map<String, dynamic> body = {
                                      //spUserID
                                      "userId": prefs.getString("spUserID"),
                                      "type": type
                                    };
                                    controller
                                        .waitUntilGetOtp(body, url)
                                        .then((value) {
                                      setState(() {
                                        flag = true;
                                      });
                                    });
                                  }))
                        ]),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: hp.width / 40),
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
            appBar: AppBar(
                title: const Text("Verify OTP"),
                foregroundColor: hp.theme.secondaryHeaderColor,
                backgroundColor: hp.theme.primaryColor)));
  }

  void diChange(GetBuilderState<UserController> state) {
    state.controller.hp.lockScreenRotation();
  }

  @override
  Widget build(BuildContext context) {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    return GetBuilder<UserController>(
        didChangeDependencies: diChange,
        builder: pageBuilder,
        init: UserController(context, state));
  }
}
