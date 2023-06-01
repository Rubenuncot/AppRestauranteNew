import 'dart:convert';

class LineasComanda {
  LineasComanda({
    required this.id,
    required this.precio,
    required this.producto,
    required this.idMesa,
    required this.cantidad,
    required this.enviado,
    this.detalle,
  });

  int id;
  int idMesa;
  int producto;
  int cantidad;
  double precio;
  int enviado;
  String? detalle;

  factory LineasComanda.fromRawJson(String str) =>
      LineasComanda.fromJson(json.decode(str));

  factory LineasComanda.fromJson(Map<String, dynamic> json) => LineasComanda(
      id: json['id'],
      idMesa: json['idMesa'],
      precio: double.parse(json['precio'].toString()),
      producto:json['idProducto'],
      cantidad:json['cantidad'],
      enviado:json['enviado'],
      detalle: json['detalle']);

  Map<String, dynamic> toJson() => {
        'id': '$id',
        'idMesa': '$idMesa',
        'precio': '$precio',
        'idProducto': '$producto',
        'cantidad': '$cantidad',
        'enviado': '$enviado',
        'detalle': detalle
      };
}
