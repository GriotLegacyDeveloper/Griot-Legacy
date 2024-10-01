import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';
import 'package:griot_legacy_social_media_app/src/widgets/my_button.dart';

import '../../size_config.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key key}) : super(key: key);

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final email=TextEditingController();
  final name=TextEditingController();
  final message=TextEditingController();
  FocusNode emailFocus=FocusNode();
  FocusNode nameFocus=FocusNode();
  FocusNode messageFocus=FocusNode();
  final _formKey = GlobalKey<FormState>();

  UserController controller;
  bool loaderFlag=true;

  Widget pageBuilder(UserController con) {
    final hp = con.hp;
    hp.lockScreenRotation();
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
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        child: Column(
                          children: [
                            const Divider(
                              color: Colors.grey,
                            ),
                            Padding(padding: EdgeInsets.only(top: hp.height * 0.02)),
                            Card(
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: hp.width / 32,
                                        vertical: hp.height / 64),
                                    child: Column(children: [
                                      Padding(
                                          padding:
                                              EdgeInsets.only(bottom: hp.height / 64),
                                          child: Text(
                                              "You can contact us on the following email address:",
                                              style: TextStyle(
                                                  color:
                                                      hp.theme.secondaryHeaderColor))),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Row(
                                                  children: [
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        right: hp.width / 50),
                                                    child: CircleAvatar(
                                                        child: IconButton(
                                                            icon: const Icon(
                                                                Icons.mail_outline),
                                                            onPressed: () {}),
                                                        backgroundColor: hp
                                                            .theme.secondaryHeaderColor,
                                                        foregroundColor:
                                                            hp.theme.cardColor)),
                                                Expanded(
                                                    child: Text("admin@griotlegacy.com",
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: hp.theme
                                                                .secondaryHeaderColor)))
                                              ],
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween)),
                                          /*const SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                              child: Row(
                                                  children: [
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        right: hp.width / 50),
                                                    child: CircleAvatar(
                                                        child: IconButton(
                                                            icon: const Icon(
                                                                Icons.call_outlined),
                                                            onPressed: () {}),
                                                        backgroundColor: hp
                                                            .theme.secondaryHeaderColor,
                                                        foregroundColor:
                                                            hp.theme.cardColor)),
                                                Expanded(
                                                    child: Text("+1 00000000",
                                                        style: TextStyle(
                                                            color: hp.theme
                                                                .secondaryHeaderColor)))
                                              ],
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween))*/
                                        ],
                                      )
                                    ])),
                                margin: EdgeInsets.only(bottom: hp.height / 64)),
                            Center(
                                child: Text("Connect with us",
                                    style: TextStyle(
                                        color: hp.theme.secondaryHeaderColor))),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: hp.height / 50),
                                child: TextFormField(
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  controller: name,
                                  focusNode: nameFocus,
                                  validator: hp.validateName,
                                  autovalidateMode:

                                  AutovalidateMode.onUserInteraction,
                                 inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9 ]'))],
                                  style: const TextStyle(color: Colors.white),
                                  maxLength: 60,
                                  decoration: InputDecoration(
                                    counterText: "",
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

                                      hintStyle:
                                          TextStyle(color: hp.theme.primaryColorLight),
                                      // enabledBorder: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.person_outline,
                                          color: hp.theme.primaryColorLight),
                                      border: const OutlineInputBorder(),
                                      hintText: "Name"),
                                  keyboardType: TextInputType.name,
                                )),
                            TextFormField(
                              autocorrect: false,
                               enableSuggestions: false,
                              validator: (value) {
                                if (email.text.isEmpty == true) {
                                  return 'Please enter email ';
                                } else if ((value.isEmpty == false) &&
                                    (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value) ==
                                        false)) {
                                  return 'Please enter valid email id ';
                                } else {
                                  return "";
                                }
                              },
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              controller: email,
                              focusNode: emailFocus,
                              maxLength: 50,
                              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9@.]'))],

                              decoration: InputDecoration(
                                counterText: "",
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
                                  hintStyle: TextStyle(
                                      color:
                                      hp.theme.primaryColorLight),
                                  prefixIcon: Icon(Icons.mail_outline,
                                      color:
                                      hp.theme.primaryColorLight),
                                  contentPadding: EdgeInsets.only(
                                      left: hp.width / 40,
                                      top: hp.height / 50,
                                      bottom: hp.height / 50),
                                  border: InputBorder.none,
                                  hintText: "Email *"),
                              style: TextStyle(
                                  color: hp.theme.secondaryHeaderColor),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: hp.height / 50, bottom: hp.height / 40),
                                child: TextField(
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  controller: message,
                                  focusNode: messageFocus,
                                  maxLines: 10,
                                  style: const TextStyle(color: Colors.white),

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
                                      hintStyle:
                                          TextStyle(color: hp.theme.primaryColorLight),
                                      // enabledBorder: OutlineInputBorder(),
                                      // prefixIcon: Icon(Icons.call_outlined,
                                      //     color: hp.theme.primaryColorLight),
                                      border: const OutlineInputBorder(),
                                      hintText: "Enter Your Message Here"),
                                  keyboardType: TextInputType.multiline,
                                )),
                            MyButton(
                                label: "Submit",
                                labelWeight: FontWeight.w500,
                                onPressed: () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                  bool flag = true;
                                  final prefs = await con.sharedPrefs;
                                  if(name.text==""){
                                    flag=false;
                                    ScaffoldMessenger.of(context).showSnackBar((const SnackBar(content: Text('name email message can not blank',))));

                                  }else if(email.text==""){
                                    flag=false;
                                    ScaffoldMessenger.of(context).showSnackBar((const SnackBar(content: Text('email can not blank',))));

                                  }
                                  else if(message.text==""){
                                    flag=false;
                                    ScaffoldMessenger.of(context).showSnackBar((const SnackBar(content: Text('message can not blank',))));

                                  }
                                  if(flag){
                                    Map<String, dynamic> body = {
                                      "userId": prefs.getString("spUserID"),
                                      "loginId": prefs.getString("spLoginID"),
                                      "appType": prefs.getString("spAppType"),
                                      "name":name.text,
                                      "email":email.text,
                                      "message":message.text,
                                    };
                                    setState(() {
                                      loaderFlag = false;
                                    });
                                    con
                                        .waitUntilContact(body)
                                        .then((value) {
                                      setState(() {
                                        loaderFlag = true;
                                      });
                                    });
                                  }



                                },
                                heightFactor: 40,
                                widthFactor: 2.5,
                                radiusFactor: 100)
                          ],
                        ),
                      ),
                    ),
                    //padding: EdgeInsets.symmetric(horizontal: hp.width / 40)
                ),
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
            appBar: AppBar(
                title: const Text("Contact Us"),
                foregroundColor: hp.theme.secondaryHeaderColor,
                backgroundColor: hp.theme.primaryColor)));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    return pageBuilder(UserController(context, state));
  }
}
