import 'dart:convert';

class Familia {
  Familia({
    required this.id,
    required this.nombre,
    required this.icono
  });

  int id;
  String nombre;
  String icono;

  factory Familia.fromRawJson(String str) => Familia.fromJson(json.decode(str));

  factory Familia.fromJson(Map<String, dynamic> json) =>
      Familia(id: json['id'], nombre: json['nombre'], icono: json['icono']);

  Map<String, dynamic> toJson() => {'id': '$id', 'nombre': nombre, 'icono':icono};
}
