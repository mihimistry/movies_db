import 'package:flutter/material.dart';
import 'package:movies_db/ui/home_page.dart';
import 'package:movies_db/ui/movie_detail_page.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/home":
        return MaterialPageRoute(builder: (_) => HomePage());
      case "/movieDetail":
        return MaterialPageRoute(
            builder: (context) => MovieDetailPage());
      case "/personDetail":
        return MaterialPageRoute(
            builder: (context) => MovieDetailPage());
      default:
        return MaterialPageRoute(builder: (_) => HomePage());
    }
  }
}
