import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:prueba_widgets/database/models/models.dart';

class LogProvider extends ChangeNotifier {
  bool _waiting = false;
  List users = [];
  Usuario user = Usuario(id: 0, name: 'name', apellido: 'apellido', dni: 'dni', email: 'email', imagenQr: Uint8List.fromList([]), codigoQr: 'codigoQr');

  bool get waiting => _waiting;

  set waiting(bool value) {
    _waiting = value;
    notifyListeners();
  }
}