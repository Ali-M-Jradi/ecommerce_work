import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/parameter.dart';
import 'dart:convert';

class ParameterProvider extends ChangeNotifier {
  List<Parameter> _parameters = [];

  List<Parameter> get parameters => List.unmodifiable(_parameters);

  ParameterProvider() {
    loadParameters();
  }

  Future<void> loadParameters() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('parameters');
    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data);
      _parameters = decoded.map((e) {
        final param = Parameter.fromMap(e);
        // Always fallback to empty string if description is null or not a String
        return param;
      }).toList();
      notifyListeners();
    }
  }

  Future<void> saveParameters() async {
    final prefs = await SharedPreferences.getInstance();
    final data = jsonEncode(_parameters.map((e) => e.toMap()).toList());
    await prefs.setString('parameters', data);
  }


  void addParameter(Parameter param) {
    _parameters.add(param);
    saveParameters();
    notifyListeners();
  }

  void updateParameter(int index, Parameter param) {
    _parameters[index] = param;
    saveParameters();
    notifyListeners();
  }

  bool keyExists(String key, [int? ignoreIndex]) {
    for (int i = 0; i < _parameters.length; i++) {
      if (_parameters[i].key == key && (ignoreIndex == null || i != ignoreIndex)) {
        return true;
      }
    }
    return false;
  }

  void deleteParameter(int index) {
    _parameters.removeAt(index);
    saveParameters();
    notifyListeners();
  }
}
