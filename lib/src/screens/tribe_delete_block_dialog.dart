import 'package:flutter/material.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
class TribeDeleteBlockDialog extends StatefulWidget {
  const TribeDeleteBlockDialog({Key key}) : super(key: key);

  @override
  _TribeDeleteBlockDialogState createState() => _TribeDeleteBlockDialogState();
}

class _TribeDeleteBlockDialogState extends State<TribeDeleteBlockDialog> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding:  EdgeInsets.only(
          left: SizeConfig.screenWidth * 0.05,
          right: SizeConfig.screenWidth * 0.05,
          bottom: SizeConfig.screenHeight * .04),
      child: GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        onDoubleTap: (){},
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            child:  Container(
              decoration:  const BoxDecoration(
                borderRadius:  BorderRadius.all(Radius.circular(10.0)),
                color: Colors.white,
              ),
              child:  Padding(
                padding:  EdgeInsets.only(top: SizeConfig.screenHeight *.015,
                    bottom: SizeConfig.screenHeight *.015,left: SizeConfig.screenWidth *.02),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Edit",
                          style:  TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 3.8,
                              fontFamily: "Avenir_Heavy",
                              color: Colors.black.withOpacity(0.5),

                              fontWeight: FontWeight.w600
                          ),
                          textScaleFactor: 1.2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        Text(
                          "Quote",
                          style:  TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                              fontFamily: "Avenir_Heavy",
                              color: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.w600
                          ),
                          textScaleFactor: 1.2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        Text(
                          "Forward",
                          style:  TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                              fontFamily: "Avenir_Heavy",
                              color: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.w600
                          ),
                          textScaleFactor: 1.2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        Text(
                          "Copy",
                          style:  TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                              fontFamily: "Avenir_Heavy",
                              color: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.w600
                          ),
                          textScaleFactor: 1.2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        Text(
                          "Remove Chat",
                          style:  TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                              fontFamily: "Avenir_Heavy",
                              color: Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.w600
                          ),
                          textScaleFactor: 1.2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getMessageText(double parentHeight, double parentWidth) {
    return Row(
//        crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "Delete",
          style:  TextStyle(
              fontSize: SizeConfig.safeBlockHorizontal * 3.5,
              fontFamily: "Avenir_Heavy",
              color: Colors.black,
              fontWeight: FontWeight.w600
          ),
          textScaleFactor: 1.2,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

}
