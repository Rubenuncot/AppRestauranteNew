import 'package:flutter/material.dart';

class SalasProvider extends ChangeNotifier {
  String _salaActual = 'S-254';

  String get salaActual => _salaActual;

  set salaActual(String value) {
    _salaActual = value;
    notifyListeners();
  }
}