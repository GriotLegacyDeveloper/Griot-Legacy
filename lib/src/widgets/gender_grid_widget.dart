import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:griot_legacy_social_media_app/src/controllers/user_controller.dart';

import 'gender_item_widget.dart';

class GenderGridWidget extends StatelessWidget {
  const GenderGridWidget({Key key}) : super(key: key);

  /*Widget getItem(BuildContext context, int index) {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>();
    return GenderItemWidget(
        content: state.controller.genders[index], index: index);
  }*/
  Widget gridBuilder(UserController con) {
    final hp = con.hp;
   // String text="";

    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: con.genders.length,
        padding: const EdgeInsets.all(0.0),

        itemBuilder: (BuildContext context,int index){
          String key = con.genders.elementAt(index);

      return GestureDetector(
          child: Padding(
            padding: const EdgeInsets.only(left: 2,right: 3,top: 10),
            child: Container(
              decoration:  BoxDecoration(
                color: hp.theme.cardColor,
                border: Border.all(color: con.flags[index]
                    ? hp.theme.secondaryHeaderColor
                    : hp.theme.cardColor),
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              ),
              //  margin: EdgeInsets.symmetric(vertical: hp.height / 40),
                //semanticContainer: false,
                // color: hp.theme.primaryColorLight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8,left: 8),
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
                    Text(key,
                        style: TextStyle(
                            fontSize: key.length > 9 ? 12 : 12.8,
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
                ),
               /* shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: con.flags[index]
                            ? hp.theme.secondaryHeaderColor
                            : hp.theme.cardColor),
                    borderRadius:
                    BorderRadius.all(Radius.circular(hp.radius / 100)))*/
            ),
          ),
          onTap: () {
            con.setGender(index);
            con.genderIndex = index;
          });
        /*  Row(
        children: List<String>.from(con.genders)
            .map<GenderItemWidget>((e) =>
            GenderItemWidget(content: e, index: index))
            .toList()
      );*/
    });
     /* GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(4),
        crossAxisSpacing: hp.height / hp.width,
        // childAspectRatio: (hp.width) / hp.height,
        crossAxisCount: con.genders.length,
        children: List<String>.from(con.genders)
            .map<GenderItemWidget>((e) =>
                GenderItemWidget(content: e, index: con.genders.indexOf(e)))
            .toList());*/
  }




  @override
  Widget build(BuildContext context) {
    final state =
        context.findAncestorStateOfType<GetBuilderState<UserController>>() ??
            GetBuilderState<UserController>();
    // TODO: implement build
    return GetBuilder<UserController>(
        builder: gridBuilder, init: UserController(context, state));
  }
}
