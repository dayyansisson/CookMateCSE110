import 'package:cookmate/recipe.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:flutter/material.dart';
import 'cookbook.dart';

class SearchResultPage extends StatefulWidget {

  final Future<List<Recipe>> _searchResults;
  Future<List<Recipe>> get searchResults => _searchResults;

  SearchResultPage(Future<List<Recipe>> searchResults)
      : _searchResults = searchResults;

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {

  bool _initPrefs = false;
  int _minPrepTime = 0, _maxPrepTime = 0;
  double _minPrice, _maxPrice;
  int _minCalories, _maxCalories;
  double _timeLimit = 10, _priceLimit = 0, _calLimit = 0;

  int _totalRecipesDisplayed = 0;
  Color _titleColor = Color.fromRGBO(70, 70, 70, 1);
  List<Recipe> recipeList;

  final BackendRequest _request = BackendRequest("03740945581ed4d2c3b25a62e7b9064cd62971a4", 2);

  @override
  void initState() {
    widget._searchResults.then(
      (data) {
        setState(() {
          initializePreferences(data);
        });
      }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.restaurant_menu)),
              Tab(icon: Icon(Icons.format_list_bulleted))
            ],
          ),
        ),
        body:
        TabBarView(
          children: <Widget>[
            FutureBuilder(
              future: widget._searchResults,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            Container(
                              child: Text("Loading recipes..."),
                              padding: EdgeInsets.all(30)
                            ),
                          ],
                        )
                      );
                  case ConnectionState.done:
                    return ListView(children: _searchResults(snapshot.data));
                  default:
                    return Text("error");
                }
              },
            ),
            preferences(recipeList)
          ],
        )
      ),
    );
  }

  Widget preferences(List<Recipe> data) {

    if(!_initPrefs) {
      return Center(child: CircularProgressIndicator());
    }

    setState(() {
      countValidRecipes(data);
    });

    return Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Text(
                      "Preferences",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: _titleColor
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Prep Time: ",
                          style: TextStyle(
                            color: _titleColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          formatPrepTime(_timeLimit.toInt()),
                          style: TextStyle(
                            color: _titleColor,
                            fontWeight: FontWeight.w300,
                            fontSize: 17
                          ),
                        ),
                      ]
                    )
                  ),
                  Slider(
                    activeColor: Colors.redAccent,
                    value: _timeLimit,
                    min: _minPrepTime.toDouble(),
                    max: _maxPrepTime.toDouble(),
                    onChanged: (newLimit) {
                      setState(() {
                        _timeLimit = newLimit;
                        countValidRecipes(data);
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Price: ",
                          style: TextStyle(
                            color: _titleColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          formatPrice(_priceLimit),
                          style: TextStyle(
                            color: _titleColor,
                            fontWeight: FontWeight.w300,
                            fontSize: 17
                          ),
                        ),
                      ]
                    )
                  ),
                  Slider(
                    activeColor: Colors.redAccent,
                    value: _priceLimit,
                    min: _minPrice,
                    max: _maxPrice,
                    onChanged: (newLimit) {
                      setState(() {
                        _priceLimit = newLimit;
                        countValidRecipes(data);
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Calorie Limit: ",
                          style: TextStyle(
                            color: _titleColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          "${_calLimit.toInt()} calories",
                          style: TextStyle(
                            color: _titleColor,
                            fontWeight: FontWeight.w300,
                            fontSize: 17
                          ),
                        ),
                      ]
                    )
                  ),
                  Slider(
                    activeColor: Colors.redAccent,
                    value: _calLimit,
                    min: _minCalories.toDouble(),
                    max: _maxCalories.toDouble(),
                    onChanged: (newLimit) {
                      setState(() {
                        _calLimit = newLimit;
                        countValidRecipes(data);
                      });
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Displaying ",
                          style: TextStyle(
                            color: _titleColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 19,
                          ),
                        ),
                        Text(
                          "$_totalRecipesDisplayed recipes",
                          style: TextStyle(
                            color: _titleColor,
                            fontWeight: FontWeight.w300,
                            fontSize: 19
                          ),
                        ),
                      ]
                    )
                  ),
                ],
              )
            )
          ],
        ),
    );
  }

  void initializePreferences(List<Recipe> recipes) {

    if(_initPrefs) {
      return;
    }

    recipeList = recipes;

    _minPrepTime = 10000000;
    _maxPrepTime = 0;
    _minPrice = 10000000;
    _maxPrice = 0;
    _minCalories = 10000000;
    _maxCalories = 0;

    for(Recipe recipe in recipes) {
      if(recipe.cookTime < _minPrepTime) {
        _minPrepTime = recipe.cookTime;
      }
      if(recipe.cookTime > _maxPrepTime){
        _maxPrepTime = recipe.cookTime;
      }
      if(recipe.price < _minPrice) {
        _minPrice = recipe.price;
      }
      if(recipe.price > _maxPrice){
        _maxPrice = recipe.price;
      }
      if(recipe.calories < _minCalories) {
        _minCalories = recipe.calories.toInt();
      }
      if(recipe.calories > _maxCalories){
        _maxCalories = recipe.calories.toInt();
      }
    }

    _timeLimit = _maxPrepTime.toDouble();
    _priceLimit = _maxPrice;
    _calLimit = _maxCalories.toDouble();

    _initPrefs = true;
  }

  List<Widget> _searchResults(List<Recipe> data) {

    List<Widget> results = List<Widget>();
    List<Widget> recipes = List<Widget>();

    _totalRecipesDisplayed = 0;

    for (Recipe recipe in data) {
      if(passFilters(recipe)) {
        recipes.add(Divider());
        recipes.add(_recipeCard(recipe));
        _totalRecipesDisplayed++;
      }
    }
    recipes.add(Divider());

    Widget topBar = Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            print("pressed this ish");
          },
        ),
        Text("Back"),
        Spacer(flex: 2),
        Text(
          "Found ${data.length} recipes, showing $_totalRecipesDisplayed",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w300,
            color: Color.fromRGBO(128, 128, 128, 1)
          ),
        ),
        Spacer()
      ],
    );

    results.add(topBar);
    results.addAll(recipes);
    
    return results;
  }

  void countValidRecipes (List<Recipe> data) {

    _totalRecipesDisplayed = 0;

    for (Recipe recipe in data) {
      if(passFilters(recipe)) {
        _totalRecipesDisplayed++;
      }
    }
  } 

  bool passFilters (Recipe recipe) {

    if(recipe.cookTime > _timeLimit) return false;
    if(recipe.price > _priceLimit) return false;
    if(recipe.calories > _calLimit + 1) return false;

    return true;
  }

  Widget _recipeCard (Recipe recipe) {
    return Row(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: FlatButton(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), 
              child: Image.network(
                recipe.imageURL,
                width: 150
              )
            ),
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => RecipeDisplay(_request.getRecipe("${recipe.apiID}")))
              );
            },
          ),
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    formatTitle(recipe.title), 
                    softWrap: false,
                    overflow: TextOverflow.fade,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: _titleColor,
                    ),
                  ),
                ),
              ),
              _infoDisplay("Prep Time", formatPrepTime(recipe.cookTime)),
              _infoDisplay("Calories", formatCalories(recipe.calories)),
              _infoDisplay("Servings", "${recipe.servings}"),
              _infoDisplay("Price", formatPrice(recipe.price))
            ],
          ),
        )
      ],
    );
  }

  Widget _infoDisplay (String title, String info) {
    return Row(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(74, 74, 74, 1)
          ),
        ),
        Text(
          "  $info",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            color: Color.fromRGBO(74, 74, 74, 1)
          ),
        ),
      ],
    );
  }

  String formatTitle (String input) {

    List<String> formattedString = input.toLowerCase().split(' ');
    String finalString = "";
    for(String word in formattedString) {
      finalString += "${word[0].toUpperCase()}${word.substring(1, word.length)} ";
    }
    return finalString;
  }

  String formatPrice (double price) {

    List<String> formattedString = price.toString().split('.');
    if(formattedString[1].length < 2) {
      formattedString[1] += '0';
    } else if(formattedString[1].length > 2) {
      formattedString[1] = formattedString[1].substring(0, 2);
    }
    return "\$${formattedString[0]}.${formattedString[1]}";
  }

  String formatCalories (double calories) => calories.toInt() == 0 ? "Not Available" : "${calories.toInt()} cal";

  String formatPrepTime (int prepTime) {

    String time;

    int minutes = prepTime.remainder(60);
    int hours = prepTime ~/ 60;

    if(hours == 0 && minutes == 0) {
      return "Not Available";
    }

    if(hours > 0) {
      time = "$hours hour";
      if(hours > 1) {
        time += "s";
      }
      if(minutes > 0) {
        time += ", $minutes minutes";
      }
    } else {
      time = "$minutes minutes";
    }

    return time;
  }
}