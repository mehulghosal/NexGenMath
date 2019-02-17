import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'api.dart';

class ProblemViewer extends StatelessWidget {
  final String id;

  // In the constructor, require a Todo
  ProblemViewer({Key key, @required this.id}) : super();

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<String>(
        future: loadWidget(context),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (!snapshot.hasData) {
            return new Scaffold(
              appBar: AppBar(
                title: Text("Practice Problems"),
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
            return new Scaffold(
              backgroundColor: Theme.of(context).primaryColorLight,
              appBar: AppBar(
                title: Text("Practice - " + id),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Color(0xFFFFFFFFF)),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                ),
              ),
              body: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: new Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.all(16.0),
                          child: WebView(
                            initialUrl: info['question'],
                            javascriptMode: JavascriptMode.unrestricted,
                          ),
                        ),
                        Container(
                            alignment: Alignment(0, -0.5),
                            child: TextField(
                              decoration: new InputDecoration(labelText: "Enter The NUMERATOR for your solution"),
                              keyboardType: TextInputType.number,
                            ),
                        ),
                        Container(
                          alignment: Alignment(0, -0.25),
                          child: TextField(
                            decoration: new InputDecoration(labelText: "Enter The DENOMINATOR for your solution"),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Container(
                          alignment: Alignment(0, 0),
                          child: RaisedButton(
                            child: Text("Submit Answer"),
                            onPressed: () {
                              debugPrint(info['answer']); // In the Form "{NUM}{DENUM}"
                            },
                          )
                        ),
                      ]
                  ),
              ),
            );
          }
        });
  }

  @protected
  Future<String> loadWidget(BuildContext context) async {
    return API.getProblem(id);
  }

}