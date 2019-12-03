import 'package:cookmate/cookbook.dart' as CB;
import 'package:cookmate/util/cookmateStyle.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:flutter/material.dart';
import 'package:cookmate/util/user.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:cookmate/util/localStorage.dart' as LS;

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // TODO generate these maps with getDietList (), getCuisineList ()

  // Backend request object
  BackendRequest request;

  // User info
  int userID;
  String token;
  String userDiet;
  int userName;

  // Page data
  List<CB.Diet> dietsList = new List<CB.Diet>();
  Map<String, bool> diets = new Map<String, bool>();
  String userInfo = "";

  Map<String, bool> allergens = {
    'peanuts': true,
    'gluten': false,
  };
//  Map<String, bool> diets = {
//    'vegan': true,
//    'vegetarian': false,
//    'keto': false,
//    'idk': false,
//    'lowcarb': false,
//  };
  _initData() async {
    userID = await LS.LocalStorage.getUserID();
    token = await LS.LocalStorage.getAuthToken();
    userDiet = await LS.LocalStorage.getDiet();
    userName = 2;
    request = new BackendRequest(token, userID);
    _getDiets();
    _getUserProfile();
  }
  _getDiets() async {
    print(request);
    dietsList = await request.getDietList();
    for(int i = 0; i < dietsList.length; i++){
      diets[dietsList[i].name] = false;
    }
    //diets.forEach((key, value) => print('$key'));
  }
  _getUserProfile() async {
    userInfo = await request.getUserName(userID);
  }

  Map<String, bool> cuisines = {};

  @override
  void initState(){
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
                decoration: new InputDecoration(
                    // TODO get (locally stored?) username of current user
                    // labelText: 'user.username' + '(current)';
                    hintText: 'New Username'),
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
                bool success = false;
                // TODO backendrequest
                /*
                bool success = BackendRequest.updateUsername(currentUsername, newUserName);
                if(!success){
                  // 
                }
                else{
                  // 
                };
                */
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
                // TODO backendrequest
                bool success = false;
                /*
                bool success = myBackendRequest.updatePassword(currentPassword, newPassword);
                if(!success){
                  // 
                }
                else{
                  // 
                };
                */
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
              child: Row(
                children: <Widget>[
                  Icon(Icons.person_outline),
                  SizedBox(width: 30.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Change Username"),
                      Text("user.username: "  + userInfo), // TODO
                    ],
                  ),
                ],
              ),
            ),
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
            Column(
              children: <Widget>[
                Text("Select Diet:"),
              ],
            ),
            Card(
                child: Container(
                    height: 175,
                    child: ListView(
                      children: diets.keys.map((String key) {
                        return new CheckboxListTile(
                          dense: true,
                          title: new Text(key),
                          value: diets[key],
                          onChanged: (bool value) {
                            setState(() {
                              print("changing diet: " + key);
                              diets[key] = value;
                            });
                          },
                        );
                      }).toList(),
                    )))
          ],
        ));
  }
}
