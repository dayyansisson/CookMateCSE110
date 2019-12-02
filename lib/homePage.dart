import 'package:cookmate/util/backendRequest.dart';
import 'package:cookmate/util/cookmateStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'cookbook.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  BackendRequest request = BackendRequest("03740945581ed4d2c3b25a62e7b9064cd62971a4", 2);

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
                future: request.getPopularRecipes(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return CookmateStyle.loadingIcon("Loading popular...");
                    case ConnectionState.done:
                      return _displayPopular(snapshot.data);
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

  Widget _displayPopular (List<String> popular) {

    List<Widget> recipeList = List<Widget>();
    for(String recipeID in popular) {
      recipeList.add(
        _recipeCard(recipeID)
      );
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

  Widget _recipeCard (String recipeID) {

    return FutureBuilder(
      future: request.getRecipe(recipeID),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return SizedBox(
              width: 230,
              height: 230,
              child: Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            );
          case ConnectionState.done:
            return Padding(
              padding: EdgeInsets.all(0.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4.0, // has the effect of softening the shadow
                          
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

  //   return Scaffold(
  //     appBar: NavBar(title: "Home", hasReturn: false, isHome: true),
  //       body: Column(
  //         children: <Widget>[
  //           SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 20.0),
  //                   child: Text(
  //                     'Today Meals'.toUpperCase(),
  //                     style: TextStyle(
  //                       color: Colors.black,
  //                       fontSize: ScreenUtil.instance.setWidth(22.0),
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
  //                 Container(
  //                   height: ScreenUtil.instance.setWidth(250.0),
  //                   child: ListView.builder(
  //                     padding: const EdgeInsets.only(left: 16.0),
  //                     scrollDirection: Axis.horizontal,
  //                     itemBuilder: _buildItem,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: ScreenUtil.instance.setWidth(7.0),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 20.0),
  //                   child: Text(
  //                     'Your Favorites!'.toUpperCase(),
  //                     style: TextStyle(
  //                       color: Colors.black,
  //                       fontSize: ScreenUtil.instance.setWidth(22.0),
  //                       fontWeight: FontWeight.bold,
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: ScreenUtil.instance.setWidth(7.0),
  //                 ),
  //                 Container(
  //                   height: ScreenUtil.instance.setWidth(250.0),
  //                   child: ListView.builder(
  //                     padding: const EdgeInsets.only(left: 16.0),
  //                     scrollDirection: Axis.horizontal,
  //                     itemBuilder: (context, index) =>
  //                         _buildItem(context, index),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ));
  // }

  Widget _buildItem(Recipe recipe) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(ScreenUtil.instance.setWidth(10.0)),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              height: ScreenUtil.instance.setWidth(210.0),
              width: ScreenUtil.instance.setWidth(170.0),
              child: recipe.image
            ),
            Positioned(
              left: ScreenUtil.instance.setWidth(0.0),
              bottom: ScreenUtil.instance.setWidth(0.0),
              width: ScreenUtil.instance.setWidth(170.0),
              height: ScreenUtil.instance.setWidth(50.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black54, Colors.black54],
                  ),
                ),
              ),
            ),
            Positioned(
              left: ScreenUtil.instance.setWidth(40.0),
              bottom: ScreenUtil.instance.setWidth(10.0),
              child: Column(
                children: <Widget>[
                  Text(
                    recipe.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: ScreenUtil.instance.setWidth(17.0),
                    ),
                  ),
                  Text(
                    'subtitle',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: ScreenUtil.instance.setWidth(15.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
