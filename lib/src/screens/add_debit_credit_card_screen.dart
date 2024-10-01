import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../controllers/user_controller.dart';
import '../models/token_create_response_model.dart';
import '../utils/common_color.dart';
import '../widgets/my_button.dart';

class AddCreditDebitCardDetails extends StatefulWidget {
  final AddCreditDebitCardDetailsInterface mListener;
  final String comeFrom;
  const AddCreditDebitCardDetails({Key key, this.mListener, this.comeFrom}) : super(key: key);

  @override
  _AddCreditDebitCardDetailsState createState() =>
      _AddCreditDebitCardDetailsState();
}

class _AddCreditDebitCardDetailsState extends State<AddCreditDebitCardDetails> {
  final cardNumber = TextEditingController();
  final cardHolderName = TextEditingController();
  final expiryDateController = TextEditingController();
  final expiryYearController = TextEditingController();
  final cvvController = TextEditingController();
  UserController controller;
  final _formKey = GlobalKey<FormState>();
  TokenCreateResponseModel tokenCreateRes = TokenCreateResponseModel();
  bool flag=false;

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
    hp.lockScreenRotation();
    return Stack(
      children: [
        Scaffold(
          backgroundColor: hp.theme.backgroundColor,
          appBar: AppBar(
            backgroundColor: hp.theme.backgroundColor,
            foregroundColor: hp.theme.secondaryHeaderColor,
            centerTitle: true,
            title: Text(
              "Card Details",
              style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                  color: Colors.white),
              textScaleFactor: 1.1,
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(
                left: SizeConfig.screenWidth * .03,
                right: SizeConfig.screenWidth * .03,
                top: SizeConfig.screenHeight * .02),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: SizeConfig.screenHeight * .015),
                    child: TextFormField(
                        validator: (value) =>
                        value.trim().isEmpty ? "card holder name" : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 20,
                        decoration: InputDecoration(
                            counterText: "",
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                              borderSide:
                              BorderSide(color: Colors.transparent, width: 2),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            filled: true,
                            fillColor: CommonColor.blackoff,
                            hintStyle: TextStyle(color: hp.theme.primaryColorLight),
                            contentPadding: EdgeInsets.only(
                                left: hp.width / 40,
                                top: hp.height / 50,
                                bottom: hp.height / 50),
                            border: InputBorder.none,
                            hintText: "Card Holder Name"),
                        style: TextStyle(color: hp.theme.secondaryHeaderColor),
                        //keyboardType: TextInputType.number,
                        controller: cardHolderName),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: SizeConfig.screenHeight * .015),
                    child: TextFormField(
                        validator: (value) =>
                            value.trim().isEmpty ? "card number" : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                        ],
                        maxLength: 20,
                        decoration: InputDecoration(
                            counterText: "",
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                              borderSide:
                                  BorderSide(color: Colors.transparent, width: 2),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            filled: true,
                            fillColor: CommonColor.blackoff,
                            hintStyle: TextStyle(color: hp.theme.primaryColorLight),
                            contentPadding: EdgeInsets.only(
                                left: hp.width / 40,
                                top: hp.height / 50,
                                bottom: hp.height / 50),
                            border: InputBorder.none,
                            hintText: "Card Number"),
                        style: TextStyle(color: hp.theme.secondaryHeaderColor),
                        keyboardType: TextInputType.number,
                        controller: cardNumber),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: SizeConfig.screenHeight * .02),
                    child: TextFormField(
                        validator: (value) =>
                            value.trim().isEmpty ? "expiry date required" : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 2,
                        decoration: InputDecoration(
                            counterText: "",
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                              borderSide:
                                  BorderSide(color: Colors.transparent, width: 2),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            filled: true,
                            fillColor: CommonColor.blackoff,
                            hintStyle: TextStyle(color: hp.theme.primaryColorLight),
                            contentPadding: EdgeInsets.only(
                                left: hp.width / 40,
                                top: hp.height / 50,
                                bottom: hp.height / 50),
                            border: InputBorder.none,
                            hintText: "MM"
                           // hintText: "Exp. Date MM"
                        ),
                        style: TextStyle(color: hp.theme.secondaryHeaderColor),
                        keyboardType: TextInputType.number,
                        controller: expiryDateController),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: SizeConfig.screenHeight * .02),
                    child: TextFormField(
                        validator: (value) =>
                            value.trim().isEmpty ? "expiry year required" : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 2,
                        decoration: InputDecoration(
                            counterText: "",
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                              borderSide:
                                  BorderSide(color: Colors.transparent, width: 2),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            filled: true,
                            fillColor: CommonColor.blackoff,
                            hintStyle: TextStyle(color: hp.theme.primaryColorLight),
                            contentPadding: EdgeInsets.only(
                                left: hp.width / 40,
                                top: hp.height / 50,
                                bottom: hp.height / 50),
                            border: InputBorder.none,
                            hintText: "YY"
                          //  hintText: "Exp. Date yy"
                        ),
                        style: TextStyle(color: hp.theme.secondaryHeaderColor),
                        keyboardType: TextInputType.number,
                        controller: expiryYearController),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: SizeConfig.screenHeight * .02),
                    child: TextFormField(
                        validator: (value) =>
                            value.trim().isEmpty ? "CVV Number required" : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLength: 3,
                        decoration: InputDecoration(
                            counterText: "",
                            enabledBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                              borderSide:
                                  BorderSide(color: Colors.transparent, width: 2),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            filled: true,
                            fillColor: CommonColor.blackoff,
                            hintStyle: TextStyle(color: hp.theme.primaryColorLight),
                            contentPadding: EdgeInsets.only(
                                left: hp.width / 40,
                                top: hp.height / 50,
                                bottom: hp.height / 50),
                            border: InputBorder.none,
                            hintText: "CVV Number"
                          //  hintText: "Cvv number"
                        ),
                        style: TextStyle(color: hp.theme.secondaryHeaderColor),
                        keyboardType: TextInputType.number,
                        controller: cvvController),
                  ),
                
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: MyButton(
                          label: "Card Save",
                          labelWeight: FontWeight.w500,
                          onPressed: () async {

                              if(widget.comeFrom=="1") {
                                if(_formKey.currentState.validate()){
                                  CardTokenParams cardParams = CardTokenParams(type: TokenType.Card, name:cardHolderName.text,);

                                  await Stripe.instance.dangerouslyUpdateCardDetails(CardDetails(
                                    number: cardNumber.text,
                                    cvc: cvvController.text,
                                    expirationMonth: int.tryParse(expiryDateController.text),
                                    expirationYear: int.tryParse("20${expiryYearController.text}"),
                                  ));

                                  final token = await Stripe.instance.createToken(
                                    CreateTokenParams.card(
                                      params: cardParams,
                                    ),
                                  );
                                  final state = context.findAncestorStateOfType<GetBuilderState<UserController>>() ?? GetBuilderState<UserController>();
                                  controller = UserController(context, state);
                                  if (mounted) {
                                    setState(() {
                                      flag = true;
                                    });
                                  }

                                  if(token!=null && token.id!=null){
                                    callCardSaveApi(token.id);
                                  }
    }
                                  /*controller.waitUntilCreateToken(
                                      cardNumber.text,
                                      expiryDateController.text,
                                      expiryYearController.text,
                                      cvvController.text)
                                      .then((value) {
                                    if (mounted) {
                                      setState(() {
                                        flag = false;
                                      });
                                    }
                                    tokenCreateRes = controller.tokenResponse;
                                    if (tokenCreateRes.responseData.isNotEmpty) {
                                      callCardSaveApi(tokenCreateRes.responseData.elementAt(0).token);
                                    }
                                  });
                                  }*/
                              }
                              else{
                                Navigator.pop(context);

                              }
                          },
                          heightFactor: 50,
                          widthFactor: 3.2,
                          radiusFactor: 160),
                    ),
                  ),
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

  callCardSaveApi(String cardToken) async {
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
      "cardToken": cardToken,
    };
    controller.waitUntilCardSaveApi(body).then((value) {
      if (mounted) {
        setState(() {
          flag = false;
        });
      }
      Navigator.pop(context);
      if(widget.mListener!=null){
        widget.mListener.addBackFunction();
      }


    });
  }
}

abstract class AddCreditDebitCardDetailsInterface{
  addBackFunction();
}
