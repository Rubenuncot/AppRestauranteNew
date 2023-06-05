import 'dart:async';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:counter_slider/counter_slider.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:provider/provider.dart';
import 'package:prueba_widgets/database/models/familia.dart';
import 'package:prueba_widgets/database/models/models.dart';
import 'package:prueba_widgets/database/services/db_service.dart';
import 'package:prueba_widgets/globalDatabase/db_connection.dart';
import 'package:prueba_widgets/providers/salas_provider.dart';
import 'package:prueba_widgets/screens/home_screen.dart';
import 'package:prueba_widgets/shared_preferences/preferences.dart';
import 'package:prueba_widgets/widgets/widgets.dart';

class MesaScreen extends StatefulWidget {
  static String routeName = '_mesa';

  const MesaScreen({Key? key}) : super(key: key);

  @override
  State<MesaScreen> createState() => _MesaScreenState();
}

class _MesaScreenState extends State<MesaScreen> with WidgetsBindingObserver {
  /* Variables */

  //----- Bool -----
  bool openProductos = false;
  bool openCounter = false;
  bool estaSolicitado = false;
  bool updated = false;

  //----- Int -----
  int index = 2;
  int mesaId = 0;
  int cant = 0;

  //----- Strings -----
  String mesaNombre = '';
  String productoSelected = '';

  //----- Lists -----
  List<Widget> familias = [];
  List<Familia> familiasTipo = [];
  List<Producto> productos = [];
  List<Producto> productosFamilia = [];
  List<Comanda> comandas = [];
  List<Comanda> comandasMesa = [];
  List<LineasComanda> lineasComandas = [];
  List<LineasComanda> lineasComandasAll = [];

  //----- Map ------

  /* Métodos */
  setLineaComanda(lineaTemp) async {
    await DBProvider.db.newReg(lineaTemp);
  }

  sendTicket() async {
    for(var x in lineasComandas){
      await DBConnection.rawQuery('Update res_lineas_comandas set ticket = 1, fechaTicket = ${DateTime.now()}');
    }
  }
  
  Future<void> getList() async {
    SalasProvider salasProvider =
        Provider.of<SalasProvider>(context, listen: false);
    mesaId = salasProvider.idMesa;
    final productosRes =
        await DBConnection.rawQuery('Select * from res_productos');
    final familiasRes =
        await DBConnection.rawQuery('Select * from res_tipo_productos');
    final lineasComandasRes = await DBConnection.rawQuery(
        'Select * from res_lineas_comandas where idMesa = $mesaId and ticket = 0');
    final comandasRes = await DBConnection.rawQuery(
        'Select * from res_comandas where id = $mesaId');
    final lineasComandasAllRes =
        await DBConnection.rawQuery('Select * from res_lineas_comandas');

    for (var x in lineasComandasAllRes) {
      lineasComandasAll.add(LineasComanda(
          id: x[0],
          precio: x[5],
          idProducto: x[3],
          idMesa: x[1],
          cantidad: x[6],
          enviado: x[7]));
    }

    for (var x in comandasRes) {
      comandas.add(Comanda(id: x[0], precioTotal: x[1]));
    }
    for (var x in productosRes) {
      productos.add(Producto(
          id: x[0],
          nombre: x[1],
          descripcion: x[4],
          precio: x[7],
          idFamilia: x[2],
          idTipo: x[5]));
    }
    for (var x in familiasRes) {
      familiasTipo.add(Familia(id: x[0], nombre: x[1]));
    }
    for (var x in lineasComandasRes) {
      lineasComandas.add(LineasComanda(
          id: x[0],
          precio: x[5],
          idProducto: x[3],
          idMesa: x[1],
          cantidad: x[6],
          enviado: x[7]));
    }

    familias = [
      for (var familia in familiasTipo)
        CustomContainer(
          maxHeight: 250,
          maxWidth: 150,
          gradientColors: const [
            Color.fromARGB(255, 255, 247, 94),
            Color.fromARGB(255, 227, 255, 103)
          ],
          boxShadowColor: Colors.orangeAccent,
          image: 'assets/lata-de-refresco.png',
          textShadowColor: const Color.fromARGB(255, 168, 252, 255),
          textColor: Colors.white,
          onTap: () {
            productosFamilia = [];
            for (var x in productos) {
              if (x.idTipo == familia.id) {
                productosFamilia.add(x);
              }
            }
            openProductos = true;
            setState(() {});
          },
          child: Text(
            familia.nombre,
            style: GoogleFonts.titanOne(
                color: Colors.white,
                fontSize: 20,
                shadows: const [
                  Shadow(color: Colors.orangeAccent, blurRadius: 20)
                ]),
          ),
        ),
    ];
    setState(() {
      mesaNombre = salasProvider.heroMesa;
    });
  }

  sum(i) {
    setState(() {
      cant = i;
    });
  }

  /* Overrides */
  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
    familias = [];
    familiasTipo = [];
    productos = [];
    productosFamilia = [];
    comandas = [];
    comandasMesa = [];
    lineasComandas = [];
    lineasComandasAll = [];
    await getList();
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(milliseconds: 1), (timer) async {
      if (openProductos) {
        DropDownState(DropDown(
          data: [
            for (var x in productosFamilia)
              SelectedListItem(name: x.nombre, value: x.id.toString()),
          ],
          selectedItems: (selectedItems) {
            for (var x in selectedItems) {
              productoSelected = x.value!;
              openCounter = true;
            }
          },
        )).showModal(context);
        openProductos = false;
      }

      if (openCounter) {
        Producto prodTemp = Producto(
            nombre: 'nombre',
            idTipo: 1,
            descripcion: 'descripcion',
            precio: 7,
            idFamilia: 1,
            id: 0);
        LineasComanda lineaTemp = LineasComanda(
            id: 0,
            precio: 0,
            idProducto: 0,
            cantidad: 0,
            enviado: 0,
            detalle: 'detalle',
            idMesa: 0);

        for (var x in productosFamilia) {
          if (x.id.toString() == productoSelected) {
            prodTemp = x;
          }
        }
        if(lineasComandas.isNotEmpty){
          for (var x in lineasComandas) {
            if (x.idProducto == prodTemp.id) {
              lineaTemp = x;
            } else {
              lineaTemp = LineasComanda(
                  id: lineasComandasAll.last.id + 1,
                  precio: prodTemp.precio,
                  idProducto: prodTemp.id,
                  cantidad: 0,
                  enviado: 0,
                  detalle: '',
                  idMesa: mesaId);
            }
          }
        } else {
          lineaTemp = LineasComanda(
              id: lineasComandasAll.last.id + 1,
              precio: prodTemp.precio,
              idProducto: prodTemp.id,
              cantidad: 0,
              enviado: 0,
              detalle: '',
              idMesa: mesaId);
        }

        showDialog(
            context: context,
            builder: (context) => StatefulBuilder(
                  builder: (context, setState) {
                    return Dialog(
                      child: Container(
                        constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.3,
                            maxWidth: MediaQuery.of(context).size.width * 0.8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(150),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                  child: Center(
                                      child: Text(prodTemp.nombre,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)))),
                              const Expanded(
                                  child: Center(
                                      child: Text('Seleccionar Cantidad'))),
                              Expanded(
                                child: Center(
                                  child: CounterSlider(
                                    value: lineaTemp.cantidad,
                                    width: 200,
                                    height: 50,
                                    slideFactor: 1.4,
                                    onChanged: (i) {
                                      setState(() {
                                        lineaTemp.cantidad = i;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      filled: true,
                                      label: Row(
                                        children: const [
                                          Icon(Icons.newspaper_outlined),
                                          Text('Detalles')
                                        ],
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Colors.black45))),
                                  onChanged: (value) {
                                    lineaTemp.detalle = value;
                                  },
                                ),
                              ),
                              IconsButton(
                                onPressed: () async {
                                  familias = [];
                                  familiasTipo = [];
                                  productos = [];
                                  productosFamilia = [];
                                  comandas = [];
                                  comandasMesa = [];
                                  lineasComandas = [];
                                  lineasComandasAll = [];
                                  await getList();
                                  for (var x in lineasComandas) {
                                    if (x.idProducto == prodTemp.id) {
                                      await DBConnection.rawQuery(
                                          'Update res_lineas_comandas set cantidad = ${lineaTemp.cantidad}, precio = ${lineaTemp.cantidad * prodTemp.precio} where id = ${lineaTemp.id}');
                                      updated = true;
                                    }
                                  }
                                  if(!updated){
                                    await DBConnection.rawQuery(
                                        'Insert into res_lineas_comandas (id, cantidad, trabajador, precio, idProducto, idMesa, enviado, ticket, fechaTicket) values (${lineaTemp.id}, ${lineaTemp.cantidad}, ${Preferences.usuario.id}, ${lineaTemp.cantidad * prodTemp.precio}, ${lineaTemp.idProducto}, ${lineaTemp.idMesa}, ${lineaTemp.enviado}, 0, "${DateTime.now()}")');
                                    updated = false;
                                  }
                                  Navigator.pop(context);
                                },
                                text: 'Guardar',
                                iconData: Icons.save_alt,
                                color: Colors.green,
                                textStyle: const TextStyle(color: Colors.white),
                                iconColor: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ));
        openCounter = false;
      }
    });

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      bottomNavigationBar: Hero(
        tag: 'NavigatorBar',
        child: CustomNavigationBar(
          iconSize: 30.0,
          backgroundColor: Colors.white,
          strokeColor: Colors.orangeAccent,
          items: [
            CustomNavigationBarItem(
                icon: const Icon(Icons.shopping_basket_outlined),
                selectedIcon: const Icon(Icons.shopping_basket_outlined,
                    color: Colors.orangeAccent)),
            CustomNavigationBarItem(
                icon: const Icon(Icons.send),
                selectedIcon:
                    const Icon(Icons.send, color: Colors.orangeAccent)),
            CustomNavigationBarItem(
                icon: const Icon(Icons.home),
                selectedIcon:
                    const Icon(Icons.home, color: Colors.orangeAccent)),
            CustomNavigationBarItem(
                icon: const Icon(Icons.arrow_circle_left),
                selectedIcon: const Icon(Icons.arrow_circle_left,
                    color: Colors.orangeAccent)),
          ],
          currentIndex: index,
          onTap: (i) async{
            familias = [];
            familiasTipo = [];
            productos = [];
            productosFamilia = [];
            comandas = [];
            comandasMesa = [];
            lineasComandas = [];
            lineasComandasAll = [];
            await getList();
            setState(() {
              index = i;
              switch (index) {
                case 0:
                  DropDownState(DropDown(
                    data: [
                      SelectedListItem(name: 'Producto     --     Cantidad     --     Precio', value: 'cabecera'),
                      SelectedListItem(name: '______________________________________', value: 'cabecera'),
                      for (var x in lineasComandas)
                        for (var i in productos)
                          if (i.id == x.idProducto)
                            SelectedListItem(
                                name:
                                    '${i.nombre} -- ${x.cantidad} -- ${x.precio}€',
                                value: x.id.toString()),
                    ],
                    selectedItems: (selectedItems) async {
                      for (var x in selectedItems) {
                        if(x.value == 'cabecera'){
                          Navigator.pop(context);
                        } else {
                          LineasComanda lineaTemp = LineasComanda(
                              id: 0,
                              precio: 0,
                              idProducto: 0,
                              cantidad: 0,
                              enviado: 0,
                              detalle: '',
                              idMesa: 0);
                          Producto prodTemp = Producto(
                              nombre: 'nombre',
                              idTipo: 1,
                              descripcion: 'descripcion',
                              precio: 7,
                              idFamilia: 1,
                              id: 0);
                          dynamic listRes = await DBConnection.rawQuery(
                              'Select * from res_lineas_comandas where id = ${x.value}');
                          dynamic listProdRes = await DBConnection.rawQuery(
                              'Select * from res_productos where id = ${x.value}');
                          for (var i in listRes) {
                            lineaTemp = LineasComanda(
                                id: i[0],
                                precio: i[5],
                                idProducto: i[3],
                                idMesa: i[1],
                                cantidad: i[6],
                                enviado: i[7]);
                          }
                          showDialog(
                              context: context,
                              builder: (context) => StatefulBuilder(
                                builder: (context, setState) {
                                  return Dialog(
                                    child: Container(
                                      constraints: BoxConstraints(
                                          maxHeight: MediaQuery.of(context)
                                              .size
                                              .height *
                                              0.3,
                                          maxWidth: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(150),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                                child: Center(
                                                    child: Text(
                                                        prodTemp.nombre,
                                                        style: TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .bold)))),
                                            const Expanded(
                                                child: Center(
                                                    child: Text(
                                                        'Seleccionar Cantidad'))),
                                            Expanded(
                                              child: Center(
                                                child: CounterSlider(
                                                  value: lineaTemp.cantidad,
                                                  width: 200,
                                                  height: 50,
                                                  slideFactor: 1.4,
                                                  onChanged: (i) {
                                                    setState(() {
                                                      lineaTemp.cantidad = i;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    label: Row(
                                                      children: const [
                                                        Icon(Icons
                                                            .newspaper_outlined),
                                                        Text('Detalles')
                                                      ],
                                                    ),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(20),
                                                        borderSide:
                                                        const BorderSide(
                                                            color: Colors
                                                                .black45))),
                                                onChanged: (value) {
                                                  lineaTemp.detalle = value;
                                                },
                                              ),
                                            ),
                                            IconsButton(
                                              onPressed: () async {
                                                familias = [];
                                                familiasTipo = [];
                                                productos = [];
                                                productosFamilia = [];
                                                comandas = [];
                                                comandasMesa = [];
                                                lineasComandas = [];
                                                lineasComandasAll = [];
                                                await getList();
                                                await DBConnection.rawQuery(
                                                    'Update res_lineas_comandas set cantidad = ${lineaTemp.cantidad}, precio = ${lineaTemp.cantidad * prodTemp.precio} where id = ${lineaTemp.id}');
                                                Navigator.pop(context);
                                              },
                                              text: 'Guardar',
                                              iconData: Icons.save_alt,
                                              color: Colors.green,
                                              textStyle: const TextStyle(
                                                  color: Colors.white),
                                              iconColor: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ));
                        }
                      }
                    },
                  )).showModal(context);
                  break;
                case 1:
                  sendTicket();
                  CherryToast.success(title: const Text('Enviado'));
                  break;
                case 2:
                  Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                  break;
                case 3:
                  Navigator.pop(context);
                  break;
              }
            });
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FlexibleGridView(
                axisCount: GridLayoutEnum.twoElementsInRow,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: List.generate(
                  familias.length,
                  (index) => Center(child: familias[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
