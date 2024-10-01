import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/controllers/other_controller.dart';
import 'package:griot_legacy_social_media_app/src/models/quick_link.dart';

class SettingsItemWidget extends StatelessWidget {
  final QuickLink link;
  final int index;
  final String comming;
  const SettingsItemWidget({Key key, @required this.link, @required this.index, this.comming})
      : super(key: key);

  Widget itemBuilder(OtherController con) {
    final hp = con.hp;
    return GestureDetector(
        onTap: link.onPressed,
        child: Container(
            padding: EdgeInsets.symmetric(
                vertical: hp.height / 30, horizontal: hp.width / 50),
            decoration: BoxDecoration(
              color: hp.theme.primaryColor,
              border: Border(
                  top: index == 0
                      ? BorderSide(
                          color: hp.theme.hoverColor, width: hp.radius / 800)
                      : BorderSide.none,
                  bottom: BorderSide(
                      color: hp.theme.hoverColor, width: hp.radius / 800)),
            ),
            child: Row(children: [
              Expanded(
                  child: Text(link.content,
                      style: const TextStyle(color: Colors.white))),
              comming=="1"?Flexible(
                  child: Text(String.fromCharCodes(Runes("\u2192")),
                      style: const TextStyle(color: Colors.white))):const Text(""),
            ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
            margin: EdgeInsets.symmetric(horizontal: hp.width / 40)));
  }

  @override
  Widget build(BuildContext context) {
    final state =
        context.findAncestorStateOfType<GetBuilderState<OtherController>>() ??
            GetBuilderState<OtherController>();
    return itemBuilder(OtherController(context, state));
  }
}
