import 'package:flutter/material.dart';
import 'package:ne_yapsam_ki/pages/favorite/favorite.dart';
import 'package:ne_yapsam_ki/pages/login_pages/login_page.dart';
import 'package:ne_yapsam_ki/pages/home_page.dart';
import 'package:ne_yapsam_ki/pages/landing_page.dart';
import 'package:ne_yapsam_ki/pages/login_pages/profile_page.dart';
import 'package:ne_yapsam_ki/pages/survey/book/book_survey.dart';
import 'package:ne_yapsam_ki/pages/survey/game/game_survey.dart';
import 'package:ne_yapsam_ki/pages/survey/movie/movie_survey.dart';
import 'package:ne_yapsam_ki/pages/survey/recipe/recipe_survey.dart';
import 'package:ne_yapsam_ki/pages/survey/survey.dart';
import 'package:ne_yapsam_ki/pages/wheel_pages/luck_wheel.dart';

import '../pages/survey/tv/survey_tv.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/landing":
        return MaterialPageRoute(builder: (_) => const LandingPage());
      case "/login":
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case "/homepage":
        return MaterialPageRoute(builder: (_) => HomePage());
      case "/wheel":
        return MaterialPageRoute(builder: (_) => LuckWheel());
      case "/favorite":
        return MaterialPageRoute(builder: (_) => FavoritePage());
      case "/profile":
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case "/survey":
        return MaterialPageRoute(builder: (_) => SurveyPage());
      case "/surveyMovie":
        return MaterialPageRoute(builder: (_) => MovieSurvey());
      case "/surveyTV":
        return MaterialPageRoute(builder: (_) => TVSurvey());
      case "/surveyBook":
        return MaterialPageRoute(builder: (_) => BookSurvey());
      case "/surveyRecipe":
        return MaterialPageRoute(builder: (_) => RecipeSurvey());
      case "/surveyGame":
        return MaterialPageRoute(builder: (_) => GameSurvey());
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
