import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';

import 'package:griot_legacy_social_media_app/src/widgets/my_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  bool flag = true;
  final TextEditingController ec = TextEditingController();
  final TextEditingController pc = TextEditingController();

  Widget pageBuilder(UserController controller) {
    final hp = controller.hp;
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
            backgroundColor: hp.theme.primaryColor,
            body: Stack(
              children: [
                SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.asset("assets/images/logic.png",
                            height: hp.height / 10),
                        // SvgPicture.asset("assets/images/icon.svg"),
                        Padding(
                            padding: EdgeInsets.only(top: hp.height / 40),
                            child: Text("Welcome Back",
                                style: TextStyle(
                                    fontSize: 32,
                                    color: hp.theme.shadowColor,
                                    fontWeight: FontWeight.w600))),
                        Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: hp.height / 64),
                            child: Text("Enter your credentials to continue",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: hp.theme.canvasColor))),
                        Padding(
                            padding: EdgeInsets.only(
                                top: hp.height / 50, bottom: hp.height / 50),
                            child: TextFormField(
                              controller: ec,
                               autocorrect: false,
                               enableSuggestions: false,
                              style: TextStyle(
                                  color: hp.theme.secondaryHeaderColor),
                              decoration: InputDecoration(
                              
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  filled: true,
                                  fillColor: hp.theme.cardColor,
                                  hintStyle: TextStyle(
                                      color: hp.theme.primaryColorLight),
                                  // enabledBorder:const OutlineInputBorder(),
                                  prefixIcon: Icon(
                                      Icons.account_circle_outlined,
                                      color: hp.theme.primaryColorLight),
                                  contentPadding: EdgeInsets.only(
                                      left: hp.width / 40,
                                      top: hp.height / 50,
                                      bottom: hp.height / 50),
                                  border: InputBorder.none,
                                  hintText: "Email"),
                             // keyboardType: TextInputType.emailAddress,
                            )),

                        TextFormField(
                            controller: pc,
                            style:
                                TextStyle(color: hp.theme.secondaryHeaderColor),
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    onPressed: controller.hideOrRevealText,
                                    icon: Icon(
                                        controller.hideText
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility,
                                        color: hp.theme.primaryColorLight)),
                                filled: true,
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  // borderSide: BorderSide(color: Colors.red, width: 2),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  //borderSide: BorderSide(color: Colors.red),
                                ),
                                fillColor: hp.theme.cardColor,
                                hintStyle: TextStyle(
                                    color: hp.theme.primaryColorLight),
                                // enabledBorder: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.lock_outlined,
                                    color: hp.theme.primaryColorLight),
                                contentPadding: EdgeInsets.only(
                                    left: hp.width / 40,
                                    top: hp.height / 50,
                                    bottom: hp.height / 50),
                                border: InputBorder.none,
                                hintText: "Password"),
                            obscureText: controller.hideText,
                            obscuringCharacter: "*"),
                        GestureDetector(
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: hp.height / 30),
                                child: Text("Forgot your password?",
                                    style: TextStyle(
                                        color: hp.theme.primaryColorLight))),
                            onTap: () async {
                              setState(() {});

                              hp.goToRoute("/mobileLogin");
                            }),
                        SizedBox(
                          width: double.infinity,
                          child: MyButton(
                              label: "Sign In",
                              labelWeight: FontWeight.w500,
                              onPressed: () async {
                                String token =
                                    await FirebaseMessaging.instance.getToken();

                                if (int.tryParse(ec.text) == null
                                    ? hp.isEmail(ec.text)
                                    : true) {
                                  setState(() {
                                    flag = false;
                                  });
                                  Map<String, dynamic> body = {
                                    "user": ec.text,
                                    "password": pc.text,
                                    "deviceToken": token,
                                    "appType": Platform.isAndroid
                                        ? "ANDROID"
                                        : (Platform.isIOS ? "IOS" : "BROWSER")
                                  };
                                  controller.waitForLogin(body).then((value) {
                                    //print("value    $value");
                                    setState(() {
                                      flag = true;
                                      //print("flaggggg    $flag");
                                    });
                                  });
                                }
                              },
                              heightFactor: 50,
                              widthFactor: 3.2,
                              radiusFactor: 160),
                        ),
                        GestureDetector(
                          child: Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: hp.height / 7),
                              child: Row(children: [
                                Text("Don't have an Account? ",
                                    style: TextStyle(
                                        color: hp.theme.unselectedWidgetColor)),
                                Text("Sign Up",
                                    style:
                                        TextStyle(color: hp.theme.shadowColor))
                              ], mainAxisAlignment: MainAxisAlignment.center)),
                          onTap: () async {
                            // hp.goToRouteWithNoWayBack("/register", true);
                            hp.goToRoute("/register");
                          },
                        )
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: hp.width / 10)),
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
                leading: Container(),
                backgroundColor: hp.theme.primaryColor,
                foregroundColor: hp.theme.secondaryHeaderColor)));
  }

  void didChange(GetBuilderState<UserController> state) {
    state.controller.hp.lockScreenRotation();
  }

  @override
  Widget build(BuildContext context) {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    return GetBuilder<UserController>(
        didChangeDependencies: didChange,
        builder: pageBuilder,
        init: UserController(context, state));
  }
}



//! BACkUP
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:get/get.dart';
// import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';

// import 'package:griot_legacy_social_media_app/src/widgets/my_button.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() {
//     return LoginPageState();
//   }
// }

// class LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   bool flag = true;
//   final TextEditingController ec = TextEditingController();
//   final TextEditingController pc = TextEditingController();

//   Widget pageBuilder(UserController controller) {
//     final hp = controller.hp;
//     return SafeArea(
//         top: false,
//         bottom: false,
//         child: Scaffold(
//             backgroundColor: hp.theme.primaryColor,
//             body: Stack(
//               children: [
//                 SingleChildScrollView(
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           Image.asset("assets/images/logic.png",
//                               height: hp.height / 10),
//                           // SvgPicture.asset("assets/images/icon.svg"),
//                           Padding(
//                               padding: EdgeInsets.only(top: hp.height / 40),
//                               child: Text("Welcome Back",
//                                   style: TextStyle(
//                                       fontSize: 32,
//                                       color: hp.theme.shadowColor,
//                                       fontWeight: FontWeight.w600))),
//                           Padding(
//                               padding: EdgeInsets.symmetric(
//                                   vertical: hp.height / 64),
//                               child: Text("Enter your credentials to continue",
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       color: hp.theme.canvasColor))),
//                           // Padding(
//                           //     padding: EdgeInsets.only(
//                           //         top: hp.height / 50, bottom: hp.height / 50),
//                           //     child: TextFormField(
//                           //       validator: (value) {
//                           //         if (value.isEmpty) {
//                           //           return "Please enter phone number/email id";
//                           //         } else {
//                           //           if (int.tryParse(ec.text) == null) {
//                           //             if (!hp.isEmail(ec.text)) {
//                           //               return "Please enter a valid email id";
//                           //             }
//                           //           }
//                           //         }
//                           //       },
//                           //       autovalidateMode:
//                           //           AutovalidateMode.onUserInteraction,
//                           //       controller: ec,
//                           //       style: TextStyle(
//                           //           color: hp.theme.secondaryHeaderColor),
//                           //       decoration: InputDecoration(
//                           //           enabledBorder: const OutlineInputBorder(
//                           //             borderRadius: BorderRadius.all(
//                           //                 Radius.circular(5.0)),
//                           //             // borderSide: BorderSide(color: Colors.red, width: 2),
//                           //           ),
//                           //           focusedBorder: const OutlineInputBorder(
//                           //             borderRadius: BorderRadius.all(
//                           //                 Radius.circular(5.0)),
//                           //             //borderSide: BorderSide(color: Colors.red),
//                           //           ),
//                           //           filled: true,
//                           //           fillColor: hp.theme.cardColor,
//                           //           hintStyle: TextStyle(
//                           //               color: hp.theme.primaryColorLight),
//                           //           // enabledBorder:const OutlineInputBorder(),
//                           //           prefixIcon: Icon(
//                           //               Icons.account_circle_outlined,
//                           //               color: hp.theme.primaryColorLight),
//                           //           contentPadding: EdgeInsets.only(
//                           //               left: hp.width / 40,
//                           //               top: hp.height / 50,
//                           //               bottom: hp.height / 50),
//                           //           border: InputBorder.none,
//                           //           hintText: "Email"),
//                           //       keyboardType: TextInputType.emailAddress,
//                           //     )),

//                           Padding(
//                               padding: EdgeInsets.only(
//                                   top: hp.height / 50, bottom: hp.height / 50),
//                               child: TextField(
//                                 controller: ec,
//                                 style: TextStyle(
//                                     color: hp.theme.secondaryHeaderColor),
//                                 decoration: InputDecoration(
//                                     enabledBorder: const OutlineInputBorder(
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(5.0)),
//                                     ),
//                                     focusedBorder: const OutlineInputBorder(
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(5.0)),
//                                     ),
//                                     filled: true,
//                                     fillColor: hp.theme.cardColor,
//                                     hintStyle: TextStyle(
//                                         color: hp.theme.primaryColorLight),
//                                     // enabledBorder:const OutlineInputBorder(),
//                                     prefixIcon: Icon(
//                                         Icons.account_circle_outlined,
//                                         color: hp.theme.primaryColorLight),
//                                     contentPadding: EdgeInsets.only(
//                                         left: hp.width / 40,
//                                         top: hp.height / 50,
//                                         bottom: hp.height / 50),
//                                     border: InputBorder.none,
//                                     hintText: "Email"),
//                                 keyboardType: TextInputType.emailAddress,
//                               )),

//                           TextFormField(
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return "Please enter password";
//                                 }
//                               },
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction,
//                               controller: pc,
//                               style: TextStyle(
//                                   color: hp.theme.secondaryHeaderColor),
//                               decoration: InputDecoration(
//                                   suffixIcon: IconButton(
//                                       onPressed: controller.hideOrRevealText,
//                                       icon: Icon(
//                                           controller.hideText
//                                               ? Icons.visibility_off_outlined
//                                               : Icons.visibility,
//                                           color: hp.theme.primaryColorLight)),
//                                   filled: true,
//                                   enabledBorder: const OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(5.0)),
//                                     // borderSide: BorderSide(color: Colors.red, width: 2),
//                                   ),
//                                   focusedBorder: const OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(5.0)),
//                                     //borderSide: BorderSide(color: Colors.red),
//                                   ),
//                                   fillColor: hp.theme.cardColor,
//                                   hintStyle: TextStyle(
//                                       color: hp.theme.primaryColorLight),
//                                   // enabledBorder: OutlineInputBorder(),
//                                   prefixIcon: Icon(Icons.lock_outlined,
//                                       color: hp.theme.primaryColorLight),
//                                   contentPadding: EdgeInsets.only(
//                                       left: hp.width / 40,
//                                       top: hp.height / 50,
//                                       bottom: hp.height / 50),
//                                   border: InputBorder.none,
//                                   hintText: "Password"),
//                               obscureText: controller.hideText,
//                               obscuringCharacter: "*"),
//                           GestureDetector(
//                               child: Padding(
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: hp.height / 30),
//                                   child: Text("Forgot your password?",
//                                       style: TextStyle(
//                                           color: hp.theme.primaryColorLight))),
//                               onTap: () async {
//                                 setState(() {});
//                                 /*Navigator.push(
//                                     hp.context,
//                                     MaterialPageRoute(
//                                       builder: (context) =>
//                                       const Dummy(),
//                                     ));*/
//                                 hp.goToRoute("/mobileLogin");
//                               }),
//                           SizedBox(
//                             width: double.infinity,
//                             child: MyButton(
//                                 label: "Sign In",
//                                 labelWeight: FontWeight.w500,
//                                 onPressed: () async {
//                                   String token = await FirebaseMessaging
//                                       .instance
//                                       .getToken();

//                                   FocusScope.of(context)
//                                       .requestFocus(FocusNode());
//                                   final prefs = await controller.sharedPrefs;
//                                   if (_formKey.currentState.validate()) {
//                                     if (int.tryParse(ec.text) == null
//                                         ? hp.isEmail(ec.text)
//                                         : true) {
//                                       setState(() {
//                                         flag = false;
//                                       });
//                                       Map<String, dynamic> body = {
//                                         "user": ec.text,
//                                         "password": pc.text,
//                                         "deviceToken": token,
//                                         "appType": Platform.isAndroid
//                                             ? "ANDROID"
//                                             : (Platform.isIOS
//                                                 ? "IOS"
//                                                 : "BROWSER")
//                                       };
//                                       controller
//                                           .waitForLogin(body)
//                                           .then((value) {
//                                         //print("value    $value");
//                                         setState(() {
//                                           flag = true;
//                                           //print("flaggggg    $flag");
//                                         });
//                                       });
//                                       /* DataConnectionStatus netStatus =
//                                           await InternetChecker.checkInternet();
//                                       if (netStatus ==
//                                           DataConnectionStatus.connected) {

//                                       }else{
//                                         Helper.showToast("No Internet");
//                                         setState(() {
//                                           flag = false;
//                                         });
//                                       }*/
//                                     }
//                                   } /*else {
//                                     final p = await Fluttertoast.showToast(
//                                             msg: ec.text.isEmpty && pc.text.isEmpty
//                                                 ? " Please Provide Your Email and Password"
//                                                 : (pc.text.isEmpty
//                                                     ? "Please Provide your Password"
//                                                     : (ec.text.isEmpty ||
//                                                             !hp.isEmail(ec.text)
//                                                         ? "Please Provide your valid email"
//                                                         : ""))) ??
//                                         false;
//                                     if (p) ;
//                                   }*/
//                                   //Future.delayed(const Duration(milliseconds: 500), () {
//                                   //Navigator.pop(dialogContext!);
//                                   //});
//                                 },
//                                 heightFactor: 50,
//                                 widthFactor: 3.2,
//                                 radiusFactor: 160),
//                           ),
//                           GestureDetector(
//                             child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical: hp.height / 7),
//                                 child: Row(
//                                     children: [
//                                       Text("Don't have an Account? ",
//                                           style: TextStyle(
//                                               color: hp.theme
//                                                   .unselectedWidgetColor)),
//                                       Text("Sign Up",
//                                           style: TextStyle(
//                                               color: hp.theme.shadowColor))
//                                     ],
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.center)),
//                             onTap: () async {
//                               // hp.goToRouteWithNoWayBack("/register", true);
//                               hp.goToRoute("/register");
//                             },
//                           )
//                         ],
//                       ),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: hp.width / 10)),
//                 flag
//                     ? Container()
//                     : Container(
//                         height: hp.height,
//                         width: hp.width,
//                         color: Colors.black87,
//                         child: const SpinKitFoldingCube(color: Colors.white),
//                       )
//               ],
//             ),
//             appBar: AppBar(
//                 leading: Container(),
//                 backgroundColor: hp.theme.primaryColor,
//                 foregroundColor: hp.theme.secondaryHeaderColor)));
//   }

//   void didChange(GetBuilderState<UserController> state) {
//     state.controller.hp.lockScreenRotation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state =
//         context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
//             GetBuilderState<UserController>();
//     return GetBuilder<UserController>(
//         didChangeDependencies: didChange,
//         builder: pageBuilder,
//         init: UserController(context, state));
//   }
// }
