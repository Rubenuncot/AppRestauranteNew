import 'dart:async';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:prueba_widgets/providers/salas_provider.dart';
import 'package:prueba_widgets/screens/mesa_screen.dart';
import 'package:prueba_widgets/widgets/widgets.dart';

class SalaScreen extends StatefulWidget {
  static String routeName = '_sala';

  const SalaScreen({Key? key}) : super(key: key);

  @override
  State<SalaScreen> createState() => _SalaScreenState();
}

class _SalaScreenState extends State<SalaScreen> with WidgetsBindingObserver {
  /* Variables */

  //----- Lists -----
  List<Widget> cards = [];
  List<String> salas = ['Terraza', 'Salón', 'Barra'];

  //----- Int -----
  int index = 1;

  //----- Boolean -----
  bool navigateMesa = false;

  //----- Strings -----
  String salaActual = '';
  String mesaActual = '';
  String heroTag = '';

  /* Métodos */
  void getLists() {
    SalasProvider salasProvider = Provider.of<SalasProvider>(context);

    for (var x in salas) {
      if (x == salasProvider.salaSeleccionada) {
        setState(() {
          salaActual = x.substring(0, 1);
          switch (salaActual) {
            case 'T':
              salasProvider.setIcons('assets/terraza.png');
              salasProvider.setColors(const [
                Color.fromARGB(255, 93, 255, 182),
                Color.fromARGB(255, 104, 255, 232)
              ]);
              break;
            case 'S':
              salasProvider.setIcons('assets/restaurante.png');
              salasProvider.setColors(const [
                Color.fromARGB(255, 255, 93, 93),
                Color.fromARGB(255, 255, 190, 104)
              ]);
              break;
            case 'B':
              salasProvider.setIcons('assets/barra-de-bar.png');
              salasProvider.setColors(const [
                Color.fromARGB(255, 93, 158, 255),
                Color.fromARGB(255, 104, 210, 255)
              ]);
              break;
            default:
              salasProvider.setIcons('assets/cena.png');
              salasProvider.setColors(const [
                Color.fromARGB(255, 152, 93, 255),
                Color.fromARGB(255, 222, 104, 255)
              ]);
          }
        });
      }
    }

    for (var x = 0; x < 10; x++) {
      Hero hero = Hero(
        tag:
            Provider.of<SalasProvider>(context, listen: false).heroMesa == '' ||
                    Provider.of<SalasProvider>(context, listen: false)
                        .heroMesa
                        .contains(salaActual)
                ? x == 0
                    ? ''
                    : '$salaActual${x + 1}'
                : '$salaActual${x + 1}',
        child: CustomFuncyCard(
          maxHeight: 250,
          maxWidth: 150,
          onTap: () {
            SalasProvider salasProvider =
                Provider.of<SalasProvider>(context, listen: false);
            setState(() {
              mesaActual = '$salaActual${x + 1}';
              salasProvider.heroMesa = mesaActual;
              navigateMesa = true;
              salasProvider.setNames('$salaActual${x + 1}');
            });
          },
          gradientColors: salasProvider.colors[salasProvider.colors.length - 1],
          boxShadowColor: Colors.orangeAccent,
          image: salasProvider.iconoStr[salasProvider.iconoStr.length - 1],
          roundedBoxColor: const Color.fromARGB(166, 184, 255, 255),
          textShadowColor: const Color.fromARGB(255, 168, 252, 255),
          textColor: Colors.white,
          child: Text(
            '$salaActual${x + 1}',
            style: GoogleFonts.titanOne(
                color: Colors.white,
                fontSize: 20,
                shadows: const [
                  Shadow(color: Colors.orangeAccent, blurRadius: 20)
                ]),
          ),
        ),
      );

      cards.add(hero);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      getLists();
    });
  }

  /* Overrides */

  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (navigateMesa) {
        Navigator.pushNamed(context, MesaScreen.routeName,
            arguments: [mesaActual]);
        navigateMesa = false;
      }
    });

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Scaffold(
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: Center(
                      child: CustomFuncyCard(
                        maxHeight: 300,
                        gradientColors: const [
                          Color.fromARGB(255, 44, 216, 255),
                          Color.fromARGB(255, 103, 235, 255)
                        ],
                        boxShadowColor: Colors.transparent,
                        image: 'assets/comida-sana.png',
                        roundedBoxColor:
                            const Color.fromARGB(166, 184, 255, 255),
                        textShadowColor:
                            const Color.fromARGB(255, 168, 252, 255),
                        textColor: Colors.white,
                        title: Text(
                          'Fuera de carta',
                          style: GoogleFonts.titanOne(
                              color: Colors.white,
                              fontSize: 15,
                              shadows: const [
                                Shadow(
                                    color: Colors.orangeAccent, blurRadius: 20)
                              ]),
                        ),
                        child: Column(
                          children: [
                            const Divider(),
                            Text(
                              'Ensala de marisco',
                              style: GoogleFonts.manjari(fontSize: 15),
                            ),
                            const Divider(),
                            Text(
                              'Panecillos de rulo de cabra',
                              style: GoogleFonts.manjari(fontSize: 15),
                            ),
                            const Divider(),
                            Text(
                              'Chuletón de vaca',
                              style: GoogleFonts.manjari(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          backgroundColor: Colors.white,
          elevation: 10,
          heroTag: 'NavigatorBar',
          child: const Icon(
            Icons.outbond_outlined,
            color: Colors.orangeAccent,
            size: 30,
          ),
        ),
        appBar: AppBar(
          title: Text(
              Provider.of<SalasProvider>(context, listen: false)
                  .salaSeleccionada,
              style: GoogleFonts.titanOne(
                color: Colors.black87,
                fontSize: 12,
              )),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.9),
                    child: Stack(
                      children: [
                        DynamicHeightGridView(
                            itemCount: cards.length,
                            crossAxisCount: 2,
                            builder: (context, index) {
                              return cards[index];
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
