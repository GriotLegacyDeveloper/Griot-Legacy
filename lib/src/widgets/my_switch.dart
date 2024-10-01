import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:griot_legacy_social_media_app/src/helpers/helper.dart';

class MySwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const MySwitch({Key key, @required this.value, @required this.onChanged})
      : super(key: key);

  @override
  MySwitchState createState() => MySwitchState();
}

class MySwitchState extends State<MySwitch>
    with SingleTickerProviderStateMixin {
  Animation _circleAnimation;
  AnimationController _animationController;
  Helper get hp => Helper.of(context, GetBuilderState());
  double get size => sqrt(pow(hp.height, 2) + pow(hp.width, 2));

  Widget switchBuilder(BuildContext context, Widget child) {
    return GestureDetector(
      onTap: () {
        if (_animationController.isCompleted) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
        print(child);
        widget.value == false
            ? widget.onChanged(true)
            : widget.onChanged(false);
        // widget.onChanged(widget.value);
      },
      child: Container(
        width: hp.width / 6.4,
        height: hp.height / 32,
        decoration: BoxDecoration(
            border: Border.all(color: hp.theme.secondaryHeaderColor),
            borderRadius: BorderRadius.circular(size / 40),
            color: _circleAnimation.value == Alignment.centerLeft
                ? hp.theme.cardColor
                : hp.theme.canvasColor),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: hp.width / 640),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
             /* _circleAnimation.value == Alignment.centerRight
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: hp.width / 64),
                      child: Text(
                        'ON',
                        style: TextStyle(
                            color: hp.theme.secondaryHeaderColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.8),
                      ),
                    )
                  : Container(),*/
              Align(
                alignment: _circleAnimation.value,
                child: Container(
                  width: size / 50,
                  height: size / 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _circleAnimation.value == Alignment.centerLeft
                          ? hp.theme.secondaryHeaderColor
                          : hp.theme.primaryColor),
                ),
              ),
             /* _circleAnimation.value == Alignment.centerLeft
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: hp.width / 100),
                      child: Text(
                        'OFF',
                        style: TextStyle(
                            color: hp.theme.shadowColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.8),
                      ),
                    )
                  : Container(),*/
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(
            begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
            end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(
            parent: _animationController, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController, builder: switchBuilder);
  }
}
