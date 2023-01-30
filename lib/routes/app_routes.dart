import 'package:flutter/material.dart';
import '../screens/screens_export.dart';

class AppRoutes {
  static const initialRoute = 'home';

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    appRoutes.addAll({'home': (_) => const HomeScreen()});
    appRoutes.addAll({'details': (_) => const DetailsScreen()});

    // for (final option in menuOption) {
    //   appRoutes.addAll({option.route: (BuildContext context) => option.screen});
    // }

    return appRoutes;
  }

  // static Map<String, Widget Function(BuildContext)> routes = {
  //   'home': (context) => const HomeScreen(),
  //   'listView': (context) => const ListViewScreen(),
  //   'alert': (context) => const AlertScreen(),
  //   'card': (context) => const CardScreen(),
  // };

}
