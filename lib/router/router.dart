import 'package:flutter/material.dart';

import '../models/menu_option.dart';
import '../screens/screens.dart';

class RoutesList {
  static String initialRoute = "_main";

  static final menuOptions = <MenuOption>[
    MenuOption(
        name: MainScreen.routeName,
        icon: Icons.list,
        screen: const MainScreen(),
        route: MainScreen.routeName),
    MenuOption(
        name: HomeScreen.routeName,
        icon: Icons.list,
        screen: const HomeScreen(),
        route: HomeScreen.routeName),
    MenuOption(
        name: MesaScreen.routeName,
        icon: Icons.list,
        screen: const MesaScreen(),
        route: MesaScreen.routeName),
    MenuOption(
        name: SettingsScreen.routeName,
        icon: Icons.list,
        screen: const SettingsScreen(),
        route: SettingsScreen.routeName),
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    for (final e in menuOptions) {
      appRoutes.addAll({e.route: (BuildContext context) => e.screen});
    }

    return appRoutes;
  }

  static Route<dynamic>? onGeneratedRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const MainScreen());
  }
}