import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_widgets/database/models/models.dart';
import 'package:prueba_widgets/database/models/versions.dart';
import 'package:prueba_widgets/database/services/db_service.dart';
import 'package:prueba_widgets/providers/api_provider.dart';
import 'package:prueba_widgets/providers/booking_provider.dart';
import 'package:prueba_widgets/providers/log_provider.dart';
import 'package:prueba_widgets/providers/salas_provider.dart';
import 'package:prueba_widgets/router/router.dart';
import 'package:prueba_widgets/shared_preferences/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Preferences.init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => SalasProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => BookingProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => ApiProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => LogProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 15), (timer) async {
      ApiProvider apiProvider = Provider.of<ApiProvider>(context,
          listen: false); //Declaración del provider.

      //Respuesta de la petición que se ejecuta siempre
      final response =
          await apiProvider.responseJsonData('show', {'type': '0'});
      Map<String, dynamic> jsonVersion = jsonDecode(response);
      Version version = Version.fromJson(
          jsonVersion['version'][0]); //Objeto que se crea de cada petición.

      //Lista de versiones de la base de datos del movil
      List versions = await DBProvider.db.getAllReg(version);
      /*
      Se ejecuta si versiones está vacía o si la version de la base de datos
      es distinta a la verison que viene de la api.
       */
      if (versions.isEmpty || versions[0].version != version.version) {
        if (versions.isEmpty) {
          setState(() {
            apiProvider.pase += 1;
          });
          if (apiProvider.pase == 1) await DBProvider.db.newReg(version);
        } else {
          if (versions[0].version == version.version) {
            await DBProvider.db.updateReg(version, 'version', version.version);
          }
        }

        // Petición de todos los datos estáticos.
        final responseTotal = await apiProvider
            .responseJsonData('show', {'type': version.changes});

        Map<String, dynamic> jsonMap = jsonDecode(responseTotal);
        Iterable<String> keys = jsonMap.keys;

        for (var x in keys) {
          List jsonList = jsonMap[x];
          for (var i in jsonList) {
            switch (x) {
              case 'salas':
                Sala sala = Sala.fromJson(i);
                List salas = await apiProvider.getSalas(sala);
                for (var x in salas) {
                  if (x.id == sala.id) {
                    await DBProvider.db.updateReg(sala, 'nombre', sala.nombre);
                  } else {
                    if (!salas.contains(sala)) {
                      print('si');
                      await DBProvider.db.newReg(sala);
                    }
                  }
                }
                break;
              case 'mesas':
                Mesa mesa = Mesa.fromJson(i);
                List mesas = await apiProvider.getMesas(mesa);
                for (var x in mesas) {
                  if (x.id == mesa.id) {
                    await DBProvider.db
                        .updateReg(mesa, 'capacidad', mesa.capacidad);
                    await DBProvider.db.updateReg(mesa, 'nombre', mesa.nombre);
                    await DBProvider.db
                        .updateReg(mesa, 'comensales', mesa.comensales);
                  } else {
                    if (!mesas.contains(mesa)) {
                      await DBProvider.db.newReg(mesa);
                    }
                  }
                }
                break;
              case 'comandas':
                Comanda comanda = Comanda.fromJson(i);

                List comandas = await apiProvider.getComandas(comanda);
                for (var x in comandas) {
                  if (x.id == comanda.id) {
                    await DBProvider.db.updateReg(
                        comandas, 'precioTotal', comanda.precioTotal);
                  } else {
                    if (!comandas.contains(comanda)) {
                      print('si');
                      await DBProvider.db.newReg(comanda);
                    }
                  }
                }
                break;
              case 'productos':
                Producto producto = Producto.fromJson(i);

                List productos = await apiProvider.getProductos(producto);

                for (var x in productos) {
                  if (x.id == producto.id) {
                    await DBProvider.db
                        .updateReg(producto, 'nombre', producto.nombre);
                    await DBProvider.db
                        .updateReg(producto, 'idFamilia', producto.idFamilia);
                    await DBProvider.db.updateReg(
                        producto, 'descripcion', producto.descripcion);
                    await DBProvider.db
                        .updateReg(producto, 'precio', producto.precio);
                  } else {
                    if (!productos.contains(producto)) {
                      print('si');
                      await DBProvider.db.newReg(producto);
                    }
                  }
                }
                break;
              case 'usuarios':
                Usuario usuario = Usuario.fromJson(i);
                List usuarios = await apiProvider.getUsuarios(usuario);
                for (var x in usuarios) {
                  if (x.id == usuario.id) {
                    await DBProvider.db
                        .updateReg(usuario, 'name', usuario.name);
                    await DBProvider.db
                        .updateReg(usuario, 'email', usuario.email);
                    await DBProvider.db
                        .updateReg(usuario, 'apellido', usuario.apellido);
                    await DBProvider.db.updateReg(usuario, 'dni', usuario.dni);
                    await DBProvider.db
                        .updateReg(usuario, 'codigoQr', usuario.codigoQr);
                    await DBProvider.db
                        .updateReg(usuario, 'imagenQr', usuario.imagenQr);
                  } else {
                    if (!usuarios.contains(usuario)) {
                      print('si');
                      await DBProvider.db.newReg(usuario);
                    }
                  }
                }
                break;
              case 'reservas':
                Reserva reserva = Reserva.fromJson(i);

                List reservas = await apiProvider.getReservas(reserva);

                for (var x in reservas) {
                  if (x.id == reserva.id) {
                    await DBProvider.db
                        .updateReg(reserva, 'comensales', reserva.comensales);
                    await DBProvider.db
                        .updateReg(reserva, 'hora', reserva.hora);
                    await DBProvider.db
                        .updateReg(reserva, 'fecha', reserva.fecha);
                    await DBProvider.db
                        .updateReg(reserva, 'anotaciones', reserva.anotaciones);
                    await DBProvider.db
                        .updateReg(reserva, 'idMesa', reserva.idMesa);
                    await DBProvider.db
                        .updateReg(reserva, 'nombre', reserva.nombre);
                    await DBProvider.db
                        .updateReg(reserva, 'apellidos', reserva.apellidos);
                    await DBProvider.db
                        .updateReg(reserva, 'telefono', reserva.telefono);
                  } else {
                    if (!reservas.contains(reserva)) {
                      await DBProvider.db.newReg(reserva);
                    }
                  }
                }
                break;
              case 'restaurante':
                RestauranteInfo restaurante = RestauranteInfo.fromJson(i);
                List restaurantes =
                    await apiProvider.getRestaurantes(restaurante);

                for (var x in restaurantes) {
                  if (x.id == restaurante.id) {
                    await DBProvider.db
                        .updateReg(restaurante, 'nombre', restaurante.nombre);
                    await DBProvider.db.updateReg(restaurante,
                        'domicilioFiscal', restaurante.domicilioFiscal);
                    await DBProvider.db
                        .updateReg(restaurante, 'cif', restaurante.cif);
                    await DBProvider.db.updateReg(
                        restaurante, 'telefono', restaurante.telefono);
                    await DBProvider.db.updateReg(
                        restaurante, 'direccion', restaurante.direccion);
                    await DBProvider.db
                        .updateReg(restaurante, 'logo', restaurante.logo);
                  } else {
                    if (!restaurantes.contains(restaurante)) {
                      print('si');
                      await DBProvider.db.newReg(restaurante);
                    }
                  }
                }
                break;
              case 'tipoProductos':
                Familia familia = Familia.fromJson(i);

                List familias = await apiProvider.getFamilias(familia);

                for (var x in familias) {
                  if (x.id == familia.id) {
                    await DBProvider.db
                        .updateReg(familia, 'nombre', familia.nombre);
                  } else {
                    if (!familias.contains(familia)) {
                      print('si');
                      await DBProvider.db.newReg(familia);
                    }
                  }
                  break;
                }
            }
          }
        }
      }
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurante App',
      initialRoute: RoutesList.initialRoute,
      routes: RoutesList.getAppRoutes(),
      onGenerateRoute: RoutesList.onGeneratedRoute,
    );
  }
}
