import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MobileLoginPageImageWidget extends StatelessWidget {
  const MobileLoginPageImageWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SvgPicture.asset(
            "assets/images/icon-bg.svg",
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.height * 0.2,
            //fit: BoxFit.fill
          ),
        ),
        Center(
          child: SvgPicture.asset(
            "assets/images/mobile-otp-icon.svg",
            height: MediaQuery.of(context).size.height * 0.12,
            //width: MediaQuery.of(context).size.height * 0.12,
            //fit: BoxFit.fill
          ),
        ),
      ],
    );
  }
}
