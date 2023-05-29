import 'dart:convert';

class Sala {
  Sala({
    required this.id,
    required this.nombre,
  });

  int id;
  String nombre;

  factory Sala.fromRawJson(String str) => Sala.fromJson(json.decode(str));

  factory Sala.fromJson(Map<String, dynamic> json) =>
      Sala(id: json['id'], nombre: json['nombre']);

  Map<String, dynamic> toJson() => {'id': '$id', 'nombre': nombre};
}
