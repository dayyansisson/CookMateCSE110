import 'package:cookmate/util/backendRequest.dart';
//import 'package:cookmate/search.dart';
import 'package:flutter/material.dart';
import 'package:cookmate/inspirationPage.dart';
import 'package:cookmate/calendar.dart';
import 'package:cookmate/homePage.dart';


void main(){
  runApp(MaterialApp(
    title: 'Home',
    home: HomePage(),
  ));
}
class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }

}
class HomePageState extends State<HomePage> {
  String _authToken ="e27dc27ab455de7a3afa076e09e0eacff2b8eefb";
  int id = 6;
  BackendRequest br = new BackendRequest("e27dc27ab455de7a3afa076e09e0eacff2b8eefb", 6);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text("Calendar"),
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyCalendar( )));
                },
              ),
              ListTile(
                title: Text("Inspiration"),
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Inspiration(authToken: this._authToken, id: this.id,)));
                },
              ),
              ListTile(
                title: Text("Create User"),
                onTap: (){
                  setState(() {
                   /* br.createUser("Hatef.nabili@gmail.com", "hatef88" , "G0lPe3ar").then((id){
                      this.id = id;
                      print("id: " + this.id.toString());
                    });*/
                  });
                },
              ),
              ListTile(
                title: Text("Log in"),
                onTap: (){
                  setState(() {
                      BackendRequest.login("hatef88", "G0lPe3ar").then((_authToken){
                      this._authToken = _authToken;
                      this.br = new BackendRequest(this._authToken, id);
                      print("Token: " + _authToken);
                    });
                  });
                },
              ),

              /*ListTile(
                title: Text("Search"),
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                },
              )*/



            ],
          )
      )

    );
  }
}