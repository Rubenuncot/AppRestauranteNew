import 'dart:convert';

class LineasComanda {
  LineasComanda({
    required this.id,
    required this.precio,
    required this.producto,
    required this.cantidad,
    required this.enviado,
    required this.detalle,
  });

  int id;
  int producto;
  int cantidad;
  double precio;
  int enviado;
  String detalle;

  factory LineasComanda.fromRawJson(String str) =>
      LineasComanda.fromJson(json.decode(str));

  factory LineasComanda.fromJson(Map<String, dynamic> json) => LineasComanda(
      id: json['id'],
      precio: json['precio'],
      producto:json['producto'],
      cantidad:json['cantidad'],
      enviado:json['enviado'],
      detalle: json['detalle']);

  Map<String, dynamic> toJson() => {
        'id': '$id',
        'precio': '$precio',
        'producto': '$producto',
        'cantidad': '$cantidad',
        'enviado': '$enviado',
        'detalle': detalle
      };
}
