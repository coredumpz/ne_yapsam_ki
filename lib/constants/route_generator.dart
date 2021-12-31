import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/pages/login_pages/login_page.dart';
import 'package:ne_yapsam_ki/pages/home_page.dart';
import 'package:ne_yapsam_ki/pages/landing_page.dart';
import 'package:ne_yapsam_ki/pages/login_pages/sign_up_page.dart';
import 'package:ne_yapsam_ki/pages/wheel_pages/luck_wheel.dart';
import 'package:ne_yapsam_ki/pages/wheel_pages/result_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/landing":
        return MaterialPageRoute(builder: (_) => const LandingPage());
      case "/login":
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case "/signup":
        return MaterialPageRoute(builder: (_) => const SingUpPage());
      case "/homepage":
        return MaterialPageRoute(builder: (_) => HomePage());
      case "/wheel":
        return MaterialPageRoute(builder: (_) => LuckWheel());
      case "/result":
        return MaterialPageRoute(builder: (_) => const WheelResultPage());
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
