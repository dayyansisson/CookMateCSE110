import 'package:cookmate/cookbook.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:flutter/painting.dart';
import 'dart:math';

class Inspiration extends StatefulWidget {
  final String authToken;
  final int id;
  //Inspiration( String authToken ) ;
  const Inspiration({Key key, this.authToken, this.id}): super(key: key);
  @override
  State<StatefulWidget> createState() {
    return InspirationState(authToken, id);
  }
}

class InspirationState extends State<Inspiration> {
  final List<String> iList = [
    'a',
    'b',
    'c',
    'd',
    'e',
    'f',
    'g',
    'h',
    'i',
    'j',
    'k',
    'l',
    'm',
    'n',
    '0',
    'p'
  ];
  final List<String> cList = [
    'Chineese',
    'Mediteranian',
    'French',
    'Colombian',
    'Italian',
    'Persian',
    'Mexican',
    'Indian',
    'Sea Food',
    'Low Carb'

  ];
  BackendRequest br;
  String authToken;
  int id;
  List<Ingredient> ing;
  List<String> kwList = [];
  var rn;

  Color color;
  int n1;
  int n2;
  String text;
  String listHeader;
  Ingredient ing1;
  Ingredient ing2;
  String kw1;
  String kw2;

  InspirationState(String authToken, int id) {
    rn = new Random();
    this.authToken = authToken;
    this.id = id;
    this.listHeader = 'list:';
    kwList.add(listHeader);
    br = new BackendRequest(this.authToken, this.id);
    br.getIngredientList().then((list){
      this.ing.addAll(list);
    });
    print("L" + ing.length.toString());
    n1 = rn.nextInt(ing.length - 1);
    n2 = rn.nextInt(ing.length - 1);
    this.ing1 = ing[n1];
    this.ing2 = ing[n2];
    this.kw1 = ing1.name;
    print(ing.length.toString());
    this.kw2 = ing2.name;
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Inspiration"),
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            Container(
                child: FlatButton(
              child: Text(kw1),
              onPressed: () {
                setState(() {
                  //text = (iList[n1]);
                  kwList.add(kw1);
                  ing.removeAt(n1);
                  n1 = rn.nextInt(ing.length - 1);
                });
              },
            )),
            Container(
                child: FlatButton(
              child: Text(kw2),
              onPressed: () {
                setState(() {
                  //text = (cList[n2]);
                  kwList.add(kw2);
                  ing.removeAt(n2);
                  n2 = rn.nextInt(ing.length - 1);
                });
              },
            )),
            Container(
               margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.00),
               height: 200,
              color: Colors.red,
              child: ListView.builder(
                  //scrollDirection: Axis.horizontal,
                  //shrinkWrap: true,

                  itemCount: kwList.length,
                  itemBuilder: (context, index) {
                    return Container(
                        color: Colors.red,
                        child: Wrap(
                          children: <Widget>[Text(kwList[index])],
                        ));
                  }),
            )
          ],
        )));
  }
}
