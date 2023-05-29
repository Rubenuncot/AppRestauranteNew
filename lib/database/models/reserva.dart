import 'dart:convert';

class Reserva {
  Reserva({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.telefono,
    required this.comensales,
    required this.hora,
    required this.fecha,
    required this.idMesa,
    required this.anotaciones,
  });

  int id;
  String nombre;
  String apellidos;
  String telefono;
  int comensales;
  int idMesa;
  DateTime hora;
  DateTime fecha;
  String anotaciones;

  factory Reserva.fromRawJson(String str) =>
      Reserva.fromJson(json.decode(str));

  factory Reserva.fromJson(Map<String, dynamic> json) => Reserva(
      id: json['id'],
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      telefono: json['telefono'],
      comensales: json['comensales'],
      idMesa: json['idMesa'],
      hora: DateTime.parse(json['hora']),
      fecha: DateTime.parse(json['fecha']),
      anotaciones: json['anotaciones']
  );

  Map<String, dynamic> toJson() => {
    'id': '$id',
    'nombre' : nombre,
    'apellidos' : apellidos,
    'telefono' : telefono,
    'comensales' : '$comensales',
    'idMesa' : '$idMesa',
    'hora' : hora.toString(),
    'fecha' : fecha.toString(),
    'anotaciones' : anotaciones
  };
}
