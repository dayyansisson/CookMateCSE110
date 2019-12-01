import 'package:cookmate/cookbook.dart';
import 'package:cookmate/util/backendRequest.dart';
import 'package:flutter/material.dart';
import 'package:cookmate/util/user.dart';
import 'dart:async';
import 'package:flutter/services.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  // TODO generate these maps with getDietList (), getCuisineList ()
  Map<String, bool> allergens = {
    'peanuts': true,
    'gluten': false,
  };

  Map<String, bool> diets = {
    'vegan': true,
    'vegetarian': false,
    'keto': false,
    'idk': false,
    'lowcarb': false,
  };

  Map<String, bool> cuisines = {
    
  };


  Future<String> _asyncUsernameInput(BuildContext context) async {
    String newUserName = '';
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
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
                    hintText: 'New Username'
                  ),
                  onChanged: (value) {
                    newUserName = value;
                  },
                )
              )
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
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter New Password'),
          content: new Column(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  autofocus: true,
                  obscureText: true,
                  decoration: new InputDecoration(
                    hintText: 'Current Password'
                  ),
                  onChanged: (value) {
                    currentPassword = value;
                  },
                )
              ),
              new Expanded(
                child: new TextField(
                  autofocus: true,
                  obscureText: true,
                  decoration: new InputDecoration(
                    hintText: 'New Password'
                  ),
                  onChanged: (value) {
                    newPassword = value;
                  },
                )
              )
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
      
      // GENERIC APPBAR 
      appBar: AppBar(
        title: Text("CookMate"),
        leading: IconButton(
          icon: Icon(Icons.home, semanticLabel: 'home',),
          onPressed: () {
            print('Home button');
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              semanticLabel: "search",
            ), 
            onPressed: () {
              print('Search button');
            },
          ),
        ],
      ),

      // MAIN BODY
      body: ListView(
        children: <Widget>[

          OutlineButton(
            padding: EdgeInsets.all(20.0),
            onPressed: (){
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
            onPressed: (){
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
            child:Container(
              height: 175,
              child: ListView(
                children: 
                  diets.keys.map((String key) {
                  return new CheckboxListTile(
                    dense: true,
                    title: new Text(key),
                    value: diets[key],
                    onChanged: (bool value) {
                      setState((){
                        print("changing diet: " + key);
                        diets[key]=value;
                      });
                    },
                  );
                }).toList(),
              )
            )
          )
        ],
      )
      
    );
  }

      
}