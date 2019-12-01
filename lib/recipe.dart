import 'dart:math';

import 'package:cookmate/calendar.dart';
import 'package:cookmate/cookbook.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:cookmate/util/cookmateStyle.dart';
import 'package:cookmate/util/database_helpers.dart' as localDB;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
//import 'package:cookmate/util/database_helpers.dart';
import 'package:cookmate/util/localStorage.dart' as LS;

class RecipeDisplay extends StatefulWidget {
  Future<Recipe> recipe;
  RecipeDisplay(Future<Recipe> recipe) {
    this.recipe = recipe;
  }

  @override
  _RecipeDisplayState createState() => _RecipeDisplayState(recipe);
}

class _RecipeDisplayState extends State<RecipeDisplay> {
  localDB.DatabaseHelper helper = localDB.DatabaseHelper.instance;
  //BackendRequest backend = new BackendRequest("42e96d88b6684215c9e260273b5e56b0522de18e", 4);
  BackendRequest backend;
  Future<Recipe> recipeFuture;
  List<String> instructions;
  List<Ingredient> ingredients;
  Recipe pageRecipe;
  Color starColor = Colors.white;

  GlobalKey _tabBarKey = GlobalKey();
  _getUserInfo() async {
    int userID = await LS.LocalStorage.getUserID();
    String token = await LS.LocalStorage.getAuthToken();
    backend = BackendRequest(token, userID);
  }
  _RecipeDisplayState(Future<Recipe> recipe) {
    _getUserInfo();
    recipeFuture = recipe;
    recipeFuture.then((data) {
      pageRecipe = data;
      if (data.getInstructions() != null) {
        instructions = data.getInstructions();
      }
      if (data.getIngredients() != null) {
        ingredients = data.getIngredients();
      }
    });
  }

  Color _titleColor = Color.fromRGBO(70, 70, 70, 1);
  Color _iconColor = Color.fromRGBO(180, 180, 180, 1);
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Recipe Page',
        home: Scaffold(
          body: FutureBuilder(
            future: recipeFuture,
            builder: (futureContext, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState
                    .waiting: // this handles waiting for the async call
                  return CookmateStyle.loadingIcon("Loading recipe...");
                case ConnectionState.done:
                  return DefaultTabController(
                      length: 2,
                      child: CustomScrollView(slivers: <Widget>[
                        SliverAppBar(
                          backgroundColor: Color.fromRGBO(250, 250, 250, 1),
                          expandedHeight: 231.5,
                          flexibleSpace: FlexibleSpaceBar(
                            background: header(snapshot.data.image),
                          ),
                        ),
                        SliverFillRemaining(
                          child: Column(
                            children: <Widget>[
                              infoBar(snapshot.data),
                              Container(
                                padding: EdgeInsets.all(7),
                              ),
                              TabBar(
                                key: _tabBarKey,
                                tabs: <Widget>[
                                  Tab(
                                      child: Text("Ingredients",
                                          style:
                                              TextStyle(color: _titleColor))),
                                  Tab(
                                      child: Text("Instructions",
                                          style:
                                              TextStyle(color: _titleColor))),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: <Widget>[
                                    getIngredientWidgets(ingredients),
                                    getInstructionWidgets(instructions),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ]));
                default:
                  return Text("error");
              }
            },
          ),
          floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            marginRight: 20,
            marginBottom: 28,
            backgroundColor: Colors.white,
            foregroundColor: Colors.redAccent,
            children: [
              SpeedDialChild(
                  child: Icon(Icons.add_shopping_cart),
                  backgroundColor: Colors.redAccent,
                  label: 'Add to Shopping List',
                  labelStyle: TextStyle(fontSize: 18.0),
                  onTap: () {
                    _addIngredients(ingredients);
                  }),
              SpeedDialChild(
                child: Icon(Icons.calendar_today),
                backgroundColor: Colors.redAccent,
                label: 'Add to Calendar',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              new MyCalendar(recipe: pageRecipe)));
                },
              ),
            ],
          ),
        ));
  }

  Widget header(Image image) {
    _isPressedFave();
    return Stack(
      children: <Widget>[
        image,
        Positioned(
            top: 50,
            left: 10,
            child: FlatButton(
              shape: CircleBorder(),
              color: Colors.white,
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.redAccent,
              ),
              onPressed: () => Navigator.pop(context),
            )),
        Positioned(
          top: 45,
          right: 20,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.star_border),
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                color: starColor,
                iconSize: 35.0,
                onPressed: () {
                  //helper.clearRecipes();
                  setState(() {
                    if (isPressed) {
                      isPressed = false;
                    } else {
                      isPressed = true;
                    }
                  });

                  if(!isPressed){
                    _addToFavorites();
                  }
                  else{
                    _removeFromFavorites();
                  }
                },
              )
            ],
          ),
        )
      ],
    );
  }

  Widget getInstructionWidgets(List<String> strings) {
    List<Widget> list = List<Widget>();

    //Check for no instruction
    if (strings == null) {
      Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "No instructions provided for this recipe unfortunately",
              style: TextStyle(fontSize: 20, color: _titleColor),
            ),
          ));
    }

    for (var i = 0; i < strings.length; i++) {
      list.add(Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "${i + 1}",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: _titleColor),
              ),
            ),
            Flexible(
              child: Container(
                padding: EdgeInsets.only(right: 25.0),
                child: Text(
                  "${strings[i]}",
                  softWrap: true,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w200,
                      color: _titleColor),
                ),
              ),
            ),
          ],
        ),
      ));
    }
    return ListView(
        children: list, padding: EdgeInsets.only(top: 10), shrinkWrap: true);
  }

  Widget infoBar(Recipe data) {
    return Column(children: <Widget>[
      Container(
        padding: EdgeInsets.only(left: 15, top: 15),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            formatTitle(data.title),
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 22, color: _titleColor),
          ),
        ),
        constraints: BoxConstraints.expand(height: 45),
        decoration: BoxDecoration(
          color: Color.fromRGBO(250, 250, 250, 1),
          /*boxShadow: [
                BoxShadow(
                    offset: Offset(0, -6),
                    color: Colors.black12,
                    spreadRadius: 0,
                    blurRadius: 2)
              ]*/
        ),
      ),
      Container(
        padding: EdgeInsets.only(left: 15, top: 5, bottom: 10),
        child: Row(
          children: <Widget>[
            Icon(Icons.timer, color: _iconColor),
            Spacer(flex: 1),
            Text(
              formatPrepTime(data.cookTime),
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w200,
                  color: _titleColor),
            ),
            Spacer(flex: 3),
            Icon(Icons.restaurant, color: _iconColor),
            Spacer(flex: 1),
            Text(
              "${data.servings}",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w200,
                  color: _titleColor),
            ),
            Spacer(flex: 3),
            Icon(Icons.attach_money, color: _iconColor),
            Text(
              formatPrice(data.price),
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w200,
                  color: _titleColor),
            ),
            Spacer(flex: 50),
          ],
        ),
      )
    ]);
  }

  Widget getIngredientWidgets(List<Ingredient> strings) {
    List<Widget> list = new List<Widget>();

    if (strings == null) {
      return new Column(children: list);
    }
    for (var i = 0; i < strings.length; i++) {
      list.add(Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 25.0),
              child: Text(
                "${formatAmount(strings[i].quantity)} ${strings[i].units}",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: _titleColor),
              ),
            ),
            //unitsCheck(strings[i].units),
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  "${strings[i].name}",
                  softWrap: true,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w200,
                      color: _titleColor),
                ),
              ),
            ),
          ],
        ),
      ));
    }
    return ListView(
        children: list, padding: EdgeInsets.only(top: 10), shrinkWrap: true);
  }

  String formatTitle(String input) {
    List<String> formattedString = input.toLowerCase().split(' ');
    String finalString = "";
    for (String word in formattedString) {
      finalString +=
          "${word[0].toUpperCase()}${word.substring(1, word.length)} ";
    }
    return finalString;
  }

  String formatPrepTime(int prepTime) {
    String time;

    int minutes = prepTime.remainder(60);
    int hours = prepTime ~/ 60;

    if (hours == 0 && minutes == 0) {
      return "Not Available";
    }

    if (hours > 0) {
      time = "${hours}h";
      if (minutes > 0) {
        time += " ${minutes}m";
      }
    } else {
      time = "${minutes}m";
    }

    return time;
  }

  String formatPrice(double price) {
    List<String> formattedString = price.toString().split('.');
    if (formattedString[1].length < 2) {
      formattedString[1] += '0';
    } else if (formattedString[1].length > 2) {
      formattedString[1] = formattedString[1].substring(0, 2);
    }
    return "${formattedString[0]}.${formattedString[1]}";
  }

  _addIngredients(List<Ingredient> ingredients) async {
    await helper.clearShoppingList();
    for (int i = 0; i < ingredients.length; i++) {
      localDB.ShoppingList sl = new localDB.ShoppingList(
          ingredient: ingredients[i].name,
          quantity: ingredients[i].quantity.round(),
          purchased: false,
          measurement: ingredients[i].units);
      await helper.insertShoppingListItem(sl);
      
    }
    print(await helper.shoppingListItems());
  }

  _addToFavorites() async {
    localDB.Recipe fave = new localDB.Recipe(
      id: pageRecipe.apiID,
      name: pageRecipe.title,
      img: pageRecipe.imageURL
    );

    //print(pageRecipe.toString());
    //backend.removeFavorite(pageRecipe.apiID);
    print(pageRecipe);
    backend.addFavorite(pageRecipe);

    await helper.insertRecipe(fave);
  }

  _removeFromFavorites() async {
    await helper.deleteRecipe(pageRecipe.apiID);
    backend.removeFavorite(pageRecipe.apiID);
  }

  _isPressedFave() async {
    List<localDB.Recipe> recipes = await helper.recipes();

    for(int i =0; i < recipes.length; i++){
      if(pageRecipe.title == recipes[i].name){
        isPressed = true;
      }
    }

    if (this.isPressed) {
      setState(() {
        starColor = Colors.yellow;
      });
    }
    else{
      setState(() {
        starColor = Colors.white;
      });
    }
  }

  // Widget unitsCheck(String units) {
  //   if (units != "") {
  //     return Flexible(
  //       child: Container(
  //         padding: EdgeInsets.only(left: 7.0),
  //         child: Text(
  //           "${units}",
  //           softWrap: true,
  //           style: TextStyle(
  //               fontSize: 20, fontWeight: FontWeight.w200, color: _titleColor),
  //         ),
  //       ),
  //     );
  //   } else
  //     return Container();
  // }

  

  String formatAmount(double amount) {
    if (amount == 0.25) {
      return "1/4";
    } else if (amount == 0.5) {
      return "1/2";
    } else if (amount == 0.125) {
      return "1/8";
    } else if (amount < 0.125) {
      return "A pinch of";
    } else
      return amount.round().toString();
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
