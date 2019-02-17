import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dashboard.dart';
import 'api.dart';
import 'lessons.dart';
import 'lesson.dart';
import 'problemviewer.dart';


abstract class ListItem {}
class HeadingItem implements ListItem {
  final String heading;
  HeadingItem(this.heading);
}

// A ListItem that contains data to display a message
class TopicItem implements ListItem {
  final String topicName;
  final String id;
  final int mastery;
  final int haveLearned;
  TopicItem(this.topicName, this.id, this.mastery, this.haveLearned);
}

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

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<String>(
        future: loadWidget(context, isInit),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if(!snapshot.hasData) {
            return new Scaffold(
              body: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: new CircularProgressIndicator(),
                  )
              ),
            );
          } else {
            List<ListItem> listItems = [];
            Map<String, dynamic> topics = jsonDecode(snapshot.data.toString());
            debugPrint(topics.keys.length.toString());

            listItems.add(new HeadingItem("Algebra"));
            debugPrint(topics["0"].keys.length.toString());
            topics["0"].keys.forEach((value) {
              listItems.add(new TopicItem(topics["0"][value]["name"], topics["0"][value]["id"], topics["0"][value]["mastery"], topics["0"][value]["haveAleadyLearned"]));
            });
            listItems.add(new HeadingItem("Trigonometry"));
            debugPrint(topics["1"].keys.length.toString());
            topics["1"].keys.forEach((value) {
              listItems.add(new TopicItem(topics["1"][value]["name"], topics["1"][value]["id"], topics["1"][value]["mastery"], topics["1"][value]["haveAleadyLearned"]));
            });
            listItems.add(new HeadingItem("Matricies"));
            debugPrint(topics["2"].keys.length.toString());
            topics["2"].keys.forEach((value) {
              listItems.add(new TopicItem(topics["2"][value]["name"], topics["2"][value]["id"], topics["2"][value]["mastery"], topics["2"][value]["haveAleadyLearned"]));
            });

            isInit = false;
            return new ListView.builder(
                itemCount: listItems.length,
                itemBuilder: (context, index) {
                  final item = listItems[index];
                  if (item is HeadingItem) {
                    return MaterialButton(
                      highlightColor: Theme.of(context).accentColor,
                      onPressed: (){

                      },
                      child: Text(
                        item.heading,
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline,
                      ),
                    );
                  }
                  else if(item is TopicItem) {
                    Icon rightIcon;
                    if(item.haveLearned == 0)
                      rightIcon = new Icon(Icons.indeterminate_check_box ,color: const Color(0xFF000000));
                    else if(item.mastery == 0)
                      rightIcon = new Icon(Icons.radio_button_unchecked ,color: const Color(0xFF000000));
                    else
                      rightIcon = new Icon(Icons.star ,color: const Color(0xFF000000));

                    String state;
                    if(item.haveLearned == 0) {
                      state = "Need to Learn";
                    }
                    else {
                      state = "Ready to Practice";
                    }
                    if(item.haveLearned == 1) {
                      return ListTile(
                          title: Text(item.topicName),
                          subtitle: Text(state),
                          trailing: rightIcon,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProblemViewer(id: item.id),
                              ),
                            );
                          }
                      );
                    }
                    else {
                      return new ListTile(
                            title: Text(item.topicName),
                            subtitle: Text(state),
                            trailing: rightIcon
                      );
                    }
                  }
                }
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
