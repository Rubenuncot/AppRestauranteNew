import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_widgets/providers/api_provider.dart';
import 'package:prueba_widgets/providers/booking_provider.dart';
import 'package:prueba_widgets/providers/log_provider.dart';
import 'package:prueba_widgets/providers/salas_provider.dart';
import 'package:prueba_widgets/router/router.dart';
import 'package:prueba_widgets/shared_preferences/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Preferences.init();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => SalasProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => BookingProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => ApiProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => LogProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurante App',
      initialRoute: RoutesList.initialRoute,
      routes: RoutesList.getAppRoutes(),
      onGenerateRoute: RoutesList.onGeneratedRoute,
    );
  }
}
