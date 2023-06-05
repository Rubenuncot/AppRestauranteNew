import 'dart:async';

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:provider/provider.dart';
import 'package:prueba_widgets/database/models/familia.dart';
import 'package:prueba_widgets/database/models/models.dart';
import 'package:prueba_widgets/database/services/db_service.dart';
import 'package:prueba_widgets/globalDatabase/db_connection.dart';
import 'package:prueba_widgets/providers/salas_provider.dart';
import 'package:prueba_widgets/widgets/widgets.dart';

class CartaScreen extends StatefulWidget {
  static String routeName = '_carta';

  const CartaScreen({Key? key}) : super(key: key);

  @override
  State<CartaScreen> createState() => _CartaScreenState();
}

class _CartaScreenState extends State<CartaScreen> with WidgetsBindingObserver {
  /* Variables */
  /*----- Bool -----*/
  bool openProductos = false;
  bool precio = false;

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
    for (var x in lineasComandas) {
      await DBConnection.rawQuery(
          'Update res_lineas_comandas set ticket = 1, fechaTicket = ${DateTime.now()}');
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
            Color.fromARGB(255, 94, 255, 199),
            Color.fromARGB(255, 103, 128, 255)
          ],
          boxShadowColor: const Color.fromARGB(255, 255, 103, 247),
          image: 'assets/lata-de-refresco.png',
          textShadowColor: const Color.fromARGB(255, 246, 255, 168),
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
  void didChangeDependencies() async {
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
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (openProductos) {
        DropDownState(DropDown(
          data: [
            for (var x in productosFamilia)
              SelectedListItem(name: x.nombre, value: x.id.toString()),
          ],
          selectedItems: (selectedItems) {
            for (var x in selectedItems) {
              productoSelected = x.value!;
              precio = true;
            }
          },
        )).showModal(context);
        openProductos = false;
      }

      if (precio) {
        dynamic res = await DBConnection.rawQuery(
            'Select * from res_productos where id = $productoSelected');
        Producto prodTemp = Producto(
            id: 0,
            nombre: 'nombre',
            descripcion: 'descripcion',
            precio: 0,
            idFamilia: 0,
            idTipo: 0);
        for (var x in res) {
          prodTemp = Producto(
              id: x[0],
              nombre: x[1],
              descripcion: x[4],
              precio: x[7],
              idFamilia: x[2],
              idTipo: x[5]);
        }
        Dialogs.materialDialog(
            title: prodTemp.nombre,
            msg:
                'Precio: ${prodTemp.precio}, Descripción: ${prodTemp.descripcion}',
            actions: [
              IconsButton(
                  onPressed: () => Navigator.pop(context) ,
                  text: 'Cerrar'
              )
            ],
            context: context);
      }
      precio = false;
    });

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
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
