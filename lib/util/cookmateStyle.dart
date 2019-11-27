import 'package:flutter/material.dart';

class CookmateStyle {

  static const Color textGrey = Color.fromRGBO(70, 70, 70, 1);
  static const Color iconGrey = Color.fromRGBO(180, 180, 180, 1);
  static const Color standardRed = Colors.redAccent;

  static final ThemeData theme = ThemeData(
    fontFamily: 'Lato',
    primaryColor: standardRed,
  );

  static Widget loadingIcon (String message) {
    return Center(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(
          strokeWidth: 2,
        ),
        Container(
          child: Text(
            message,
            style: TextStyle(
              fontWeight: FontWeight.w300
            ),
          ),
          padding: EdgeInsets.all(30)
        ),
      ],
    ));
  }
}