import 'dart:convert';

class MesaProducto {
  MesaProducto({
    required this.id,
    required this.producto,
    required this.mesa,
  });

  int id;
  int producto;
  int mesa;

  factory MesaProducto.fromRawJson(String str) =>
      MesaProducto.fromJson(json.decode(str));

  factory MesaProducto.fromJson(Map<String, dynamic> json) => MesaProducto(
      id: json['id'],
      producto:json['producto'],
      mesa: json['mesa'],
  );

  Map<String, dynamic> toJson() => {
    'id': '$id',
    'producto': '$producto',
    'mesa': '$mesa',
  };
}
