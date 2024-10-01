import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';
import 'package:griot_legacy_social_media_app/src/models/quick_link.dart';

class QuickLinkItemWidget extends StatelessWidget {
  final QuickLink link;
  const QuickLinkItemWidget({Key key, @required this.link}) : super(key: key);

  Widget itemBuilder(UserController con) {
    final hp = con.hp;
    return GestureDetector(
        child: Card(
            child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: hp.height / 50, horizontal: hp.width / 32),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(link.content,
                            style: const TextStyle(color: Colors.white))),
                    Flexible(
                        child: Text(String.fromCharCodes(Runes("\u2192")),
                            style: const TextStyle(color: Colors.white)))
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                )),
            elevation: 0),
        onTap: link.onPressed);
  }

  @override
  Widget build(BuildContext context) {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    return GetBuilder<UserController>(
        builder: itemBuilder, init: UserController(context, state));
  }
}
