import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';
import 'package:griot_legacy_social_media_app/src/helpers/helper.dart';

class ChatItemWidget extends StatefulWidget {
  const ChatItemWidget({Key key}) : super(key: key);

  @override
  ChatItemWidgetState createState() => ChatItemWidgetState();
}

class ChatItemWidgetState extends State<ChatItemWidget> {
  Helper get hp =>
      Helper.of(context, context.findAncestorStateOfType<GetBuilderState>());
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Card(
        child: Padding(
          padding:  EdgeInsets.only(left: SizeConfig.screenWidth *.02,
              right: SizeConfig.screenWidth*.02,
              top: SizeConfig.screenHeight *.015,bottom: SizeConfig.screenHeight *.025),
          child: Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: <Widget>[
                      Container(
                        height: SizeConfig.screenHeight*.05,
                        width: SizeConfig.screenHeight*.05,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  "assets/images/dummy.jpeg")),

                        ),

                      ),
                      /*Container(
                              height: SizeConfig.screenHeight*.13,
                              width: SizeConfig.screenHeight*.13,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: hp
                                        .theme.selectedRowColor,
                                    width: 2),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                                image:  DecorationImage(
                                  fit: BoxFit.cover,
                                  image: _image!=null?  FileImage(_image,) :
                                  NetworkImage(profileImage),
                                ),
                              ),
                            ),*/
                    ],
                  ),
                ],
              ),
              Expanded(
                  child: Padding(
                    padding:  EdgeInsets.only(left: SizeConfig.screenWidth *.04),
                    child: Column(children: [
                      Text("Jaden Smith",
                          style: TextStyle(color: hp.theme.secondaryHeaderColor
                              ,fontSize: SizeConfig.blockSizeHorizontal *4.1),
                        textScaleFactor: 1.1,
                      ),
                      Padding(
                        padding:  EdgeInsets.only(top: SizeConfig.screenHeight *.01),
                        child: Text("Active 1 hr Ago",
                            style: TextStyle(color: hp.theme.secondaryHeaderColor,
                                fontSize: SizeConfig.blockSizeHorizontal *3.4),
                          textScaleFactor: 1.0,

                        ),
                      )
                    ], crossAxisAlignment: CrossAxisAlignment.start),
                  )),
              PopupMenuButton(
                color: Colors.white,
                  icon: Container(
                    decoration: BoxDecoration(
                      color: hp.theme.cardColor,
                      shape: BoxShape.circle
                    ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(Icons.more_vert_outlined,
                          color: hp.theme.secondaryHeaderColor,),
                      )),
                  itemBuilder: (context) => [
                     PopupMenuItem(
                      child:  Text(
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
                      value: 1,
                    ),

                     PopupMenuItem(
                      child:  Text(
                        "Block",
                        style:  TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                            fontFamily: "Avenir_Heavy",
                            color: Colors.black,
                            fontWeight: FontWeight.w600
                        ),
                        textScaleFactor: 1.2,
                        textAlign: TextAlign.center,
                      ),
                      value: 2,
                    )
                  ]
              )
              /*CircleAvatar(
                child: IconButton(
                    onPressed: () {
                      showGeneralDialog(
                          barrierColor: Colors.black.withOpacity(0.8),
                          transitionBuilder: (context, a1, a2, widget) {
                            final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
                            return Transform(
                              transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
                              child: Opacity(
                                opacity: a1.value,
                                child:  ChatDeleteBlockDialog(),
                              ),
                            );
                          },
                          transitionDuration: Duration(milliseconds: 200),
                          //barrierDismissible: false,
                          barrierLabel: '',
                          context: context,
                          pageBuilder: (context, animation2, animation1) {});
                    }, icon: const Icon(Icons.more_vert_outlined)),
                backgroundColor: hp.theme.dividerColor,
                foregroundColor: hp.theme.secondaryHeaderColor,
              )*/
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
        color: hp.theme.primaryColor);
  }
}
