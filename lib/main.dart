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

  final UserProfile profile = UserProfile(
      id: -1,
      diet: Diet(
          id: 3,
          name: "gluten free"
      ),
      allergens: [
        {
          "id": 8,
          "name": "Shellfish"
        },
      ],
      favorites: [
        {
          "id": 1,
          "api_id": 716429,
          "name": "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs",
          "url": "https://spoonacular.com/recipeImages/716429-312x231.jpg"
        }
      ]
  );

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: CookmateStyle.theme,
      home: HomePage()
    );
  }

}