import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';
import 'package:griot_legacy_social_media_app/src/widgets/my_button.dart';
import 'package:griot_legacy_social_media_app/src/widgets/icon_image_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../utils/common_color.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ResetPasswordPageState();
  }
}

class ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  bool flag = true;
  final TextEditingController cpc = TextEditingController(),
      pc = TextEditingController();
  bool hidePassword = true;
  bool hideConfirmPassword = true;




  @override
  void initState() {
    getToken();


  }


  getToken() async {
     sharedPreferences = await SharedPreferences.getInstance();
    String token = await FirebaseMessaging.instance.getToken();

   // print("token     $token");
     //ScaffoldMessenger.of(context).showSnackBar((SnackBar(content: Text('${token}',))));

     SharePrefrence.setToken(token);
    // sharedPreferences.setString(Constant.deviceToken, token);


  }







  Widget pageBuilder(UserController controller) {
    final hp = controller.hp;
    hp.lockScreenRotation();
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                title: const Text("Reset Password"),
                backgroundColor: controller.hp.theme.primaryColor,
                foregroundColor: controller.hp.theme.secondaryHeaderColor),
            backgroundColor: hp.theme.primaryColor,
            body: Stack(
              children: [
                SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: hp.height * 0.09),
                          ),
                          SizedBox(
                            height: hp.height * 0.16,
                            child: const IconImageWidget(
                              imagePath:
                                  "assets/images/reset-password-icon.svg",
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  top: hp.height / 17, bottom: hp.height / 50),
                              child: Text("Reset Your Password",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: hp.theme.shadowColor,
                                      fontWeight: FontWeight.w600))),
                          Container(
                              width: hp.width * 0.8,
                              padding: EdgeInsets.only(
                                  top: hp.height / 50, bottom: hp.height / 40),
                              child: TextFormField(
                                autocorrect: false,
                                enableSuggestions: false,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please enter new password";
                                  }
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: pc,
                                style: TextStyle(
                                    color: hp.theme.secondaryHeaderColor),
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          hidePassword = !hidePassword;
                                        });
                                      },
                                      icon: Icon(
                                          hidePassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility,
                                          color: hp.theme.primaryColorLight),
                                    ),
                                    filled: true,
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      // borderSide: BorderSide(color: Colors.red, width: 2),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      //borderSide: BorderSide(color: Colors.red),
                                    ),
                                    contentPadding: EdgeInsets.only(
                                        left: hp.width / 40,
                                        top: hp.height / 50,
                                        bottom: hp.height / 50),
                                    fillColor: hp.theme.cardColor,
                                    hintStyle: TextStyle(
                                        color: hp.theme.primaryColorLight),
                                    // enabledBorder: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.lock_outlined,
                                        color: hp.theme.primaryColorLight),
                                    border: InputBorder.none,
                                    hintText: "New Password"),
                                obscureText: hidePassword,
                                obscuringCharacter: "*",
                              )),
                          Container(
                              width: hp.width * 0.8,
                              padding: EdgeInsets.only(bottom: hp.height / 20),
                              child: TextFormField(
                                autocorrect: false,
                                enableSuggestions: false,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Please enter confirm password";
                                  } else if (value != pc.text) {
                                    return "Password and confirm password does not match";
                                  } else {
                                    return "";
                                  }
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: cpc,
                                style: TextStyle(
                                    color: hp.theme.secondaryHeaderColor),
                                decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          hideConfirmPassword =
                                              !hideConfirmPassword;
                                        });
                                      },
                                      icon: Icon(
                                          hideConfirmPassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility,
                                          color: hp.theme.primaryColorLight),
                                    ),
                                    filled: true,
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      // borderSide: BorderSide(color: Colors.red, width: 2),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      //borderSide: BorderSide(color: Colors.red),
                                    ),
                                    fillColor: hp.theme.cardColor,
                                    contentPadding: EdgeInsets.only(
                                        left: hp.width / 40,
                                        top: hp.height / 50,
                                        bottom: hp.height / 50),
                                    hintStyle: TextStyle(
                                        color: hp.theme.primaryColorLight),
                                    // enabledBorder:const OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.lock_outlined,
                                        color: hp.theme.primaryColorLight),
                                    border: InputBorder.none,
                                    hintText: "Confirm Password"),
                                obscureText: hideConfirmPassword,
                                obscuringCharacter: "*",
                              )),
                          SizedBox(
                            width: hp.width * 0.8,
                            child: MyButton(
                                label: "Submit",
                                labelWeight: FontWeight.w500,
                                onPressed: () async {
                                  //  FocusScope.of(context)
                                  //    .requestFocus(FocusNode());
                                  if (_formKey.currentState.validate()) {
                                    if (pc.text == cpc.text) {
                                      setState(() {
                                        flag = false;
                                      });
                                    } else {
                                      /*setState(() {
                                      hidePassword = false;
                                      hideConfirmPassword = false;
                                    });*/
                                      Fluttertoast.showToast(
                                          msg:
                                              "New password and confirm password not matching");
                                    }
                                  } else {
                                    setState(() {
                                      flag = false;
                                    });
                                  //  print("fffffff");
                                    final prefs = await controller.sharedPrefs;
                                    String token=await SharePrefrence.getToken();

                                    Map<String, dynamic> body = {
                                      "userId": prefs.getString("spUserID"),
                                      "password": pc.text,
                                      "confirmPassword": cpc.text,
                                      "deviceToken": token,
                                      "appType": Platform.isAndroid
                                          ? "ANDROID"
                                          : (Platform.isIOS ? "IOS" : "BROWSER")
                                    };
                                    await controller
                                        .waitUntilPasswordReset(body)
                                        .then((value) {
                                      setState(() {
                                        flag = true;
                                      });
                                    });
                                  }
                                },
                                heightFactor: 50,
                                widthFactor: 3.2,
                                radiusFactor: 160),
                          ),
                        ],
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: hp.height / 50)),
                flag
                    ? Container()
                    : Container(
                        height: hp.height,
                        width: hp.width,
                        color: Colors.black87,
                        child: const SpinKitFoldingCube(color: Colors.white),
                      )
              ],
            )));
  }






  @override
  Widget build(BuildContext context) {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    return pageBuilder(UserController(context, state));
  }
}
