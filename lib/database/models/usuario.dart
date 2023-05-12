import 'dart:convert';
import 'dart:typed_data';

class Usuario {
  Usuario({
    required this.id,
    required this.nombre,
    required this.rol,
    required this.qr,
    required this.code,
  });

  int id;
  String nombre;
  String rol;
  Uint8List qr;
  String code;

  factory Usuario.fromRawJson(String str) =>
      Usuario.fromJson(json.decode(str));

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
      id: int.parse(json['id']),
      nombre: json['nombre'],
      rol: json['rol'],
      qr: json['qr'], /* Para enseñar la imagen se puede usar Image.memory(snapshot.data[index].pict) */
      code: json['code']);

  Map<String, dynamic> toJson() => {
    'id': '$id',
    'nombre': nombre,
    'rol': rol,
    'qr': qr,
    'code': code
  };
}
