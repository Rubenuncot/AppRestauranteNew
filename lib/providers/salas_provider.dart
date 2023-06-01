import 'package:flutter/material.dart';
import 'package:prueba_widgets/shared_preferences/preferences.dart';

class SalasProvider extends ChangeNotifier {
  String _mesaActual = 'S-254';
  String _salaSeleccionada = '';
  String _heroMesa = '';
  int _idMesa = 0;
  List<String> iconoStr = [];
  List<List<Color>> colors = [];
  List<String> nombresMesas = [];
  bool _notAdd = false;

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


  int get idMesa => _idMesa;

  set idMesa(int value) {
    _idMesa = value;
    notifyListeners();
  }

  void setColors(List<Color> colors){
    if(!_notAdd){
      if (this.colors.length > 4) {
        this.colors.removeAt(0);
      }

      this.colors.add(colors);
      Preferences.saveColorsToPreferences(this.colors);
    }
  }

  void setNames(String name){
    if(!nombresMesas.contains(name)){
      if (nombresMesas.length > 4) {
        nombresMesas.removeAt(0);
      }
      nombresMesas.add(name);
      Preferences.saveNameToPreferences(nombresMesas);
      _notAdd = false;
    } else {
      _notAdd = true;
    }

  }

  setIcons(String icon){
    if(!_notAdd){
      if (iconoStr.length > 4) {
        iconoStr.removeAt(0);
      }
      iconoStr.add(icon);
      Preferences.saveIconsToPreferences(iconoStr);
    }
  }

  void getLists(BuildContext context){
    Preferences.getNamesFromPreferences(context);
    Preferences.getIconsFromPreferences(context);
    Preferences.getColorsFromPreferences(context);
  }
}