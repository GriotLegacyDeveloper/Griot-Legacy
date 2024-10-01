import 'package:flutter/material.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/utils/common_color.dart';

import '../controllers/user_controller.dart';
class ConfirmationDialogForDeleteAccount extends StatefulWidget {
  final String msg;
  final  context;
  final  state;
  final  UserController controller;
  final ConfirmationDialogForDeleteAccountInterface mListener;
  const ConfirmationDialogForDeleteAccount({Key key,this.mListener, this.msg, this.context, this.state, this.controller}) : super(key: key);

  @override
  _ConfirmationDialogForDeleteAccountState createState() => _ConfirmationDialogForDeleteAccountState();
}

class _ConfirmationDialogForDeleteAccountState extends State<ConfirmationDialogForDeleteAccount> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Padding(
      padding: EdgeInsets.only(
          left: SizeConfig.screenWidth * 0.07 ,
          right: SizeConfig.screenWidth * 0.07 ,
          bottom: SizeConfig.screenHeight * .04 ) ,
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular( 25.0 ) ,
          ) ,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all( Radius.circular( 25.0 ) ) ,
              color: Colors.white ,

            ) ,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start ,
              mainAxisSize: MainAxisSize.min ,
              children: <Widget>[
                getHeadingText( SizeConfig.screenHeight , SizeConfig.screenWidth ) ,
                getMessageText( SizeConfig.screenHeight , SizeConfig.screenWidth ) ,
                getYesOrNo(SizeConfig.screenHeight , SizeConfig.screenWidth ) ,
              ] ,
            ) ,
          ) ,
        ) ,
      ) ,
    );
  }

  /*text filed Widget*/
  Widget getMessageText(double parentHeight , double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(
        top: parentHeight * .01,
        bottom: parentHeight * .04 ,
        left: parentWidth * .06 ,
        right: parentWidth * .05 ,
      ) ,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
// crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              widget.msg,
              style: TextStyle(color: Colors.black,fontSize: SizeConfig.blockSizeHorizontal *3.2),
              textScaleFactor: 1.2 ,
              textAlign: TextAlign.start ,
            ) ,
          ) ,
        ] ,
      ) ,
    );
  }

  Widget getHeadingText(double parentHeight , double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(
        left: parentWidth * .06 ,
        right: parentWidth * .05 ,
        top: parentHeight * .03,
      ) ,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
// crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              "Delete Account",
              style: TextStyle(color: Colors.black,
                  fontSize: SizeConfig.blockSizeHorizontal *3.8,
                  fontWeight: FontWeight.w600
              ),
              textScaleFactor: 1.2 ,
              textAlign: TextAlign.start ,
            ) ,
          ) ,
        ] ,
      ) ,
    );
  }

  /*widget for yes or no field*/
  Widget getYesOrNo(double parentHeight , double parentWidth) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: parentHeight * .03,
        left: parentWidth * .06 ,
        right: parentWidth * .08 ,
      ) ,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end ,
        children: <Widget>[
          GestureDetector(
            onTap: (){
              Navigator.pop( context , false );

            },onDoubleTap: (){},
            child: Text(
              "No" ,
              style: TextStyle(color: CommonColor.goldenColor,fontSize: SizeConfig.blockSizeHorizontal *3.6),

              textScaleFactor: 1.2 ,
            ),
          ) ,
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              if(mounted) {
                setState(() {
                  if(widget.mListener!=null) {
                    widget.mListener.callApiDeleteAccount(widget.context,widget.state,widget.controller);
                  }
                });
              }

            },onDoubleTap: (){},
            child: Padding(
              padding:  EdgeInsets.only(left: SizeConfig.screenWidth *.04),
              child: Text(
                "Yes" ,
                style: TextStyle(color: CommonColor.goldenColor,fontSize: SizeConfig.blockSizeHorizontal *3.6),

                textScaleFactor: 1.2 ,
              ),
            ),
          ) ,
          // getNoText( parentHeight , parentWidth ) ,
          // getYesText( parentHeight , parentWidth ) ,

        ] ,
      ),
    );
  }


}

abstract class ConfirmationDialogForDeleteAccountInterface{
  callApiDeleteAccount(context,state,con);
}
