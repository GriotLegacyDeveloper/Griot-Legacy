import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';
import 'package:griot_legacy_social_media_app/src/widgets/my_button.dart';
import 'package:griot_legacy_social_media_app/src/widgets/icon_image_widget.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ChangePasswordPageState();
  }
}

class ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  bool flag = true;
  final TextEditingController cpc = TextEditingController(),
      pc = TextEditingController(),opc=TextEditingController();
  bool hidePassword = true;
  bool oldPassword = true;
  bool hideConfirmPassword = true;

  Widget pageBuilder(UserController controller) {
    final hp = controller.hp;
    hp.lockScreenRotation();
    return Scaffold(
        appBar: AppBar(
            title: const Text("Change Password"),
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
                        padding: EdgeInsets.only(top: hp.height * 0.06),
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
                              top: hp.height / 20, bottom: hp.height / 50),
                          child: Text("Change Your Password",
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
                                return "Please enter old password";
                              }
                            },
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            controller: opc,
                            style: TextStyle(
                                color: hp.theme.secondaryHeaderColor),
                            maxLength: 100,
                            decoration: InputDecoration(
                              counterText: "",
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      oldPassword = !oldPassword;
                                    });
                                  },
                                  icon: Icon(
                                      oldPassword
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
                                hintText: "Old Password"),
                            obscureText: oldPassword,
                            obscuringCharacter: "*",
                          )),
                      Container(
                          width: hp.width * 0.8,
                          padding: EdgeInsets.only(bottom: hp.height / 40),
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
                            maxLength: 100,
                            style: TextStyle(
                                color: hp.theme.secondaryHeaderColor),
                            decoration: InputDecoration(
                              counterText: "",
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
                            maxLength: 100,

                            style: TextStyle(
                                color: hp.theme.secondaryHeaderColor),
                            decoration: InputDecoration(
                              errorStyle: TextStyle(
                                color: Colors.white
                              ),
                              counterText: "",
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
                              bool status=true;
                              if (_formKey.currentState.validate()) {
                                if (pc.text == cpc.text) {
                                  setState(() {
                                    flag = false;
                                  });
                                } else {

                                  Fluttertoast.showToast(
                                      msg:
                                      "New password and confirm password not matching");
                                }
                              } else {

                                if(opc.text==""){
                                  status=false;
                                  ScaffoldMessenger.of(context).showSnackBar((const SnackBar(content: Text('old password can not be blank',))));

                                }else if(cpc.text==""){
                                  status=false;
                                  ScaffoldMessenger.of(context).showSnackBar((const SnackBar(content: Text('confirm password can not be blank',))));

                                }
                                else if(pc.text==""){
                                  status=false;
                                  ScaffoldMessenger.of(context).showSnackBar((const SnackBar(content: Text('confirm password can not be blank',))));

                                }
                                if(status){
                                  setState(() {
                                    flag = false;
                                  });

                                  final prefs = await controller.sharedPrefs;
                                  Map<String, dynamic> body = {
                                    "userId": prefs.getString("spUserID"),
                                    "oldPassword": opc.text,
                                    "newPassword": pc.text,
                                    "confirmPassword": cpc.text,
                                    "loginId": prefs.getString("spLoginID"),
                                    "appType": Platform.isAndroid
                                        ? "ANDROID"
                                        : (Platform.isIOS ? "IOS" : "BROWSER")
                                  };
                                  await controller
                                      .waitUntilChangePassword(body)
                                      .then((value) {
                                    setState(() {
                                      Navigator.pop(context,true);
                                      flag = true;
                                    });
                                  });
                                }

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
        ));
  }

  @override
  Widget build(BuildContext context) {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    return pageBuilder(UserController(context, state));
  }
}
