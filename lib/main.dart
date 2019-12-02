import 'package:cookmate/cookbook.dart';
import 'package:cookmate/homePage.dart';
import 'package:cookmate/login.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:cookmate/util/cookmateStyle.dart';
import 'package:flutter/material.dart';

main() {
  //DatabaseHelper helper = DatabaseHelper.instance;
  //helper.clearRecipes();
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