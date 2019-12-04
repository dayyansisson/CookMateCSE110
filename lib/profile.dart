import 'package:cookmate/cookbook.dart' as CB;
import 'package:cookmate/util/cookmateStyle.dart';
import 'package:cookmate/util/backendRequest.dart';
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
    bool succes = await request.updateUsername(userInfo, newUserName);
    if (succes) {
      setState(() {
        userInfo = newUserName;
      });
    }
  }

  _updateUserDiet(int newDiet) async {
    bool success = await request.setDiet(newDiet);
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
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter New Username'),
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
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter New Password'),
          content: new Column(
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
          actions: <Widget>[
            FlatButton(
              child: Text('Update'),
              onPressed: () {
                _updatePassword(currentPassword, newPassword).then((value) {
                  if (value) {
                    print("succes changing password");
                  }
                });

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
        Icon(Icons.person_outline),
        SizedBox(width: 30.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Change Username"),
            Text("User Name: " + userInfo),
          ],
        )
      ],
    );
  }

  Widget _displayUSerDiet() {
    String currDiet;
    if (userDiet == -1) {
      currDiet = "No diet set";
    } else {
      currDiet = diets[userDiet - 1];
    }
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text("Current Diet: " + currDiet),
    );
  }

  Widget _displayDietList() {
    int dietKey = 0;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: DropdownButton(
        hint: Text("Choose a Diet"),
        onChanged: (value) {
          setState(() {
            userDiet = value;
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: NavBar(title: "Profile", titleSize: 25, isUserPrefs: true),

        // MAIN BODY
        body: ListView(
          children: <Widget>[
            OutlineButton(
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
                          return Text("Error: Not user info found");
                      }
                    })),
            OutlineButton(
              padding: EdgeInsets.all(20.0),
              onPressed: () {
                print("change Password");
                _asyncPasswordInput(context);
              },
              child: Row(
                children: <Widget>[
                  Icon(Icons.lock),
                  SizedBox(width: 30.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Change Password"),
                    ],
                  ),
                ],
              ),
            ),
            FutureBuilder(
                future: _dietList,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text("Loading Diet List");
                    case ConnectionState.done:
                      return _displayUSerDiet();
                    default:
                      return Text("Error: Diet list not available");
                  }
                }),
            FutureBuilder(
                future: _dietList,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text("Loading Diet List");
                    case ConnectionState.done:
                      return _displayDietList();
                    default:
                      return Text("Error: Diet List not available");
                  }
                }),
          ],
        ));
  }
}
