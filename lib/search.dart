/*
 * Coders: Rayhan, Luis
 */
import 'dart:convert';
import 'dart:developer' as logger;
import 'package:cookmate/dialog.dart';
import 'package:cookmate/scanner.dart';
import 'package:cookmate/topNavBar.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:flutter/material.dart';
import 'package:cookmate/util/localStorage.dart';
import 'package:cookmate/cookbook.dart' as CB;
import 'dart:async';
import 'package:cookmate/util/database_helpers.dart' as DB;
import 'package:cookmate/searchResultPage.dart';

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
      home: new SearchPage(),
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ScanButtonState scanButt = new ScanButtonState();
  TextEditingController editingController = TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  // User Data
  String token;
  int userID;

  // Backend controller
  BackendRequest request;

  // Data containers
  var items = List<String>();
  List<String> duplicateItems = new List<String>();
  List<String> diets = new List<String>();
  List<String> cuisines = new List<String>();
  List<DropdownMenuItem<String>> dropDownCuisines = [];

  // Queries for recipe search
  List<String> ingredientQuery = null;
  int maxCalories = null;
  String cuisineQuery = null;
  String dietQuery;

  // Recipe List results
  List<CB.Recipe> recipes = List<CB.Recipe>();
  Future<List<CB.Recipe>> recipesResult;

//**********Rayhan Code **********//
  int _value = 2100;

//********************************//

  @override
  void initState() {
    _initData();
    super.initState();
  }

  _initData() async {
    //token = await LocalStorage.getAuthToken();
    //userID = await LocalStorage.getUserID();

    token = "03740945581ed4d2c3b25a62e7b9064cd62971a4";
    userID = 2;
    request = BackendRequest(token, userID);
    ingredientQuery;
    _addAllIngredients();
    _getDiets();
    // _getCuisines();
    _getIngredients();
  }

  _recipeSearch() async {
    recipesResult = request.recipeSearch(
        cuisine: cuisineQuery,
        maxCalories: maxCalories,
        ingredients: ingredientQuery);
  }

  _routeRecipePage(BuildContext context) async {
    _recipeSearch();
    if (recipesResult != null) {
      print(recipesResult);
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SearchResultPage(recipesResult)));
    }
    _clearQueries();
  }

  _clearQueries() {
    recipes.clear();
    if (ingredientQuery != null) ingredientQuery.clear();
    ingredientQuery = null;
    cuisineQuery = null;
    maxCalories = _value;
  }

  _getCuisines() async {
    request.getCuisineList().then((cuisineList) {
      for (int i = 0; i < cuisineList.length; i++) {
        cuisines.add(cuisineList[i].name);
      }
    });
  }

  Future<List<CB.Cuisine>> _loadCusines() async {
    return request.getCuisineList();
  }

  _getDiets() async {
    request.getDietList().then((dietList) {
      for (int i = 0; i < dietList.length; i++) {
        diets.add(dietList[i].name);
      }
    });
  }

  _getIngredients() async {
    DB.DatabaseHelper helper = DB.DatabaseHelper.instance;
    List<String> ingredients;
    helper.ingredients().then((list) {
      for (int i = 0; i < list.length; i++) {
        duplicateItems.add(list[i].name);
      }
    });
  }

  _addAllIngredients() async {
    //String token = await LocalStorage.getAuthToken();
    if (token != '-1') {
      //int userID= await LocalStorage.getUserID();
      // or ideally change backendRequest to not need userID
      DB.DatabaseHelper helper = DB.DatabaseHelper.instance;

      // gets ingredient list from server
      // adds them to locally if not exist
      await request.getIngredientList().then((ingList) {
        for (dynamic ing in ingList) {
          DB.Ingredient newIng = DB.Ingredient(name: ing.name, id: ing.id);
          helper.insertIngredient(newIng);
        }
      });
      // display all ingredients...
//      print(await helper.ingredients());// returns a list of all ingredients
    } else {
      print("User is not logged in.");
    }
  }

  // Setters
  _setMaxCalories(int maxCaloriesQuery) {
    maxCalories = maxCaloriesQuery;
    print("MaxCalories: " + maxCalories.toString());
  }

  _setCuisine(String cuisine) {
    if (cuisine != null) cuisineQuery = cuisine;
    print(cuisine);
  }

  _addIngredientQuery(String ingredient) {
    print(ingredient);
    if (ingredientQuery == null) ingredientQuery = new List<String>();
    if (ingredient != null) {
      ingredientQuery.add(ingredient.toString());
      print(ingredientQuery);
    }
  }

  _getIngredientBarCode(List<String> ingredients) {
    if (ingredientQuery == null) ingredientQuery = new List<String>();
    if (ingredientQuery != null) {
      ingredientQuery.addAll(ingredients);
    }
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(duplicateItems);
    int counter = 0;
    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.contains(query) && counter < 5) {
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
      });
    }
  }

  DropdownButton<String> cuisineButton(List<CB.Cuisine> data) {
    List<String> cuisines = new List<String>();
    for (int i = 0; i < data.length; i++) {
      cuisines.add(data[i].name);
    }
    return DropdownButton<String>(
      hint: Text("Cuisines"),
      onChanged: (value) {
        setState(() {
          _setCuisine(value);
        });
      },
      isExpanded: true,
      iconSize: 35,
      value: cuisineQuery,
      items: cuisines.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  _getBCList() async {
    List<String> bcList = await scanButt.scanBarcodeNormal();
    if (bcList != null) {
      if (ingredientQuery == null) ingredientQuery = new List<String>();
      for (int i = 0; i < bcList.length; i++) {
        ingredientQuery.add(bcList[i]);
        print(bcList[i]);
      }
    }
    else if(bcList == null){
      showDialog(
          context: context,
          builder: (BuildContext context) => CustomDialog(
           title: "Uh Oh",
           description:
            "Barcode not found in our database, please try entering the item manually",
           buttonText: "Okay",
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: TopNavBar().build(context),
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
                    suffixIcon: IconButton(
                        icon: Icon(Icons.camera),
                        onPressed: () {
                          _getBCList();
                        }),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)))),
              ),
            ),
            Slider.adaptive(
              value: _value.toDouble(),
              min: 500,
              max: 5000,
              divisions: 10,
              activeColor: Colors.red,
              inactiveColor: Colors.black,
              onChanged: (newValue) {
                setState(() {
                  _value = newValue.round();
                  _setMaxCalories(newValue.round());
                });
              },
              label: 'Max Calories: $_value',
            ),
            FutureBuilder(
                future: _loadCusines(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text("Loading cuisines");
                    case ConnectionState.done:
                      return cuisineButton(snapshot.data);
                    default:
                      return Text("Error");
                  }
                }),
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
                          _addIngredientQuery('${items[index]}');
                          showDialog(
                              context: context,
                              child: new AlertDialog(
                                title: new Text("Ingredient Added:"),
                                content: new Text("${items[index]}"),
                              ));
                        },
                      ),
                      decoration: new BoxDecoration(
                          border: new Border(bottom: new BorderSide())));
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                backgroundColor: Colors.redAccent,
                child: Icon(Icons.navigate_next),
                elevation: 0,
                onPressed: () {
                  editingController.clear();
                  _routeRecipePage(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
