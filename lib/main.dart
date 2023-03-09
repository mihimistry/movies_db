import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'helper/RouteGenerator.dart';
import 'ui/home_page.dart';
import 'utils/AppTheme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            title: 'Movie DB',
            theme: AppTheme.themeData(Brightness.light),
            darkTheme: AppTheme.themeData(Brightness.dark),
            home: child,
            onGenerateRoute: RouteGenerator.generateRoute,
          );
        },
        child: HomePage());
  }
}
