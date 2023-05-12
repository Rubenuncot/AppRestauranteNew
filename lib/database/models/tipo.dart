import 'dart:convert';

class Tipo {
  Tipo({
    required this.id,
    required this.nombre,
  });

  int id;
  String nombre;

  factory Tipo.fromRawJson(String str) => Tipo.fromJson(json.decode(str));

  factory Tipo.fromJson(Map<String, dynamic> json) =>
      Tipo(id: int.parse(json['id']), nombre: json['nombre']);

  Map<String, dynamic> toJson() => {'id': '$id', 'nombre': nombre};
}
