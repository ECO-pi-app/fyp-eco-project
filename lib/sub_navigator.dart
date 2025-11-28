import 'package:flutter/material.dart';
import 'package:test_app/design/apptheme/colors.dart';
import 'package:test_app/design/primary_elements(to_set_up_pages)/appbar.dart';
import 'package:test_app/titlepages/welcomepage.dart';
import 'package:test_app/titlepages/primarypage.dart';


class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key});

  @override
  State<RootScaffold> createState() => RootScaffoldState();

    static RootScaffoldState? of(BuildContext context) {
    return context.findAncestorStateOfType<RootScaffoldState>();
  }
}

class RootScaffoldState extends State<RootScaffold> {
  final GlobalKey<NavigatorState> _innerNavigatorKey =
      GlobalKey<NavigatorState>();

  void goToWelcomePage() {
    _innerNavigatorKey.currentState!.pushReplacementNamed('/welcomepage');
  }

  void goToHomePage() {
    _innerNavigatorKey.currentState!.pushReplacementNamed('/homepage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Apptheme.drawerbackground,
      appBar: Spherebar(), // stays constant across both pages
      body: Navigator(
        key: _innerNavigatorKey,
        initialRoute: '/welcomepage',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/welcomepage':
              return MaterialPageRoute(
                  builder: (_) => const Welcomepage(), settings: settings);
            case '/homepage':
              return MaterialPageRoute(
                  builder: (_) => const HomeScreen(), settings: settings);
            default:
              return MaterialPageRoute(
                  builder: (_) => const Welcomepage(), settings: settings);
          }
        },
      ),
    );
  }
}