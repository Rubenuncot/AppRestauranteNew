import 'dart:convert';

class LineasComanda {
  LineasComanda({
    required this.id,
    required this.precio,
    required this.idProducto,
    required this.idMesa,
    required this.cantidad,
    required this.enviado,
    this.detalle,
  });

  int id;
  int idMesa;
  int idProducto;
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
      idProducto:json['idProducto'],
      cantidad:json['cantidad'],
      enviado:json['enviado'],
      detalle: json['detalle']);

  Map<String, dynamic> toJson() => {
        'id': '$id',
        'idMesa': '$idMesa',
        'precio': '$precio',
        'idProducto': '$idProducto',
        'cantidad': '$cantidad',
        'enviado': '$enviado',
        'detalle': detalle
      };
  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;

    return other is LineasComanda &&
        id == other.id &&
        // Compara las demás propiedades relevantes
        cantidad == other.cantidad &&
        precio == other.precio &&
        enviado == other.enviado &&
        detalle == other.detalle;
  }

  @override
  int get hashCode => id.hashCode;
}
