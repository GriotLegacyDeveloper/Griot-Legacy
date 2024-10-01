import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class SelectionModel {
  String _id;
  String _name;
  String _isSelected;

  set isSelected(String value) {
    _isSelected = value;
  }

  String get isSelected => _isSelected;

  String get name => _name;

  SelectionModel(this._id, this._name);
  SelectionModel.update(this._isSelected);

  String get id => _id;
  Map getJson() {
    var map = {};
    map["key"] = id;
    return map;
  }
}
