import 'dart:convert';

class Comanda {
  Comanda({
    required this.id,
    required this.lineasComanda,
    required this.precioTotal,
  });

  int id;
  int lineasComanda;
  double precioTotal;

  factory Comanda.fromRawJson(String str) =>
      Comanda.fromJson(json.decode(str));

  factory Comanda.fromJson(Map<String, dynamic> json) => Comanda(
      id: int.parse(json['id']),
      lineasComanda: int.parse(json['lineasComanda']),
      precioTotal: double.parse(json['precioTotal']));

  Map<String, dynamic> toJson() => {
    'id': '$id',
    'lineasComanda': '$lineasComanda',
    'precioTotal': '$precioTotal'
  };
}
