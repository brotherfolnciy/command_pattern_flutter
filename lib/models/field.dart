import 'package:flutter/cupertino.dart';

class Field {
  final String key;
  final String value;

  Field(this.key, this.value);
}

class FieldModel extends ChangeNotifier {
  final List<Field> _fields = [];

  List<Field> get fields => _fields;

  void setFields(Map<String, String> fields) {
    _fields.clear();
    fields.forEach((key, value) => _fields.add(Field(key, value)));
    notifyListeners();
  }
}
