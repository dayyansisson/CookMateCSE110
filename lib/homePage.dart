import 'package:cookmate/recipe.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:cookmate/util/cookmateStyle.dart';
import 'package:cookmate/util/database_helpers.dart' as db;
import 'package:cookmate/util/localStorage.dart';
import 'package:flutter/material.dart';
import 'cookbook.dart';

/*
  File: homePage.dart
  Functionality: This page is the main page of the app. It is the page that 
  is diplayed upon logging in. It displays the users favorite recipes and 
  the current list of popular recipes within the app. The user can navigate 
  to all the other pages using the upper navigation bar.
*/

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  BackendRequest backend;
  Future<List<Recipe>> _futurePopular;
  List<Recipe> _popularRecipes;
  Future<List<db.Recipe>> _favoriteRecipeList;
  List<db.Recipe> _favoriteRecipes;
  db.DatabaseHelper database = db.DatabaseHelper.instance;

  Future<void> _getUserInfo() async {
    int userID = await LocalStorage.getUserID();
    String token = await LocalStorage.getAuthToken();
    backend = BackendRequest(token, userID);
  }

  @override
  void initState() {

    _getUserInfo().then((data) {
      _futurePopular = backend.getPopularRecipes();
      _futurePopular.then((popular) {
        setState(() {
          _popularRecipes = popular;
        });
      });
    });

    _updateFavorites();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: NavBar(title: "Home", hasReturn: false, isHome: true),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10, left: 20),
                child: Text(
                  "Popular Today!",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: CookmateStyle.textGrey),
                ),
              ),
              FutureBuilder(
                future: _futurePopular,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Padding(
                        padding: const EdgeInsets.all(100.0),
                        child: CookmateStyle.loadingIcon("Loading popular..."),
                      );
                    case ConnectionState.done:
                      return _displayPopular();
                    default:
                      return Text("error");
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10, left: 20),
                child: Text(
                  "Your Favorites",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: CookmateStyle.textGrey),
                ),
              ),
              FutureBuilder(
                future: _favoriteRecipeList,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Padding(
                        padding: const EdgeInsets.all(100.0),
                        child:
                            CookmateStyle.loadingIcon("Loading favorites..."),
                      );
                    case ConnectionState.done:
                      return _displayFavorites();
                    default:
                      return Text("error");
                  }
                },
              ),
            ])
          ],
        ),
      ),
    );
  }

  Widget _displayPopular() {

    List<Widget> recipeList = List<Widget>();
    for (Recipe recipe in _popularRecipes) {
      recipeList.add(_buildItem(recipe));
    }

    return Container(
      height: 280,
      child: Column(
        children: <Widget>[
          Flexible(
              child: ListView(
                  scrollDirection: Axis.horizontal, children: recipeList)),
        ],
      ),
    );
  }

  Widget _displayFavorites() {
    List<Widget> recipeList = List<Widget>();
    for (db.Recipe recipe in _favoriteRecipes) {
      recipeList.add(_buildItemDB(recipe));
    }

    return Container(
      height: 280,
      child: Column(
        children: <Widget>[
          Flexible(
            child: ListView(
              scrollDirection: Axis.horizontal, children: recipeList)),
        ],
      ),
    );
  }

  Widget _buildItem(Recipe recipe) {

    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Stack(
        children: <Widget>[
          FlatButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              print(
                  "${recipe.title} and ${recipe.apiID}");
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecipeDisplay(
                              recipe.apiID.toString())))
                  .then((value) {
                _updateFavorites();
              });
            },
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4.0,
                  )
                ],
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  height: 220,
                  width: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(recipe.imageURL))),
                ),
              ),
            ),
          ),
          Positioned(
            top: 190,
            left: 10,
            child: Container(
              height: 80,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    recipe.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: CookmateStyle.textGrey,
                        fontWeight: FontWeight.w300,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItemDB(db.Recipe recipe) {

    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Stack(
        children: <Widget>[
          FlatButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecipeDisplay(
                              recipe.id.toString())))
                  .then((value) {
                _updateFavorites();
              });
            },
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4.0,
                  )
                ],
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  height: 220,
                  width: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(recipe.img))),
                ),
              ),
            ),
          ),
          Positioned(
            top: 190,
            left: 10,
            child: Container(
              height: 80,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    recipe.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: CookmateStyle.textGrey,
                        fontWeight: FontWeight.w300,
                        fontSize: 16),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _updateFavorites() {
    _favoriteRecipeList = database.recipes();
    _favoriteRecipeList.then(
      (list) {
        _favoriteRecipes = list;
      }
    );
  }
}
