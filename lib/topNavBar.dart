import 'package:cookmate/profile.dart';
import 'package:cookmate/search.dart';
import 'package:cookmate/shoppingListPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cookmate/homePage.dart';

import 'calendar.dart';
//import 'favoriteRecipes.dart';

class TopNavBar extends StatelessWidget {
  const TopNavBar({
    Key key,
  }) : super(key: key);

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.redAccent,
      actions: [ Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home),
                color: Colors.white,
                iconSize: ScreenUtil.instance.setWidth(35.0),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                },
              ),
              IconButton(
                icon: Icon(Icons.search),
                color: Colors.white,
                iconSize: ScreenUtil.instance.setWidth(35.0),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchPage()));
                },
              ),
              IconButton(
                icon: Icon(Icons.shopping_cart),
                color: Colors.white,
                iconSize: ScreenUtil.instance.setWidth(35.0),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ShoppingListPage()));
                },
              ),
              IconButton(
                icon: Icon(Icons.calendar_today),
                color: Colors.white,
                iconSize: ScreenUtil.instance.setWidth(35.0),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyCalendar()));
                },
              ),
              IconButton(
                icon: Icon(Icons.menu),
                color: Colors.white,
                iconSize: ScreenUtil.instance.setWidth(35.0),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => UserProfile()
                  ));
                },
              ),
            ],
          ),]
    );
  }
}
