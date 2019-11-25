import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cookmate/util/database_helpers.dart';


//void main() => runApp(new MyApp());


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext buildContext){
    return MaterialApp(
      title: 'Shopping List',
      theme: new ThemeData(
        primarySwatch:  Colors.red,
      ),
      home: ShoppingListWidget()
    );
  }
}

class ShoppingListWidget extends StatefulWidget{
  @override
  ShoppingListState createState() => ShoppingListState();
}

class ShoppingListState extends State<ShoppingListWidget>{
  Future<List<ShoppingList>> ingredientsList;
  Map<String, Map<String, dynamic>> ingredientsMap = {}; // maps ingredient to map of shopping list

  @override
  void initState(){
    super.initState();
    DatabaseHelper helper = DatabaseHelper.instance;
    this.ingredientsList = helper.shoppingListItems();
    this.ingredientsList.then((list){
      for(int i = 0; i < list.length; i++){
        this.ingredientsMap[list[i].ingredient] = list[i].toMap();
      }
    });
  }

  @override
  Widget build(BuildContext buildContext){
    num bottomFontSize = 22.0;
    if(ingredientsMap == null || ingredientsMap.isEmpty){
      return Scaffold(
        appBar: AppBar(
          title: Text("Empty"),
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("NAVBAR"),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.red,
        child: Row(
          children:[
//            Padding(
//              padding: EdgeInsets.only(top: 22),
//              chi
//            ),
            Expanded(
              child: Text("  Items",
                style: TextStyle(fontSize: bottomFontSize, color: Colors.white),
              ),
            ),
            Expanded(
              child: Text("Quantity",
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: bottomFontSize, color: Colors.white),
              ),
            ),
            Expanded(
              child: Text("Purchased",
                  style: TextStyle(fontSize: bottomFontSize, color: Colors.white),
                  textAlign: TextAlign.right),
            )
          ]
        ),
      ),

      body: new ListView(
        children: ingredientsMap.keys.map((String key) {
          return new CheckboxListTile(
            title: Row(
              children: <Widget>[
                Expanded(
                  child: Text(key)
                ),
                Expanded(
                  child: Text(ingredientsMap[key]['quantity'].toString(), textAlign: TextAlign.right,)
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 100),
                  )
                )
              ]

            ),
            onChanged: (bool value) {
              setState(() {
                ingredientsMap[key]['purchased'] = value;
              });
            },
            value: ingredientsMap[key]['purchased'] == true,
          );
        }).toList(),
      ),
    );
  }
}