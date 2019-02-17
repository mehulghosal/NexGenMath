import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dashboard.dart';
import 'api.dart';


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
              appBar: AppBar(
                title: Text(name),
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
            return new ListView.builder(
                itemCount: listItems.length,
                itemBuilder: (context, index) {
                  final item = listItems[index];
                  bool tapped = true;
                  if (item is HeadingItem) {
                    return MaterialButton(
                      onTap: (){
                        tapped = !tapped;
                      },
                      title: Text(
                        item.heading,
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline,
                      ),
                    );
                  }
                  else if(tapped == true && item is TopicItem) {
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
