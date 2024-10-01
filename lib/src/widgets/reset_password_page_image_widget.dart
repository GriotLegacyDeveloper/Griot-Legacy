import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResetPasswordPageImageWidget extends StatelessWidget {
  const ResetPasswordPageImageWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Expanded(child: Icon(Icons.lock)),
      Expanded(child: SvgPicture.asset("assets/images/x-icon.svg"))
    ]);
  }
}
