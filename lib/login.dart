
import 'package:cookmate/homePage.dart';

import 'createAccount.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './util/backendRequest.dart';
import './util/localStorage.dart';
import 'package:flushbar/flushbar.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
  
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _username, _password, _token;

  



  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      
      Future<String> potentialToken = BackendRequest.login(_username, _password);
      potentialToken.then((token) {
        LocStorage.storeAuthToken(token);
        _token = token;
        if( _token != null && _token != "Unable to log in with provided credentials.") { 
          Future<int> userId = BackendRequest.getUser(_token);
          userId.then((id) {
            LocStorage.storeUserID(id);
          });
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        }
        else{ 
          _formKey.currentState.reset();
          Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            flushbarStyle: FlushbarStyle.GROUNDED,
            borderWidth: 40,
            messageText: Text('Unable to log in with provided credentials.',
            textAlign: TextAlign.center, 
            style: TextStyle(fontSize: 16, 
            fontWeight: FontWeight.bold, color: Colors.white),) ,
            backgroundColor: Colors.red[800],)..show(context);
        }
      });
    }
  }


  Widget _buildUsernameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Username',
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration:  BoxDecoration(
            color: Colors.red[100],
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextFormField(
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15.0),
                /*
                prefixIcon: Icon(
                  Icons.supervised_user_circle,
                  color: Colors.white,
                ),*/
                hintText: 'Enter your Username',
                hintStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
            ),

            validator: (input) => input.trim().isEmpty
                ? 'Please enter a valid username'
                : null,
            onSaved: (input) => _username = input,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(height: 10.0,),
        Container(
          alignment: Alignment.centerLeft,
          decoration:  BoxDecoration(
            color: Colors.red[100],
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextFormField(
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
                /*
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.white,
                ),*/
                hintText: 'Enter your Password',
                hintStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
            ),
            validator: (input) => input.length < 6
                ? 'Must be at least 6 characters'
                : null,
            onSaved: (input) => _password = input,
          ),
        ),
      ],
    );
  }

  

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          _submit();
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        color: Colors.red[800],
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
            )
          ),
        ),
      );
  }


  Widget _buildSignUpBtn() {
    return GestureDetector(
      onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreateAccountPage()),
      );
    },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account?',
              style: TextStyle(
                color: Colors.red[800],
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: ' Sign Up',
              style: TextStyle(
                color: Colors.red[800],
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),

      child: Stack(
        children: <Widget>[
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                      Color(0xF8F8FF),
                      Color(0xFFFFFF),
                      Color(0xFFFAFA),
                    ],
                    stops: [0.1, 0.4, 0.7],
              ),
            ),
          ),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 120.0,
              ),
              child:
              Form (
                key: _formKey,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 30.0,),
                  _buildUsernameTF(),
                  SizedBox(
                    height: 30.0,
                  ),
                  _buildPasswordTF(),
                  SizedBox(
                    height: 30.0,
                  ),
                  _buildLoginBtn(),
                  _buildSignUpBtn()

                ],
              ),
            ),
          ),
        ),
        ],
      ),

      ),
    ),
    );
  }
}


