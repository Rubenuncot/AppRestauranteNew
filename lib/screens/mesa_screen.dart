import 'dart:math';

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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

  //----- Int -----
  int index = 1;

  //----- Strings -----
  String mesaNombre = '';

  //----- Lists -----
  List<Widget> familias = [];

  /* Métodos */
  void getList() async {
    SalasProvider salasProvider =
        Provider.of<SalasProvider>(context, listen: false);

    Random random = Random();
    familias = [
      CustomContainer(
        maxHeight: 250,
        maxWidth: 150,
        gradientColors: const [
          Color.fromARGB(255, 153, 94, 255),
          Color.fromARGB(255, 212, 103, 255)
        ],
        boxShadowColor: Colors.orangeAccent,
        image: 'assets/lata-de-refresco.png',
        textShadowColor: const Color.fromARGB(255, 168, 252, 255),
        textColor: Colors.white,
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
      CustomContainer(
        maxHeight: 250,
        maxWidth: 150,
        gradientColors: const [
          Color.fromARGB(255, 238, 238, 238),
          Color.fromARGB(255, 54, 54, 54)
        ],
        boxShadowColor: Colors.black45,
        image: 'assets/lata-de-refresco.png',
        textShadowColor: const Color.fromARGB(255, 255, 168, 191),
        textColor: Colors.white,
        child: Text(
          'Ensaladas',
          style: GoogleFonts.titanOne(
              color: Colors.white,
              fontSize: 20,
              shadows: const [
                Shadow(color: Colors.indigo, blurRadius: 20)
              ]),
        ),
      ),
      CustomContainer(
        maxHeight: 250,
        maxWidth: 150,
        gradientColors: [
          Color.fromARGB(random.nextInt(255), random.nextInt(255), random.nextInt(255), random.nextInt(255)),
          Color.fromARGB(random.nextInt(255), random.nextInt(255), random.nextInt(255), random.nextInt(255))
        ],
        boxShadowColor: Colors.orangeAccent,
        image: 'assets/lata-de-refresco.png',
        textShadowColor: const Color.fromARGB(255, 255, 243, 168),
        textColor: Colors.white,
        child: Text(
          'Ensaladas',
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
