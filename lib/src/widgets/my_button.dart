import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:griot_legacy_social_media_app/src/helpers/helper.dart';
import 'package:griot_legacy_social_media_app/src/widgets/custom_button.dart';

class MyButton extends StatelessWidget {
  final String label;
  final FontWeight labelWeight;
  final TextStyle textStyle;
  final VoidCallback onPressed;
  final double heightFactor, widthFactor, radiusFactor;
  const MyButton(
      {Key key,
      @required this.label,
      this.textStyle,
      @required this.labelWeight,
      @required this.onPressed,
      @required this.heightFactor,
      @required this.widthFactor,
      @required this.radiusFactor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hp =
        Helper.of(context, context.findAncestorStateOfType<GetBuilderState>());
    return CustomButton(
        onPressed: onPressed,
        heightFactor: heightFactor,
        widthFactor: widthFactor,
        label: label,
        labelWeight: labelWeight,
        buttonColor: hp.theme.secondaryHeaderColor,
        labelColor: hp.theme.primaryColor,
        radiusFactor: radiusFactor,

    );
  }
}
