import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:griot_legacy_social_media_app/src/helpers/helper.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final FontWeight labelWeight;
  final Color buttonColor, labelColor;
  final double heightFactor, widthFactor, radiusFactor;
  const CustomButton(
      {Key key,
      @required this.onPressed,
      @required this.label,
      @required this.heightFactor,
      @required this.widthFactor,
      @required this.radiusFactor,
      @required this.buttonColor,
      @required this.labelWeight,
      @required this.labelColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hp =
        Helper.of(context, context.findAncestorStateOfType<GetBuilderState>());
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(fontWeight: labelWeight),
      ),
      style: ButtonStyle(
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.all(radiusFactor == 0
                  ? Radius.zero
                  : Radius.circular(hp.radius / radiusFactor)))),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(
              vertical: hp.height / heightFactor,
              horizontal: hp.width / widthFactor)),
          foregroundColor: MaterialStateProperty.all<Color>(labelColor),
          backgroundColor: MaterialStateProperty.all<Color>(buttonColor)),
    );
  }
}
