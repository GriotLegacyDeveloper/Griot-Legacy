import 'dart:async';
import 'package:flutter/material.dart';
import 'package:griot_legacy_social_media_app/src/image_picker_handler.dart';


class ImagePickerDialog extends StatelessWidget {
  ImagePickerHandler listener;
  AnimationController controller;
  BuildContext context;
  String comeFrom;

  ImagePickerDialog(this.listener, this.controller,this.comeFrom);

  Animation<double> _drawerContentsOpacity;
  Animation<Offset> _drawerDetailsPosition;

  void initState() {
    print("comeFrom   $comeFrom");
    _drawerContentsOpacity =  CurvedAnimation(
      parent:  ReverseAnimation(controller),
      curve: Curves.fastOutSlowIn,
    );
    _drawerDetailsPosition =  Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate( CurvedAnimation(
      parent: controller,
      curve: Curves.fastOutSlowIn,
    ));
  }

  getImage(BuildContext context) {
    if (controller == null ||
        _drawerDetailsPosition == null ||
        _drawerContentsOpacity == null) {
      return;
    }
    controller.forward();
    showDialog(
      context: context,
      builder: (BuildContext context) =>  SlideTransition(
        position: _drawerDetailsPosition,
        child:  FadeTransition(
          opacity:  ReverseAnimation(_drawerContentsOpacity),
          child: this,
        ),
      ),
    );
  }

  void dispose() {
    controller.dispose();
  }

  startTime() async {
    var _duration =  const Duration(milliseconds: 200);
    return  Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pop(context);
  }

  dismissDialog() {
    controller.reverse();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return  Material(
        type: MaterialType.transparency,
        child:  Opacity(
          opacity: 1.0,
          child:  Container(
            padding:const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                 GestureDetector(
                  onTap: () => listener.openCamera(),
                  child: roundedButton(

                    "Camera" ,
                    const  EdgeInsets.only(top: 10.0),
                    Colors.white,
                    Colors.black,
                  ),
                ),
                 GestureDetector(
                  onTap: () => comeFrom=="1"?listener.openGallery():listener.openGalleryForProfile(),
                  child: roundedButton(
                    "Gallery",
                    const EdgeInsets.only(top: 10.0),
                    Colors.white,
                    Colors.black,
                  ),
                ),
                Visibility(
                  visible: comeFrom=="2"?false:true,
                  child: GestureDetector(
                    onTap: () => listener.openGalleryForVideo(),
                    child: roundedButton(
                      "Video",
                      const EdgeInsets.only(top: 10.0),
                      Colors.white,
                      Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),
                 GestureDetector(
                  onTap: () => dismissDialog(),
                  child:  Padding(
                    padding:const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: roundedButton(
                      "Cancel",
                      const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      Colors.white,
                      Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
/*Widget for camera,gallery rounded button*/
  Widget roundedButton(
      String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor) {
    var loginBtn =  Container(
      margin: margin,
      padding: const EdgeInsets.all(15.0),
      alignment: FractionalOffset.center,
      decoration:  BoxDecoration(
        color: bgColor,
        borderRadius:  const BorderRadius.all(Radius.circular(100.0)),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            offset: Offset(1.0, 6.0),
            blurRadius: 0.001,
          ),
        ],
      ),
      child: Text(
        buttonLabel,
        style:  TextStyle(
            color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
    return loginBtn;
  }
}
