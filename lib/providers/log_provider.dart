import 'package:flutter/cupertino.dart';

class LogProvider extends ChangeNotifier {
  bool _waiting = false;

  bool get waiting => _waiting;

  set waiting(bool value) {
    _waiting = value;
    notifyListeners();
  }
}