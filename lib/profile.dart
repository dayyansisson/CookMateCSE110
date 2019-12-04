import 'package:cookmate/cookbook.dart' as CB;
import 'package:cookmate/homePage.dart';
import 'package:cookmate/login.dart';
import 'package:cookmate/util/cookmateStyle.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:cookmate/util/database_helpers.dart';
import 'package:cookmate/util/localStorage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cookmate/util/localStorage.dart' as LS;

/*
  File: profile.dart
  Functionality: This page handles the user preferences page. It allows the user
  to change their username and password. It also allows the user to set their 
  preferred diet. It also allows for the user to logout which clears all the data
  that is stored locally.
*/

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // Backend request object
  BackendRequest request;

  // User info
  int userID;
  String token;
  int userDiet;

  // Future data for rendering
  Future<String> _userName;
  Future<List<CB.Diet>> _dietList;

  // Page data
  List<String> diets = new List<String>();
  String userInfo = "";
  List<DropdownMenuItem<int>> dietsDropDownList =
      new List<DropdownMenuItem<int>>();

  _initData() async {
    userID = await LS.LocalStorage.getUserID();
    token = await LS.LocalStorage.getAuthToken();
    userDiet = await LS.LocalStorage.getDiet();
    request = new BackendRequest(token, userID);
    _getUserProfile();
    _getDiets();
  }

  _getDiets() async {
    _dietList = request.getDietList();
    _dietList.then((currList) {
      setState(() {
        diets.add("None");
        for (int i = 0; i < currList.length; i++) {
          print("Diet: " +
              currList[i].name +
              " id: " +
              currList[i].id.toString());
          //diets[currList[i].id] = currList[i].name;
          diets.add(currList[i].name);
        }
      });
    });
  }

  _getUserProfile() async {
    _userName = request.getUserName(userID);
    _userName.then((value) {
      setState(() {
        userInfo = value;
      });
    });
  }

  _updateUserName(String newUserName) async {
    bool success = await request.updateUsername(userInfo, newUserName);
    if (success) {
      setState(() {
        userInfo = newUserName;
      });
    }
  }

  _updateUserDiet(int newDiet) async {
    bool success = false;
    if(newDiet == 0) {
      success = await request.clearDiet();
    } else {
      success = await request.setDiet(newDiet);
    }
    if (success) {
      setState(() {
        LS.LocalStorage.storeDiet(newDiet);
        userDiet = newDiet;
      });
    }
  }

  Future<bool> _updatePassword(String currPassword, String newPassword) async {

    print("Current Password: " + currPassword);
    print("New Password: " + newPassword);
    bool success = await request.updatePassword(currPassword, newPassword);
    if (success) {
      print("New Password was set");
    } else {
      print("Faile to set new Password");
    }
    return success;
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  Future<String> _asyncUsernameInput(BuildContext context) async {
    String newUserName = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          true, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter New Username'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(hintText: 'New Username'),
                onChanged: (value) {
                  newUserName = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Update'),
              onPressed: () {
                _updateUserName(newUserName);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: CookmateStyle.textGrey,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> _asyncPasswordInput(BuildContext context) async {
    String currentPassword = '';
    String newPassword = '';
    return showDialog<String>(
      context: context,
      barrierDismissible:
          true, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter New Password'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Container(
            height: 125,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                  autofocus: true,
                  obscureText: true,
                  decoration: new InputDecoration(hintText: 'Current Password'),
                  onChanged: (value) {
                    currentPassword = value;
                  },
                )),
                new Expanded(
                  child: new TextField(
                  autofocus: true,
                  obscureText: true,
                  decoration: new InputDecoration(hintText: 'New Password'),
                  onChanged: (value) {
                    newPassword = value;
                  },
                ))
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Update'),
              onPressed: () {
                _updatePassword(currentPassword, newPassword).then((value) {
                  if (value) {
                    print("Success changing password");
                  }
                });
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: CookmateStyle.textGrey,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _displayUserName() {
    return Row(
      children: <Widget>[
        Icon(
          Icons.person_outline,
          color: CookmateStyle.iconGrey,
        ),
        Padding(padding: EdgeInsets.only(left: 30)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Username",
              style: TextStyle(
                fontSize: 15
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 2)),
            Text(
              userInfo,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300
              ),
            ),
          ],
        ),
        Spacer(),
        Text(
          "Tap to change",
          style: TextStyle(
            fontWeight: FontWeight.w200
          ),
        ),
        Padding(padding: EdgeInsets.only(right: 50)),
      ],
    );
  }

  Widget _displayPassword() {

    return Row(
      children: <Widget>[
        Icon(
          Icons.lock,
          color: CookmateStyle.iconGrey,
        ),
        Padding(padding: EdgeInsets.only(left: 30)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Password",
              style: TextStyle(
                fontSize: 15
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 5)),
            Text(
              "******",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300
              ),
            ),
          ],
        ),
        Spacer(),
        Text(
          "Tap to change",
          style: TextStyle(
            fontWeight: FontWeight.w200
          ),
        ),
        Padding(padding: EdgeInsets.only(right: 50)),
      ],
    );
  }

  // Widget _displayUserDiet() {

  //   String currDiet;
  //   if (userDiet == -1) {
  //     currDiet = "No diet set";
  //   } else {
  //     currDiet = diets[userDiet - 1];
  //   }

  //   return Padding(
  //     padding: const EdgeInsets.all(20.0),
  //     child: Text("Current Diet: " + currDiet),
  //   );
  // }

  Widget _displayDietList() {

    int dietKey = 0;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: DropdownButton(
        hint: Row(
          children: <Widget> [
            Text(
              "Your Diet ",
            ),
            Padding(padding: EdgeInsets.only(left: 10)),
            Text(
              userDiet == -1 ? "None" : diets[userDiet],
              style: TextStyle(
                color: Colors.black,
                fontSize: 16
              ),
            ),
          ]
        ),
        onChanged: (value) {
          setState(() {
            userDiet = value - 1;
            _updateUserDiet(userDiet);
          });
        },
        isExpanded: true,
        iconSize: 35,
        items: diets.map<DropdownMenuItem<int>>((String value) {
          return DropdownMenuItem<int>(
            value: ++dietKey,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogoutBtn() {
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: 120,
      child: RaisedButton(
        elevation: 2,
        onPressed: () {
          request.logout();
          _clearLocal();
          Navigator.popUntil(context, ModalRoute.withName('/'));
          Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: CookmateStyle.standardRed,
        child: Text('LOGOUT',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          )
        ),
      ),
    );
  }

  _clearLocal () {

    LocalStorage.deleteAuthToken();
    LocalStorage.deleteDiet();
    LocalStorage.deleteUserID();
    DatabaseHelper database = DatabaseHelper.instance;
    database.clearShoppingList();
    database.clearCalendars();
    database.clearIngredients();
    database.clearRecipes();
    database.clearAllergens();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: NavBar(title: "Settings", titleSize: 22, isUserPrefs: true),
      // MAIN BODY
      body: Column(
        children: <Widget> [
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 20),
            child: Text(
              "Profile",
              style: TextStyle (
                fontWeight: FontWeight.w800,
                fontSize: 25,
                color: CookmateStyle.textGrey
              ),
            ),
          ),
          Flexible(
            child: ListView(
              children: <Widget>[
                OutlineButton(
                  borderSide: BorderSide(
                    width: 0.05,
                  ),
                  padding: EdgeInsets.all(20.0),
                  onPressed: () {
                    print("change username");
                    _asyncUsernameInput(context);
                  },
                  child: FutureBuilder(
                    future: _userName,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Text("Loading User Info");
                        case ConnectionState.done:
                          return _displayUserName();
                        default:
                          return Text("Finding user info...");
                      }
                    }
                  )
                ),
                OutlineButton(
                  borderSide: BorderSide(
                    width: 0.05
                  ),
                  padding: EdgeInsets.all(20.0),
                  onPressed: () {
                    print("change Password");
                    _asyncPasswordInput(context);
                  },
                  child: _displayPassword()
                ),
                FutureBuilder(
                  future: _dietList,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Center(child: Text("Loading Diet List")),
                        );
                      case ConnectionState.done:
                        return _displayDietList();
                      default:
                        return Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Center(child: Text("Looking for your diet")),
                        );
                    }
                  }
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildLogoutBtn()
                  ],
                )
              ],
            ),
          ),
        ]
      )
    );
  }
}