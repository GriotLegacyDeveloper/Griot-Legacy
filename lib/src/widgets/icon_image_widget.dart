import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconImageWidget extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final imagePath;
  const IconImageWidget({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SvgPicture.asset(
            "assets/images/icon-bg.svg",
            height: MediaQuery.of(context).size.height * 0.16,
            width: MediaQuery.of(context).size.height * 0.16,
            //fit: BoxFit.fill
          ),
        ),
        Center(
          child: SvgPicture.asset(
            imagePath,
            height: MediaQuery.of(context).size.height * 0.1,
            //width: MediaQuery.of(context).size.height * 0.12,
            //fit: BoxFit.fill
          ),
        ),
      ],
    );
  }
}
