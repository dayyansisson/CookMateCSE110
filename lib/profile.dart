import 'package:cookmate/cookbook.dart';
import 'package:cookmate/util/cookmateStyle.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:cookmate/util/localStorage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class UserPreferences extends StatefulWidget {
  @override
  _UserPreferencesState createState() => _UserPreferencesState();
}

class _UserPreferencesState extends State<UserPreferences> {

  // User Data
  String token;
  int userID;
  String currentUsername;
  UserProfile user;
  Map<String, bool> allergens = {};
  Map<String, bool> diets = {};
  
  // Backend controller
  BackendRequest request;

  @override
  void initState() {
    _initData();
    super.initState();
  }

  _initData() async {
    token = await LocalStorage.getAuthToken();
    userID = await LocalStorage.getUserID();

    print("Token: " + token.toString());
    print("UserId: " +  userID.toString());

    request = BackendRequest(token, userID);
    user = await request.getUserProfile();
    //currentUsername = user.toString();
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
                // TODO backendrequest
                Future<bool> success = request.updateUsername(currentUsername, newUserName);
                success.then((result) {
                  if(!result){
                  // 
                  }
                  else{
                  // 
                  };
                });
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
                Future<bool> success = request.updatePassword(currentPassword, newPassword);
                success.then((result) {
                  if(!result){
                  // 
                  }
                  else{
                  // 
                  };
                });
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
                      Text("user.username (current)"), // TODO
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
                Padding(child: Text("Select Diet:"), padding: null,),
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
