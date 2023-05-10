import 'package:flutter/material.dart';
import 'package:prueba_widgets/router/router.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
