import 'dart:convert';

class Mesa {
  Mesa({
    required this.id,
    required this.nombre,
    required this.sala,
    required this.capacidad,
    required this.comensales,
  });

  int id;
  int sala;
  int capacidad;
  int comensales;
  String nombre;

  factory Mesa.fromRawJson(String str) => Mesa.fromJson(json.decode(str));

  factory Mesa.fromJson(Map<String, dynamic> json) => Mesa(
      id: json['id'],
      nombre: json['nombre'],
      capacidad: json['capacidad'],
      comensales: json['comensales'],
      sala: json['idSala']);

  Map<String, dynamic> toJson() => {
        'id': '$id',
        'nombre': nombre,
        'idSala': '$sala',
        'capacidad': '$capacidad',
        'comensales': comensales
      };
}
