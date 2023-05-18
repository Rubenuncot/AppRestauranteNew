import 'package:flutter/material.dart';

class SalasProvider extends ChangeNotifier {
  String _mesaActual = 'S-254';
  String _salaSeleccionada = '';
  String _heroMesa = '';
  List<String> iconoStr = [];
  List<List<Color>> colors = [];
  List<String> nombresMesas = [];

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


  void setColors(List<Color> colors){
    if(nombresMesas.length > 4){
      colors.removeAt(0);
    }

    this.colors.add(colors);
    notifyListeners();
  }

  void setNames(String name){

    if(nombresMesas.length > 4){
      nombresMesas.removeAt(0);
    }
    nombresMesas.add(name);
    notifyListeners();
  }

  setIcons(String icon){
    if(nombresMesas.length > 4){
      iconoStr.removeAt(0);
    }
    iconoStr.add(icon);
    notifyListeners();
  }
}