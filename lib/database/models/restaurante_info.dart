import 'dart:convert';
import 'dart:typed_data';

class RestauranteInfo {
  RestauranteInfo({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.domicilioFiscal,
    required this.cif,
    required this.logo,
  });

  int id;
  String nombre;
  String direccion;
  String domicilioFiscal;
  String cif;
  String telefono;
  Uint8List logo;

  factory RestauranteInfo.fromRawJson(String str) =>
      RestauranteInfo.fromJson(json.decode(str));

  factory RestauranteInfo.fromJson(Map<String, dynamic> json) => RestauranteInfo(
      id: json['id'],
      nombre: json['nombre'],
    direccion: json['direccion'],
    telefono: json['telefono'],
    logo: json['telefono'],
    cif: json['cif'],
    domicilioFiscal: json['domicilioFiscal']
  );

  Map<String, dynamic> toJson() => {
    'id': '$id',
    'nombre' : nombre,
    'direccion' : direccion,
    'telefono' : telefono,
    'cif' : cif,
    'domicilioFiscal' : domicilioFiscal,
    'logo': logo
  };
}
