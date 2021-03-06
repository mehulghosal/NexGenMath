import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'api.dart';
import 'problemviewer.dart';
import 'dashboard.dart';
import 'lessons.dart';

class Lesson extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  
  // Declare a field that holds the Todo
  final String id;
  final String name;
  String email;


  // In the constructor, require a Todo
  Lesson({Key key, @required this.id, @required this.name}) : super();

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<String>(
      future: loadWidget(context),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (!snapshot.hasData) {

          return new Scaffold(
              backgroundColor: Theme.of(context).primaryColorLight,
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
        }
        else {
          Map<String, dynamic> info = jsonDecode(snapshot.data.toString());
          debugPrint(info.keys.length.toString());
          info.keys.forEach((a) {
            debugPrint(a);
          });
          String url = info['url'];
          debugPrint(url);
          // Use the Todo to create our UI
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColorLight,
              appBar: AppBar(
                title: Text(name),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Color(0xFFFFFFFFF)),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                ),
              ),
              body: new Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: WebView(
                        initialUrl: url,
                        javascriptMode: JavascriptMode.unrestricted,
                      ),
                    ),
                  ]
              ),
            bottomNavigationBar: BottomAppBar(
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(child: Text("Learn More"), onPressed: () {
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Comfirmation'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('You will be marking this lesson as completed.'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text('Ok'),
                              onPressed: () {
                                API.markAsDone(email, id);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );

                    },
                  ),
                  FlatButton(child: Text("Do Some Practice"), onPressed: () {
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Comfirmation'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('You will be marking this lesson as completed.'),
                                Text('The app will now take you to some practice problems.'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text('Ok'),
                              onPressed: () {
                                API.markAsDone(email, id);
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProblemViewer(id: id),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );

                  },),
                ],
              ),
            ),
          );
        }
      }
     );
  }

  @protected
  Future<String> loadWidget(BuildContext context) async {
    SharedPreferences.getInstance().then( (prefs) {
      email = prefs.getString("email");
    });
    return API.getLessonDetails(id);

  }
}
