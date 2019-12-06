import 'package:cookmate/login.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:cookmate/util/cookmateStyle.dart';
import 'package:cookmate/util/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'homePage.dart';

/*
  File: main.dart
  Functionality: This file runs the app. It launches the login page.
*/

main() {

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) {
      runApp(new MyApp());
    }
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CookmateStyle.theme,
      home: StartPage()
    );
  }
}

class StartPage extends StatelessWidget {

  Future<bool> _loginCheck(BuildContext context) async {
    //get the auth token and id from local storge
    String _auth = await LocalStorage.getAuthToken();
    if( _auth!= null) {
      int _id = await LocalStorage.getUserID();
      //geting the id according to the auth token from the backend
      BackendRequest backend = BackendRequest(_auth, null);
      int userID = await backend.getUser();
        //if do ids match then navigate to homepage automatically
        if (_id == userID) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
          return true;
        }
    }
    //naviage to login page
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
    return false;
  }

  @override
  Widget build(BuildContext context) {

    _loginCheck(context);

    return Scaffold(
      backgroundColor: CookmateStyle.standardRed,
      body: Container(
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black38)
          )
        )
      )
    );
  }
}