import 'package:flutter/material.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/utils/common_color.dart';


class ConfirmationDialog extends StatefulWidget {
  final String tribeId;
  final String msg;
  final String comeFrom;
  final ConfirmationDialogInterface mListener;
  const ConfirmationDialog({Key key, this.tribeId, this.mListener, this.msg, this.comeFrom}) : super(key: key);

  @override
  _ConfirmationDialogState createState() => _ConfirmationDialogState();
}


class _ConfirmationDialogState extends State<ConfirmationDialog> {
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
              widget.comeFrom =="6"? "Report as Spam": widget.comeFrom =="7"?"Report User":"Back to Listings?",
              style: TextStyle(color: widget.comeFrom=="3" ? Colors.transparent:Colors.black,
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
                    widget.mListener.callApiForLeaveTribe(widget.tribeId,widget.comeFrom);
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

  /*widget get yes*/
  Widget getYesText(double parentHeight , double parentWidth) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);

        if(mounted) {

          setState(() {
          if(widget.mListener!=null) {
            widget.mListener.callApiForLeaveTribe(widget.tribeId,widget.comeFrom);
          }
        });
        }

      },
      /* onTap: () {
        if (widget.isDialogType == "1") {
          exit( 0 );
        } else if (widget.isDialogType == "2") {
          callLogoutApi( );
        }
      } ,*/
      child: Padding(
        padding: EdgeInsets.only(
            right: parentWidth * .0 , bottom: parentHeight * .04 ) ,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.rectangle ,
            borderRadius: BorderRadius.all( Radius.circular( 10.0 ) ) ,
            color: CommonColor.goldenColor ,
// color: Colors.white,
          ) ,
          child: Padding(
            padding: EdgeInsets.only(
              top: parentHeight * .02 ,
              right: parentWidth * .08 ,
              left: parentWidth * .08 ,
              bottom: parentHeight * .02 ,
            ) ,
            child: Text(
             "Yes" ,
              style: TextStyle(color: Colors.white,fontSize: SizeConfig.blockSizeHorizontal *3.0),

              textScaleFactor: 1.2 ,
            ) ,
          ) ,
        ) ,
      ) ,
    );
  }

  /*Widget get no*/
  Widget getNoText(double parentHeight , double parentWidth) {
    return GestureDetector(
      onTap: () {
        Navigator.pop( context , false );
      } ,
      child: Padding(
        padding: EdgeInsets.only(
            right: parentWidth * .0 , bottom: parentHeight * .03 ) ,
        child: Container(
          decoration:  BoxDecoration(
            shape: BoxShape.rectangle ,

            borderRadius: const BorderRadius.all( Radius.circular( 10.0 ) ) ,
            border: Border.all(color: CommonColor.goldenColor,width: 1.0),
            color: Colors.white ,

// color: Colors.white,
          ) ,
          child: Padding(
            padding: EdgeInsets.only(
              top: parentHeight * .02 ,
              right: parentWidth * .08 ,
              left: parentWidth * .08 ,
              bottom: parentHeight * .02 ,
            ) ,
            child: Text(
              "No" ,
              style: TextStyle(color: CommonColor.goldenColor,fontSize: SizeConfig.blockSizeHorizontal *3.0),

              textScaleFactor: 1.2 ,
            ) ,
          ) ,
        ) ,
      ) ,
    );
  }
}

abstract class ConfirmationDialogInterface{
  callApiForLeaveTribe(String tribeId,String comeFrom,);
}
