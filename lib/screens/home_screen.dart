import 'dart:async';

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:prueba_widgets/database/models/models.dart';
import 'package:prueba_widgets/database/services/db_service.dart';
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

  //-----Boleanos-----
  bool navigateSala = false;
  bool navigateMesa = false;
  bool navigateReserva = false;

  //-----Strings-----
  String salaSeleccionada = '';
  String ultimaSala = '';

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

  insertarRegistro() async {
  }

  printRegistro() async {
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ultimaSala = Provider.of<SalasProvider>(context).heroMesa;
  }

  /* Overrides */
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    list = [
      Hero(
        tag: Provider.of<SalasProvider>(context, listen: false).heroMesa,
        child: ListElement(
          onTap: () {
            setState(() {
              navigateMesa = true;
            });
          },
          gradientColors: const [
            Color.fromARGB(255, 44, 216, 255),
            Color.fromARGB(255, 103, 235, 255)
          ],
          boxShadowColor: const Color.fromARGB(255, 0, 211, 148),
          subTitle: '',
          title: 'Regresar',
          image: 'assets/volver.png',
          roundedBoxColor: const Color.fromARGB(166, 184, 255, 255),
          textShadowColor: const Color.fromARGB(255, 168, 252, 255),
          textColor: Colors.white,
        ),
      ),
      ListElement(
        gradientColors: const [
          Color.fromARGB(255, 104, 255, 44),
          Color.fromARGB(255, 103, 255, 128)
        ],
        boxShadowColor: const Color.fromARGB(255, 95, 211, 0),
        subTitle: '',
        title: 'Salas',
        image: 'assets/silla.png',
        roundedBoxColor: const Color.fromARGB(166, 184, 255, 185),
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
        roundedBoxColor: const Color.fromARGB(166, 255, 246, 184),
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
        roundedBoxColor: const Color.fromARGB(166, 216, 184, 255),
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
        roundedBoxColor: const Color.fromARGB(155, 255, 129, 129),
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
        roundedBoxColor: const Color.fromARGB(155, 255, 129, 238),
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Curved AppBar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: 300.0,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: AnimatedDefaultTextStyle(
                  style: GoogleFonts.titanOne(
                    color: Colors.black87,
                    fontSize: 12,
                  ),
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                      'Última mesa atendida: ${Provider.of<SalasProvider>(context).heroMesa}'),
                ),
                background: Container(
                    decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(20))),
                    child: const ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(20)),
                        child: FadeInImage(
                          image: AssetImage('assets/restaurante.jpg'),
                          placeholder: AssetImage('assets/restaurante.jpg'),
                          fit: BoxFit.cover,
                        ))),
              ),
              backgroundColor: Colors.transparent,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Container(color: Colors.white, child: list[index]);
                },
                childCount: list.length,
              ),
            ),
          ],
        ),
      ),
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
  final Color roundedBoxColor;
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
    required this.roundedBoxColor,
    required this.textColor,
    this.sizedBox = 50,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFuncyCard(
      image: image,
      gradientColors: gradientColors,
      textShadowColor: textShadowColor,
      boxShadowColor: boxShadowColor,
      roundedBoxColor: roundedBoxColor,
      textColor: textColor,
      onTap: onTap,
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                title,
                style: GoogleFonts.titanOne(
                    color: textColor,
                    fontSize: 20,
                    shadows: [
                      Shadow(
                          color: textShadowColor,
                          blurRadius: 10,
                          offset: const Offset(5, 2))
                    ]),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                subTitle,
                style: GoogleFonts.titanOne(
                    color: textColor,
                    fontSize: 15,
                    shadows: [
                      Shadow(
                          color: textShadowColor,
                          blurRadius: 10,
                          offset: const Offset(5, 2))
                    ]),
              )
            ],
          ),
        ],
      ),
    );
  }
}
