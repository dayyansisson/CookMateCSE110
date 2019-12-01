import 'package:cookmate/cookbook.dart';
import 'package:cookmate/homePage.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:cookmate/util/cookmateStyle.dart';
import 'package:cookmate/util/database_helpers.dart';
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

  @override
  Widget build(BuildContext context) {

    // BackendRequest request = BackendRequest("03740945581ed4d2c3b25a62e7b9064cd62971a4", 2, userProfile: profile);
    // DatabaseHelper db = DatabaseHelper.instance;
    // ShoppingList sl = ShoppingList(ingredient: 'Watermelon', quantity: 2, purchased: false, measurement: "slices");
    // db.insertShoppingListItem(sl);


    return MaterialApp(
      theme: CookmateStyle.theme,

      // home: SearchResultPage(request.recipeSearch(ingredients: ["mozzarella"], maxCalories: 1000)),
      //home: ShoppingListPage(),
      home: MyHomePage()
    );
  }

}
