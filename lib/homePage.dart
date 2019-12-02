import 'package:cookmate/util/backendRequest.dart';
import 'package:cookmate/util/cookmateStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cookmate/util/backendRequest.dart';

import 'cookbook.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  BackendRequest request = BackendRequest("03740945581ed4d2c3b25a62e7b9064cd62971a4", 2);
  Future<List<String>> _popularIDs;
  List<Future<Recipe>> _popularRecipes;

  @override
  void initState() {

    _popularRecipes = List<Future<Recipe>>();
    _popularIDs = request.getPopularRecipes();
    _popularIDs.then(
      (popular) {
        for(String recipeID in popular) {
          _popularRecipes.add(request.getRecipe(recipeID));
        }
      }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double defaultScreenWidth = 400.0;
    double defaultScreenHeight = 810.0;
    ScreenUtil.instance = ScreenUtil(
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: true,
    )..init(context);

    return Scaffold(
      appBar: NavBar(title: "Home", hasReturn: false, isHome: true),
      body: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10, left: 20),
                child: Text(
                  "Popular Today!",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: CookmateStyle.textGrey
                  ),
                ),
              ),
              FutureBuilder(
                future: _popularIDs,
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
            ]
          )
        ],
      ),
    );
  }

  Widget _displayPopular () {

    List<Widget> recipeList = List<Widget>();
    for(Future<Recipe> recipe in _popularRecipes) {
      recipeList.add(_buildItem(recipe));
    }

    return Container(
      height: 280,
      child: Column(
        children: <Widget> [
          Flexible(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: recipeList
            )
          ),
        ],
      ),
    );
  }

  Widget _buildItem (Future<Recipe> recipe) {

    return FutureBuilder(
      future: recipe,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return SizedBox(
              width: 240,
              height: 240,
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            );
          case ConnectionState.done:
            return Padding(
              padding: EdgeInsets.all(0.0),
              child: Stack(
                children: <Widget>[
                  FlatButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      print(snapshot.data.title);
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
                              image: NetworkImage(snapshot.data.imageURL)
                            ) 
                          ),
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
                            snapshot.data.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: CookmateStyle.textGrey,
                              fontWeight: FontWeight.w300,
                              fontSize: 16
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          default:
            return Text("error");
        }
      },
    );
  }
}