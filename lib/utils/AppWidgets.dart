import 'package:flutter/material.dart';

class AppWidgets {
  static AppBar appBar(BuildContext context, String title) {
    return AppBar(
      title: Text(title, style: TextStyle(color: textColor(context))),
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.white : Colors.black54,
      iconTheme: IconThemeData(
        color: textColor(context), //change your color here
      ),
      elevation: 0,
    );
  }

  static Color textColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? Colors.black87 : Colors.white;

  static Widget progressIndicator()=>
      Padding(padding: EdgeInsets.all(10),child: CircularProgressIndicator(color: Colors.green,));
}
