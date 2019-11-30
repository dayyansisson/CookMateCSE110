import 'package:cookmate/util/backendRequest.dart';
import 'package:cookmate/util/cookmateStyle.dart';
//import 'package:cookmate/search.dart';
import 'package:flutter/material.dart';
import 'package:cookmate/calendar.dart';
import 'package:cookmate/homePage.dart';

import 'cookbook.dart';

//import 'cookbook.dart' as cb;


void main(){
  runApp(MaterialApp(
    title: 'Home',
    theme: CookmateStyle.theme,
    home: HomePage(),
  ));
}
class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }

}
class HomePageState extends State<HomePage> {
  String _authToken ="e27dc27ab455de7a3afa076e09e0eacff2b8eefb";
  int id = 6;
  BackendRequest br = new BackendRequest("e27dc27ab455de7a3afa076e09e0eacff2b8eefb", 6);
  Recipe recipe1 = new Recipe(221886);
  Recipe recipe2 = new Recipe(716429);
  HomePageState(){
    this.recipe1.title = "Red pepper, ham & cheese tart";
    this.recipe1.imageURL = "https://spoonacular.com/recipeImages/221886-312x231.jpg";
    this.recipe2.title = "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs";
    this.recipe2.imageURL = "https://spoonacular.com/recipeImages/716429-312x231.jpg";
  }

  // Recipe recipe1 = new Recipe(
  //     716429,
  //     "Pasta with Garlic, Scallions, Cauliflower & Breadcrumbs",
  //     "https://spoonacular.com/recipeImages/716429-312x231.jpg");

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text("Calendar"),
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyCalendar(recipe: recipe2,)));
                },
              ),
              ListTile(
                title: Text("Create User"),
                onTap: (){
                  setState(() {
                   /* br.createUser("Hatef.nabili@gmail.com", "hatef88" , "G0lPe3ar").then((id){
                      this.id = id;
                      print("id: " + this.id.toString());
                    });*/
                  });
                },
              ),
              ListTile(
                title: Text("Log in"),
                onTap: (){
                  setState(() {
                      BackendRequest.login("hatef88", "G0lPe3ar").then((_authToken){
                      this._authToken = _authToken;
                      this.br = new BackendRequest(this._authToken, id);
                      print("Token: " + _authToken);
                    });
                  });
                },
              ),

              /*ListTile(
                title: Text("Search"),
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                },
              )*/



            ],
          )
      )

    );
  }
}