import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FocusWrap extends StatefulWidget {
  final FocusNode focusNode;
  final Widget child;
  final Function onNext;
  final Function onPrevious;

  const FocusWrap(
      {Key key,
      @required this.focusNode,
      @required this.onNext,
      @required this.onPrevious,
      @required this.child})
      : super(key: key);

  @override
  FocusWrapState createState() => FocusWrapState();
}

class FocusWrapState extends State<FocusWrap> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_handleFocusChanged);
  }

  @override
  void didUpdateWidget(FocusWrap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode.removeListener(_handleFocusChanged);
      widget.focusNode.addListener(_handleFocusChanged);
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChanged);
    _detachKeyboardIfAttached();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (widget.focusNode.hasFocus) {
      _attachKeyboardIfDetached();
    } else {
      _detachKeyboardIfAttached();
    }
  }

  bool _listening = false;

  void _attachKeyboardIfDetached() {
    if (_listening) return;
    RawKeyboard.instance.addListener(_handleRawKeyEvent);
    _listening = true;
  }

  void _detachKeyboardIfAttached() {
    if (!_listening) return;
    RawKeyboard.instance.removeListener(_handleRawKeyEvent);
    _listening = false;
  }

  void _handleRawKeyEvent(RawKeyEvent event) {
    if (event is RawKeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.keyQ) {
        widget.onNext();
      } else if ((event.isShiftPressed &&
              event.logicalKey == LogicalKeyboardKey.tab) ||
          event.isKeyPressed(LogicalKeyboardKey.backspace)) {
        widget.onPrevious();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
