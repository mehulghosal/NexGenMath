import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'lessons.dart';
import 'practice.dart';

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
      backgroundColor: Theme.of(context).primaryColorLight,
      body: new Stack(
        children: <Widget>[
          Container(
            alignment: Alignment(0, -.6),
            child: new Text(
              'Hello ' + name.split(' ')[0] + '!',
              style: new TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 42,
              ),
            ),
          ),
          Container(
            alignment: Alignment(0, -.05),
//            START PRACTICING BUTTON
            child: MaterialButton(
              height: 60,
              minWidth: 230,
              color: Theme.of(context).buttonColor,
              highlightColor: Theme.of(context).accentColor,
              splashColor: Theme.of(context).accentColor,
              textColor: Theme.of(context).primaryColorLight,
              onPressed: () {
                DashboardState.navigationTapped(3)
//                Navigator.push(context, new MaterialPageRoute(builder: (context) => new Practice()));
              },
              child: Text(
                  'Start Practicing',
                  style: new TextStyle(
                    fontSize: 24
                  ),
              ),
            ),
          ),
          Container(
            alignment: Alignment(0, .23),
//            START PRACTICING BUTTON
            child: MaterialButton(
              height: 60,
              minWidth: 230,
              color: Theme.of(context).buttonColor,
              highlightColor: Theme.of(context).accentColor,
              splashColor: Theme.of(context).accentColor,
              textColor: Theme.of(context).primaryColorLight,
              onPressed: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => new Lessons()));
              },
              child: Text(
                'Next Lesson',
                style: new TextStyle(
                    fontSize: 24
                ),
              ),
            ),
          )

          ],
        ),
      );
  }
}
