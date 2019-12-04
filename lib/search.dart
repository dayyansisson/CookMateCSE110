/*
 * Coders: Rayhan, Luis
 */
import 'package:cookmate/dialog.dart';
import 'package:cookmate/scanner.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:cookmate/util/cookmateStyle.dart';
import 'package:flutter/material.dart';
import 'package:cookmate/util/localStorage.dart';
import 'package:cookmate/cookbook.dart' as CB;
import 'dart:async';
import 'package:cookmate/util/database_helpers.dart' as DB;
import 'package:cookmate/searchResultPage.dart';

/*
  File: search.dart
  Functionality: This page handles the entire search functionality of the app.
  It allows users to enter items manually and select from a list of autocompleted
  ingredients within our database. It also implements the scanner class which allows
  the user to add ingredients via a barcode scanner. 
*/

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
  List<String> ingredientQuery;
  int maxCalories;
  String cuisineQuery;
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
    token = await LocalStorage.getAuthToken();
    userID = await LocalStorage.getUserID();
    request = BackendRequest(token, userID);
    _addAllIngredients();
    _getDiets();
    _getCuisines();
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
      Navigator.push(
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
        if (item.contains(query) && counter < 10) {
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

  String displayIngredients(List<String> ingredient) {

    if(ingredient == null) {
      return "No ingredients added yet!";
    }

    String display = "";
    for (int i = 0; i < ingredient.length; i++) {
      String token = ingredient[i];
      display += "$token";
      if (i != ingredient.length - 1) {
        display += ", ";
      }
    }
    return display;
  }

  Widget cuisineButton(List<CB.Cuisine> data) {
    List<String> cuisines = new List<String>();
    for (int i = 0; i < data.length; i++) {
      cuisines.add(data[i].name);
    }
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: DropdownButton<String>(
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
      ),
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
    else if (bcList == null || bcList.length == 0){ 
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
      appBar: NavBar(title: "Search", titleSize: 25, hasReturn: true, isSearch: true),
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
                        title: new Text(
                          '${items[index]}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Icon(
                          Icons.add_circle,
                          color: Colors.redAccent,
                        ),
                        onTap: () {
                          _addIngredientQuery('${items[index]}');
                          String display = displayIngredients(ingredientQuery);
                          showDialog(
                              context: context,
                              child: AlertDialog(
                                title: Text("Selected Ingredients: "),
                                content: Text("$display"),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ));
                          editingController.clear();
                        },
                      ),
                      decoration: new BoxDecoration(
                          border: new Border(bottom: new BorderSide(
                            width: 0.1
                          ))));
                },
              ),
            ),
            new Divider(
              color: Colors.grey,
            ),
            new Container(
              margin: new EdgeInsets.all(20.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget> [
                      Container(
                        height: 45,
                        width: 100,
                        child: RaisedButton(
                          color: CookmateStyle.standardRed,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Icon(Icons.list, color: Colors.white, size: 30),
                          elevation: 1,
                          onPressed: () {
                            String display = displayIngredients(ingredientQuery);
                            editingController.clear();
                            showDialog(
                                context: context,
                                child: AlertDialog(
                                  title: Text("Ingredients"),
                                  content: Text("$display"),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Ingredients",
                          style: TextStyle(
                            fontSize: 15,
                            color: CookmateStyle.textGrey
                          ),
                        ),
                      )
                    ]
                  ),
                  Column (
                    children: <Widget> [ 
                      Container(
                        height: 45,
                        width: 100,
                        child: RaisedButton(
                          color: CookmateStyle.standardRed,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Icon(Icons.search, color: Colors.white, size: 30),
                          elevation: 1,
                          onPressed: () {
                            editingController.clear();
                            _routeRecipePage(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Search",
                          style: TextStyle(
                            fontSize: 15,
                            color: CookmateStyle.textGrey
                          ),
                        ),
                      )
                    ]
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}