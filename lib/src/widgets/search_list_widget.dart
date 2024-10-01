import 'package:flutter/material.dart';
import 'package:griot_legacy_social_media_app/src/widgets/search_item_widget.dart';

class SearchListWidget extends StatelessWidget {
  const SearchListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: getItem, itemCount: 8);
  }

  Widget getItem(BuildContext context, int index) {
    return const SearchItemWidget();
  }
}
