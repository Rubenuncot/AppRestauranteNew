import 'dart:async';
import 'dart:convert';
import 'dart:math';

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

  //----- Int -----
  int index = 2;
  int mesaId = 0;

  //----- Strings -----
  String mesaNombre = '';
  String productoSelected = '';

  //----- Lists -----
  List<Widget> familias = [];
  List<Producto> productosFamilia = [];
  List<LineasComanda> lineasComandas = [];
  List<LineasComanda> lineasComandasAll = [];
  //----- Map ------
  Map<String, String> productos = {};

  /* Métodos */

  setLineaComanda(lineaTemp) async{
    await DBProvider.db.newReg(lineaTemp);
  }

  void getList() async {
    SalasProvider salasProvider =
        Provider.of<SalasProvider>(context, listen: false);
    ApiProvider apiProvider = Provider.of<ApiProvider>(context);

    List familiasTemp =
        await apiProvider.getFamilias(Familia(id: 1, nombre: 'nombre'));
    List productosTemp = await apiProvider.getProductos(Producto(nombre: 'nombre', idTipo: 1, descripcion: 'descripcion', precio: 7, idFamilia: 1));
    Map<String, dynamic> lineasTemp = jsonDecode(await apiProvider.responseJsonData('show', {'type':'7'}));

    mesaId = salasProvider.idMesa;

    for(var x  in lineasTemp.keys){
      for(var x in lineasTemp[x]){
        LineasComanda lineasComanda = LineasComanda.fromJson(x);
        List lineasComandas = await apiProvider.getLineasComandas(lineasComanda);
        if(lineasComandas.isNotEmpty){
          for (var x in lineasComandas) {
            if (x.id == lineasComanda.id) {
              await DBProvider.db.updateReg(lineasComanda, 'precio', lineasComanda.precio);
              await DBProvider.db.updateReg(lineasComanda, 'cantidad', lineasComanda.cantidad);
              await DBProvider.db.updateReg(lineasComanda, 'enviado', lineasComanda.enviado);
              await DBProvider.db.updateReg(lineasComanda, 'detalle', lineasComanda.detalle);
            } else {
              if (!lineasComandas.contains(lineasComanda)) {
                await DBProvider.db.newReg(lineasComanda);
                break;
              }
            }
          }
        } else {
          await DBProvider.db.newReg(lineasComanda);
        }
        lineasComandasAll.add(x);
        if('${x['idMesa']}' == salasProvider.idMesa.toString()){
          LineasComanda linea = LineasComanda.fromJson(x);
          lineasComandas.add(linea);
        }
      }
    }
    familias = [
      for (var familia in familiasTemp)
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
            for (var x in productosTemp){
              if(x.idTipo == familia.id){
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    getList();
  }

  /* Overrides */

  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(milliseconds: 1), (timer) async{
      if (openProductos) {
        DropDownState(DropDown(
          data: [
            for (var x in productosFamilia) SelectedListItem(name: x.nombre, value: x.id.toString()),
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
        Producto prodTemp = Producto(nombre: 'nombre', idTipo: 1, descripcion: 'descripcion', precio: 7, idFamilia: 1);
        LineasComanda lineaTemp = LineasComanda(id: 0, precio: 0, producto: 0, cantidad: 0, enviado: 0, detalle: 'detalle', idMesa: 0);

        for(var x in productosFamilia){
          if(x.id.toString() == productoSelected){
            prodTemp = x;
          }
        }
        for(var x in lineasComandas){
          if(x.producto == prodTemp.id){
            lineaTemp = x;
          } else {
            lineaTemp = LineasComanda(id: lineasComandasAll.last.id + 1, precio: prodTemp.precio, producto: prodTemp.id ?? productosFamilia.last.id! + 1, cantidad: 0, enviado: 0, detalle: '', idMesa: mesaId);
          }
        }
        Dialogs.materialDialog(
            msg: 'Seleccione la cantidad',
            title: prodTemp.nombre,
            color: Colors.white,
            context: context,
            customViewPosition: CustomViewPosition.BEFORE_ACTION,
            customView: Container(
              padding: const EdgeInsets.only(top: 15),
              child: CounterSlider(
                value: lineaTemp.cantidad,
                width: 200,
                height: 50,
                slideFactor: 1.4,
                onChanged: (int i) {
                  lineaTemp.cantidad = i;
                },
              ),
            ),
            actions: [
              IconsButton(
                onPressed: () {
                  setLineaComanda(lineaTemp);
                  Navigator.pop(context);
                },
                text: 'Cerrar',
                iconData: Icons.close,
                color: Colors.red,
                textStyle: const TextStyle(color: Colors.white),
                iconColor: Colors.white,
              ),
            ]);
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
              selectedIcon: const Icon(Icons.shopping_basket_outlined, color: Colors.orangeAccent)
            ),
            CustomNavigationBarItem(
              icon: const Icon(Icons.send),
              selectedIcon:  const Icon(Icons.send, color: Colors.orangeAccent)
            ),
            CustomNavigationBarItem(
              icon: const Icon(Icons.home),
              selectedIcon:  const Icon(Icons.home, color: Colors.orangeAccent)
            ),
            CustomNavigationBarItem(
              icon: const Icon(Icons.arrow_circle_left),
              selectedIcon:  const Icon(Icons.arrow_circle_left, color: Colors.orangeAccent)
            ),
          ],
          currentIndex: index,
          onTap: (i) {
            setState(() {
              index = i;
              switch(index) {
                case 0:
                 break;
                case 1:

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
