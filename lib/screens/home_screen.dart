import 'dart:async';
import 'dart:math';

import 'package:carousel_animations/carousel_animations.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:prueba_widgets/providers/salas_provider.dart';
import 'package:prueba_widgets/widgets/widgets.dart';

import 'screens.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '_home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /* Variables */
  //-----Variables de widgets-----
  late ScrollController _scrollController;

  //-----Listas-----
  List<Widget> list = [];
  List<Widget> listCarrousel = [];

  //-----Boleanos-----
  bool navigateSala = false;
  bool navigateMesa = false;
  bool navigateReserva = false;

  //-----Strings-----
  String salaSeleccionada = '';
  String ultimaSala = '';
  String salaActual = '';
  String mesaActual = '';

  /* Métodos */
  void showDialogMenu() {
    showDialog(
      context: context,
      builder: (context) => FluidDialog(
          rootPage: FluidDialogPage(builder: (BuildContext context) {
        return Container(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromARGB(255, 211, 176, 0), blurRadius: 20)
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 50),
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.6,
                        maxWidth: MediaQuery.of(context).size.width * 0.8),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurple, width: 5)),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text(
                            'MENÚ DEL DÍA',
                            style: GoogleFonts.pollerOne(fontSize: 25),
                          ),
                        ),
                        const Divider(),
                        Center(
                          child: Text(
                            '1º Plato',
                            style: GoogleFonts.pollerOne(fontSize: 15),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text(
                            'Tortilla de patatas',
                            style: GoogleFonts.manjari(fontSize: 15),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            'Paella',
                            style: GoogleFonts.manjari(fontSize: 15),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            'Cocido extremeño',
                            style: GoogleFonts.manjari(fontSize: 15),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(),
                        Center(
                          child: Text(
                            '2º Plato',
                            style: GoogleFonts.pollerOne(fontSize: 15),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text(
                            'Calamares a la plancha',
                            style: GoogleFonts.manjari(fontSize: 15),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            'Solomillo a la plancha',
                            style: GoogleFonts.manjari(fontSize: 15),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            'Cazón en adobo',
                            style: GoogleFonts.manjari(fontSize: 15),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(),
                        Center(
                          child: Text(
                            'Postre',
                            style: GoogleFonts.pollerOne(fontSize: 15),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text(
                            'Tarta de arándanos',
                            style: GoogleFonts.manjari(fontSize: 15),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            'Helado de vainilla con sirope',
                            style: GoogleFonts.manjari(fontSize: 15),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            'Tarta de queso casera',
                            style: GoogleFonts.manjari(fontSize: 15),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Text(
                            'Una bebida gratis',
                            style: GoogleFonts.manjari(
                                fontSize: 15, fontStyle: FontStyle.italic),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            'Total: 25€',
                            style: GoogleFonts.pollerOne(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ));
      })),
    );
  }

  showDialogSalas(int i) {
    DropDownState(DropDown(
      data: [
        SelectedListItem(name: 'Terraza', value: 'Terraza'),
        SelectedListItem(name: 'Salón', value: 'Salón'),
        SelectedListItem(name: 'Barra', value: 'Barra'),
      ],
      selectedItems: (selectedItems) {
        switch (i) {
          case 1:
            for (var x in selectedItems) {
              setState(() {
                Provider.of<SalasProvider>(context, listen: false)
                    .salaSeleccionada = x.value!;
                navigateSala = true;
              });
            }
            break;
          case 2:
            for (var x in selectedItems) {
              setState(() {
                Provider.of<SalasProvider>(context, listen: false)
                    .salaSeleccionada = x.value!;
                navigateReserva = true;
              });
            }
            break;
        }
      },
    )).showModal(context);
  }

  insertarRegistro() async {}

  printRegistro() async {}

  /* Overrides */

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ultimaSala = Provider.of<SalasProvider>(context).heroMesa;
    SalasProvider salasProvider = Provider.of<SalasProvider>(context, listen: false);
    _scrollController = ScrollController();
    listCarrousel = [
      for (var x = 0; x < salasProvider.nombresMesas.length; x++)
        Expanded(
          child: Hero(
            tag: salasProvider.heroMesa == '' ||
                salasProvider.heroMesa.contains(salaActual)
                ? x == 0
                ? ''
                : salasProvider.nombresMesas[x]
                : salasProvider.nombresMesas[x],
            child: CustomFuncyCard(
              maxHeight: 250,
              maxWidth: 150,
              onTap: () {
                setState(() {
                  mesaActual = salasProvider.nombresMesas[x];
                  salasProvider.heroMesa = mesaActual;
                  navigateMesa = true;
                });
              },
              gradientColors: salasProvider.colors[x],
              boxShadowColor: Colors.orangeAccent,
              image: salasProvider.iconoStr[x],
              roundedBoxColor: const Color.fromARGB(166, 184, 255, 255),
              textShadowColor: const Color.fromARGB(255, 168, 252, 255),
              textColor: Colors.white,
              child: Text(
                salasProvider.nombresMesas[x],
                style: GoogleFonts.titanOne(
                    color: Colors.white,
                    fontSize: 20,
                    shadows: const [
                      Shadow(color: Colors.orangeAccent, blurRadius: 20)
                    ]),
              ),
            ),
          ),
        ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    list = [
      ListElement(
        gradientColors: const [
          Color.fromARGB(255, 104, 255, 44),
          Color.fromARGB(255, 103, 255, 128)
        ],
        boxShadowColor: const Color.fromARGB(255, 95, 211, 0),
        subTitle: '',
        title: 'Salas',
        image: 'assets/silla.png',
        textShadowColor: const Color.fromARGB(255, 171, 255, 168),
        textColor: Colors.white,
        onTap: () {
          showDialogSalas(1);
        },
      ),
      ListElement(
        gradientColors: const [
          Color.fromARGB(255, 255, 228, 90),
          Color.fromARGB(255, 198, 255, 85)
        ],
        boxShadowColor: const Color.fromARGB(255, 211, 176, 0),
        subTitle: '',
        title: 'Menú del Día',
        image: 'assets/menuDelDia.png',
        textShadowColor: const Color.fromARGB(255, 255, 248, 168),
        textColor: Colors.white,
        onTap: showDialogMenu,
      ),
      ListElement(
        gradientColors: const [
          Color.fromARGB(255, 112, 90, 255),
          Color.fromARGB(255, 161, 85, 255)
        ],
        boxShadowColor: const Color.fromARGB(255, 158, 0, 211),
        subTitle: '',
        title: 'Carta',
        image: 'assets/carta.png',
        textShadowColor: const Color.fromARGB(255, 193, 168, 255),
        textColor: Colors.white,
        onTap: insertarRegistro,
      ),
      ListElement(
        gradientColors: const [
          Color.fromARGB(255, 255, 98, 98),
          Color.fromARGB(255, 255, 150, 115)
        ],
        boxShadowColor: Colors.orangeAccent,
        subTitle: '',
        title: 'Reservas',
        image: 'assets/calendario.png',
        textShadowColor: const Color.fromARGB(255, 255, 150, 115),
        textColor: Colors.white,
        onTap: () {
          showDialogSalas(2);
        },
      ),
      ListElement(
        gradientColors: const [
          Color.fromARGB(255, 255, 98, 218),
          Color.fromARGB(255, 255, 115, 164)
        ],
        boxShadowColor: const Color.fromARGB(255, 211, 0, 162),
        subTitle: '',
        // subTitle: 'Día: ${DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day} / ${DateTime.now().month < 10 ? '0${DateTime.now().month}' : DateTime.now().month} / ${DateTime.now().year}',
        title: 'Ajustes',
        image: 'assets/ajustes.png',
        textShadowColor: const Color.fromARGB(255, 255, 25, 80),
        textColor: Colors.white,
        onTap: printRegistro,
      ),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (navigateSala) {
        Navigator.pushNamed(context, SalaScreen.routeName);
        navigateSala = false;
      }
      if (navigateMesa) {
        Navigator.pushNamed(context, MesaScreen.routeName);
        navigateMesa = false;
      }
      if (navigateReserva) {
        Navigator.pushNamed(context, BookingScreen.routeName);
        navigateReserva = false;
      }
    });

    return Scaffold(
      body: SafeArea(
          child: Container(
        constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            minWidth: MediaQuery.of(context).size.width),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Mesas Recientes', style: GoogleFonts.hammersmithOne(color: Colors.white, shadows: const [Shadow(color: Colors.black, blurRadius: 20)], fontSize: 25),),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: listCarrousel.isNotEmpty ? MediaQuery.of(context).size.height * 0.3 : MediaQuery.of(context).size.height * 0.2,
                  child: listCarrousel.isNotEmpty ?
                      ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: listCarrousel.length,
                        itemBuilder: (context, index) => SizedBox( width: MediaQuery.of(context).size.width * 0.4, child: listCarrousel[index]),)
                      : CustomContainer(
                    image: 'assets/ajustes.png',
                    gradientColors: [Colors.orange, Colors.yellow],
                    textShadowColor: Colors.white,
                    boxShadowColor: Colors.white,
                    textColor: Colors.black,
                    title: SizedBox(width: MediaQuery.of(context).size.width *0.6,
                        child: Text('Aún no se han atendido mesas', style: GoogleFonts.hammersmithOne(fontSize: 15),)),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            CustomContainer(
                image: 'assets/perfilusuario.png',
                gradientColors: const [Colors.blueGrey, Colors.blueAccent],
                textShadowColor: Colors.white,
                boxShadowColor: Colors.yellowAccent,
                textColor: Colors.black,
              title: SizedBox(width: MediaQuery.of(context).size.width *0.6,
                  child: Text('Última mesa atendida: $salaSeleccionada', style: GoogleFonts.hammersmithOne(fontSize: 15),)),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: FlexibleGridView(
                axisCount: GridLayoutEnum.twoElementsInRow,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: List.generate(
                  list.length,
                      (index) => Center(
                        child: list[index]
                      ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}

/* Cada uno de los cajones.*/
class ListElement extends StatelessWidget {
  final String title;
  final String subTitle;
  final String image;
  final List<Color> gradientColors;
  final Color textShadowColor;
  final Color boxShadowColor;
  final Color textColor;
  final double sizedBox;
  final dynamic Function()? onTap;

  const ListElement({
    super.key,
    required this.title,
    required this.subTitle,
    required this.image,
    required this.gradientColors,
    required this.textShadowColor,
    required this.boxShadowColor,
    required this.textColor,
    this.sizedBox = 50,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      image: image,
      gradientColors: gradientColors,
      textShadowColor: textShadowColor,
      boxShadowColor: boxShadowColor,
      textColor: textColor,
      onTap: onTap,
      maxWidth: 150,
      maxHeight: 250,
      child: Text(title, style: GoogleFonts.hammersmithOne(fontSize: 15),),
    );
  }
}
