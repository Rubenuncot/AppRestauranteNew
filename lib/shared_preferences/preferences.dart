import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:prueba_widgets/providers/salas_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _prefs;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static void saveColorsToPreferences(List<List<Color>> colors) {
    List<List<int>> colorValues = colors.map((list) => list.map((color) => color.value).toList()).toList();
    _prefs.setString('colors', json.encode(colorValues));
  }

  static void getColorsFromPreferences(BuildContext context) {
    String colorsJson = _prefs.getString('colors') ?? '';

    if (colorsJson != '') {
      List<List<dynamic>> colorValues = json.decode(colorsJson).cast<List<dynamic>>();
      List<List<Color>> colors = colorValues.map((list) => list.map((colorValue) => Color(colorValue as int)).toList()).toList();
      Provider.of<SalasProvider>(context, listen: false).colors = colors;
    }
  }

  static void saveNameToPreferences(List<String> names) {
    _prefs.setStringList('names', names);
  }

  static void getNamesFromPreferences(BuildContext context) {
    Provider.of<SalasProvider>(context, listen: false).nombresMesas = _prefs.getStringList('names') ?? [];
  }

  static void saveIconsToPreferences(List<String> icons) {
    _prefs.setStringList('icons', icons);
  }

  static void getIconsFromPreferences(BuildContext context) {
    Provider.of<SalasProvider>(context, listen: false).iconoStr = _prefs.getStringList('icons') ?? [];
  }

  static void saveLoginStateToPreferences(bool state){
    _prefs.setBool('loginState', state);
    _prefs.setString('colors', '');
    _prefs.setStringList('names', []);
    _prefs.setStringList('icons', []);
    if(state){
      SystemNavigator.pop();
    }
  }

  static bool getLoginStateFromPreferences(){
    return _prefs.getBool('loginState') ?? true;
  }
}
