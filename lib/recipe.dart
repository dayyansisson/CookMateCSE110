import 'package:cookmate/cookbook.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecipeDisplay extends StatelessWidget {

  Color _titleColor = Color.fromRGBO(70, 70, 70, 1);
  Color _iconColor = Color.fromRGBO(180, 180, 180, 1);

  Future<Recipe> recipeFuture;
  List<String> instructions;
  List<String> ingredients;

  RecipeDisplay(Future<Recipe> recipe) {
    recipeFuture = recipe;
    recipeFuture.then((data) {
      if (data.getInstructions() != null) {
        instructions = data.getInstructions();
      }
      if (data.getIngredients() != null) {
        ingredients = data.getIngredients();
      }
    });
  }

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
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Container(
                          child: Text("Loading recipe..."),
                          padding: EdgeInsets.all(30)),
                    ],
                  )
                );
                case ConnectionState.done: // this handles what to display
                  return DefaultTabController(
                    length: 2,
                      child: Column(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              snapshot.data.image,
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
                                )
                              ),
                              Positioned(
                                top: 45,
                                right: 20,
                                child: Row(
                                  children: <Widget>[
                                    // IconButton(
                                    //   icon: Icon(Icons.calendar_today),
                                    //   color: Colors.white,
                                    //   iconSize: 35.0,
                                    //   onPressed: () {
                                    //     print("Pressed");
                                    //   },
                                    // ),
                                    // IconButton(
                                    //   icon: Icon(Icons.shopping_cart),
                                    //   padding: EdgeInsets.symmetric(horizontal: 10.0),
                                    //   color: Colors.white,
                                    //   iconSize: 35.0,
                                    //   onPressed: () {
                                    //     print('pressed');
                                    //   },
                                    // ),
                                    IconButton(
                                      icon: Icon(Icons.star_border),
                                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                                      color: Colors.white,
                                      iconSize: 35.0,
                                      onPressed: () {
                                        print('pressed');
                                      },
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15, top: 15),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                formatTitle(snapshot.data.title),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, 
                                    fontSize: 22,
                                    color: _titleColor
                                  ),
                              ),
                            ),
                            constraints: BoxConstraints.expand(height: 45),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(250, 250, 250, 1),
                              boxShadow: [ 
                                BoxShadow(
                                  offset: Offset(0, -6),
                                  color: Colors.black12,
                                  spreadRadius: 0,
                                  blurRadius: 2
                                )
                              ]
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 15, top: 5, bottom: 10),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.timer, color: _iconColor),
                                Spacer(flex: 1),
                                Text(
                                  formatPrepTime(snapshot.data.cookTime),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w200,
                                    color: _titleColor
                                  ),
                                ),
                                Spacer(flex: 3),
                                Icon(Icons.restaurant, color: _iconColor),
                                Spacer(flex: 1),
                                Text(
                                  "${snapshot.data.servings}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w200,
                                    color: _titleColor
                                  ),
                                ),
                                Spacer(flex: 3),
                                Icon(Icons.attach_money, color: _iconColor),
                                Text(
                                  formatPrice(snapshot.data.price),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w200,
                                    color: _titleColor
                                  ),
                                ),
                                Spacer(flex:50),
                              ],
                            ),
                          ),
                          TabBar(
                            tabs: <Widget>[
                              Tab(child: Text("Ingredients", style: TextStyle(color: _titleColor))),
                              Tab(child: Text("Instructions", style: TextStyle(color: _titleColor))),
                            ],
                          ),
                          Container(
                            constraints: BoxConstraints.expand(height: 450),
                            child: TabBarView(
                              children: <Widget>[
                                getIngredientWidgets(ingredients),
                                getInstructionWidgets(instructions),
                              ],
                            ),
                          )
                        ]
                      )
                  );
                default:
                  return Text("error");
              }
            },
          ),
        ));
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
        )
      );
    }

    for (var i = 0; i < strings.length; i++) {
      list.add(
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  "${i+1}",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: _titleColor),
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(right: 25.0),
                  child: Text(
                    "${strings[i]}",
                    softWrap: true,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200, color: _titleColor),
                  ),
                ),
              ),
            ],
          ),
        )
      );
    }
    return ListView(children: list, padding: EdgeInsets.only(top: 10));
  }

  Widget getIngredientWidgets(List<String> strings) {
    List<Widget> list = new List<Widget>();

    if (strings == null) {
      return new Column(children: list);
    }

    for (var i = 0; i < strings.length; i++) {
      list.add(Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              "${strings[i]}",
              style: TextStyle(fontSize: 20, color: _titleColor),
            ),
          )));
    }
    return new Column(children: list);
  }

  String formatTitle (String input) {

    List<String> formattedString = input.toLowerCase().split(' ');
    String finalString = "";
    for(String word in formattedString) {
      finalString += "${word[0].toUpperCase()}${word.substring(1, word.length)} ";
    }
    return finalString;
  }

  String formatPrepTime (int prepTime) {

    String time;

    int minutes = prepTime.remainder(60);
    int hours = prepTime ~/ 60;

    if(hours == 0 && minutes == 0) {
      return "Not Available";
    }

    if(hours > 0) {
      time = "${hours}h";
      if(minutes > 0) {
        time += " ${minutes}m";
      }
    } else {
      time = "${minutes}m";
    }

    return time;
  }

  String formatPrice (double price) {

    List<String> formattedString = price.toString().split('.');
    if(formattedString[1].length < 2) {
      formattedString[1] += '0';
    } else if(formattedString[1].length > 2) {
      formattedString[1] = formattedString[1].substring(0, 2);
    }
    return "${formattedString[0]}.${formattedString[1]}";
  }
}
