import 'dart:convert';

class Ticket {
  Ticket({
    required this.id,
    required this.lineasComanda,
    required this.precioTotal,
    required this.fecha,
    required this.restauranteInfo,
  });

  int id;
  int lineasComanda;
  int restauranteInfo;
  double precioTotal;
  DateTime fecha;

  factory Ticket.fromRawJson(String str) =>
      Ticket.fromJson(json.decode(str));

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
      id: json['id'],
      lineasComanda: json['lineasComanda'],
      precioTotal: json['precioTotal'],
      restauranteInfo: json['restauranteInfo'],
      fecha: DateTime.parse(json['fecha']),
  );

  Map<String, dynamic> toJson() => {
    'id': '$id',
    'lineasComanda': '$lineasComanda',
    'precioTotal': '$precioTotal'
  };
}
