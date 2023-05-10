import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prueba_widgets/widgets/widgets.dart';

class MesaScreen extends StatefulWidget {
  static String routeName = '_mesa';

  const MesaScreen({Key? key}) : super(key: key);

  @override
  State<MesaScreen> createState() => _MesaScreenState();
}

class _MesaScreenState extends State<MesaScreen> {

  /* Variables */

  //----- Int -----
  int index = 1;

  @override
  Widget build(BuildContext context) {
    final List args = ModalRoute.of(context)?.settings.arguments as List;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Scaffold(
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: DotNavigationBar(
          currentIndex: index,
          items: [
            DotNavigationBarItem(
                icon: const Icon(Icons.send),
                selectedColor: Colors.orangeAccent,
                unselectedColor: Colors.grey
            ),
            DotNavigationBarItem(
                icon: const Icon(Icons.home),
                selectedColor: Colors.orangeAccent,
                unselectedColor: Colors.grey
            ),
            DotNavigationBarItem(
                icon: const Icon(Icons.calendar_month),
                selectedColor: Colors.orangeAccent,
                unselectedColor: Colors.grey
            ),
          ],
          enableFloatingNavBar: true,
          boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 10, blurRadius: 10)],
          onTap: (p0) {
            setState(() {
              index = p0;
            });
          },
        ),
        appBar: AppBar(
          title: Text('${args[0]}',
              style: GoogleFonts.titanOne(
                color: Colors.black87,
                fontSize: 12,
              )),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomFuncyCard(
                maxHeight: 300,
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
                  'Articulos Recomendados',
                  style: GoogleFonts.titanOne(
                    color: Colors.white,
                    fontSize: 15,
                    shadows: const [Shadow(color: Colors.orangeAccent, blurRadius: 20)]
                  ),
                ),
                child: Column(
                  children:  [
                    const Divider(),
                    Text('Ensala de marisco', style: GoogleFonts.manjari(fontSize: 15),),
                    const Divider(),
                    Text('Panecillos de rulo de cabra', style: GoogleFonts.manjari(fontSize: 15),),
                    const Divider(),
                    Text('Chuletón de vaca', style: GoogleFonts.manjari(fontSize: 15),),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
                    child: Stack(
                      children: [
                        DynamicHeightGridView(
                            itemCount: 13,
                            crossAxisCount: 2,
                            builder: (context, index) {
                              return CustomFuncyCard(
                                maxHeight: 250,
                                maxWidth: 150,
                                gradientColors: const [
                                  Color.fromARGB(255, 153, 94, 255),
                                  Color.fromARGB(255, 212, 103, 255)
                                ],
                                boxShadowColor: Colors.orangeAccent,
                                image: 'assets/lata-de-refresco.png',
                                roundedBoxColor: const Color.fromARGB(166, 184, 255, 255),
                                textShadowColor: const Color.fromARGB(255, 168, 252, 255),
                                textColor: Colors.white,
                                child: Text('Refrescos',
                                  style: GoogleFonts.titanOne(
                                      color: Colors.white,
                                      fontSize: 20,
                                      shadows: const [Shadow(color: Colors.orangeAccent, blurRadius: 20)]
                                  ),),
                              );
                            }
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
