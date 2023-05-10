import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:prueba_widgets/providers/salas_provider.dart';
import 'package:prueba_widgets/router/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => SalasProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

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
