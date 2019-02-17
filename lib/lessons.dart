import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';
import 'dashboard.dart';
import 'api.dart';
import 'lesson.dart';

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
  final int cando;
  TopicItem(this.topicName, this.id, this.mastery, this.cando);
}

class Lessons extends StatefulWidget {
  @override
  Lessons({Key key}) : super(key: key);
  LessonState createState() => new LessonState();
  static LessonState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<LessonState>());
}

class LessonState extends State<Lessons> { //with AutomaticKeepAliveClientMixin<Lessons> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

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
      Dashboard.title = 'NexGenMath - Lessons';
      setState(() {
      });
    });
  }

  void refresh() {
    Dashboard.of(context).onPageChanged(0);
    build(context);
  }

  Future<void> _handleRefresh() {
    final Completer<void> completer = Completer<void>();
    Timer(const Duration(seconds: 1), () { completer.complete(); });
    return completer.future.then<void>((_) {
      Dashboard.of(context).onPageChanged(0);
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: const Text('Refresh complete'),
          action: SnackBarAction(
              label: 'RETRY',
              onPressed: () {
                _refreshIndicatorKey.currentState.show();
              }
          )
      ));
    });
  }



  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<String>(
        future: loadWidget(context, isInit),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if(!snapshot.hasData) {
            return new Scaffold(
              appBar: AppBar(
                title: Text(""),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Color(0xFFFFFFFFF)),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                ),
              ),
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
              listItems.add(new TopicItem(topics["0"][value]["name"], topics["0"][value]["id"], topics["0"][value]["mastery"], topics["0"][value]["haveDependencies"]));
            });
            listItems.add(new HeadingItem("Trigonometry"));
            debugPrint(topics["1"].keys.length.toString());
            topics["1"].keys.forEach((value) {
              listItems.add(new TopicItem(topics["1"][value]["name"], topics["1"][value]["id"], topics["1"][value]["mastery"], topics["1"][value]["haveDependencies"]));
            });
            listItems.add(new HeadingItem("Matricies"));
            debugPrint(topics["2"].keys.length.toString());
            topics["2"].keys.forEach((value) {
              listItems.add(new TopicItem(topics["2"][value]["name"], topics["2"][value]["id"], topics["2"][value]["mastery"], topics["2"][value]["haveDependencies"]));
            });

            isInit = false;
            return new RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _handleRefresh,
                child: ListView.builder(
                itemCount: listItems.length,
                itemBuilder: (context, index) {
                  final item = listItems[index];
                  if (item is HeadingItem) {
                    return ListTile(
                      title: Text(
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
                    if(item.cando == 0)
                      rightIcon = new Icon(Icons.indeterminate_check_box ,color: const Color(0xFF000000));
                    else if(item.mastery == 0)
                      rightIcon = new Icon(Icons.radio_button_unchecked ,color: const Color(0xFF000000));
                    else
                      rightIcon = new Icon(Icons.star ,color: const Color(0xFF000000));

                    String state;
                    if(item.cando == 0) {
                      state = "Need to Complete Prerequisites";
                    }
                    else if(item.mastery == 0){
                      state = "Ready to Learn!";
                    }
                    else if(item.mastery == 1){
                      state = "You Learned the Material! Do Some Practice Now!";
                    }
                    else if(item.mastery == 2){
                      state = "You're Proficient!";
                    }
                    else if(item.mastery == 3){
                      state = "You're a Master! Nice Job!";
                    }
                    if(item.cando == 1) {
                      return ListTile(
                          title: Text(item.topicName),
                          subtitle: Text(state),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Lesson(id: item.id, name: item.topicName),
                              ),
                            );
                          },
                          trailing: rightIcon
                      );
                    }
                    else {
                      return Container (
                          decoration: new BoxDecoration (
                              color: new Color(0xFFA8A8A8)
                          ),
                          child: new ListTile(
                            title: Text(item.topicName),
                            subtitle: Text(state),
                            trailing: rightIcon,
                          )
                      );
                    }
                  }
                }
            )
      );
      }}
            );
  }

  @protected
  Future<String> loadWidget(BuildContext context, bool isInit) async {
    debugPrint("executed " + (isInit?"for the first time":"again"));
    return API.getTopicsToLearn(prefs.getString("email"));
  }
}
