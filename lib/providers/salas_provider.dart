import 'package:flutter/material.dart';

class SalasProvider extends ChangeNotifier {
  String _mesaActual = 'S-254';
  String _salaSeleccionada = '';
  String _heroMesa = '';

  String get mesaActual => _mesaActual;

  set mesaActual(String value) {
    _mesaActual = value;
    notifyListeners();
  }

  String get salaSeleccionada => _salaSeleccionada;

  set salaSeleccionada(String value) {
    _salaSeleccionada = value;
    notifyListeners();
  }

  String get heroMesa => _heroMesa;

  set heroMesa(String value) {
    _heroMesa = value;
    notifyListeners();
  }
}