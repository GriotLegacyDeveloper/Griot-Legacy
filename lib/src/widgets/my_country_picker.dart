import 'package:collection/collection.dart' show IterableExtension;
//import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
//import 'package:country_code_picker/country_codes.dart';
//import 'package:country_code_picker/selection_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
//import 'package:universal_platform/universal_platform.dart';

class MyCountryCodePicker extends StatefulWidget {
  final ValueChanged<CountryCode> onChanged;
  final ValueChanged<CountryCode> onInit;
  final String initialSelection;
  final List<String> favorite;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final bool showCountryOnly;
  final InputDecoration searchDecoration;
  final TextStyle searchStyle;
  final TextStyle dialogTextStyle;
  final WidgetBuilder emptySearchBuilder;
  final Function(CountryCode) builder;
  final bool enabled;
  final TextOverflow textOverflow;
  final Icon closeIcon;
  final TextEditingController tc;

  /// Barrier color of ModalBottomSheet
  final Color barrierColor;

  /// Background color of ModalBottomSheet
  final Color backgroundColor;

  /// BoxDecoration for dialog
  final BoxDecoration boxDecoration;

  /// the size of the selection dialog
  final Size dialogSize;

  /// Background color of selection dialog
  final Color dialogBackgroundColor;

  /// used to customize the country list
  final List<String> countryFilter;

  /// shows the name of the country instead of the dialcode
  final bool showOnlyCountryWhenClosed;

  /// aligns the flag and the Text left
  ///
  /// additionally this option also fills the available space of the widget.
  /// this is especially useful in combination with [showOnlyCountryWhenClosed],
  /// because longer country names are displayed in one line
  final bool alignLeft;

  /// shows the flag
  final bool showFlag;

  final bool hideMainText;

  final bool showFlagMain;

  final bool showFlagDialog;

  /// Width of the flag images
  final double flagWidth;

  /// Use this property to change the order of the options
  final Comparator<CountryCode> comparator;

  /// Set to true if you want to hide the search part
  final bool hideSearch;

  /// Set to true if you want to show drop down button
  final bool showDropDownButton;

  /// [BoxDecoration] for the flag image
  final Decoration flagDecoration;

  /// An optional argument for injecting a list of countries
  /// with customized codes.
  final List<Map<String, String>> countryList;

  const MyCountryCodePicker({
    @required this.tc,
    this.onChanged,
    this.onInit,
    this.initialSelection,
    this.favorite = const [],
    this.textStyle,
    this.padding = const EdgeInsets.all(8.0),
    this.showCountryOnly = false,
    this.searchDecoration = const InputDecoration(),
    this.searchStyle,
    this.dialogTextStyle,
    this.emptySearchBuilder,
    this.showOnlyCountryWhenClosed = false,
    this.alignLeft = false,
    this.showFlag = true,
    this.showFlagDialog,
    this.hideMainText = false,
    this.showFlagMain,
    this.flagDecoration,
    this.builder,
    this.flagWidth = 32.0,
    this.enabled = true,
    this.textOverflow = TextOverflow.ellipsis,
    this.barrierColor,
    this.backgroundColor,
    this.boxDecoration,
    this.comparator,
    this.countryFilter,
    this.hideSearch = false,
    this.showDropDownButton = false,
    this.dialogSize,
    this.dialogBackgroundColor,
    this.closeIcon = const Icon(Icons.close),
    this.countryList = codes,
    Key key,
  }) : super(key: key);

  @override
  MyCountryCodePickerState createState() {
    List<Map<String, String>> jsonList = countryList;

    List<CountryCode> elements =
        jsonList.map((json) => CountryCode.fromJson(json)).toList();

    if (comparator != null) {
      elements.sort(comparator);
    }

    if (countryFilter != null && countryFilter.isNotEmpty) {
      final uppercaseCustomList =
          countryFilter.map((c) => c.toUpperCase()).toList();
      elements = elements
          .where((c) =>
              uppercaseCustomList.contains(c.code) ||
              uppercaseCustomList.contains(c.name) ||
              uppercaseCustomList.contains(c.dialCode))
          .toList();
    }

    return MyCountryCodePickerState(elements);
  }
}

class MyCountryCodePickerState extends State<MyCountryCodePicker> {
  CountryCode selectedItem;
  List<CountryCode> elements = [];
  List<CountryCode> favoriteElements = [];
  ThemeData get theme => Theme.of(context);
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;

  MyCountryCodePickerState(this.elements);

  @override
  Widget build(BuildContext context) {
    return widget.builder == null
        ? TextField(
            readOnly: true,
            controller: widget.tc,
            decoration: InputDecoration(
                hintStyle: TextStyle(color: theme.primaryColorLight),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  // borderSide: BorderSide(color: Colors.red, width: 2),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  //borderSide: BorderSide(color: Colors.red),
                ),
                filled: true,
                fillColor: theme.cardColor,
                contentPadding: EdgeInsets.only(top: height / 50, bottom: height / 50),
                border: InputBorder.none,
                prefixIcon: selectedItem == null
                    ? Icon(Icons.flag_outlined,
                        color: theme.primaryColorLight,)
                    : Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: width / 64),
                        child: Image.asset(selectedItem.flagUri,
                            package: 'country_code_picker',
                            width: widget.flagWidth)),
                hintText: "Country Code *"),
            style: TextStyle(color: theme.secondaryHeaderColor),
            onTap: widget.enabled ? showCountryCodePickerDialog : null)
        : InkWell(
            onTap: showCountryCodePickerDialog,
            child: widget.builder(selectedItem),
          );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    elements = elements.map((e) => e.localize(context)).toList();
    _onInit(selectedItem);
  }

  @override
  void didUpdateWidget(MyCountryCodePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialSelection != widget.initialSelection) {
      if (widget.initialSelection != null) {
        selectedItem = elements.firstWhere(
            (e) =>
                (e.code.toUpperCase() ==
                    widget.initialSelection.toUpperCase()) ||
                (e.dialCode == widget.initialSelection) ||
                (e.name.toUpperCase() == widget.initialSelection.toUpperCase()),
            orElse: () => elements[0]);
      } else {
        selectedItem = elements[0];
      }
      _onInit(selectedItem);
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.initialSelection != null) {
      selectedItem = elements.firstWhere(
          (e) =>
              (e.code.toUpperCase() == widget.initialSelection.toUpperCase()) ||
              (e.dialCode == widget.initialSelection) ||
              (e.name.toUpperCase() == widget.initialSelection.toUpperCase()),
          orElse: () => elements[0]);
    } else {
      selectedItem = elements[0];
    }

    favoriteElements = elements
        .where((e) =>
            widget.favorite.firstWhereOrNull((f) =>
                e.code.toUpperCase() == f.toUpperCase() ||
                e.dialCode == f ||
                e.name.toUpperCase() == f.toUpperCase()) !=
            null)
        .toList();
  }

  void showCountryCodePickerDialog() {
   /* if (!(UniversalPlatform.isAndroid || UniversalPlatform.isIOS)) {
      showDialog(
        barrierColor: widget.barrierColor ?? Colors.grey.withOpacity(0.5),
        // backgroundColor: widget.backgroundColor ?? Colors.transparent,
        context: context,
        builder: (context) => Center(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 500, maxWidth: 400),
            child: Dialog(
              child: SelectionDialog(
                elements,
                favoriteElements,
                showCountryOnly: widget.showCountryOnly,
                emptySearchBuilder: widget.emptySearchBuilder,
                searchDecoration: widget.searchDecoration,
                searchStyle: widget.searchStyle,
                textStyle: widget.dialogTextStyle,
                boxDecoration: widget.boxDecoration,
                showFlag: widget.showFlagDialog ?? widget.showFlag,
                flagWidth: widget.flagWidth,
                size: widget.dialogSize,
                backgroundColor: widget.dialogBackgroundColor,
                barrierColor: widget.barrierColor,
                hideSearch: widget.hideSearch,
                closeIcon: widget.closeIcon,
                flagDecoration: widget.flagDecoration,
              ),
            ),
          ),
        ),
      ).then((e) {
        if (e != null) {
          setState(() {
            selectedItem = e;
          });

          _publishSelection(e);
        }
      });
    }
     else {*/
     showModalBottomSheet(
        barrierColor: widget.barrierColor ?? Colors.grey.withOpacity(0.5),
        backgroundColor: widget.backgroundColor ?? Colors.transparent,
        context: context,
        builder: (context) => Center(
          child: SelectionDialog(
            elements,
            favoriteElements,
            showCountryOnly: widget.showCountryOnly,
            emptySearchBuilder: widget.emptySearchBuilder,
            searchDecoration: widget.searchDecoration,
            searchStyle: widget.searchStyle,
            textStyle: widget.dialogTextStyle,
            boxDecoration: widget.boxDecoration,
            showFlag: widget.showFlagDialog ?? widget.showFlag,
            flagWidth: widget.flagWidth,
            flagDecoration: widget.flagDecoration,
            size: widget.dialogSize,
            backgroundColor: widget.dialogBackgroundColor,
            barrierColor: widget.barrierColor,
            hideSearch: widget.hideSearch,
            closeIcon: widget.closeIcon,
          ),
        ),
      ).then((e) {
        if (e != null) {
          setState(() {
            selectedItem = e;
          });

          _publishSelection(e);
        }
      });
   // }
  }

  void _publishSelection(CountryCode e) {
    if (widget.onChanged != null) {
      widget.onChanged(e);
    }
    widget.tc.text = e.dialCode;
  }

  void _onInit(CountryCode e) {
    if (widget.onInit != null) {
      widget.onInit(e);
    }
    widget.tc.text = e.dialCode;
  }
}
