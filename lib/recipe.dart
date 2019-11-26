import 'package:cookmate/cookbook.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class recipeDisplay extends StatelessWidget{
  String recipeID;
  Recipe recipe;
  List<String> instructions;
  List<String> ingredients;

  recipeDisplay(Recipe recipe) {
    this.recipe = recipe;
    if(recipe.getInstructions() != null){
      instructions = recipe.getInstructions();
    }
    if(recipe.getIngredients() != null){
      ingredients = recipe.getIngredients();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Recipe Page',
        home: Scaffold(
          appBar: AppBar(
            title: Text(recipe.title),
          ),
          body: SingleChildScrollView(
              child: Column(
                  children: <Widget> [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.all(15.0),
                        child: Text(recipe.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: recipe.image,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                           Container(
                            padding: EdgeInsets.symmetric(vertical: 6.0),
                            child: Column(  
                              children: <Widget>[
                                Text(
                                  "Prep Time",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                    "${recipe.cookTime}",
                                    style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Servings",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                    "${recipe.servings}",
                                    style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Cost",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                    '\$' + "${recipe.price}",
                                    style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.shopping_cart),
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              color: Colors.black,
                              iconSize: 35.0,
                              onPressed: () {
                                print('pressed');
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.calendar_today),
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              color: Colors.black,
                              iconSize: 35.0,
                              onPressed: () {
                                print('pressed');
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.star_border),
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              color: Colors.black,
                              iconSize: 35.0,
                              onPressed: () {
                                print('pressed');
                              },
                            )
                          ],
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(15.0),
                      child: Text("Instructions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),),
                    ),
                    getInstructionWidgets(instructions),
                    Container(
                      padding: EdgeInsets.all(15.0),
                      child: Text("Ingredients", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),),
                    ),
                    getIngredientWidgets(ingredients)
                  ]
              )
          ),
        )
    );
  }

  Widget getInstructionWidgets(List<String> strings)
  {

    List<Widget> list = new List<Widget>();

    //Check for no instruction
    if(strings == null){
      return new Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text("No instructions provided for this recipe unfortunately", style: TextStyle(fontSize: 20),),
          )
      );
    }

    for(var i = 0; i < strings.length; i++){
      list.add(
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("${i+1}. ${strings[i]}", style: TextStyle(fontSize: 20),),
              )
          )
      );
    }
    return new Column(
        children: list);
  }

  Widget getIngredientWidgets(List<String> strings)
  {

    List<Widget> list = new List<Widget>();

    if(strings == null){
      return new Column(children: list);
    }

    for(var i = 0; i < strings.length; i++){
      list.add(
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("${strings[i]}", style: TextStyle(fontSize: 20),),
              )
          )
      );
    }
    return new Column(
        children: list);
  }
}