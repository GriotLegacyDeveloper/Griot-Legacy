import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:griot_legacy_social_media_app/src/helpers/helper.dart';

class PageLayout extends StatefulWidget {
  final List<Widget> contents;
  final double factor;
  const PageLayout({Key key, @required this.contents, @required this.factor})
      : super(key: key);

  @override
  PageLayoutState createState() => PageLayoutState();
}

class PageLayoutState extends State<PageLayout> {
  Helper get hp =>
      Helper.of(context, context.findAncestorStateOfType<GetBuilderState>());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
          child: Column(
            children: widget.contents,
          ),
          padding: EdgeInsets.symmetric(horizontal: hp.width / widget.factor)),
    ));
  }
}
