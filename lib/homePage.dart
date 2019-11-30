import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cookmate/search.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CookMate',
      theme: ThemeData(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double defaultScreenWidth = 400.0;
    double defaultScreenHeight = 810.0;
    ScreenUtil.instance = ScreenUtil(
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: true,
    )..init(context);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            ClipPath(
              //clipper: WaveClipper(),
              child: Container(
                height: ScreenUtil.instance.setWidth(180.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFB71C1C),
                      Color(0xFFE53935),
                      Color(0xFFD50000)
                    ],
                  ),
                ),
              ),
            ),
            Stack(
              children: <Widget>[
                Positioned(
                  top: ScreenUtil.instance.setWidth(25.0),
                  left: ScreenUtil.instance.setWidth(30.0),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.home),
                        color: Colors.white,

                        iconSize: ScreenUtil.instance.setWidth(50.0),
                        onPressed: () {
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: ScreenUtil.instance.setWidth(25.0),
                  left: ScreenUtil.instance.setWidth(120.0),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.search),
                        color: Colors.white,
                        tooltip: 'Action Tool Tip',
                        iconSize: ScreenUtil.instance.setWidth(50.0),
                        onPressed: () {
                          setState(() {
                            print("Inside search");
                             Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchPage()));
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: ScreenUtil.instance.setWidth(25.0),
                  left: ScreenUtil.instance.setWidth(210.0),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.shopping_cart),
                        color: Colors.white,
                        iconSize: ScreenUtil.instance.setWidth(50.0),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: ScreenUtil.instance.setWidth(25.0),
                  left: ScreenUtil.instance.setWidth(310.0),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.menu),
                        color: Colors.white,
                        iconSize: ScreenUtil.instance.setWidth(50.0),
                        onPressed: () {
                          print('Pressed');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Stack(
              children: <Widget>[
                Positioned(
                  top: ScreenUtil.instance.setWidth(90.0),
                  child: SizedBox(
                    height: ScreenUtil.instance.setWidth(10.0),
                    width: ScreenUtil.instance.setWidth(500.0),
                    child: Divider(
                      color: Colors.white,
                      thickness: ScreenUtil.instance.setWidth(1.5),
                    ),
                  ),
                ),
              ],
            ),
            Stack(
              children: <Widget>[
                Positioned(
                  top: ScreenUtil.instance.setWidth(100.0),
                  left: ScreenUtil.instance.setWidth(20.0),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'Today',
                          style: TextStyle(
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(5.0, 5.0),
                                  blurRadius: 15.0,
                                  color: Color.fromARGB(78, 79, 79, 79),
                                ),
                                Shadow(
                                  offset: Offset(5.0, 5.0),
                                  blurRadius: 5.0,
                                  color: Color.fromARGB(78, 79, 79, 79),
                                ),
                              ],
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil.instance.setWidth(25.0),
                              color: Colors.white),
                        ),
                        onPressed: () {
                          print("today");
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: ScreenUtil.instance.setWidth(100.0),
                  left: ScreenUtil.instance.setWidth(130.0),
                  child: Row(
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'Popular',
                          style: TextStyle(
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(5.0, 5.0),
                                  blurRadius: 15.0,
                                  color: Color.fromARGB(78, 79, 79, 79),
                                ),
                                Shadow(
                                  offset: Offset(5.0, 5.0),
                                  blurRadius: 5.0,
                                  color: Color.fromARGB(78, 79, 79, 79),
                                ),
                              ],
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil.instance.setWidth(25.0),
                              color: Colors.white),
                        ),
                        onPressed: () {
                          print("popular");
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: ScreenUtil.instance.setWidth(100.0),
                  left: ScreenUtil.instance.setWidth(265.0),
                  child: Row(children: <Widget>[
                    FlatButton(
                      child: Text(
                        'Favorite',
                        style: TextStyle(
                            shadows: <Shadow>[
                              Shadow(
                                offset: Offset(5.0, 5.0),
                                blurRadius: 15.0,
                                color: Color.fromARGB(78, 79, 79, 79),
                              ),
                              Shadow(
                                offset: Offset(5.0, 5.0),
                                blurRadius: 5.0,
                                color: Color.fromARGB(78, 79, 79, 79),
                              ),
                            ],
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil.instance.setWidth(25.0),
                            color: Colors.white),
                      ),
                      onPressed: () {
                        setState(() {
                          print("Favorite");
                        });

                      },
                    ),
                  ]),
                ),
              ],
            ),
            Stack(
              children: <Widget>[
                Positioned(
                  top: ScreenUtil.instance.setWidth(180.0),
                  left: ScreenUtil.instance.setWidth(325.0),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        color: Color(0xFFD50000),
                        iconSize: ScreenUtil.instance.setWidth(50.0),
                        onPressed: () {
                          print('Pressed');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
//
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: ScreenUtil.instance.setWidth(228.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Today Meals'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil.instance.setWidth(22.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil.instance.setWidth(10.0)),
                  Container(
                    height: ScreenUtil.instance.setWidth(250.0),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 16.0),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: _buildItem,
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil.instance.setWidth(7.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Popular Today !'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil.instance.setWidth(22.0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil.instance.setWidth(7.0),
                  ),
                  Container(
                    height: ScreenUtil.instance.setWidth(250.0),
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 16.0),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) =>
                          _buildItem(context, index),
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

  Widget _buildItem(BuildContext context, index) {
    String mealName;
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
              child: Image.network(
                  'https://previews.123rf.com/images/rawpixel/rawpixel1510/rawpixel151025608/47062607-food-table-celebration-delicious-party-meal-concept.jpg',
                  fit: BoxFit.cover),
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
              top: ScreenUtil.instance.setWidth(200.0),
              left: ScreenUtil.instance.setWidth(125.0),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.stars),
                    color: Colors.white,
                    iconSize: ScreenUtil.instance.setWidth(20.0),
                    onPressed: () {
                      print('Pressed');
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              left: ScreenUtil.instance.setWidth(40.0),
              bottom: ScreenUtil.instance.setWidth(10.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'MealName',
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
