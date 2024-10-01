import 'package:flutter/material.dart';
import 'package:griot_legacy_social_media_app/size_config.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: getCustomAppBarDesign(
            SizeConfig.screenHeight, SizeConfig.screenWidth),
      ),
      body: Padding(
        padding:  EdgeInsets.only(top: SizeConfig.screenHeight *.025,
            left: SizeConfig.screenWidth *.05,
            right: SizeConfig.screenWidth *.05),
        child: Column(
          children: [
            getTiTleNameLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
            getLanguageLayout(SizeConfig.screenHeight,SizeConfig.screenWidth),
          ],
        ),
      ),
    );
  }

  
  /*custom app bar design layout*/
  Widget getCustomAppBarDesign(double parentHeight, double parentWidth) {
    return Row(
      children: [
        Text(
          "Back",
          style: TextStyle(
              color: Colors.white,
              fontSize: SizeConfig.blockSizeHorizontal * 4.4,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal),
          textScaleFactor: 1.1,
        )
      ],
    );
  }
  
  
  /*main layout design*/
Widget getTiTleNameLayout(double parentHeight,double parentWidth){
  return Row(
    children: [
      Text("Settings",style: TextStyle(color: Colors.white,
          fontSize: SizeConfig.blockSizeHorizontal *4.8,
          fontWeight: FontWeight.w500,
      fontFamily: "Poppins",
      fontStyle: FontStyle.normal),
        textScaleFactor: 1.1,
      ),
    ],
  );
}

  Widget getLanguageLayout(double parentHeight,double parentWidth){
    return Row(
      children: [
        Text("Language",style: TextStyle(color: Colors.white,
            fontSize: SizeConfig.blockSizeHorizontal *4.4,
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins",
            fontStyle: FontStyle.normal),
          textScaleFactor: 1.1,
        ),
      ],
    );
  }
}
