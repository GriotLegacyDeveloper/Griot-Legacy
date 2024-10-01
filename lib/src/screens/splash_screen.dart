import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/controllers/splash_screen_controller.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  Widget pageBuilder(SplashScreenController con) {
    final hp = con.hp;
    hp.lockScreenRotation();
   // final assetPath = GlobalConfiguration().getValue("asset_image_path");
    return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
            body: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/icon-logo.png",
                          fit: BoxFit.contain,
                          errorBuilder: hp.errorBuilder,
                          height: hp.height / 5,
                          width: hp.width / 2),
                    ],
                  ),
                  SizedBox(height: hp.height / 40),
                  /*CircularLoader(
                      heightFactor: 32,
                      loaderType: LoaderType.fadingCube,
                      duration: Helper.duration,
                      color: hp.theme.secondaryHeaderColor)*/
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center),
            backgroundColor: hp.theme.primaryColor));
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashScreenController>(
        builder: pageBuilder,
        init: SplashScreenController(
            context, context.findAncestorStateOfType<GetBuilderState>()));
  }


}
