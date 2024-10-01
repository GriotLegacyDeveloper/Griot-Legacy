import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:griot_legacy_social_media_app/src/utils/common_color.dart';
import 'package:griot_legacy_social_media_app/src/widgets/my_country_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../size_config.dart';
import '../controllers/user_controller.dart';
import '../helpers/helper.dart';
import '../models/add_advertisment_response_model.dart';
import '../widgets/my_button.dart';

class AdvertisementAddPage extends StatefulWidget {
  final AdvertisementAddPageInterface mListener;
  const AdvertisementAddPage({Key key, this.mListener}) : super(key: key);

  @override
  _AdvertisementAddPageState createState() => _AdvertisementAddPageState();
}

class _AdvertisementAddPageState extends State<AdvertisementAddPage> {
  UserController controller;
  final companyName = TextEditingController();
  final contactPerson = TextEditingController();
  final email = TextEditingController();
  final countryCode = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final purposeOdAdv = TextEditingController();
  final discription = TextEditingController();
  final link = TextEditingController();
  final title = TextEditingController();
  final validFromController = TextEditingController();
  final validTillController = TextEditingController();
  final targetAudienceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  RangeValues _currentRangeValues = const RangeValues(17, 80);
  bool flag = false;

  String startDate="";
  String endDate="";
  bool buildFlag = true;



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
    if (buildFlag) {
      countryCode.clear();
      phone.clear();
      con.nationCode = "+1";
      buildFlag = false;
    }
    hp.lockScreenRotation();
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: SizeConfig.screenHeight * .03,
              right: SizeConfig.screenWidth * .05,
              left: SizeConfig.screenWidth * .05),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                      autocorrect: false,
                      enableSuggestions: false,
                      validator: (value) =>
                          value.trim().isEmpty ? "Company name required" : null,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          counterText: "",
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
                          filled: true,
                          fillColor: hp.theme.cardColor,
                          hintStyle:
                              TextStyle(color: hp.theme.primaryColorLight),
                          prefixIcon: Image.asset(
                            "assets/images/business.png",
                            scale: 2.5,
                          ),
                          contentPadding: EdgeInsets.only(
                              left: hp.width / 40,
                              top: hp.height / 50,
                              bottom: hp.height / 50),
                          border: InputBorder.none,
                          hintText: "Company Name"),
                      style: TextStyle(color: hp.theme.secondaryHeaderColor),
                      keyboardType: TextInputType.text,
                      controller: companyName),
                  Padding(
                    padding:
                        EdgeInsets.only(top: SizeConfig.screenHeight * .02),
                    child: TextFormField(
                        autocorrect: false,
                        enableSuggestions: false,
                        validator: (value) => value.trim().isEmpty
                            ? "Person name required"
                            : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                       /* inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9 ]'))
                        ],*/
                        decoration: InputDecoration(
                            counterText: "",
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
                            filled: true,
                            fillColor: hp.theme.cardColor,
                            hintStyle:
                                TextStyle(color: hp.theme.primaryColorLight),
                            prefixIcon: Icon(
                              Icons.person_outlined,
                              color: CommonColor.iconCOlor,
                            ),
                            contentPadding: EdgeInsets.only(
                                left: hp.width / 40,
                                top: hp.height / 50,
                                bottom: hp.height / 50),
                            border: InputBorder.none,
                            hintText: "Contact Person"),
                        style: TextStyle(color: hp.theme.secondaryHeaderColor),
                       // keyboardType: TextInputType.text,
                        controller: contactPerson),
                  ),

                  Padding(
                    padding:
                        EdgeInsets.only(top: SizeConfig.screenHeight * .02),
                    child: TextFormField(
                       autocorrect: false,
                       enableSuggestions: false,
                        maxLength: 50,
                      /*  inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp('[a-zA-Z0-9@.]'))
                        ],*/
                        decoration: InputDecoration(
                            counterText: "",
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
                            filled: true,
                            fillColor: hp.theme.cardColor,
                            hintStyle:
                                TextStyle(color: hp.theme.primaryColorLight),
                            prefixIcon: Image.asset(
                              "assets/images/email.png",
                              scale: 2.5,
                            ),
                            contentPadding: EdgeInsets.only(
                                left: hp.width / 40,
                                top: hp.height / 50,
                                bottom: hp.height / 50),
                            border: InputBorder.none,
                            hintText: "Email Address"),
                        style: TextStyle(color: hp.theme.secondaryHeaderColor),
                       // keyboardType: TextInputType.emailAddress,
                        controller: email),
                  ),

                  Padding(
                    padding:
                        EdgeInsets.only(top: SizeConfig.screenHeight * .02),
                    child:Row(
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
                              initialSelection: con.nationCode,
                              onChanged: con.onChangedNationCode,
                              backgroundColor: hp.theme.cardColor,
                              barrierColor:
                              hp.theme.primaryColorLight,
                              textStyle: TextStyle(
                                  color: hp.theme.secondaryHeaderColor),
                              tc: countryCode),
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
                                  if ((value.isEmpty)) {
                                    return "Please enter mobile number";
                                  } else if ((value.length < 6) &&
                                      (value.isEmpty == false)) {
                                    return "Please enter valid mobile number";
                                  } else {
                                    return "";
                                  }
                                },
                                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                    hintText: "Phone Number"),
                                style: TextStyle(
                                    color: hp
                                        .theme.secondaryHeaderColor),
                                keyboardType:TextInputType.number,
                                //keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                controller: phone),
                          ),
                        ),
                      ],
                    ),
                   /* TextFormField(
                        autocorrect: false,
                        enableSuggestions: false,
                        validator: (value) =>
                            value.trim().isEmpty ? "Phone required" : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                        ],
                        maxLength: 14,
                        decoration: InputDecoration(
                            counterText: "",
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
                            filled: true,
                            fillColor: hp.theme.cardColor,
                            hintStyle:
                                TextStyle(color: hp.theme.primaryColorLight),
                            prefixIcon: Image.asset(
                              "assets/images/call.png",
                              scale: 2.5,
                            ),
                            contentPadding: EdgeInsets.only(
                                left: hp.width / 40,
                                top: hp.height / 50,
                                bottom: hp.height / 50),
                            border: InputBorder.none,
                            hintText: "Phone Number"),
                        style: TextStyle(color: hp.theme.secondaryHeaderColor),
                        keyboardType: TextInputType.phone,
                        controller: phone),*/
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: SizeConfig.screenHeight * .02),
                    child: TextFormField(
                        autocorrect: false,
                        enableSuggestions: false,
                        validator: (value) =>
                            value.trim().isEmpty ? "Address required" : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 300,
                        decoration: InputDecoration(
                            counterText: "",
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
                            filled: true,
                            fillColor: hp.theme.cardColor,
                            hintStyle:
                                TextStyle(color: hp.theme.primaryColorLight),
                            prefixIcon: Image.asset(
                              "assets/images/location.png",
                              scale: 2.5,
                            ),
                            contentPadding: EdgeInsets.only(
                                left: hp.width / 40,
                                top: hp.height / 50,
                                bottom: hp.height / 50),
                            border: InputBorder.none,
                            hintText: "Physical Address"),
                        style: TextStyle(color: hp.theme.secondaryHeaderColor),
                       // keyboardType: TextInputType.name,
                        controller: address),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: SizeConfig.screenHeight * .02),
                    child: TextFormField(
                        autocorrect: false,
                        enableSuggestions: false,
                        validator: (value) =>
                            value.trim().isEmpty ? "Purpose required" : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 500,
                        decoration: InputDecoration(
                            counterText: "",
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
                            filled: true,
                            fillColor: hp.theme.cardColor,
                            hintStyle:
                                TextStyle(color: hp.theme.primaryColorLight),
                            prefixIcon: Image.asset(
                              "assets/images/boxs.png",
                              scale: 2.5,
                            ),
                            contentPadding: EdgeInsets.only(
                                left: hp.width / 40,
                                top: hp.height / 50,
                                bottom: hp.height / 50),
                            border: InputBorder.none,
                            hintText: "Purpose of Advertisement"),
                        style: TextStyle(color: hp.theme.secondaryHeaderColor),
//keyboardType: TextInputType.name,
                        controller: purposeOdAdv),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.only(top: SizeConfig.screenHeight * .02),
                      child: Container(
                        decoration: BoxDecoration(
                          color: hp.theme.cardColor,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        height: SizeConfig.screenHeight * .15,
                        child: TextFormField(
                          autocorrect: false,
                          enableSuggestions: false,
                          validator: null,
                          controller: discription,
                          maxLines: null,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              prefixIcon: Image.asset(
                                "assets/images/edit.png",
                                scale: 2.5,
                              ),
                              hintStyle:
                                  TextStyle(color: hp.theme.primaryColorLight),
                              border: InputBorder.none,
                              hintText: "Description"),
                          keyboardType: TextInputType.multiline,
                        ),
                      )),
                  Padding(
                    padding:
                        EdgeInsets.only(top: SizeConfig.screenHeight * .02),
                    child: TextFormField(
                        autocorrect: false,
                        enableSuggestions: false,
                        validator: (value) {
                          if (link.text.isEmpty) {
                            return 'Please enter link ';
                          } else if ((value.isEmpty == false) &&
                              (RegExp(r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)')
                                      .hasMatch(value) ==
                                  false)) {
                            return 'Please enter valid link';
                          } else {
                            return null;
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            counterText: "",
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
                            filled: true,
                            fillColor: hp.theme.cardColor,
                            hintStyle:
                                TextStyle(color: hp.theme.primaryColorLight),
                            prefixIcon: Image.asset(
                              "assets/images/world.png",
                              scale: 2.5,
                            ),
                            contentPadding: EdgeInsets.only(
                                left: hp.width / 40,
                                top: hp.height / 50,
                                bottom: hp.height / 50),
                            border: InputBorder.none,
                            hintText: "Link"),
                        style: TextStyle(color: hp.theme.secondaryHeaderColor),
                        //keyboardType: TextInputType.name,
                        controller: link),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: SizeConfig.screenHeight * .02),
                    child: TextFormField(
                        autocorrect: false,
                        enableSuggestions: false,
                        validator: (value) =>
                            value.trim().isEmpty ? "Please enter title" : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            counterText: "",
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
                            filled: true,
                            fillColor: hp.theme.cardColor,
                            hintStyle:
                                TextStyle(color: hp.theme.primaryColorLight),
                            prefixIcon: Image.asset(
                              "assets/images/boxs.png",
                              scale: 2.5,
                            ),
                            contentPadding: EdgeInsets.only(
                                left: hp.width / 40,
                                top: hp.height / 50,
                                bottom: hp.height / 50),
                            border: InputBorder.none,
                            hintText: "Title"),
                        style: TextStyle(color: hp.theme.secondaryHeaderColor),
                        //keyboardType: TextInputType.name,
                        controller: title),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: SizeConfig.screenHeight * .02),
                    child: TextFormField(
                        autocorrect: false,
                        enableSuggestions: false,
                        readOnly: true,
                        validator: (value) =>
                            value.trim().isEmpty ? "Please enter date" : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 60,
                        onTap: () {
                          datePicker("1");
                        },
                        decoration: InputDecoration(
                            counterText: "",
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
                            filled: true,
                            fillColor: hp.theme.cardColor,
                            hintStyle:
                                TextStyle(color: hp.theme.primaryColorLight),
                            prefixIcon: Image.asset(
                              "assets/images/calender.png",
                              scale: 2.5,
                            ),
                            contentPadding: EdgeInsets.only(
                                left: hp.width / 40,
                                top: hp.height / 50,
                                bottom: hp.height / 50),
                            border: InputBorder.none,
                            hintText: "Start Date"),
                        style: TextStyle(color: hp.theme.secondaryHeaderColor),
                        keyboardType: TextInputType.name,
                        controller: validFromController),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: SizeConfig.screenHeight * .02),
                    child: TextFormField(
                        autocorrect: false,
                        enableSuggestions: false,
                        readOnly: true,
                        validator: (value) =>
                            value.trim().isEmpty ? "Please enter date" : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onTap: () async {
                          datePicker("2");
                        },
                        maxLength: 60,
                        decoration: InputDecoration(
                            counterText: "",
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
                            filled: true,
                            fillColor: hp.theme.cardColor,
                            hintStyle:
                                TextStyle(color: hp.theme.primaryColorLight),
                            prefixIcon: Image.asset(
                              "assets/images/calender.png",
                              scale: 2.5,
                            ),
                            contentPadding: EdgeInsets.only(
                                left: hp.width / 40,
                                top: hp.height / 50,
                                bottom: hp.height / 50),
                            border: InputBorder.none,
                            hintText: "End Date"),
                        style: TextStyle(color: hp.theme.secondaryHeaderColor),
                        keyboardType: TextInputType.name,
                        controller: validTillController),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: SizeConfig.screenHeight * .02,
                        bottom: SizeConfig.screenHeight * .02),
                    child: Row(
                      children: [
                        Text(
                          "Upload Image",
                          style: TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 4.0,
                              color: Colors.white),
                          textScaleFactor: 1.0,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      openGallery();
                    },
                    onDoubleTap: () {},
                    child: Row(
                      children: [
                        _image == null
                            ? Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: CommonColor.textColor,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: SizeConfig.screenWidth * .09,
                                        right: SizeConfig.screenWidth * .09,
                                        top: SizeConfig.screenHeight * .04,
                                        bottom: SizeConfig.screenHeight * .04),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(1.0),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size:
                                                SizeConfig.screenHeight * .015,
                                          ),
                                        ))),
                              )
                            : Container(
                                height: SizeConfig.screenHeight * .1,
                                width: SizeConfig.screenWidth * .25,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: CommonColor.textColor,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Image.file(
                                    File(_image.path),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: SizeConfig.screenHeight * .02),
                    child: RangeSlider(
                      values: _currentRangeValues,
                      max: 80,
                      min: 17,
                      divisions: 5,
                      /* labels: RangeLabels(

                        _currentRangeValues.start.round().toString(),
                        _currentRangeValues.end.round().toString(),
                      ),*/

                      onChanged: (RangeValues values) {
                        setState(() {
                          _currentRangeValues = values;
                          targetAudienceController.text =
                              values.start.round().toString() +
                                  "-" +
                                  values.end.round().toString();
                        });
                        print("v..    ${targetAudienceController.text}");
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Range Label Value is:",
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 4.0,
                            color: Colors.white),
                        textScaleFactor: 1.1,
                      ),
                      Text(
                        " ",
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 4.0,
                            color: Colors.white),
                        textScaleFactor: 1.1,
                      ),
                      Text(
                        _currentRangeValues.start.round().toString(),
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 4.0,
                            color: Colors.white),
                        textScaleFactor: 1.1,
                      ),
                      Text(
                        " - ",
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 4.0,
                            color: Colors.white),
                        textScaleFactor: 1.1,
                      ),
                      Text(
                        _currentRangeValues.end.round().toString(),
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 4.0,
                            color: Colors.white),
                        textScaleFactor: 1.1,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: MyButton(
                          label: "Next",
                          labelWeight: FontWeight.w500,
                          // ignore: void_checks
                          onPressed: () {
                        
                            if (
                                // _formKey.currentState.validate() &&
                                discription.text.isNotEmpty) {
                              if (_image == null) {
                                // status = false;
                                return ScaffoldMessenger.of(context)
                                    .showSnackBar((SnackBar(
                                        content: Text(
                                  'please select image ',
                                ))));
                              }

                              createAdsAPi();
                              setState(() {});
                            } else {
                              Helper.showToast("Enter description");
                            }
                          },
                          heightFactor: 50,
                          widthFactor: 3.2,
                          radiusFactor: 160),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Container(
                        color: Colors.transparent,
                        width: double.infinity,
                        child: Text("")),
                  )
                ],
              ),
            ),
          ),
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

  AddAdvertismentResponseData addAdsModel = AddAdvertismentResponseData();

  createAdsAPi() async {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    controller = UserController(context, state);
    final prefs = await controller.sharedPrefs;

   // print("hhhhhhh..$startDate....${ countryCode.text}.....${phone.text}");

    if (mounted) {
      setState(() {
        flag = true;
      });
    }
    controller.waitUntilAddAdvertisement(
            _image.path,
            companyName.text,
            contactPerson.text,
            email.text,
            countryCode.text,
            phone.text,
            address.text,
            purposeOdAdv.text,
            discription.text,
            link.text,
            title.text,
           startDate,
            endDate,
            targetAudienceController.text)
        .then((value) {
      if (mounted) {
        setState(() {
          flag = false;
        });
      }
      addAdsModel = controller.addAdsResponse;

      if (addAdsModel.responseData.isNotEmpty) {
        widget.mListener.addPaymentScreen(
            addAdsModel.responseData.elementAt(0).sId,
            addAdsModel.responseData.elementAt(0).title);
      }
    });
  }

  final picker = ImagePicker();
  XFile _image;

  openGallery() async {
    var image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 1200,
        maxWidth: 1200);
    print("_image...    ${_image}");
    if (mounted) {
      setState(() {
        if (image != null) {
          _image = image;
          print("_image    ${_image}");
        } else {}
      });
    }
  }

  datePicker(String comeFrom) async {
    try {
      //- 13
      final today = DateTime.now();
      final picked = await showDatePicker(
          context: context,
          initialDate: today,
          firstDate: comeFrom == "1"
              ? today
              : DateTime(today.year, today.month, today.day),
          lastDate: DateTime(today.year + 1, today.month, today.day));
      if (comeFrom == "1") {
        validFromController.text = putDateToString(picked);
        startDate = putDateToServer(picked);
      } else {
        validTillController.text = putDateToString(picked);
        endDate = putDateToServer(picked);
      }

      // putDateToServer(picked);
      print("picked   $picked");
      return picked;
    } catch (e) {
      rethrow;
    }
  }

  String putDateToString(DateTime dt) {
    final DateFormat formatter = DateFormat('MM/dd/yyyy');
    final String formatted = formatter.format(dt);
    // dt.day.toString() + "/" + dt.month.toString() + "/" + dt.year.toString();
    print("formatted....... $formatted");
    return formatted;
  }

  String putDateToServer(DateTime dt) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formatted = formatter.format(dt);
    // dt.day.toString() + "/" + dt.month.toString() + "/" + dt.year.toString();
    print("newwwwwwwww....... $formatted");
    return formatted;
  }
}

abstract class AdvertisementAddPageInterface {
  addPaymentScreen(String id, String name);
}
