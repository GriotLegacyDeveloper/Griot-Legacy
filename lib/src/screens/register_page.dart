import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';
import 'package:griot_legacy_social_media_app/src/widgets/gender_grid_widget.dart';
import 'package:griot_legacy_social_media_app/src/widgets/my_button.dart';
import 'package:griot_legacy_social_media_app/src/widgets/my_country_picker.dart';

import '../helpers/helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool buildFlag = true;
  String localDateKey = "";
  bool loaderFlag = true;

  Widget pageBuilder(UserController controller) {
    final hp = controller.hp;
    if (buildFlag) {
      controller.phc.clear();
      controller.nationCode = "+1";
      buildFlag = false;
    }
    return WillPopScope(
        child: SafeArea(
            top: false,
            bottom: false,
            child: Scaffold(
                backgroundColor: hp.theme.primaryColor,
                body: Stack(
                  children: [
                    SingleChildScrollView(
                        child: Form(
                            child: Column(children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: 64, bottom: hp.height / 160),
                                  child: Center(
                                      child: Text("Create New Account",
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: hp.theme.shadowColor,
                                              fontWeight: FontWeight.w600)))),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: hp.height / 160,
                                      bottom: hp.height / 25),
                                  child: Center(
                                      child: Text(
                                          "Enter your credentials to continue",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: hp.theme.shadowColor)))),
                              TextFormField(
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  validator: hp.validateName,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[a-zA-Z ]'))
                                  ],
                                  maxLength: 60,
                                  decoration: InputDecoration(
                                      counterText: "",
                                      enabledBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        // borderSide: BorderSide(color: Colors.red, width: 2),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        //borderSide: BorderSide(color: Colors.red),
                                      ),
                                      filled: true,
                                      fillColor: hp.theme.cardColor,
                                      hintStyle: TextStyle(
                                          color: hp.theme.primaryColorLight),
                                      prefixIcon: Icon(Icons.person_outline,
                                          color: hp.theme.primaryColorLight),
                                      contentPadding: EdgeInsets.only(
                                          left: hp.width / 40,
                                          top: hp.height / 50,
                                          bottom: hp.height / 50),
                                      border: InputBorder.none,
                                      hintText: "Name *"),
                                  style: TextStyle(
                                      color: hp.theme.secondaryHeaderColor),
                                  keyboardType: TextInputType.name,
                                  controller: controller.nc),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: hp.height / 50),
                                  child: TextFormField(
                                     autocorrect: false,
                                  enableSuggestions: false,
                                      validator: (value) {
                                        if ((controller.ec.text.isEmpty ==
                                                true) &&
                                            (controller.phc.text.isEmpty ==
                                                true)) {
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
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp('[a-zA-Z0-9@.]'))
                                      ],
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      maxLength: 70,
                                      decoration: InputDecoration(
                                          counterText: "",
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                            // borderSide: BorderSide(color: Colors.red, width: 2),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
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
                                      controller: controller.ec)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: MyCountryCodePicker(
                                        dialogBackgroundColor:
                                            hp.theme.secondaryHeaderColor,
                                        boxDecoration: BoxDecoration(
                                            color:
                                                hp.theme.secondaryHeaderColor,
                                            border: Border.all(
                                                color: hp.theme
                                                    .secondaryHeaderColor)),
                                        initialSelection: controller.nationCode,
                                        onChanged:
                                            controller.onChangedNationCode,
                                        backgroundColor: hp.theme.cardColor,
                                        barrierColor:
                                            hp.theme.primaryColorLight,
                                        textStyle: TextStyle(
                                            color:
                                                hp.theme.secondaryHeaderColor),
                                        tc: controller.ccc),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                          autocorrect: false,
                                          enableSuggestions: false,
                                          maxLength: 12,
                                          validator: (value) {
                                            if ((value.isEmpty) &&
                                                (controller.ec.text.isEmpty ==
                                                    true)) {
                                              return "Please enter mobile number";
                                            } else if ((value.length < 6) &&
                                                (value.isEmpty == false)) {
                                              return "Please enter valid mobile number";
                                            } else {
                                              return "";
                                            }
                                          },
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp('[0-9]'))
                                          ],
                                          decoration: InputDecoration(
                                            counterText: "",
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0)),
                                                // borderSide: BorderSide(color: Colors.red, width: 2),
                                              ),
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0)),
                                                //borderSide: BorderSide(color: Colors.red),
                                              ),
                                              filled: true,
                                              fillColor: hp.theme.cardColor,
                                              hintStyle: TextStyle(
                                                  color: hp
                                                      .theme.primaryColorLight),
                                              prefixIcon: Icon(
                                                  Icons.call_outlined,
                                                  color: hp
                                                      .theme.primaryColorLight),
                                              contentPadding: EdgeInsets.only(
                                                  left: hp.width / 40,
                                                  top: hp.height / 50,
                                                  bottom: hp.height / 50),
                                              border: InputBorder.none,
                                              hintText: "Mobile Number *"),
                                          style: TextStyle(
                                              color: hp
                                                  .theme.secondaryHeaderColor),
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          controller: controller.phc),
                                    ),
                                  ),
                                ],
                              ),

                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: hp.height / 64),
                                  child: TextFormField(
                                      autocorrect: false,
                                      enableSuggestions: false,
                                      validator: hp.validateDate,
                                      readOnly: true,
                                      onTap: () async {
                                        final dt = await hp.getDatePicker(
                                            controller.dobc,
                                            true,
                                            controller.dobForServer);
                                      },
                                      decoration: InputDecoration(
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                            // borderSide: BorderSide(color: Colors.red, width: 2),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                            //borderSide: BorderSide(color: Colors.red),
                                          ),
                                          filled: true,
                                          fillColor: hp.theme.cardColor,
                                          suffixIcon: IconButton(
                                              icon: Icon(
                                                  Icons.date_range_outlined,
                                                  color: hp.theme
                                                      .secondaryHeaderColor),
                                              onPressed: () async {
                                                // ignore: avoid_print
                                               // print("Hi");
                                                final dt =
                                                    await hp.getDatePicker(
                                                        controller.dobc,
                                                        true,
                                                        controller
                                                            .dobForServer);
                                                hp.validateDate(
                                                    controller.dobc.text);
                                              }),
                                          hintStyle: TextStyle(
                                              color:
                                                  hp.theme.primaryColorLight),
                                          prefixIcon: Icon(Icons.cake_outlined,
                                              color:
                                                  hp.theme.primaryColorLight),
                                          contentPadding: EdgeInsets.only(
                                              left: hp.width / 40,
                                              top: hp.height / 50,
                                              bottom: hp.height / 50),
                                          border: InputBorder.none,
                                          hintText: "Date Of Birth *"),
                                      style: TextStyle(
                                          color: hp.theme.secondaryHeaderColor),
                                      keyboardType: TextInputType.datetime,
                                      controller: controller.dobc)),
                              Padding(
                                padding:
                                    EdgeInsets.only(bottom: hp.height / 70),
                                child: Text("Gender:",
                                    style: TextStyle(
                                        color: hp.theme.secondaryHeaderColor)),
                              ),
                              SizedBox(
                                  child: const GenderGridWidget(),
                                  height: hp.height / 15,
                                  width: double.infinity),
                              Visibility(
                                visible: false,
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: hp.height / 50,
                                        top: hp.height / 50),
                                    child: Text("Relationship Status: *",
                                        style: TextStyle(
                                            color:
                                                hp.theme.secondaryHeaderColor))),
                              ),
                              Visibility(
                                visible: false,
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(bottom: hp.height / 64),
                                    child: DropdownButtonFormField<String>(
                                        dropdownColor: hp.theme.cardColor,
                                        decoration: InputDecoration(
                                            enabledBorder:
                                                const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0)),
                                              // borderSide: BorderSide(color: Colors.red, width: 2),
                                            ),
                                            focusedBorder:
                                                const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0)),
                                              //borderSide: BorderSide(color: Colors.red),
                                            ),
                                            filled: true,
                                            fillColor: hp.theme.cardColor,
                                            hintStyle: TextStyle(
                                                color:
                                                    hp.theme.primaryColorLight),
                                            contentPadding: EdgeInsets.only(
                                                left: hp.width / 40,
                                                top: hp.height / 50,
                                                bottom: hp.height / 50),
                                            border: InputBorder.none,
                                            hintText: "Relationship"),
                                        value: controller.relationshipStatus,
                                        onChanged:
                                            controller.onChangedRelationStatus,
                                        items: <String>[
                                          "SINGLE",
                                          "RELATIONSHIP",
                                          "MARRIED",
                                          "DIVORCED"
                                        ]
                                            .map((e) => DropdownMenuItem<String>(
                                                onTap: () {
                                                  controller
                                                      .onChangedRelationStatus(e);
                                                },
                                                value: e,
                                                child: Text(e.capitalizeFirst,
                                                    style: TextStyle(
                                                        color: hp.theme
                                                            .secondaryHeaderColor))))
                                            .toList())),
                              ),

                              Padding(
                                padding: EdgeInsets.only(
                                    top: hp.height / 50),
                                child: TextFormField(
                                    autocorrect: false,
                                    enableSuggestions: false,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Please enter password";
                                      } else {
                                        return "";
                                      }
                                    },
                                    maxLength: 20,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(
                                          RegExp('[ ]'))
                                    ],
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                        counterText: "",
                                        contentPadding: EdgeInsets.only(
                                            left: hp.width / 40,
                                            top: hp.height / 50,
                                            bottom: hp.height / 50),
                                        // border: InputBorder.none,
                                        // suffixIcon: Icon(Icons.visibility_off_outlined,
                                        //     color: hp.theme.primaryColorLight),
                                        filled: true,
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          // borderSide: BorderSide(color: Colors.red, width: 2),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          //borderSide: BorderSide(color: Colors.red),
                                        ),
                                        fillColor: hp.theme.cardColor,
                                        hintStyle: TextStyle(
                                            color: hp.theme.primaryColorLight),
                                        prefixIcon: Icon(Icons.lock_outlined,
                                            color: hp.theme.primaryColorLight),
                                        hintText: "Password *"),
                                    style: TextStyle(
                                        color: hp.theme.secondaryHeaderColor),
                                    obscureText: true,
                                    obscuringCharacter: "*",
                                    controller: controller.pc),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: hp.height / 50,
                                      bottom: hp.height / 20),
                                  child: TextFormField(
                                      autocorrect: false,
                                      enableSuggestions: false,
                                      validator: (str) => str != null &&
                                              str.isNotEmpty &&
                                              controller.pc.text == str
                                          ? null
                                          : "Passwords don't Match",
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(
                                            RegExp('[ ]'))
                                      ],
                                      maxLength: 20,
                                      decoration: InputDecoration(
                                          counterText: "",
                                          contentPadding: EdgeInsets.only(
                                              left: hp.width / 40,
                                              top: hp.height / 50,
                                              bottom: hp.height / 50),
                                          //border: InputBorder.none,
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                            // borderSide: BorderSide(color: Colors.red, width: 2),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                            //borderSide: BorderSide(color: Colors.red),
                                          ),
                                          // suffixIcon: Icon(Icons.visibility_off_outlined,
                                          //     color: hp.theme.primaryColorLight),
                                          filled: true,
                                          fillColor: hp.theme.cardColor,
                                          hintStyle: TextStyle(
                                              color:
                                                  hp.theme.primaryColorLight),
                                          prefixIcon: Icon(Icons.lock_outlined,
                                              color:
                                                  hp.theme.primaryColorLight),
                                          hintText: "Confirm Password *"),
                                      style: TextStyle(
                                          color: hp.theme.secondaryHeaderColor),
                                      obscureText: true,
                                      obscuringCharacter: "*",
                                      controller: controller.cpc)),
                              SizedBox(
                                  width: double.infinity,
                                  child: MyButton(
                                      label: "Sign Up",
                                      labelWeight: FontWeight.w500,
                                      onPressed: () async {
                                        FocusScope.of(context).requestFocus(FocusNode());
                                        bool flag = true;
                                        if (/*controller.formKey*/ _formKey
                                                .currentState
                                                .validate() &&
                                            flag) {
                                          //print("jjj");
                                          if (!(controller.nc.text.isEmpty ||
                                                  controller
                                                      .dobc.text.isEmpty ||
                                                  controller.pc.text.isEmpty ||
                                                  controller.cpc.text.isEmpty ||
                                                  controller.pc.text !=
                                                      controller.cpc.text) &&
                                              !(controller.ec.text.isEmpty &&
                                                  controller
                                                      .phc.text.isEmpty) &&
                                              controller.flags.contains(true) &&
                                              flag) {
                                          } else {}
                                        } else {
                                          String genderValue = "";
                                          if (controller
                                              .genders[controller.genderIndex]  != "" ) {
                                            setState(() {
                                              if (controller
                                                  .genders[controller.genderIndex] == "NON BINARY") {

                                                setState(() {
                                                  controller.genders[controller.genderIndex] =
                                                  "NON_BINARY";
                                                });
                                              } else if (controller
                                                  .genders[controller.genderIndex] ==
                                                  "PREFER NOT TO REVEAL IT") {
                                                genderValue = "PREFER_NOT_TO_REVEAL_IT";
                                                controller
                                                    .genders[controller.genderIndex] =
                                                    "PREFER_NOT_TO_REVEAL_IT";
                                              } else if (controller
                                                  .genders[controller.genderIndex] ==
                                                  "FEMALE") {
                                                genderValue = "FEMALE";

                                                controller
                                                    .genders[controller.genderIndex] = "FEMALE";
                                              } else if (controller
                                                  .genders[controller.genderIndex] ==
                                                  "MALE") {
                                                genderValue = "MALE";

                                                controller
                                                    .genders[controller.genderIndex] = "MALE";
                                              }
                                              /*controller.gender =
                                                  controller.genders[controller
                                                      .flags
                                                      .indexOf(true)];*/
                                            });
                                          } else {
                                            Helper.showToast("Select gender");
                                          }

                                          Map<String, dynamic> body = {
                                            "email": controller.ec.text,
                                            "fullName": controller.nc.text,
                                            "password": controller.pc.text,
                                            "confirmPassword": controller.cpc.text,
                                            "dateOfBirth": controller.dobForServer.text,
                                            "gender": controller.genders[controller.genderIndex],
                                            "countryCode": controller.ccc.text,
                                            "phone": controller.phc.text
                                          };
                                         // print(body);
                                          setState(() {
                                            loaderFlag = false;
                                          });
                                       //   print(body);
                                          controller.waitUntilRegister(body).then((value) {
                                            setState(() {
                                              loaderFlag = true;
                                              controller.phc.clear();
                                              controller.ccc.clear();
                                            });
                                          });
                                        }
                                      },
                                      heightFactor: 50,
                                      widthFactor: 3.2,
                                      radiusFactor: 160)),
                              GestureDetector(
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: hp.height / 20),
                                    child: Row(
                                        children: [
                                          Text("Already have an Account? ",
                                              style: TextStyle(
                                                  color: hp.theme
                                                      .unselectedWidgetColor)),
                                          Text("Sign In",
                                              style: TextStyle(
                                                  color: hp.theme.shadowColor))
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.center)),
                                onTap: () async {
                                  // _formKey.currentState.reset();
                                  // hp.goToRouteWithNoWayBack("/login", false);
                                  Navigator.pop(context);
                                },
                              )
                            ], crossAxisAlignment: CrossAxisAlignment.start),
                            key: /*controller.formKey*/ _formKey),
                        padding:
                            EdgeInsets.symmetric(horizontal: hp.width / 20)),
                    loaderFlag
                        ? Container()
                        : Container(
                            height: hp.height,
                            width: hp.width,
                            color: Colors.black87,
                            child:
                                const SpinKitFoldingCube(color: Colors.white),
                          )
                  ],
                ))),
        onWillPop: () async {
          bool flag = false;
          hp.goToRouteWithNoWayBack("/login", flag);
          return Future.value(flag);
        });
  }

  void didChange(GetBuilderState<UserController> state) {
    state.controller.hp.lockScreenRotation();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    return GetBuilder<UserController>(
        autoRemove: false,
        builder: pageBuilder,
        init: UserController(context, state),
        didChangeDependencies: didChange);
  }
}
