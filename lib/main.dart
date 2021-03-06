import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_db/cubit/movie_cubit.dart';
import 'package:movies_db/data/MovieRepository.dart';

import 'helper/RouteGenerator.dart';
import 'ui/home_page.dart';
import 'utils/AppTheme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie DB',
      theme: AppTheme.themeData(Brightness.light),
      darkTheme: AppTheme.themeData(Brightness.dark),
      home: BlocProvider(
        create: (context) => MovieCubit(MovieRepository()),
        child: HomePage(),
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
