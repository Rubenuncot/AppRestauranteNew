import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mysql1/mysql1.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:prueba_widgets/database/models/models.dart';
import 'package:prueba_widgets/globalDatabase/db_connection.dart';
import 'package:prueba_widgets/providers/log_provider.dart';
import 'package:prueba_widgets/screens/home_screen.dart';
import 'package:prueba_widgets/shared_preferences/preferences.dart';

class MainScreen extends StatefulWidget {
  static String routeName = '_main';

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<void> logIn() async{
    await Future.delayed(const Duration(seconds: 3));
    Preferences.saveLoginStateToPreferences(false);
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<LogProvider>(context).waiting ? logIn() : null,
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
                    const Text('Iniciando Sesión...'),
                    const SizedBox(height: 50,),
                    LoadingAnimationWidget.halfTriangleDot(color: Colors.orangeAccent, size: 50),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            body: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Stack(
                  children: [
                    const background(),
                    Container(
                        margin: EdgeInsets.symmetric(vertical: 50, horizontal: MediaQuery.of(context).size.width * 0.3),
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: const FadeInImage(
                            placeholder: NetworkImage('https://i.imgur.com/G2nFuDj.png'),
                            image: NetworkImage('https://i.imgur.com/G2nFuDj.png'))),
                    SingleChildScrollView(child: Container(
                      margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.5),
                        child: const CuadradoDelMedio())
                    ),
                  ]
              ),
            ),
          );
        }
      },
    );
  }
}

class CuadradoDelMedio extends StatelessWidget {
  const CuadradoDelMedio({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5, maxWidth: MediaQuery.of(context).size.width * 0.8),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.orangeAccent.withOpacity(0.5), blurRadius: 20)
            ],
            borderRadius: BorderRadius.circular(50)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 50, bottom: 10),
                  constraints: const BoxConstraints(
                      maxWidth: 350, maxHeight: 200),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(color: Colors.black45, blurRadius: 10)
                      ]
                  ),
                  child: const ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: FadeInImage(
                      image: NetworkImage('https://i.imgur.com/xihuley.jpg'),
                      placeholder: NetworkImage('https://i.imgur.com/xihuley.jpg'),),
                  ),
                )
            ),

            Text('Escanear Qr (Inicar Sesión)', style: GoogleFonts.titanOne(
              color: Colors.black45,
              fontSize: 15,
            ),),

            Center(
              child: MaterialButton(
                onPressed: () async{
                  LogProvider logProvider = Provider.of<LogProvider>(context, listen: false);
                  dynamic users = await DBConnection.rawQuery('Select * from res_users');

                  for(var x in users){
                    Blob blob = x[10];
                    Utf8Encoder utfEncoder = const Utf8Encoder();
                    print(utfEncoder.convert(blob.toString()));
                    logProvider.users.add(Usuario(id: x[0], name: x[1], apellido: x[6], dni: x[8], email: x[2], imagenQr: utfEncoder.convert(blob.toString()), codigoQr: x[9]));
                  }
                  String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                      '#0791e0',
                      'Cancelar',
                      true,
                      ScanMode.QR);
                  for(var x in logProvider.users){
                    if(barcodeScanRes == x.codigoQr){
                      Preferences.usuario = x;
                      logProvider.waiting = true;
                    }
                  }
                },
                padding: const EdgeInsets.all(20),
                color: const Color.fromARGB(255, 38, 246, 246),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Container(
                    constraints: const BoxConstraints(maxHeight: 50),
                    child: const FadeInImage(
                        placeholder: NetworkImage('https://i.imgur.com/c9wAZSl.png'),
                        image: NetworkImage('https://i.imgur.com/c9wAZSl.png'))),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class background extends StatelessWidget {
  const background({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: LinearGradient(
          colors: [Colors.redAccent, Colors.white],
          stops: [0.4, 0.4],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
    );
  }
}