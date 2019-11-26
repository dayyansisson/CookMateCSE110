import 'package:cookmate/cookbook.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class recipeDisplay extends StatelessWidget{
  String recipeID;
  Future<Recipe> recipeFuture;
  //Recipe recipe;
  List<String> instructions;
  List<String> ingredients;

  recipeDisplay(Future<Recipe> recipe) {
    recipeFuture = recipe;
    recipeFuture.then(
      (data) {
        if(data.getInstructions() != null){
          instructions = data.getInstructions();
        }
        if(data.getIngredients() != null){
          ingredients = data.getIngredients();
        }
      }
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Recipe Page',
        home: Scaffold(
          appBar: AppBar(
            
          ),
          body: FutureBuilder(
              future: recipeFuture,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting: // this handles waiting for the async call
                    return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            Container(
                              child: Text("Loading recipe..."),
                              padding: EdgeInsets.all(30)
                            ),
                          ],
                        )
                      );
                  case ConnectionState.done: // this handles what to display
                    return SingleChildScrollView(
                            child: Column(
                                children: <Widget> [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      padding: EdgeInsets.all(15.0),
                                      child: Text(snapshot.data.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),),
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: snapshot.data.image,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Column(
                                        children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 6.0),
                                          child: Column(  
                                            children: <Widget>[
                                              Text(
                                                "Prep Time",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                  "${snapshot.data.cookTime}",
                                                  style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 5.0),
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                "Servings",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                  "${snapshot.data.servings}",
                                                  style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(vertical: 5.0),
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                "Cost",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                  '\$' + "${snapshot.data.price}",
                                                  style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ],
                                      ),
                                      Column(
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.shopping_cart),
                                            padding: EdgeInsets.symmetric(vertical: 15.0),
                                            color: Colors.black,
                                            iconSize: 35.0,
                                            onPressed: () {
                                              print('pressed');
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.calendar_today),
                                            padding: EdgeInsets.symmetric(vertical: 15.0),
                                            color: Colors.black,
                                            iconSize: 35.0,
                                            onPressed: () {
                                              print('pressed');
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.star_border),
                                            padding: EdgeInsets.symmetric(vertical: 15.0),
                                            color: Colors.black,
                                            iconSize: 35.0,
                                            onPressed: () {
                                              print("Pressed");
                                            },
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(15.0),
                                    child: Text("Instructions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),),
                                  ),
                                  getInstructionWidgets(instructions),
                                  Container(
                                    padding: EdgeInsets.all(15.0),
                                    child: Text("Ingredients", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),),
                                  ),
                                  getIngredientWidgets(ingredients)
                                ]
                            )
                        );// your widget... the actual recipe is stored in snapshot.data
                  default:
                    return Text("error");
                }
              },
            ),
        )
    );
  }

  Widget getInstructionWidgets(List<String> strings)
  {

    List<Widget> list = new List<Widget>();

    //Check for no instruction
    if(strings == null){
      return new Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text("No instructions provided for this recipe unfortunately", style: TextStyle(fontSize: 20),),
          )
      );
    }

    for(var i = 0; i < strings.length; i++){
      list.add(
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("${i+1}. ${strings[i]}", style: TextStyle(fontSize: 20),),
              )
          )
      );
    }
    return new Column(
        children: list);
  }

  Widget getIngredientWidgets(List<String> strings)
  {

    List<Widget> list = new List<Widget>();

    if(strings == null){
      return new Column(children: list);
    }

    for(var i = 0; i < strings.length; i++){
      list.add(
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text("${strings[i]}", style: TextStyle(fontSize: 20),),
              )
          )
      );
    }
    return new Column(
        children: list);
  }
}