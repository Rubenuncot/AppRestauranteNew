import 'package:mysql1/mysql1.dart';

class DBConnection {
  static const String _host = 'castelarlamp.duckdns.org';
  static const int _port = 33069;
  static const String _user = 'fcasco';
  static const String _pass = 'fcasco22';
  static const String _db = 'fcasco';
  static MySqlConnection? _connection;

  static init(){
    _connect();
  }

  static Future<MySqlConnection?> _connect() async{
    _connection ??= await MySqlConnection.connect(
          ConnectionSettings(
            db: _db,
            host: _host,
            password: _pass,
            user: _user,
            port: _port,
          )
      );
    return _connection;
  }
  static Future<void> _disconnect() async{
    if(_connection != null)  await _connection!.close();
  }

  /*---- Consultas -----*/
  static insert(List obj, String objClass) async{
    await _connect();
    String sql = 'Insert into $objClass values ';
    int i = 0;
    for(var x in obj){
      i++;
      if(obj.length > 1){
        sql = '$sql($x)';
      } else {
        if(i == 1){
          sql = '$sql($x, ';
        } else if(i == obj.length){
          sql = '$sql$x)';
        } else {
          sql = '$sql$x, ';
        }
      }
    }
    print(sql);
    await _connection?.query(sql);
  }

  static update(List obj, List campos, String objClass) async {
    await _connect();
    String sql = 'update $objClass set ';
    int i = 0;
    for(var x in campos){
      if(i < campos.length -1) {
        sql = '$sql$x = ${obj[i]}, ';
      } else {
        sql = '$sql$x = ${obj[i]}';
      }
      i++;
    }
    print(sql);
    await _connection?.query(sql);
  }

  static delete(dynamic id, String tabla) async{
    await _connect();
    String sql = 'Delete from $tabla where id = $id';
    await _connection?.query(sql);
  }

  static select(dynamic id, List? campos, String tabla) async {
    await _connect();
    String sql = 'Select';
    if(id == null){
      if(campos == null){
        sql = '$sql * from $tabla';
      } else {
        int i = 0;
        for (var x in campos){
          i++;
          if(i == campos.length){
            sql = '$sql $x from $tabla';
          } else {
            sql = '$sql $x, ';
          }
        }
      }
    } else {
      if(campos == null){
        sql = '$sql * from $tabla where id = $id';
      } else {
        int i = 0;
        for (var x in campos){
          i++;
          if(i == campos.length){
            sql = '$sql $x from $tabla where id = $id';
          } else {
            sql = '$sql $x, ';
          }
        }
      }
    }
    print(sql);

    return await _connection?.query(sql);
  }

  static rawQuery(String sql) async{
    await _connect();
    return await _connection?.query(sql);
  }
}