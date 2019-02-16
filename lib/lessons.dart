import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dashboard.dart';
import 'api.dart';

class Lessons extends StatefulWidget {
  @override
  Lessons({Key key}) : super(key: key);
  LessonState createState() => new LessonState();
}

class LessonState extends State<Lessons> with AutomaticKeepAliveClientMixin<Lessons> {
  SharedPreferences prefs;
  String name = '';
  bool isInit = false;
  Future<String> data;
  String knownData;

  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    isInit = true;
    super.initState();
    _readLocal();
  }

  void _readLocal() {
    SharedPreferences.getInstance().then( (yes) {
      prefs = yes;
      name = prefs.getString('name') ?? '';
      Dashboard.title = 'NexGenMath';
      setState(() {
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<String>(
        future: loadWidget(context, isInit),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if(!snapshot.hasData) {
            return new Text("awaiting result");
          } else {
              String toPrint = snapshot.data.toString();
              knownData = toPrint;
              isInit = false;
              return new Scaffold(
                backgroundColor: Theme
                    .of(context)
                    .primaryColorLight,
                body: new Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment(0, -.3),
                      child: Text(
                        'Lessons ' + name.split(' ')[0] + ' ' + toPrint.toString() + '!',
                        style: new TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                        ),
                      ),
                    )
                  ],
                ),
              );
          }
        });
  }

  @protected
  Future<String> loadWidget(BuildContext context, bool isInit) async {
    debugPrint("executed " + (isInit?"for the first time":"again"));
    return API.getTopicsToLearn(prefs.getString("email"));
  }
}
