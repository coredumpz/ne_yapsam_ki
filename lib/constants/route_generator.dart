import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/src/pages/home_page.dart';
import 'package:ne_yapsam_ki/src/pages/landing_page.dart';
import 'package:ne_yapsam_ki/src/pages/log_in_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.arguments;

    switch (settings.name) {
      case "/landing":
        return MaterialPageRoute(builder: (_) => const LandingPage());
      case "/login":
        return MaterialPageRoute(builder: (_) => LoginPage());
      case "/homepage":
        return MaterialPageRoute(builder: (_) => const HomePage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Error"),
        ),
        body: const Center(
          child: Text("Error"),
        ),
      );
    });
  }
}
