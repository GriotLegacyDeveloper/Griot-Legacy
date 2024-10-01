import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';
import 'package:griot_legacy_social_media_app/src/helpers/helper.dart';
import 'package:griot_legacy_social_media_app/src/screens/otp_verification_page.dart';
import 'package:griot_legacy_social_media_app/src/utils/constant_class.dart';
import 'package:griot_legacy_social_media_app/src/widgets/my_button.dart';
import 'package:griot_legacy_social_media_app/src/widgets/icon_image_widget.dart';
import 'package:griot_legacy_social_media_app/src/widgets/my_country_picker.dart';

class MobileLoginPage extends StatefulWidget {
  const MobileLoginPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MobileLoginPageState();
  }
}

class MobileLoginPageState extends State<MobileLoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool flag = true;
  bool buildFlag = true;
  bool isPhoneNumber = true;
  final TextEditingController phoneNoController = TextEditingController();

  Widget pageBuilder(UserController con) {
    final hp = con.hp;
    if (buildFlag) {
      con.phc.clear();
      con.nationCode="+1";

      buildFlag = false;
    }
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
                      child: Padding(
                        padding: EdgeInsets.only(top: hp.height * 0.09),
                        child: Column(
                          children: [
                            SizedBox(
                                height: hp.height * 0.16,
                                child: const IconImageWidget(
                                  imagePath: "assets/images/mobile-otp-icon.svg",
                                )),
                            Padding(
                              padding: EdgeInsets.only(top: hp.height * 0.03),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: hp.height / 40),
                              child: Text("Enter Mobile Number\nOr Email id",
                                  style: TextStyle(
                                    height: 1.3,
                                      fontSize: hp.height * 0.028,
                                      color: hp.theme.secondaryHeaderColor,
                                      fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                           /* Padding(
                              // ignore: prefer_const_constructors
                              padding: EdgeInsets.only(top: 5),
                              child: Text("Or Email id",
                                  style: TextStyle(
                                      fontSize: hp.height * 0.028,
                                      color: hp.theme.secondaryHeaderColor,
                                      fontWeight: FontWeight.w600)),
                            ),*/
                            Padding(
                                padding: EdgeInsets.only(
                                    top: hp.height / 80,),
                                child: Text(
                                    "Enter Credentials & You will get OTP",
                                    style: TextStyle(
                                        color: hp.theme.secondaryHeaderColor))),
                            Padding(
                              padding:  EdgeInsets.only(top: hp.height /25 ),
                              child: !isPhoneNumber
                                  ? Container()
                                  : MyCountryCodePicker(
                                      dialogBackgroundColor:
                                          hp.theme.secondaryHeaderColor,
                                      boxDecoration: BoxDecoration(
                                          color: hp.theme.secondaryHeaderColor,
                                          border: Border.all(
                                              color:
                                                  hp.theme.secondaryHeaderColor)),
                                      initialSelection: con.nationCode,
                                      onChanged: con.onChangedNationCode,
                                      backgroundColor: hp.theme.cardColor,
                                      barrierColor: hp.theme.primaryColorLight,
                                      textStyle: TextStyle(
                                          color: hp.theme.secondaryHeaderColor),
                                      tc: con.ccc),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: hp.height / 60, bottom: hp.height / 20),
                              child: TextFormField(
                                 autocorrect: false,
                                  enableSuggestions: false,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Please enter email id/phone number";
                                    }
                                  },
                                  onChanged: (value) {
                                    if (int.tryParse(value) == null) {
                                      if (value.isNotEmpty) {
                                        setState(() {
                                          isPhoneNumber = false;
                                        });
                                      } else {
                                        setState(() {
                                          isPhoneNumber = true;
                                        });
                                      }
                                    }
                                  },
                                  style: const TextStyle(color: Colors.white),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                        // borderSide: BorderSide(color: Colors.red, width: 2),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                        //borderSide: BorderSide(color: Colors.red),
                                      ),
                                      filled: true,
                                      fillColor: hp.theme.cardColor,
                                      contentPadding: EdgeInsets.only(
                                          left: hp.width / 40,
                                          top: hp.height / 50,
                                          bottom: hp.height / 50),
                                      hintStyle: TextStyle(
                                          color: hp.theme.primaryColorLight),
                                      // enabledBorder: OutlineInputBorder(),
                                      prefixIcon: Icon(
                                          !isPhoneNumber
                                              ? Icons.mail_outline
                                              : Icons.call_outlined,
                                          color: hp.theme.primaryColorLight),
                                      border: InputBorder.none,
                                      hintText: "Email/Mobile Number"),
                                 // keyboardType: TextInputType.emailAddress,
                                  controller: con.phc),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: MyButton(
                                  label: "Submit",
                                  labelWeight: FontWeight.w500,
                                  onPressed: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        flag = false;
                                      });
                                      String user = "";
                                      if (!isPhoneNumber) {
                                        if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                .hasMatch(con.phc.text) ==
                                            false) {
                                          Helper.showToast("Please enter valid email id");
                                         /* EasyLoading.showToast(
                                              "Please enter valid email id");*/
                                        } else {
                                          user = con.phc.text;
                                        }
                                      } else {
                                        if ((con.phc.text.length > 12) ||
                                            (con.phc.text.length < 6)) {
                                          Helper.showToast("Please enter valid mobile number");
                                       /*   EasyLoading.showToast(
                                              "Please enter valid mobile number");*/
                                        } else {
                                          user = /*con.nationCode +*/ con.phc.text;
                                        }
                                      }
                                      // if (user == "") {
                                      //   EasyLoading.showToast(
                                      //       "Please enter credentials");
                                      // } else if (con.phc.text == "") {
                                      //   EasyLoading.showToast(
                                      //       "Please enter email/ mobile");
                                      // } else {

                                      // }
                                      Map<String, dynamic> body = {
                                        "user": user,
                                      };
                                      String url =Constant.FORGOT_PASSWORD_URL;
                                          //"https://nodeserver.mydevfactory.com:2109/api/" + "user/forgotPassword";
                                      con
                                          .waitUntilGetOtp(body, url)
                                          .then((value) {
                                        setState(() {
                                          flag = true;
                                          con.phc.clear();
                                          con.nationCode=="+1";
                                        });
                                        if (value) {

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OTPVerificationPage(
                                                  emailPhone: con.phc.text,
                                                  api: "fpVerifyUser",
                                                      userId: "",
                                                      sId: "",
                                                ),
                                              ));
                                          // print("value: " + value.toString());
                                          _formKey.currentState.reset();
                                        }
                                      });
                                    }
                                  },
                                  heightFactor: 50,
                                  widthFactor: 4,
                                  radiusFactor: 160),
                            )
                          ],
                        ),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: hp.width / 8)),
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
              title: const Text("Forgot Your Password?"),
              backgroundColor: hp.theme.primaryColor,
              foregroundColor: hp.theme.secondaryHeaderColor,
            )));
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
        builder: pageBuilder,
        didChangeDependencies: didChange,
        init: UserController(context, state));
  }
}
