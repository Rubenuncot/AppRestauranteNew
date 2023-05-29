import 'dart:convert';

class Comanda {
  Comanda({
    required this.id,
    required this.precioTotal,
  });

  int id;
  double precioTotal;

  factory Comanda.fromRawJson(String str) =>
      Comanda.fromJson(json.decode(str));

  factory Comanda.fromJson(Map<String, dynamic> json) => Comanda(
      id:json['id'],
      precioTotal: json['precioTotal'].runtimeType.toString() == 'int' ? double.parse(json['precioTotal'].toString()) : json['precioTotal']);

  Map<String, dynamic> toJson() => {
    'id': '$id',
    'precioTotal': '$precioTotal'
  };
}
