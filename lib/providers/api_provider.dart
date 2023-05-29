import 'dart:async';
import 'dart:isolate';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../database/models/models.dart';
import '../database/services/db_service.dart';

class ApiProvider extends ChangeNotifier {
  String baseUrl = 'telamarinera.zapto.org:16012';
  late Isolate isolate;
  int _pase = 0;

  List salas = [];
  List mesas = [];
  List productos = [];
  List usuarios = [];
  List reservas = [];
  List restaurantes = [];
  List familias = [];
  List comandas = [];

  Future<List> getSalas(Sala sala) async{
    salas = await DBProvider.db.getAllReg(sala);
    notifyListeners();
    return salas;
  }
  Future<List> getMesas(Mesa mesa) async{
    mesas = await DBProvider.db.getAllReg(mesa);
    return mesas;
  }
  Future<List> getProductos(Producto producto) async{
    productos = await DBProvider.db.getAllReg(producto);
    return productos;
  }
  Future<List> getUsuarios(Usuario usuario) async{
    usuarios = await DBProvider.db.getAllReg(usuario);
    return usuarios;
  }
  Future<List> getReservas(Reserva reserva) async{
    reservas = await DBProvider.db.getAllReg(reserva);
    return reservas;
  }
  Future<List> getRestaurantes(RestauranteInfo restauranteInfo) async{
    restaurantes = await DBProvider.db.getAllReg(restauranteInfo);
    return restaurantes;
  }
  Future<List> getFamilias(Familia familia) async{
    familias = await DBProvider.db.getAllReg(familia);
    return familias;
  }
  Future<List> getComandas(Comanda comanda) async{
    comandas = await DBProvider.db.getAllReg(comanda);
    return comandas;
  }

  void setSalas(Sala value) {
    salas.add(value);
    notifyListeners();
  }
  void setMesas(Mesa value) {
    mesas.add(value);
    notifyListeners();
  }
  void setProductos(Producto value) {
    salas.add(value);
    notifyListeners();
  }
  void setUsuarios(Usuario value) {
    salas.add(value);
    notifyListeners();
  }
  void setReservas(Reserva value) {
    salas.add(value);
    notifyListeners();
  }
  void setRestaurante(RestauranteInfo value) {
    salas.add(value);
    notifyListeners();
  }
  void setFamilias(Familia value) {
    salas.add(value);
    notifyListeners();
  }
  void setComanda(Comanda value) {
    salas.add(value);
    notifyListeners();
  }

  int get pase => _pase;

  set pase(int value) {
    _pase = value;
    notifyListeners();
  }

  Future<String> responseJsonData(
      String verb, Map<String, String> params) async {
    final dynamic url;
    final dynamic response;

    for(var x = 0; x < params.length; x++){
      // print(params.keys.first);
    }

    url = Uri.http(baseUrl, '/api/getResources/$verb', params);

    switch (verb) {
      case 'show':
        response = await http.get(url);
        break;
      case 'delete':
        response = await http.delete(url);
        break;
      case 'update':
        response = await http.patch(url);
        break;
      case 'store':
        response = await http.post(url);
        break;
      default:
        response = await http.get(Uri.https(baseUrl));
    }
    // print(response.body);
    return response.body;
  }
}
