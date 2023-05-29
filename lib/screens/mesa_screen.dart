import 'dart:async';
import 'dart:math';

import 'package:counter_slider/counter_slider.dart';
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
import 'package:prueba_widgets/providers/api_provider.dart';
import 'package:prueba_widgets/providers/salas_provider.dart';
import 'package:prueba_widgets/screens/home_screen.dart';
import 'package:prueba_widgets/screens/main_screen.dart';
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
  int index = 1;

  //----- Strings -----
  String mesaNombre = '';
  String productoSelected = '';

  //----- Lists -----
  List<Widget> familias = [];
  List<String> productosFamilia = [];


  //----- Map ------
  Map<String,String> productos = {};

  /* Métodos */
  void getList() async {
    SalasProvider salasProvider =
        Provider.of<SalasProvider>(context, listen: false);
    ApiProvider apiProvider = Provider.of<ApiProvider>(context);

    List familiasTemp = await apiProvider.getFamilias(Familia(id: 1, nombre: 'nombre'));

    familias = [
      for(var familia in familiasTemp)
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
            Iterable<String> claves = productos.keys;
            for(var x in claves){
              if(productos[x] == familia.nombre){
                productosFamilia.add(x);
              }
            }
            openProductos = true;
            setState(() {

            });
          },

          child: Text(
            'Refrescos',
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

    Timer.periodic(const Duration(milliseconds: 1), (timer) {
      if(openProductos){
        DropDownState(DropDown(
          data: [
            for(var x in productosFamilia)
              SelectedListItem(name: x, value: x),
          ],
          selectedItems: (selectedItems) {
            for(var x in selectedItems){
              productoSelected = x.value!;
              openCounter = true;
            }
          },
        )).showModal(context);
        openProductos = false;
      }

      if(openCounter){
        Dialogs.materialDialog(
            msg: 'Seleccione la cantidad',
            title: productoSelected,
            color: Colors.white,
            context: context,
            customViewPosition: CustomViewPosition.BEFORE_ACTION,
            customView: Container(
              padding: const EdgeInsets.only(top: 15),
              child: CounterSlider(
                value: 5,
                width: 200,
                height: 50,
                slideFactor: 1.4,
                onChanged: (int i) {  },
              ),
            ),
            actions: [
              IconsButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                text: 'Cerrar',
                iconData: Icons.close,
                color: Colors.red,
                textStyle: TextStyle(color: Colors.white),
                iconColor: Colors.white,
              ),
            ]);
        openCounter = false;
      }
    });

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Hero(
        tag: 'NavigatorBar',
        child: SweetNavBar(
          currentIndex: index,
          paddingBackgroundColor: Colors.transparent,
          items: [
            SweetNavBarItem(
                sweetIcon: const Icon(Icons.calendar_month),
                sweetLabel: 'Ver Comanda'),
            SweetNavBarItem(
                sweetActive: const Icon(Icons.home),
                sweetIcon: const Icon(
                  Icons.home_outlined,
                ),
                sweetLabel: 'Home',
                sweetBackground: Colors.transparent),
            SweetNavBarItem(
                sweetIcon: const Icon(Icons.send),
                sweetLabel: 'Enviar Comanda'),
          ],
          onTap: (index) {
            setState(() {
              this.index = index;
              if (index == 1) {
                Navigator.pushNamed(context, HomeScreen.routeName);
              }
            });
          },
        ),
      ),
      appBar: AppBar(
        title: Text(mesaNombre,
            style: GoogleFonts.titanOne(
              color: Colors.black87,
              fontSize: 12,
            )),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
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
                    (index) => Center(
                    child: familias[index]
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
