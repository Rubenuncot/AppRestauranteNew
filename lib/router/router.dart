import 'package:flutter/material.dart';
import 'package:prueba_widgets/shared_preferences/preferences.dart';

import '../models/menu_option.dart';
import '../screens/screens.dart';

class RoutesList {
  static String initialRoute = Preferences.getLoginStateFromPreferences() ? "_main" : HomeScreen.routeName;

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
        name: SalaScreen.routeName,
        icon: Icons.list,
        screen: const SalaScreen(),
        route: SalaScreen.routeName),
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
    MenuOption(
        name: BookingScreen.routeName,
        icon: Icons.list,
        screen: const BookingScreen(),
        route: BookingScreen.routeName),
    MenuOption(
        name: CartaScreen.routeName,
        icon: Icons.list,
        screen: const CartaScreen(),
        route: CartaScreen.routeName),
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