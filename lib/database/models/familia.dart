import 'dart:convert';

class Familia {
  Familia({
    required this.id,
    required this.nombre,
  });

  int id;
  String nombre;

  factory Familia.fromRawJson(String str) => Familia.fromJson(json.decode(str));

  factory Familia.fromJson(Map<String, dynamic> json) =>
      Familia(id: json['id'], nombre: json['nombre']);

  Map<String, dynamic> toJson() => {'id': '$id', 'nombre': nombre};
}
