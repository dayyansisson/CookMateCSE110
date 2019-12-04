import 'package:cookmate/login.dart';
import 'package:cookmate/util/cookmateStyle.dart';
import 'package:flutter/material.dart';

/*
  File: main.dart
  Functionality: This file runs the app. It launches the login page.
*/

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CookmateStyle.theme,
      home: LoginPage()
    );
  }
}