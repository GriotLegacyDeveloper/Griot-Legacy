import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/controllers/other_controller.dart';
import 'package:griot_legacy_social_media_app/src/widgets/my_button.dart';

class SearchItemWidget extends StatelessWidget {
  const SearchItemWidget({Key key}) : super(key: key);

  Widget itemBuilder(OtherController con) {
    final hp = con.hp;
    return Card(
      margin: EdgeInsets.symmetric(
          vertical: hp.height / 100, horizontal: hp.width / 50),
      color: hp.theme.bottomAppBarColor,
      child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: hp.height / 50, horizontal: hp.width / 50),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.only(
                      left: hp.width / 80, bottom: hp.height / 80),
                  child: Row(
                    children: [
                      CircleAvatar(
                          radius: hp.radius / 25,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person_outline,
                              color: hp.theme.secondaryHeaderColor)),
                      Padding(
                          padding: EdgeInsets.only(left: hp.width / 50),
                          child: Text("Johnson Doe",
                              style: TextStyle(
                                  color: hp.theme.secondaryHeaderColor)))
                    ],
                  )),
              MyButton(
                  label: "Send Message",
                  labelWeight: FontWeight.w500,
                  onPressed: () {},
                  heightFactor: 64,
                  widthFactor: 3.2,
                  radiusFactor: 160)
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtherController>(
        builder: itemBuilder,
        init: OtherController(
            context, context.findAncestorStateOfType<GetBuilderState>()));
  }
}
