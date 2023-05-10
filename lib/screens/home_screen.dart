import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '_home';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;

  List<Widget> list = [
    const ListElement(
      gradientColors: [
        Color.fromARGB(255, 44, 216, 255),
        Color.fromARGB(255, 103, 235, 255)
      ],
      boxShadowColor: Color.fromARGB(255, 0, 211, 148),
      subTitle: '',
      title: 'Regresar Sala',
      image: 'assets/volver.png',
      roundedBoxColor: Color.fromARGB(166, 184, 255, 255),
      textShadowColor: Color.fromARGB(255, 168, 252, 255),
      textColor: Colors.white,
    ),
    const ListElement(
      gradientColors: [
        Color.fromARGB(255, 104, 255, 44),
        Color.fromARGB(255, 103, 255, 128)
      ],
      boxShadowColor: Color.fromARGB(255, 95, 211, 0),
      subTitle: '',
      title: 'Salas',
      image: 'assets/salas.png',
      roundedBoxColor: Color.fromARGB(166, 184, 255, 185),
      textShadowColor: Color.fromARGB(255, 171, 255, 168),
      textColor: Colors.white,
    ),
    const ListElement(
      gradientColors: [
        Color.fromARGB(255, 255, 228, 90),
        Color.fromARGB(255, 198, 255, 85)
      ],
      boxShadowColor: Color.fromARGB(255, 211, 176, 0),
      subTitle: '',
      title: 'Menú del Día',
      image: 'assets/menuDelDia.png',
      roundedBoxColor: Color.fromARGB(166, 255, 246, 184),
      textShadowColor: Color.fromARGB(255, 255, 248, 168),
      textColor: Colors.white,
    ),
    const ListElement(
      gradientColors: [
        Color.fromARGB(255, 112, 90, 255),
        Color.fromARGB(255, 161, 85, 255)
      ],
      boxShadowColor: Color.fromARGB(255, 158, 0, 211),
      subTitle: '',
      title: 'Carta',
      image: 'assets/carta.png',
      roundedBoxColor: Color.fromARGB(166, 216, 184, 255),
      textShadowColor: Color.fromARGB(255, 193, 168, 255),
      textColor: Colors.white,
    ),
    const ListElement(
      gradientColors: [
        Color.fromARGB(255, 255, 98, 98),
        Color.fromARGB(255, 255, 150, 115)
      ],
      boxShadowColor: Colors.orangeAccent,
      subTitle: '',
      // subTitle: 'Día: ${DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day} / ${DateTime.now().month < 10 ? '0${DateTime.now().month}' : DateTime.now().month} / ${DateTime.now().year}',
      title: 'Reservas',
      image: 'assets/calendario.png',
      roundedBoxColor: Color.fromARGB(155, 255, 129, 129),
      textShadowColor: Color.fromARGB(255, 255, 150, 115),
      textColor: Colors.white,
    ),
    const ListElement(
      gradientColors: [
        Color.fromARGB(255, 255, 98, 218),
        Color.fromARGB(255, 255, 115, 164)
      ],
      boxShadowColor: Color.fromARGB(255, 211, 0, 162),
      subTitle: '',
      // subTitle: 'Día: ${DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day} / ${DateTime.now().month < 10 ? '0${DateTime.now().month}' : DateTime.now().month} / ${DateTime.now().year}',
      title: 'Ajustes',
      image: 'assets/ajustes.png',
      roundedBoxColor: Color.fromARGB(155, 255, 129, 238),
      textShadowColor: Color.fromARGB(255, 255, 25, 80),
      textColor: Colors.white,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  // Color predeterminado
                  duration: const Duration(milliseconds: 300),
                  child: const Text('Última mesa atendida: S12'),
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
    this.sizedBox = 50, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Stack(children: [
        ZoomTapAnimation(
          onTap: onTap,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 200),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: boxShadowColor, blurRadius: 20)],
                  gradient: LinearGradient(colors: gradientColors),
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(100),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      topLeft: Radius.circular(30))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Container(
                            constraints:
                            const BoxConstraints(maxHeight: 80, maxWidth: 80),
                            padding: const EdgeInsets.only(
                                left: 20, bottom: 10, right: 10),
                            decoration: BoxDecoration(
                              color: roundedBoxColor,
                              borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(100),
                                  bottomLeft: Radius.circular(90),
                                  topRight: Radius.circular(90),
                                  topLeft: Radius.circular(50)),
                            ),
                          ),
                          Container(
                            constraints:
                            const BoxConstraints(maxHeight: 90, maxWidth: 90),
                            padding: const EdgeInsets.only(
                                left: 20, bottom: 10, right: 10),
                            decoration: BoxDecoration(
                              color: roundedBoxColor.withOpacity(0.5),
                              borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(50),
                                  bottomLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                  topLeft: Radius.circular(40)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: sizedBox,
                      ),
                      Column(
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
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          child: Container(
              constraints: const BoxConstraints(maxHeight: 80),
              child: FadeInImage(
                  placeholder: AssetImage(image), image: AssetImage(image))),
        ),
      ]),
    );
  }
}