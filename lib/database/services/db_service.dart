import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prueba_widgets/database/models/models.dart';
import 'package:prueba_widgets/database/models/versions.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  Future<Database?> initDB() async {
    // Path de donde almacenaremos la base de datos.
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentDirectory.path, 'Restaurante.db');

    // Crear la base de datos
    return await openDatabase(path, version: 6, onOpen: (db) {},
        onCreate: (db, version) async {

      /* Comprobada (SALAS) */
      await db.execute('''
      CREATE TABLE Sala (
        id INTEGER PRIMARY KEY,
        nombre TEXT
      )
    ''');

      /* Comprobada (FAMILIAS) */
      await db.execute('''
      CREATE TABLE Familia (
        id INTEGER PRIMARY KEY,
        nombre TEXT
      )
    ''');

      /* Comprobada (PRODUCTOS) */
      await db.execute('''
      CREATE TABLE Producto (
        id INTEGER PRIMARY KEY,
        nombre TEXT,
        descripcion TEXT,
        idFamilia INTEGER,
        precio REAL,
        idTipo INTEGER,
        FOREIGN KEY (idTipo) REFERENCES Familia (id)
      )
    ''');

      /* Comprobada (LINEAS COMANDA) */
      await db.execute('''
      CREATE TABLE LineasComanda (
        id INTEGER PRIMARY KEY,
        idMesa INTEGER,
        precio REAL,
        producto INTEGER,
        cantidad INTEGER,
        enviado INTEGER,
        detalle TEXT,
        FOREIGN KEY (producto) REFERENCES Producto (id),
        FOREIGN KEY (idMesa) REFERENCES Mesa (id)
      )
    ''');

      /* Comprobada (COMANDAS) */
      await db.execute('''
      CREATE TABLE Comanda (
        id INTEGER PRIMARY KEY,
        precioTotal REAL
      )
    ''');

      /* Comprobada (RESTAURANTE INFO) */
      await db.execute('''
      CREATE TABLE RestauranteInfo (
        id INTEGER PRIMARY KEY,
        nombre TEXT,
        direccion TEXT,
        domicilioFiscal TEXT,
        telefono TEXT,
        cif TEXT,
        logo BLOB
      )
    ''');

      /* Comprobada (TICKET) */
      await db.execute('''
      CREATE TABLE Ticket (
        id INTEGER PRIMARY KEY,
        lineasComanda INTEGER,
        precioTotal REAL,
        fecha TEXT,
        restauranteInfo INTEGER,
        FOREIGN KEY (lineasComanda) REFERENCES LineasComanda (id),
        FOREIGN KEY (restauranteInfo) REFERENCES RestauranteInfo (id)
      )
    ''');

      /* Comprobada (MESAS) */ // Los productos se sacan teniendo el id de la mesa y haciendo un select a MesasProductos
      await db.execute('''
      CREATE TABLE Mesa (
        id INTEGER PRIMARY KEY,
        nombre TEXT,
        comanda INTEGER,
        idSala INTEGER,
        capacidad INTEGER,
        comensales INTEGER,
        FOREIGN KEY (comanda) REFERENCES Comanda (id),
        FOREIGN KEY (idSala) REFERENCES Sala (id)
      )
    ''');

      /* Comprobada (RESERVAS) */
      await db.execute('''
      CREATE TABLE Reserva (
        id INTEGER PRIMARY KEY,
        nombre TEXT,
        apellidos TEXT,
        telefono TEXT,
        comensales INTEGER,
        hora TEXT,
        fecha Date,
        anotaciones TEXT,
        idMesa INTEGER,
        FOREIGN KEY (idMesa) REFERENCES Mesa (id)
      )
    ''');

      /* Comprobada (USUARIOS) */
      await db.execute('''
      CREATE TABLE Usuario (
        id INTEGER PRIMARY KEY,
        name TEXT,
        apellidos TEXT,
        dni TEXT,
        email TEXT,
        imagenQr BLOB,
        codigoQr TEXT
      )
    ''');

      await db.execute('''
      CREATE TABLE Version (
        id INTEGER PRIMARY KEY,
        version INTEGER,
        changes TEXT
      )
    ''');
    });
  }

  /* ----- Métodos de inserción de datos -----*/

  Future<int> newReg(dynamic newReg) async {
    final db = await database;
    final res = db!.insert('${newReg.runtimeType}', newReg.toJson());
    return res;
  }

/* ----- Fin métodos de inserción de datos -----*/

/* -------------------------------------------- */

/* ----- Métodos de obtención de datos -----*/

  Future<List> getAllReg(dynamic obj) async {
    final db = await database;
    final List<dynamic> objects = [];
    final res = await db?.query('${obj.runtimeType}');

    if(res==null || res.isEmpty){
      return objects;
    }

    for(var x = 0; x < (res != null ? res.length : 0); x++ ){
      switch('${obj.runtimeType}'){
        case 'Mesa':
          objects.add(Mesa.fromJson(res[x]));
          break;
        case 'Sala':
          objects.add(Sala.fromJson(res[x]));
          break;
        case 'Producto':
          objects.add(Producto.fromJson(res[x]));
          break;
        case 'Reserva':
          objects.add(Reserva.fromJson(res[x]));
          break;
        case 'Usuario':
          objects.add(Usuario.fromJson(res[x]));
          break;
        case 'Ticket':
          objects.add(Ticket.fromJson(res[x]));
          break;
        case 'RestauranteInfo':
          objects.add(RestauranteInfo.fromJson(res[x]));
          break;
        case 'MesaProducto':
          objects.add(MesaProducto.fromJson(res[x]));
          break;
        case 'LineasComanda':
          objects.add(LineasComanda.fromJson(res[x]));
          break;
        case 'Familia':
          objects.add(Familia.fromJson(res[x]));
          break;
        case 'Comanda':
          objects.add(Comanda.fromJson(res[x]));
          break;
        case 'Tipo':
          objects.add(Tipo.fromJson(res[x]));
          break;
        case 'Version':
          objects.add(Version.fromJson(res[x]));
          break;
      }
    }

    return objects;
  }

/* ----- Fin métodos de obtención de datos -----*/

/* -------------------------------------------- */

/* ----- Métodos de borrado de datos -----*/

Future<int> deleteReg(dynamic obj) async {
  final db = await database;
  final res = db!.rawDelete('''
    DELETE FROM ${obj.runtimeType} WHERE id = ${obj.id};
  ''');
  return res;
}

/* ----- Fin métodos de borrado de datos -----*/

/* -------------------------------------------- */

/* ----- Métodos de modificación de datos -----*/

Future<int> updateReg(dynamic obj, String campo, dynamic cambio) async {
  final db = await database;
  final res = db!.rawUpdate('''
  UPDATE ${obj.runtimeType} SET $campo = '$cambio' WHERE id = '${obj.id}'
''');
  return res;
}

/* ----- Fin métodos de modificación de datos -----*/

/* -------------------------------------------- */
}
