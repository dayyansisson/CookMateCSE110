import 'package:cookmate/homePage.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:flutter/material.dart';
import 'cookbook.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  BackendRequest request =
      BackendRequest("03740945581ed4d2c3b25a62e7b9064cd62971a4", 2);
  List<Recipe> recipes;

  void makeRequest() async {
    request.getPopularRecipes().then((popularRecipes) {
      recipes = popularRecipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    makeRequest();
    return MaterialApp(

      title: 'CookMate',
      theme: ThemeData(),
      home: MyHomePage(),
    );
  }
}
