import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {
  SharedPreferences prefs;
  String name = '';
  @override
  void initState() {
    super.initState();
    _readLocal();
  }
  void _readLocal() async {
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? '';
    Dashboard.title = 'NexGenMath';
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'Home ' + name.split(' ')[0] + '!',
              style: new TextStyle(
                color: Colors.black,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
