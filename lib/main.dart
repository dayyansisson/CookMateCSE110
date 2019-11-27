import 'package:cookmate/cookbook.dart';
import 'package:cookmate/searchResultPage.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:flutter/material.dart';

main() {
  
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
      // {
      //   "id": 1,
      //   "name": "Dairy"
      // },
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

<<<<<<< HEAD
  @override
  Widget build(BuildContext context) {
    
    BackendRequest request = BackendRequest("03740945581ed4d2c3b25a62e7b9064cd62971a4", 2, userProfile: profile);
    request.getRecipe("201298");

    return MaterialApp(
      theme: ThemeData(fontFamily: 'Lato'),
      home: SearchResultPage(request.recipeSearch(ingredients: ["mozzarella"], maxCalories: 1000)),
    );
  }
=======
  BackendRequest request = BackendRequest("03740945581ed4d2c3b25a62e7b9064cd62971a4", 2, userProfile: profile);
//  request.recipeSearch().then(
//    (recipes) {
//      for(Recipe recipe in recipes) {
//        print(recipe.toString());
//      }
//    }
//  );
>>>>>>> 5274ac229b795714f0c645f20ec7f8188e784240
}