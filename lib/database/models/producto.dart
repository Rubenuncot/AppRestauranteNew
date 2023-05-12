import 'dart:convert';

class Producto {
  Producto({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.idFamilia,
  });

  int? id;
  int idFamilia;
  String nombre;
  String descripcion;
  double precio;

  factory Producto.fromRawJson(String str) =>
      Producto.fromJson(json.decode(str));

  factory Producto.fromJson(Map<String, dynamic> json) =>
      Producto(
          id : json['id'],
          idFamilia : json['idFamilia'],
          nombre: json['nombre'],
          descripcion: json['descripcion'],
          precio: json['precio']);

  Map<String, dynamic> toJson() => id != null
      ? {
          'id': '$id',
          'nombre': nombre,
          'descripcion': descripcion,
          'precio': '$precio',
          'idFamilia': '$idFamilia'
        }
      : {'nombre': nombre, 'descripcion': descripcion, 'precio': '$precio', 'idFamilia': '$idFamilia'};
}
