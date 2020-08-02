import 'package:flutter/material.dart';
import 'package:gif_app/ui/gif_page.dart';
import 'package:gif_app/ui/home_page.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
      theme: ThemeData(
          hintColor: Color(0xfff4c430),
          primaryColor: Color(0xff96a5a9),
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff96a5a9))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xfff4c430))),
            hintStyle: TextStyle(color: Color(0xfff4c430)),
          ))
  ));
}



