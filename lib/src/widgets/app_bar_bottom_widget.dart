import 'package:flutter/material.dart';

class AppBarBottomWidget extends PreferredSize {
  final Size size;
  const AppBarBottomWidget(
      {Key key, @required Widget child, @required this.size})
      : super(key: key, child: child, preferredSize: size);
}
