import 'package:cookmate/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext buildContext){
    return MaterialApp(
      title: 'something',
      home: ShoppingList()
    );
  }
}

class ShoppingList extends StatefulWidget{
  @override
  ShoppingListState createState() => ShoppingListState();
}

class ShoppingListState extends State<ShoppingList>{
  Map<String, bool> ingredients = initializeMap();

  static Map<String, bool> initializeMap(){
    List<String> ingredientList = hardcodedIngredientList();
    Map<String, bool> ingredients = {};
    for(int i = 0; i < ingredientList.length; i++){
      ingredients[ingredientList[i]] = false;
    }
    return ingredients;
  }

  @override
  Widget build(BuildContext buildContext){
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping List"),
      ),
      body: new ListView(
        children: ingredients.keys.map((String key) {
          return new CheckboxListTile(
            title: new Text(key),
            onChanged: (bool value) {
              setState(() {
                ingredients[key] = value;
              });
            },
            value: ingredients[key],
          );
        }).toList(),
      ),
    );
  }
}