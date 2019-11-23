
import 'package:cookmate/recipePage.dart';
import 'package:flutter/material.dart';



class RecipeList extends StatefulWidget{
  final int d ;
  final int m ;
  final int y ;
  final List<Recipe2> rl;
  RecipeList({Key key, this.d, this.m, this.y, this.rl}): super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return RecipeListState();
  }

}
class RecipeListState extends State<RecipeList>{

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    //DateTime dt;
    //List<Recipe> rl;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
        backgroundColor: Colors.amberAccent,
      )
    );

  }
}