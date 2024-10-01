import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/controllers/other_controller.dart';
import 'package:griot_legacy_social_media_app/src/models/quick_link.dart';
import 'package:griot_legacy_social_media_app/src/widgets/settings_item_widget.dart';

class SettingsListWidget extends StatelessWidget {
  final List<QuickLink> links;
  final String come;
  const SettingsListWidget({Key key, @required this.links, this.come}) : super(key: key);

  Widget listBuilder(OtherController con) {
    return ListView.builder(
      itemBuilder: getItem,
      itemCount: links.length,
      //physics: const NeverScrollableScrollPhysics(),
    );
  }

  Widget getItem(BuildContext context, int index) {
    return SettingsItemWidget(link: links[index], index: index,comming: come,);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtherController>(
        builder: listBuilder,
        init: OtherController(
            context, context.findAncestorStateOfType<GetBuilderState>()));
  }
}
