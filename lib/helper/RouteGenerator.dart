import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_db/cubit/movie_cubit.dart';
import 'package:movies_db/ui/HomePage.dart';
import 'package:movies_db/ui/MovieDetailPage.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/home":
        return MaterialPageRoute(builder: (_) => HomePage());
      case "/movieDetail":
        return MaterialPageRoute(
            builder: (context) => BlocProvider.value(
                  value: BlocProvider.of<MovieCubit>(context),
                  child: MovieDetailPage(id: args as int),
                ));
      default:
        return MaterialPageRoute(builder: (_) => HomePage());
    }
  }
}
