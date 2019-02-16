import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'auth.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => new LoginState();
}
class LoginState extends State<Login> {
  var auth = new Authentication();

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;

  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    _initFirestore();
    auth.isSignedIn(context);
  }
  void _initFirestore() async {
    await Firestore.instance.settings(timestampsInSnapshotsEnabled: true);
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: Stack (
        children: <Widget>[
          Container (
            alignment: Alignment(0.0, -0.65),
            child: Text (
              'NexGenMath',
              style: new TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 48.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            alignment: Alignment(0, .1),
            child: MaterialButton(
                onPressed: () => auth.signIn(context),
                child: Text(
                  'SIGN IN WITH GOOGLE',
                  style: TextStyle(fontSize: 14.0),
                ),
                color: Theme.of(context).buttonColor,
                highlightColor: Theme.of(context).accentColor,
                splashColor: Theme.of(context).accentColor,
                textColor: Theme.of(context).primaryColorLight,
                padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0)
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: auth.isLoading,
            builder: (context, value, child) {
              return Container (
                child: auth.isLoading.value
                    ? Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).errorColor),
                    ),
                  ),
                  color: Colors.white.withOpacity(0.8),
                ): Container(),
              );
            },
          ),
        ],
      ),
    );
  }
}
class User extends StatefulWidget {
  @override
  UserState createState() => new UserState();
}
class UserState extends State<User> {
  var auth = new Authentication();

  int option = -1;

  SharedPreferences prefs;
  String id = '';

  @override
  void initState() {
    super.initState();
    _readLocal();
  }
  void _readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
  }

  void addRole(int role) {
    if (role != -1) {
      setState(() {
        auth.isLoading.value = true;
      });
      Firestore.instance
          .collection('users')
          .document(id)
          .updateData({'role': role,}).then((data) async {
        await prefs.setInt('role', role);
        setState(() {
          auth.isLoading.value = false;
        });
      }).catchError((err) {
        setState(() {
          auth.isLoading.value = false;
        });
      });
      Navigator.of(context).pushReplacementNamed('/dashboard');
    }
  }
  int roleValue = -1;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack (
        children: <Widget>[
          Container (
            alignment: Alignment(0.0, -0.8),
            child: Text (
              'Welcome!',
              style: new TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 42.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text (
                'I am a...',
                style: new TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 24.0,
                ),
                textAlign: TextAlign.center,
              ),
              RadioListTile<int>(
                  title: new Text (
                    'Student',
                    style: new TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  value: 0,
                  groupValue: roleValue,
                  onChanged: (int value) {
                    setState(() => roleValue = value);
                  }),
              RadioListTile<int>(
                  title: new Text (
                    'Tutor',
                    style: new TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  value: 1,
                  groupValue: roleValue,
                  onChanged: (int value) {
                    setState(() => roleValue = value);
                  }),
              RadioListTile<int>(
                  title: new Text (
                    'Both',
                    style: new TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  value: 2,
                  groupValue: roleValue,
                  onChanged: (int value) {
                    setState(() => roleValue = value);
                  }),
            ],
          ),
          Container (
            alignment: Alignment(0.0, 0.7),
            child: ButtonTheme(
              minWidth: 150,
              child: RaisedButton(
                  onPressed: () => addRole(roleValue),
                  child: Text(
                    'Go!',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  color: Theme.of(context).accentColor,
                  splashColor: Colors.transparent,
                  textColor: Theme.of(context).primaryColorLight,
                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: auth.isLoading,
            builder: (context, value, child) {
              return Container (
                child: auth.isLoading.value
                    ? Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).errorColor),
                    ),
                  ),
                  color: Colors.white.withOpacity(0.8),
                ): Container(),
              );
            },
          ),
        ],
      ),
    );
  }
}