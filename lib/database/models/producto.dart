import 'dart:convert';

class Producto {
  Producto({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.idFamilia,
    required this.idTipo,
  });

  int? id;
  int idFamilia;
  String nombre;
  int idTipo;
  String descripcion;
  double precio;

  factory Producto.fromRawJson(String str) =>
      Producto.fromJson(json.decode(str));

  factory Producto.fromJson(Map<String, dynamic> json) =>
      Producto(
          id : json['id'],
          idFamilia : json['idFamilia'],
          idTipo : json['idTipo'],
          nombre: json['nombre'],
          descripcion: json['descripcion'],
          precio: json['precio'].runtimeType.toString() == 'String' ? double.parse(json['precio']) : json['precio']);

  Map<String, dynamic> toJson() => id != null
      ? {
          'id': '$id',
          'nombre': nombre,
          'descripcion': descripcion,
          'precio': '$precio',
          'idFamilia': '$idFamilia',
          'idTipo': '$idTipo'
        }
      : {'nombre': nombre, 'descripcion': descripcion, 'precio': '$precio', 'idFamilia': '$idFamilia', '$idTipo':'idtipo'};
}
