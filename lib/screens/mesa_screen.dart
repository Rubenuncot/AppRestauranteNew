import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:counter_slider/counter_slider.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:provider/provider.dart';
import 'package:prueba_widgets/database/models/familia.dart';
import 'package:prueba_widgets/database/models/models.dart';
import 'package:prueba_widgets/database/services/db_service.dart';
import 'package:prueba_widgets/globalDatabase/db_connection.dart';
import 'package:prueba_widgets/providers/api_provider.dart';
import 'package:prueba_widgets/providers/salas_provider.dart';
import 'package:prueba_widgets/screens/home_screen.dart';
import 'package:prueba_widgets/screens/main_screen.dart';
import 'package:prueba_widgets/screens/salas_screen.dart';
import 'package:prueba_widgets/widgets/widgets.dart';
import 'package:sweet_nav_bar/sweet_nav_bar.dart';

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

  void getList() async {
    SalasProvider salasProvider =
        Provider.of<SalasProvider>(context, listen: false);
    mesaId = salasProvider.idMesa;
    final productosRes =
        await DBConnection.rawQuery('Select * from res_productos');
    final familiasRes =
        await DBConnection.rawQuery('Select * from res_tipo_productos');
    final lineasComandasRes = await DBConnection.rawQuery(
        'Select * from res_lineas_comandas where idMesa = $mesaId');
    final comandasRes = await DBConnection.rawQuery(
        'Select * from res_comandas where id = $mesaId');
    final lineasComandasAllRes = await DBConnection.rawQuery(
        'Select * from res_lineas_comandas');

    for (var x in lineasComandasAllRes) {
      lineasComandasAll.add(LineasComanda(
          id: x[0],
          precio: x[4],
          idProducto: x[3],
          idMesa: x[1],
          cantidad: x[5],
          enviado: x[6]));
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
          precio: x[4],
          idProducto: x[3],
          idMesa: x[1],
          cantidad: x[5],
          enviado: x[6]));
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

  sum(i){
    setState(() {
      cant = i;
    });
  }
  /* Overrides */
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    getList();
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
        showDialog(context: context,
            builder: (context) => StatefulBuilder(builder: (context, setState) {
              return Dialog(
                child: Container(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height *0.3, maxWidth: MediaQuery.of(context).size.width *0.8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(150),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Expanded(child: Center(child: Text('Ensalada César', style: TextStyle(fontWeight: FontWeight.bold)))),
                        const Expanded(child: Center(child: Text('Seleccionar Cantidad'))),
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
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                    const BorderSide(color: Colors.black45))),
                            onChanged: (value) {
                              lineaTemp.detalle = value;
                            },
                          ),
                        ),
                        IconsButton(
                          onPressed: () async {
                            getList();
                            for (var x in lineasComandas) {
                              if (x.idProducto == prodTemp.id) {
                                await DBConnection.rawQuery(
                                    'Update res_lineas_comandas set cantidad = ${lineaTemp.cantidad}, precio = ${lineaTemp.cantidad * prodTemp.precio} where id = ${lineaTemp.id}');
                              } else {
                                await DBConnection.rawQuery(
                                  //TODO: Poner el trabajador que incia sesión.
                                    'Insert into res_lineas_comandas (id, cantidad, trabajador, precio, idProducto, idMesa, enviado) values (${lineaTemp.id}, ${lineaTemp.cantidad},1, ${lineaTemp.cantidad * prodTemp.precio}, ${lineaTemp.idProducto}, ${lineaTemp.idMesa}, ${lineaTemp.enviado})');
                              }
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
            },)
        );
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
          onTap: (i) {
            setState(() {
              getList();
              index = i;
              switch (index) {
                case 0:
                  DropDownState(DropDown(
                    data: [
                      for (var x in lineasComandas)
                        for (var i in productos)
                          if (i.id == x.idProducto)
                            SelectedListItem(
                                name:
                                    '${i.nombre} -- Cantidad: ${x.cantidad} -- ${x.precio}€',
                                value: x.id.toString()),
                    ],
                  )).showModal(context);
                  break;
                case 1:
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
            Hero(
              tag: mesaNombre,
              child: CustomFuncyCard(
                maxHeight: 200,
                gradientColors: const [
                  Color.fromARGB(255, 44, 216, 255),
                  Color.fromARGB(255, 103, 235, 255)
                ],
                boxShadowColor: Colors.transparent,
                image: 'assets/comida-sana.png',
                roundedBoxColor: const Color.fromARGB(166, 184, 255, 255),
                textShadowColor: const Color.fromARGB(255, 168, 252, 255),
                textColor: Colors.white,
                title: Text(
                  'Último artículo',
                  style: GoogleFonts.titanOne(
                      color: Colors.white,
                      fontSize: 15,
                      shadows: const [
                        Shadow(color: Colors.orangeAccent, blurRadius: 20)
                      ]),
                ),
                child: Column(
                  children: [
                    const Divider(),
                    Text(
                      'Cocacola',
                      style: GoogleFonts.manjari(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
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
