import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';

class Practice extends StatefulWidget {
  @override
  PracticeState createState() => new PracticeState();
}

class PracticeState extends State<Practice> {
  SharedPreferences prefs;
  String name = '';
  double WIDTH = 160;
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
            color: Theme.of(context).splashColor ,
            alignment: Alignment(0, -.9),
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                MaterialButton(
                  color: Theme.of(context).primaryColorDark,
                  highlightColor: Theme.of(context).accentColor,
                  child: Text(
                    "Algebra",
                    style: TextStyle(
                      fontSize: 25,
                      color: Theme.of(context).primaryColorLight
                    ),
                  ),
                  minWidth: WIDTH,
                ),
                MaterialButton(
                  color: Theme.of(context).primaryColorDark ,
                  highlightColor: Theme.of(context).accentColor,
                  child: Text(
                    "Trigonometry",
                    style: TextStyle(
                        fontSize: 25,
                        color: Theme.of(context).primaryColorLight
                    ),
                  ),
                  minWidth: WIDTH,
                ),
                MaterialButton(
                  color: Theme.of(context).primaryColorDark ,
                  highlightColor: Theme.of(context).accentColor,
                  child: Text(
                    "Matrices",
                    style: TextStyle(
                        fontSize: 25,
                        color: Theme.of(context).primaryColorLight
                    ),
                  ),
                  minWidth: WIDTH,
                ),

              ],
            )
          )
//          Container(
//            alignment: Alignment(0, -.3),
//            child: Text(
//              'Lessons ' + name.split(' ')[0] + '!',
//              style: new TextStyle(
//                color: Colors.black,
//                fontSize: 30,
//              ),
//            ),
//          )
        ],
      ),
    );
  }
}
