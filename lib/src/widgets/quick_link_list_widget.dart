import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/controllers/other_controller.dart';
import 'package:griot_legacy_social_media_app/src/models/quick_link.dart';
import 'package:griot_legacy_social_media_app/src/widgets/quick_link_item_widget.dart';

class QuickLinkListWidget extends StatelessWidget {
  final List<QuickLink> links;
  const QuickLinkListWidget({Key key, @required this.links}) : super(key: key);

  Widget listBuilder(OtherController con) {
    return ListView.builder(
        shrinkWrap: true,
        itemBuilder: getItem,
        itemCount: links.length,
        physics: const NeverScrollableScrollPhysics());
  }

  Widget getItem(BuildContext context, int index) {
    return QuickLinkItemWidget(link: links[index]);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtherController>(
        builder: listBuilder,
        init: OtherController(
            context, context.findAncestorStateOfType<GetBuilderState>()));
  }
}
