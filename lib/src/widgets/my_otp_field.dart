import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

typedef OnCodeEnteredCompletion = void Function(String value);
typedef OnCodeChanged = void Function(String value);

class MyOtpTextField extends StatefulWidget {
  final int numberOfFields;
  final double fieldWidth;
  final double borderWidth;
  final Color enabledBorderColor;
  final Color focusedBorderColor;
  final Color disabledBorderColor;
  final Color borderColor;
  final Color cursorColor;
  final EdgeInsetsGeometry margin;
  final TextInputType keyboardType;
  final TextStyle textStyle;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final OnCodeEnteredCompletion onSubmit;
  final OnCodeEnteredCompletion onCodeChanged;
  final bool obscureText;
  final bool showFieldAsBox;
  final bool enabled;
  final bool filled;
  final bool autoFocus;
  final bool hasCustomInputDecoration;
  final Color fillColor;
  final BorderRadius borderRadius;
  final InputDecoration decoration;
  final List<TextStyle> styles;

  const MyOtpTextField({
    Key key,
    this.numberOfFields = 4,
    this.fieldWidth = 40.0,
    this.margin = const EdgeInsets.only(right: 8.0),
    this.textStyle,
    this.styles = const [],
    this.keyboardType = TextInputType.number,
    this.borderWidth = 2.0,
    this.cursorColor,
    this.disabledBorderColor = const Color(0xFFE7E7E7),
    this.enabledBorderColor = const Color(0xFFE7E7E7),
    this.borderColor = const Color(0xFFE7E7E7),
    this.focusedBorderColor = const Color(0xFF4F44FF),
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.onSubmit,
    this.obscureText = false,
    this.showFieldAsBox = false,
    this.enabled = true,
    this.autoFocus = false,
    this.hasCustomInputDecoration = false,
    this.filled = false,
    this.fillColor = const Color(0xFFFFFFFF),
    this.decoration,
    this.onCodeChanged,
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
  })  : assert(numberOfFields > 0),
        assert(styles.length > 0
            ? styles.length == numberOfFields
            : styles.length == 0),
        super(key: key);

  @override
  MyOtpTextFieldState createState() => MyOtpTextFieldState();
}

class MyOtpTextFieldState extends State<MyOtpTextField> {
  List<String> _verificationCode;
  List<FocusNode> _focusNodes;
  List<TextEditingController> _textControllers;

  @override
  void initState() {
    super.initState();

    _verificationCode = List<String>.filled(widget.numberOfFields, null);
    _focusNodes = List<FocusNode>.filled(widget.numberOfFields, null);
    _textControllers = List<TextEditingController>.filled(
      widget.numberOfFields,
      null,
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (var controller in _textControllers) {
      controller?.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return generateTextFields(context);
  }

  Widget _buildTextField({
    @required BuildContext context,
    @required int index,
    TextStyle style,
  }) {
    return Container(
      width: widget.fieldWidth,
      margin: widget.margin,
      child: TextField(
        keyboardType: widget.keyboardType,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: style ?? widget.textStyle,
        autofocus: widget.autoFocus,
        cursorColor: widget.cursorColor,
        controller: _textControllers[index],
        focusNode: _focusNodes[index],
        enabled: widget.enabled,
        decoration: widget.hasCustomInputDecoration
            ? widget.decoration
            : InputDecoration(
                counterText: "",
                filled: widget.filled,
                fillColor: widget.fillColor,
                focusedBorder: widget.showFieldAsBox
                    ? outlineBorder(widget.focusedBorderColor)
                    : underlineInputBorder(widget.focusedBorderColor),
                enabledBorder: widget.showFieldAsBox
                    ? outlineBorder(widget.enabledBorderColor)
                    : underlineInputBorder(widget.enabledBorderColor),
                disabledBorder: widget.showFieldAsBox
                    ? outlineBorder(widget.disabledBorderColor)
                    : underlineInputBorder(widget.disabledBorderColor),
                border: InputBorder.none,
              ),
        obscureText: widget.obscureText,
        onChanged: (String value) {
          //save entered value in a list
          _verificationCode[index] = value;
          onCodeChanged(verificationCode: value);
          if (value.isEmpty) {
            changeFocusToPreviousNodeWhenValueIsErased(
                value: value, indexOfTextField: index);
          } else {
            changeFocusToNextNodeWhenValueIsEntered(
                value: value, indexOfTextField: index);
          }
          onSubmit(verificationCode: _verificationCode);
        },
      ),
    );
  }

  OutlineInputBorder outlineBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        width: widget.borderWidth,
        color: color,
      ),
      borderRadius: widget.borderRadius,
    );
  }

  UnderlineInputBorder underlineInputBorder(Color color) {
    return UnderlineInputBorder(
      borderSide: BorderSide(
        color: color,
        width: widget.borderWidth,
      ),
    );
  }

  Widget generateTextFields(BuildContext context) {
    List<Widget> textFields = List.generate(widget.numberOfFields, (int i) {
      addFocusNodeToEachTextField(index: i);
      addTextEditingControllerToEachTextField(index: i);

      if (widget.styles.isNotEmpty) {
        return _buildTextField(
          context: context,
          index: i,
          style: widget.styles[i],
        );
      }
      return _buildTextField(context: context, index: i);
    });

    return Row(
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      children: textFields,
    );
  }

  void addFocusNodeToEachTextField({@required int index}) {
    if (_focusNodes[index] == null) {
      _focusNodes[index] = FocusNode();
    }
  }

  void addTextEditingControllerToEachTextField({@required int index}) {
    if (_textControllers[index] == null) {
      _textControllers[index] = TextEditingController();
    }
  }

  void changeFocusToNextNodeWhenValueIsEntered({
    @required String value,
    @required int indexOfTextField,
  }) {
    if (value.isNotEmpty &&
        indexOfTextField + 1 != widget.numberOfFields &&
        int.tryParse(value) != null) {
      FocusScope.of(context).requestFocus(_focusNodes[indexOfTextField + 1]);
    } else if (int.tryParse(value) == null) {
      Fluttertoast.showToast(msg: "Only Numeric Value is allowed");
    }
  }

  void onSubmit({@required List<String> verificationCode}) {
    if (verificationCode.every((String code) => code != null && code != '')) {
      if (widget.onSubmit != null) {
        widget.onSubmit(verificationCode.join());
      }
    } else {
      Fluttertoast.showToast(msg: "Please submit verification code");
    }
  }

  void onCodeChanged({@required String verificationCode}) {
    if (widget.onCodeChanged != null) {
      widget.onCodeChanged(verificationCode);
    }
  }

  void changeFocusToPreviousNodeWhenValueIsErased({
    @required String value,
    @required int indexOfTextField,
  }) {
    if (value.isEmpty && indexOfTextField > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[indexOfTextField - 1]);
    }
  }
}
