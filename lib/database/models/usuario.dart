import 'dart:convert';
import 'dart:typed_data';

class Usuario {
  Usuario({
    required this.id,
    required this.name,
    required this.apellido,
    required this.dni,
    required this.email,
    required this.imagenQr,
    required this.codigoQr,
  });

  int id;
  String name;
  String email;
  String apellido;
  String dni;
  Uint8List imagenQr;
  String codigoQr;

  factory Usuario.fromRawJson(String str) =>
      Usuario.fromJson(json.decode(str));

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
      id:json['id'],
      name: json['name'],
      apellido: json['apellidos'],
      dni: json['dni'],
      email: json['email'],
      imagenQr: Uint8List.fromList(utf8.encode(json['imagenQr'].toString())), /* Para enseñar la imagen se puede usar Image.memory(snapshot.data[index].pict) */
      codigoQr: json['codigoQr']);

  Map<String, dynamic> toJson() => {
    'id': '$id',
    'name': name,
    'imagenQr': imagenQr,
    'codigoQr': codigoQr,
    'email':email,
    'apellidos':apellido,
    'dni':dni
  };
}
