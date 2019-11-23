import 'package:flutter/material.dart';

class Recipe2 extends StatefulWidget{

  final String name;
  final AssetImage ai;
  Recipe2({Key key, this.name, this.ai}): super(key: key);
  @override
  State<StatefulWidget> createState() {
    return RecipeState();
  }
}
class RecipeState extends State<Recipe2> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //String name;
    //Image image;

    return Scaffold(
      appBar: AppBar(
        title: Text("Sushi"),
      )

    );
  }

}

