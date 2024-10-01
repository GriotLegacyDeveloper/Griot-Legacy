import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/utils/constant_class.dart';

import '../../main.dart';

class ChatOptionDialog extends StatefulWidget {
  final ChatOptionDialogInterface mListener;
  final String copyText;
  final String comeFrom;
  final String msgId;
  final int index;

  const ChatOptionDialog({Key key, this.copyText, this.mListener, this.comeFrom, this.msgId, this.index}) : super(key: key);

  @override
  _ChatOptionDialogState createState() => _ChatOptionDialogState();
}




class _ChatOptionDialogState extends State<ChatOptionDialog> {



  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding:  EdgeInsets.only(
          left: SizeConfig.screenWidth * 0.05,
          right: SizeConfig.screenWidth * 0.05,
          bottom: SizeConfig.screenHeight * .04),
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
              padding:  EdgeInsets.only(top: SizeConfig.screenHeight *.025,
                  bottom: SizeConfig.screenHeight *.025,left: SizeConfig.screenWidth *.03,
                  right: SizeConfig.screenWidth *.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Visibility(
                    visible: widget.comeFrom=="otheruser"?false:true,
                    child: GestureDetector(
                      onTap: (){
                        widget.mListener.editTextFunction(widget.copyText,widget.msgId);
                        Navigator.pop(context,false);
                      },
                      onDoubleTap: (){},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Edit",
                            style:  TextStyle(
                                fontSize: SizeConfig.safeBlockHorizontal * 3.8,
                                fontFamily: "Work Sans",
                                color: Colors.black,
                                fontWeight: FontWeight.w400
                            ),
                            textScaleFactor: 1.2,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.comeFrom=="otheruser"?false:true,
                    child: Padding(
                      padding:  EdgeInsets.only(top: SizeConfig.screenHeight*.01,
                          bottom:SizeConfig.screenHeight*.01 ),
                      child: const Divider(
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: (){
                      widget.mListener.quotedMessage(widget.copyText, "quote",widget.msgId);
                      Navigator.pop(context,false);
                    },
                    onDoubleTap: (){},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Quote",
                          style:  TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 3.8,
                              fontFamily: "Work Sans",
                              color: Colors.black,

                              fontWeight: FontWeight.w400
                          ),
                          textScaleFactor: 1.2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: SizeConfig.screenHeight*.01,
                        bottom:SizeConfig.screenHeight*.01 ),
                    child: const Divider(
                      color: Colors.grey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.mListener.forwardMessage(widget.copyText,"");
                      final prefs = sharedPreferences;
                      prefs.setString(Constant.forwardMsg, "forward");
                      Navigator.pop(context,false);
                    },
                    onDoubleTap: (){},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Forward",
                          style:  TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 3.8,
                              fontFamily: "Work Sans",
                              color: Colors.black,

                              fontWeight: FontWeight.w400
                          ),
                          textScaleFactor: 1.2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: SizeConfig.screenHeight*.01,
                        bottom:SizeConfig.screenHeight*.01 ),
                    child: const Divider(
                      color: Colors.grey,
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Clipboard.setData(ClipboardData(text: widget.copyText)).then((value) {

                      });
                      Navigator.pop(context,false);

                    },
                    onDoubleTap: (){},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Copy",
                          style:  TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 3.8,
                              fontFamily: "Work Sans",
                              color: Colors.black,

                              fontWeight: FontWeight.w400
                          ),
                          textScaleFactor: 1.2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: SizeConfig.screenHeight*.01,
                        bottom:SizeConfig.screenHeight*.01 ),
                    child: const Divider(
                      color: Colors.grey,
                    ),
                  ),
                  GestureDetector(
                    onDoubleTap: (){},
                    onTap: (){
                      if(widget.mListener!=null){
                        widget.mListener.removeChat(widget.msgId,widget.index);
                        Navigator.pop(context,false);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,

                      children: [
                        Text(
                          "Remove Chat",
                          style:  TextStyle(
                              fontSize: SizeConfig.safeBlockHorizontal * 3.8,
                              fontFamily: "Work Sans",
                              color: Colors.black,

                              fontWeight: FontWeight.w400
                          ),
                          textScaleFactor: 1.2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }





}
abstract class ChatOptionDialogInterface{
  editTextFunction(String copiedText,String msgId);
  quotedMessage(String copiedText,String come,String msgId);
  forwardMessage(String text,String comeFrom);
  removeChat(String msgId,int index);
}
