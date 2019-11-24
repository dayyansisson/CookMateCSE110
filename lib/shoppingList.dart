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
  List<String> ingredients;
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext buildContext){
    setState(() {
      ingredients = ['a', 'b', 'c'];
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping List"),
      ),
      body: _createIngredientList(),
    );
  }


  Widget _createIngredientList(){
    return ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: ingredients.length,
        itemBuilder: (context, i) {
          return _buildRow(ingredients[i]);
        }
    );
  }

  Widget _buildRow(String ingredient){
    return ListTile(
      title: Text(ingredient,
        style: _biggerFont,
      )
    );
  }
}