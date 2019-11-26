import 'dart:convert';

import 'package:cookmate/util/backendRequest.dart';
import 'package:flutter/material.dart';
import 'package:cookmate/cookbook.dart' as CB;
import 'dart:async';
import 'package:cookmate/util/database_helpers.dart';
import 'package:cookmate/util/localStorage.dart';
import 'package:cookmate/main.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(
        primarySwatch: Colors.red,
    ),
    home: new MyHomePage(title: 'NAVBAR SHOULD BE HERE'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {
  TextEditingController editingController = TextEditingController();
  String token;
  int userID;
  BackendRequest request;
  List<String> duplicateItems = new List<String>();
  List<String> cuisines = new List<String>();
  List<String> diets = new List<String>();

  // Queries for recipe search
  List<String> ingredientQuery = new List<String>();
  int maxCalories = 0;
  String cuisineQuery;
  String dietQuery;

  // Recipe List results
  List<CB.Recipe> recipes = List<CB.Recipe>();

  @override
  void initState() {
    _initData();
    _recipeSearc();
    super.initState();
  }

  _initData() async {
    //token = await LocalStorage.getAuthToken();
    //userID = await LocalStorage.getUserID();
    token = "03740945581ed4d2c3b25a62e7b9064cd62971a4";
    userID = 2;
    _addAllIngredients();
    _getDiets();
    _getCuisines();
    _getIngredients();
  }
  _recipeSearc() async {
    request.recipeSearch(cuisine: cuisineQuery, maxCalories: maxCalories,
                          ingredients: ingredientQuery).then((recipeList){
                            recipes.addAll(recipeList);
                            for(CB.Recipe recipe in recipes) {
                              print(recipe.toString());
                            }
                          });
  }
  _getCuisines() async {
    request.getCuisineList().then((cuisineList){
      for(int i  = 0; i < cuisineList.length; i++){
        cuisines.add(cuisineList[i].name);
      }
    });
  }
  _getDiets() async {
    request.getDietList().then((dietList){
      for(int i  = 0; i < dietList.length; i++){
        diets.add(dietList[i].name);
      }
    });
  }

  _getIngredients() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    List<String>  ingredients;
    helper.ingredients().then((list){
      for(int i  = 0; i < list.length; i++){
        duplicateItems.add(list[i].name);
      }
    });
    //print(await helper.ingredients());// returns a list of all ingredients
  }
  _addAllIngredients() async {
    //String token = await LocalStorage.getAuthToken();
    if (token != '-1') {
      //int userID= await LocalStorage.getUserID();
      // or ideally change backendRequest to not need userID
      DatabaseHelper helper = DatabaseHelper.instance;

      // gets ingredient list from server
      // adds them to locally if not exist
      await request.getIngredientList().then((ingList) {
        for (dynamic ing in ingList) {
          Ingredient newIng = Ingredient(name: ing.name, id: ing.id);
          helper.insertIngredient(newIng);
        }
      });
      // display all ingredients...
      print(await helper.ingredients());// returns a list of all ingredients

    } else {
      print("User is not logged in.");
    }
  }


  var items = List<String>();
  List<String> wordsToSend = List<String>();



  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(duplicateItems);
    int counter = 0;
    if(query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if(item.contains(query) && counter < 6) {
          dummyListData.add(item);
          counter++;
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        //items.add('No Items Match Inputted Ingredient');
        //items.addAll(duplicateItems);
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        title: new Text('Navbar'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Input an Ingredient",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: Icon(Icons.camera),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)))),
              ),
            ),
            Row (
              children:<Widget>[
                new Container(
                  width: 10.0,
                ),
                RaisedButton(
                  onPressed: () {_onSearchButtonPressed('Vegetarian');},
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: const BoxDecoration (
//                      border: Border(
//                        top: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
//                        left: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
//                        right: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
//                        bottom: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
//                      ),
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFFcc0000),
                          Color(0xFFff3333),
                          Color(0xFFff8080),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: const Text(
                        'Vegetarian',
                        style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                new Container(
                  width: 25.0,
                ),
                RaisedButton(
                  onPressed: () {_onSearchButtonPressed('Vegan');},
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFFcc0000),
                          Color(0xFFff3333),
                          Color(0xFFff8080),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: const Text(
                        ' Vegan ',
                        style: TextStyle(fontSize: 20)
                    ),
                  ),
                ),
                new Container(
                  width: 25.0,
                ),
                RaisedButton(
                  onPressed: () {_onSearchButtonPressed('Low Calorie');},
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xFFcc0000),
                          Color(0xFFff3333),
                          Color(0xFFff8080),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: const Text(
                        'Low Calorie',
                        style: TextStyle(fontSize: 20)
                    ),
                  ),
                ),
              ],
            ),
            // cuisine, diet, alergens, ingredients,
            new Divider(
              color: Colors.grey,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return new Container(
                      child: new ListTile(
                          title: new Text('${items[index]}'),
                        trailing: Icon(Icons.add_circle),
                        onTap: () {
                      _onSearchButtonPressed('${items[index]}');
                      showDialog(context: context, child:
                      new AlertDialog(
                        title: new Text("Ingredient Added:"),
                        content: new Text("${items[index]}"),
                      )
                      );
                    },
                      ),
                      decoration:
                      new BoxDecoration(
                          border: new Border(
                              bottom: new BorderSide()
                          )
                      )
                  );
                },
              ),
            ),
              Padding(
                padding: const EdgeInsets.all(20),
                  child: FloatingActionButton(
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.navigate_next),
                elevation: 0,
                onPressed: () => {},
              ),
            ),
          ],
        ),

      ),
    );
  }
  void _onSearchButtonPressed(String keyWord) {
    wordsToSend.add(keyWord);
    print('LIST BEING RETURNED');
    for (int i =0; i < wordsToSend.length; i++) {
      print(wordsToSend[i]);
    }
    print('FINAL LIST');
  }
}
