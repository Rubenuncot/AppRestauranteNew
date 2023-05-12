import 'dart:convert';

class Mesa {
  Mesa({
    required this.id,
    required this.nombre,
    required this.comanda,
    required this.sala,
    required this.capacidad,
    required this.comensales,
  });

  int id;
  int comanda;
  int sala;
  int capacidad;
  int comensales;
  String nombre;

  factory Mesa.fromRawJson(String str) => Mesa.fromJson(json.decode(str));

  factory Mesa.fromJson(Map<String, dynamic> json) => Mesa(
      id: int.parse(json['id']),
      nombre: json['nombre'],
      comanda: int.parse(json['comanda']),
      capacidad: int.parse(json['capacidad']),
      comensales: int.parse(json['comensales']),
      sala: int.parse(json['sala']));

  Map<String, dynamic> toJson() => {
        'id': '$id',
        'nombre': nombre,
        'comanda': '$comanda',
        'sala': '$sala',
        'capacidad': '$capacidad',
        'comensales': comensales
      };
}
