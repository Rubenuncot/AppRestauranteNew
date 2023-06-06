import 'dart:async';

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:prueba_widgets/database/models/mesa.dart';
import 'package:prueba_widgets/globalDatabase/db_connection.dart';
import 'package:prueba_widgets/providers/api_provider.dart';
import 'package:prueba_widgets/providers/salas_provider.dart';
import 'package:prueba_widgets/widgets/widgets.dart';

import '../shared_preferences/preferences.dart';
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
  List salas = [];

  //-----Boleanos-----
  bool navigateSala = false;
  bool navigateMesa = false;
  bool navigateReserva = false;
  bool waiting = false;

  //-----Strings-----
  String salaSeleccionada = '';
  String ultimaSala = '';
  String salaActual = '';
  String mesaActual = '';

  /* Métodos */
  void showDialogMenu() async {
    
    dynamic listRes = await DBConnection.rawQuery('Select * from res_menu_diarios');
    List primeros = [];
    List segundos = [];
    List postres = [];

    for(var x in listRes){
      switch(x[2]){
        case 'Primeros':
          primeros.add(x[1]);
          break;
        case 'Segundos':
          segundos.add(x[1]);
          break;
        case 'Postres':
          postres.add(x[1]);
          break;
      }
    }
    
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
                        for(var x in primeros)
                          Center(
                            child: Text(
                              x,
                              style: GoogleFonts.manjari(fontSize: 15),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
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
                        for(var x in segundos)
                          Center(
                            child: Text(
                              x,
                              style: GoogleFonts.manjari(fontSize: 15),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
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
                        for(var x in postres)
                          Center(
                            child: Text(
                              x,
                              style: GoogleFonts.manjari(fontSize: 15),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
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
        for(var x in salas)
          SelectedListItem(name: '$x', value: '$x'),
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

  printRegistro() async {}

  Future<void> logOut() async {
    await Future.delayed(const Duration(seconds: 3));
    Preferences.saveLoginStateToPreferences(true);
  }

  /* Overrides */
  @override
  void didChangeDependencies() async{
    super.didChangeDependencies();
    SalasProvider salasProvider = Provider.of<SalasProvider>(context, listen: false);

    final salasResult = await DBConnection.rawQuery('Select nombre from res_salas');
    for (var x in salasResult){
      salas.add(x[0]);
    }
    final mesasResutl = await DBConnection.rawQuery('Select * from res_mesas');
    List<Mesa> mesas = [];
    for (var x in mesasResutl){
      mesas.add(Mesa(id: x[0], nombre: x[2], sala: x[4], capacidad: x[1], comensales: x[3]));
    }
    print(mesas);
    Mesa mesa = Mesa(id: 0, nombre: 'nombre', sala: 1, capacidad: 1, comensales: 0);
    // ApiProvider apiProvider = Provider.of<ApiProvider>(context, listen: false);
    // List mesas = await apiProvider.getMesas(Mesa(id: 0, nombre: 'nombre', sala: 1, capacidad: 1, comensales: 0));
    // ultimaSala = salasProvider.heroMesa;
    // _scrollController = ScrollController();
    listCarrousel = [
      for (var x = 0; x < salasProvider.nombresMesas.length; x++)
        Hero(
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
                for(var x in mesas){
                  if(x.nombre == mesaActual){
                    mesa = x;
                  }
                }
                salasProvider.heroMesa = mesaActual;
                salasProvider.idMesa = mesa.id;
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
    ];
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();

    SalasProvider salasProvider = Provider.of<SalasProvider>(context, listen: false);
    if(salasProvider.nombresMesas.isEmpty){
      salasProvider.getLists(context);
    }

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
        image: 'https://i.imgur.com/mjLRpmx.png',
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
        image: 'https://i.imgur.com/C5FbGZb.png',
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
        image: 'https://i.imgur.com/O8MHtc1.png',
        textShadowColor: const Color.fromARGB(255, 193, 168, 255),
        textColor: Colors.white,
        onTap: () {
          Navigator.pushNamed(context, CartaScreen.routeName);
        },
      ),
      // ListElement(
      //   gradientColors: const [
      //     Color.fromARGB(255, 255, 98, 98),
      //     Color.fromARGB(255, 255, 150, 115)
      //   ],
      //   boxShadowColor: Colors.orangeAccent,
      //   subTitle: '',
      //   title: 'Reservas',
      //   image: 'assets/calendario.png',
      //   textShadowColor: const Color.fromARGB(255, 255, 150, 115),
      //   textColor: Colors.white,
      //   onTap: () {
      //     showDialogSalas(2);
      //   },
      // ),
      ListElement(
        gradientColors: const [
          Color.fromARGB(255, 255, 98, 218),
          Color.fromARGB(255, 255, 115, 164)
        ],
        boxShadowColor: const Color.fromARGB(255, 211, 0, 162),
        subTitle: '',
        // subTitle: 'Día: ${DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day} / ${DateTime.now().month < 10 ? '0${DateTime.now().month}' : DateTime.now().month} / ${DateTime.now().year}',
        title: 'Ajustes',
        image: 'https://i.imgur.com/TJTLXpO.png',
        textShadowColor: const Color.fromARGB(255, 255, 25, 80),
        textColor: Colors.white,
        onTap: () {
          setState(() {
            // DBConnection.insert();
            // waiting = true;
            Navigator.pushNamed(context, SettingsScreen.routeName);
          });
        },
      ),
      ListElement(
        gradientColors: const [
          Color.fromARGB(255, 98, 255, 190),
          Color.fromARGB(255, 192, 255, 115)
        ],
        boxShadowColor: const Color.fromARGB(255, 0, 179, 211),
        subTitle: '',
        // subTitle: 'Día: ${DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day} / ${DateTime.now().month < 10 ? '0${DateTime.now().month}' : DateTime.now().month} / ${DateTime.now().year}',
        title: 'Cerrar Sesión',
        image: 'https://i.imgur.com/HqeTzRh.png',
        textShadowColor: const Color.fromARGB(255, 25, 90, 255),
        textColor: Colors.white,
        onTap: () {
          setState(() {
            waiting = true;
          });
        },
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



    return FutureBuilder(
      future: waiting ? logOut() : null,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Scaffold(
            body: Container(
              color: const Color.fromARGB(0, 225, 225, 225),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Cerrando Sesión...'),
                    const SizedBox(height: 50,),
                    LoadingAnimationWidget.halfTriangleDot(color: Colors.orangeAccent, size: 50),
                  ],
                ),
              ),
            ),
          );
        } else {
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
                              itemBuilder: (context, index) => SizedBox( width: MediaQuery.of(context).size.width * 0.4, child: listCarrousel.reversed.toList()[index]),)
                                : CustomContainer(
                              image: 'https://i.imgur.com/TJTLXpO.png',
                              gradientColors: const [Colors.orange, Colors.yellow],
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
      },
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
