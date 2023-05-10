import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prueba_widgets/screens/home_screen.dart';

class MainScreen extends StatelessWidget {
  static String routeName = '_main';

  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
            children: [
              const background(),
              Column(
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 50),
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: const FadeInImage(
                          placeholder: AssetImage('assets/perfilusuario.png'),
                          image: AssetImage('assets/perfilusuario.png'))),
                  const cuadradoDelMedio(),
                ],
              ),
            ]
        ),
      ),
    );
  }
}

class cuadradoDelMedio extends StatelessWidget {
  const cuadradoDelMedio({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 400, maxWidth: 400),
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
                      image: AssetImage('assets/restaurante.jpg'),
                      placeholder: AssetImage('assets/restaurante.jpg'),),
                  ),
                )
            ),

            Text('Escanear Qr (Inicar Sesión)', style: GoogleFonts.titanOne(
              color: Colors.black45,
              fontSize: 15,
            ),),

            Center(
              child: MaterialButton(
                onPressed: () {
                  // Todo: Poner lo de la lectura del código qr
                  Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                },
                padding: const EdgeInsets.all(20),
                color: const Color.fromARGB(255, 38, 246, 246),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Container(
                    constraints: const BoxConstraints(maxHeight: 50),
                    child: const FadeInImage(
                        placeholder: AssetImage('assets/codigo-qr.png'),
                        image: AssetImage('assets/codigo-qr.png'))),
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
          stops: const[0.4, 0.4],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)),
    );
  }
}