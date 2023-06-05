import 'dart:async';

import 'package:flexible_grid_view/flexible_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:provider/provider.dart';
import 'package:prueba_widgets/providers/log_provider.dart';
import 'package:prueba_widgets/providers/salas_provider.dart';
import 'package:prueba_widgets/screens/main_screen.dart';

import '../shared_preferences/preferences.dart';
import '../widgets/custom_funcy_card.dart';

class SettingsScreen extends StatefulWidget {
  static String routeName = '_settings';

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  /*----- Bool -----*/
  bool waiting = false;
  bool showModal = false;

  /*----- List -----*/
  List list = [];

  /*----- Metodos -----*/
  Future<void> logOut() async {
    await Future.delayed(const Duration(seconds: 3));
    Preferences.saveLoginStateToPreferences(true);
  }

  getList() {
    list = [
      CustomFuncyCard(
        maxHeight: 300,
        gradientColors: const [
          Color.fromARGB(255, 129, 225, 255),
          Color.fromARGB(255, 210, 246, 255)
        ],
        boxShadowColor: const Color.fromARGB(255, 255, 244, 215),
        image: 'assets/usuario.png',
        roundedBoxColor: const Color.fromARGB(166, 184, 255, 255),
        textShadowColor: const Color.fromARGB(255, 168, 252, 255),
        textColor: Colors.white,
        title: Text(
          'Información de usuario',
          style: GoogleFonts.titanOne(
              color: Colors.white,
              fontSize: 15,
              shadows: const [
                Shadow(color: Colors.orangeAccent, blurRadius: 20)
              ]),
        ),
        onTap: () {
          setState(() {
            showModal = true;
          });
        },
      ),
      CustomFuncyCard(
        maxHeight: 300,
        gradientColors: const [
          Color.fromARGB(255, 175, 255, 129),
          Color.fromARGB(255, 240, 255, 210)
        ],
        boxShadowColor: const Color.fromARGB(255, 255, 216, 215),
        image: 'assets/cambiar-usuario.png',
        roundedBoxColor: const Color.fromARGB(166, 184, 255, 193),
        textShadowColor: const Color.fromARGB(255, 168, 255, 229),
        textColor: Colors.white,
        title: Text(
          'Cambiar Usuario',
          style: GoogleFonts.titanOne(
              color: Colors.white,
              fontSize: 15,
              shadows: const [
                Shadow(color: Colors.orangeAccent, blurRadius: 20)
              ]),
        ),
        onTap: () {
          Navigator.pushReplacementNamed(context, MainScreen.routeName);
        },
      ),
      CustomFuncyCard(
        maxHeight: 300,
        gradientColors: const [
          Color.fromARGB(255, 129, 192, 255),
          Color.fromARGB(255, 210, 255, 247)
        ],
        boxShadowColor: const Color.fromARGB(255, 215, 255, 229),
        image: 'assets/cerrar-sesion.png',
        roundedBoxColor: const Color.fromARGB(166, 184, 212, 255),
        textShadowColor: const Color.fromARGB(255, 226, 168, 255),
        textColor: Colors.white,
        title: Text(
          'Cerrar Sesión',
          style: GoogleFonts.titanOne(
              color: Colors.white,
              fontSize: 15,
              shadows: const [
                Shadow(color: Colors.orangeAccent, blurRadius: 20)
              ]),
        ),
        onTap: () {
          setState(() {
            waiting = true;
          });
        },
      ),
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    list = [];
    getList();
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(milliseconds: 1), (timer) {
      if (showModal) {
        Dialogs.materialDialog(
            title: "Información de Usuario (${Preferences.usuario.name})",
            color: Colors.white,
            customViewPosition: CustomViewPosition.BEFORE_ACTION,
            customView: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(child: Text('Apellidos: ${Preferences.usuario.apellido}'),),
                  Center(child: Text('Dni: ${Preferences.usuario.dni}'),),
                  Center(child: Text('Correo Electrónico: ${Preferences.usuario.email}'),),
                  Center(child: FadeInImage(placeholder: const AssetImage('assets/usuario.png'), image: MemoryImage(Preferences.usuario.imagenQr),)),
                  // Center(child: Image.memory(logProvider.user.imagenQr)),
                ],
              ),
            ),
            context: context,
            actions: [
              IconsButton(
                onPressed: () => Navigator.pop(context),
                text: 'Close',
                iconData: Icons.close,
                color: Colors.red,
                textStyle: const TextStyle(color: Colors.white),
                iconColor: Colors.white,
              ),
            ]);
        showModal = false;
      }
    });

    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Container(
              color: const Color.fromARGB(0, 225, 225, 225),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Cerrando Sesión...'),
                    const SizedBox(
                      height: 50,
                    ),
                    LoadingAnimationWidget.halfTriangleDot(
                        color: Colors.orangeAccent, size: 50),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.pop(context),
              elevation: 0,
              backgroundColor: Colors.redAccent,
              heroTag: Provider.of<SalasProvider>(context, listen: false).heroMesa,
              child: const Icon(Icons.arrow_back),
            ),
            body: SingleChildScrollView(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) => list[index],
                    ),
                  )),
            ),
          );
        }
      },
    );
  }
}
