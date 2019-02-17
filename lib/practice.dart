import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'api.dart';

class Practice extends StatefulWidget {
  @override
  Practice({Key key}) : super(key: key);
  PracticeState createState() => new PracticeState();
}

class PracticeState extends State<Practice> with AutomaticKeepAliveClientMixin<Practice> {
  SharedPreferences prefs;
  String name = '';
  bool isInit = false;
  Future<String> data;
  String knownData;
  double WIDTH = 160;
  List<int> buttonState = [0, 0, 0];
  List<String> subjectData;

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

  List<String> getStr(){
    List<String> text = [];
    for(int i = 0; i<subjectData.length-1; i++){
      if(buttonState[i] % 2 == 0){
        text.add(subjectData[i]);
      }
      else{
        text.add("");
      }
    }
    return text;
  }

  Widget getWidgets(List<String> strings) {
    List<Widget> list = new List<Widget>();
    for(var i = 0; i < subjectData.length; i++){
      list.add(new Container(
                child:Text(strings[i])));
    }
//    return list
    return new Column(children: list);
  }

  void fillValues(String d){
    d = d.substring(1, d.length-4);

  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<String>(
        future: loadWidget(context, isInit),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (!snapshot.hasData) {
            return new Text("awaiting result");
          } else {
            String toPrint = snapshot.data.toString();
            knownData = toPrint;
            isInit = false;
            fillValues(knownData);

            return new Scaffold(
              backgroundColor: Theme
                  .of(context)
                  .primaryColorLight,
              body: new Stack(
                children: <Widget>[
                  Container(
                      color: Theme
                          .of(context)
                          .splashColor,
                      alignment: Alignment(0, -.9),
                      height: 100,
                      child: ListView(

                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          Container(

                              child: MaterialButton(
                                color: Theme
                                    .of(context)
                                    .primaryColorDark,
                                highlightColor: Theme
                                    .of(context)
                                    .accentColor,
                                splashColor: Theme
                                    .of(context)
                                    .accentColor,
                                onPressed: () {
                                  setState(() {
                                    buttonState[0] += 1;
                                  });
                                },
                                child: Text(
                                  "Algebra",
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Theme
                                          .of(context)
                                          .primaryColorLight
                                  ),
                                ),
                                minWidth: WIDTH,
                            )

                          ),
                          Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(width: 1.0, color: Color(0xFFa9a9aa)),
                                  right: BorderSide(width: 1.0, color: Color(0xFFa9a9aa)),
                                ),
                              ),

                              child: MaterialButton(
                                color: Theme
                                    .of(context)
                                    .primaryColorDark,
                                highlightColor: Theme
                                    .of(context)
                                    .accentColor,
                                splashColor: Theme
                                    .of(context)
                                    .accentColor,
                                onPressed: () {
                                  setState(() {
                                    buttonState[1] += 1;
                                  });
                                },
                                child: Text(
                                  "Trigonometry",
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Theme
                                          .of(context)
                                          .primaryColorLight
                                  ),
                                ),
                                minWidth: WIDTH,
                              )

                          ),
                          Container(

                              child: MaterialButton(
                                color: Theme
                                    .of(context)
                                    .primaryColorDark,
                                highlightColor: Theme
                                    .of(context)
                                    .accentColor,
                                splashColor: Theme
                                    .of(context)
                                    .accentColor,
                                onPressed: () {
                                  setState(() {
                                    buttonState[2] += 1;
                                  });
                                },
                                child: Text(
                                  "Matrices",
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: Theme
                                          .of(context)
                                          .primaryColorLight
                                  ),
                                ),
                                minWidth: WIDTH,
                              )

                          ),

                        ],
                      )
                  ),
                  getWidgets(getStr())
                ],
//                children.add(getWidgets(getStr()))
              ),
            );
          }
        });
  }
  @protected
  Future<String> loadWidget(BuildContext context, bool isInit) async {
    debugPrint("executed " + (isInit?"for the first time":"again"));
    return API.getTopicsToPractice(prefs.getString("email"));
  }
}
