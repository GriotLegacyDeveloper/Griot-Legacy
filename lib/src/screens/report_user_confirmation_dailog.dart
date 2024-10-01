import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/utils/common_color.dart';
import '../helpers/helper.dart';

class ReportUserConfirmationDialog extends StatefulWidget {
  final String tribeId;
  final String msg;
  final ReportUserConfirmationDialogInterface mListener;
  const ReportUserConfirmationDialog({Key key, this.tribeId, this.mListener, this.msg}) : super(key: key);

  @override
  _ReportUserConfirmationDialogState createState() => _ReportUserConfirmationDialogState();
}


class _ReportUserConfirmationDialogState extends State<ReportUserConfirmationDialog> {
  final _reasonController = TextEditingController();


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
                Padding(
                  padding:  EdgeInsets.only(left: SizeConfig.screenWidth*.04
                      ,right: SizeConfig.screenWidth*.04,bottom: SizeConfig.screenHeight*.02),
                  child: TextFormField(
                      autocorrect: false,
                      enableSuggestions: false,
                      autovalidateMode:
                      AutovalidateMode.onUserInteraction,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp('[a-zA-Z ]'))],
                      maxLength: 60,
                      decoration: const InputDecoration(
                          counterText: "",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(5.0)),
                            // borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(5.0)),
                            //borderSide: BorderSide(color: Colors.red),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintStyle: TextStyle(
                              color: Colors.grey),

                          border: InputBorder.none,
                          hintText: "Reason *"),
                      style: const TextStyle(
                          color: Colors.black),
                      keyboardType: TextInputType.name,
                      controller: _reasonController),
                ),
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
        bottom: parentHeight * .02 ,
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
              "Report user",
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
              bool status=true;

              if(mounted) {
                setState(() {
                  if(_reasonController.text=="" ||_reasonController.text.isEmpty){
                    status=false;
                    Helper.showToast("reason can not be blank");

                  }

                if(status){
                  Navigator.pop(context);
                  if(mounted) {
                    setState(() {
                      if(widget.mListener!=null) {
                        widget.mListener.callApiForReportUser(widget.tribeId,_reasonController.text);
                      }
                    });
                  }
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

abstract class ReportUserConfirmationDialogInterface{
  callApiForReportUser(String tribeId,String reason);
}
