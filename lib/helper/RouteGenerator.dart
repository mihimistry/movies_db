import 'package:flutter/material.dart';
import 'package:movies_db/ui/HomePage.dart';
import 'package:movies_db/ui/MovieDetailPage.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/home":
        return MaterialPageRoute(builder: (_) => HomePage());
      case "/movieDetail":
        return MaterialPageRoute(builder: (_) => MovieDetailPage(id: args as int));
      default:
        return MaterialPageRoute(builder: (_) => HomePage());
    }
  }
}
