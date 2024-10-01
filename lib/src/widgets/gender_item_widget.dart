import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';

class GenderItemWidget extends StatelessWidget {
  final String content;
  final int index;
  const GenderItemWidget(
      {@required this.content, @required this.index, Key key})
      : super(key: key);

  Widget itemBuilder(UserController con) {
    final hp = con.hp;
    return GestureDetector(
        child: Card(
            margin: EdgeInsets.symmetric(vertical: hp.height / 40),
            //semanticContainer: false,
            // color: hp.theme.primaryColorLight,
            child: Row(children: [
              Icon(
                  index == 0
                      ? Icons.male
                      : (index == 1
                          ? Icons.female
                          : (index == 2
                              ? Icons.transgender
                              : Icons.lock_outline_rounded)),
                  color: con.flags[index]
                      ? hp.theme.secondaryHeaderColor
                      : hp.theme.primaryColorLight),
              const SizedBox(
                width: 4,
              ),
              Text(content.capitalizeFirst,
                  style: TextStyle(
                      fontSize: content.length > 9 ? 12 : 12.8,
                      color: con.flags[index]
                          ? hp.theme.secondaryHeaderColor
                          : hp.theme.primaryColorLight))
            /*  Flexible(
                  child: Text(content.capitalizeFirst,
                      style: TextStyle(
                          fontSize: content.length > 9 ? 12 : 12.8,
                          color: con.flags[index]
                              ? hp.theme.secondaryHeaderColor
                              : hp.theme.primaryColorLight)))*/
            ]),
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: con.flags[index]
                        ? hp.theme.secondaryHeaderColor
                        : hp.theme.cardColor),
                borderRadius:
                    BorderRadius.all(Radius.circular(hp.radius / 100)))),
        onTap: () {
          con.setGender(index);
          con.genderIndex = index;
        });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GetBuilder<UserController>(
        builder: itemBuilder,
        init: UserController(
            context,
            context
                .findAncestorStateOfType<GetBuilderState<UserController>>()));
  }
}
