import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'api.dart';

class Lesson extends StatelessWidget {
  // Declare a field that holds the Todo
  final String id;
  final String name;

  // In the constructor, require a Todo
  Lesson({Key key, @required this.id, @required this.name}) : super();

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<String>(
      future: loadWidget(context),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (!snapshot.hasData) {
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
            appBar: AppBar(
              title: Text(name),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Color(0xFFFFFFFFF)),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              ),
            ),
            body: Container(
              padding: EdgeInsets.all(16.0),
              child: WebView(
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
              ),
            ),
          );
        }
      }
     );
  }

  @protected
  Future<String> loadWidget(BuildContext context) async {
    return API.getLessonDetails(id);
  }
}
