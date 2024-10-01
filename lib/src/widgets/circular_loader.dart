import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:griot_legacy_social_media_app/src/helpers/helper.dart';

enum LoaderType {
  normal,
  rotatingPlain,
  doubleBounce,
  wave,
  wanderingCubes,
  wadingFour,
  fadingCube,
  pulse,
  chasingDots,
  threeBounce,
  circle,
  cubeGrid,
  fadingCircle,
  rotatingCircle,
  foldingCube,
  pumpingHeart,
  dualRing,
  hourGlass,
  pouringHourGlass,
  pouringHourGlassRefined,
  fadingGrid,
  fadingFour,
  ring,
  ripple,
  spinningCircle,
  squareCircle
}

class CircularLoader extends StatefulWidget {
  final double heightFactor;
  final LoaderType loaderType;
  final Color color;
  final Duration duration;
  const CircularLoader(
      {Key key,
      @required this.heightFactor,
      @required this.loaderType,
      @required this.duration,
      @required this.color})
      : super(key: key);

  @override
  CircularLoaderState createState() => CircularLoaderState();
}

class CircularLoaderState extends State<CircularLoader>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animationController;
  Helper get hp =>
      Helper.of(context, context.findAncestorStateOfType<GetBuilderState>());
  Timer get tm => Timer(timing, goFrontIfMounted);
  double get size => hp.height / widget.heightFactor;
  Duration get timing => widget.duration;

  @override
  void initState() {
    super.initState();
    assignState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final opacity = animation == null
        ? 1.0
        : (animation.value > 100.0 ? 1.0 : animation.value / 100);
    StatefulWidget lc;
    switch (widget.loaderType) {
      case LoaderType.chasingDots:
        lc = SpinKitChasingDots(
            color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.circle:
        lc = SpinKitCircle(color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.ring:
        lc = SpinKitRing(color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.cubeGrid:
        lc = SpinKitCubeGrid(color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.doubleBounce:
        lc = SpinKitDoubleBounce(
            color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.dualRing:
        lc = SpinKitDualRing(color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.fadingCircle:
        lc = SpinKitFadingCircle(
            color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.fadingCube:
        lc = SpinKitFadingCube(
            color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.fadingFour:
        lc = SpinKitFadingFour(
            color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.fadingGrid:
        lc = SpinKitFadingGrid(
            color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.foldingCube:
        lc = SpinKitFoldingCube(
            color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.hourGlass:
        lc =
            SpinKitHourGlass(color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.pouringHourGlass:
        lc = SpinKitPouringHourGlass(
            color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.pouringHourGlassRefined:
        lc = SpinKitPouringHourGlassRefined(
            color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.pulse:
        lc = SpinKitPulse(color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.pumpingHeart:
        lc = SpinKitPumpingHeart(
            color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.ripple:
        lc = SpinKitRipple(color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.rotatingCircle:
        lc = SpinKitRotatingCircle(
            color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.rotatingPlain:
        lc = SpinKitRotatingPlain(
            color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.spinningCircle:
        lc = SpinKitSpinningCircle(
            color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.squareCircle:
        lc = SpinKitSquareCircle(
            color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.threeBounce:
        lc = SpinKitThreeBounce(
            color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.wanderingCubes:
        lc = SpinKitWanderingCubes(
            color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.wave:
        lc = SpinKitWave(color: widget.color, duration: timing, size: size);
        break;
      case LoaderType.normal:
      default:
        lc = CircularProgressIndicator(color: widget.color);
        break;
    }
    return Opacity(
        opacity: opacity,
        child: SizedBox(height: size, child: Center(child: lc)));
  }

  void getData() {
    animationController = AnimationController(duration: timing, vsync: this);
    CurvedAnimation curve =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation = Tween<double>(begin: size, end: 0).animate(curve)
      ..addListener(reloadIfMounted);
  }

  void goFrontIfMounted() {
    if (mounted) animationController.forward();
  }

  void reloadIfMounted() {
    if (mounted) setState(hp.doNothing);
  }

  void assignState() {
    if (tm.isActive) {
      Future.delayed(Duration(seconds: tm.tick), getData);
    }
  }
}
