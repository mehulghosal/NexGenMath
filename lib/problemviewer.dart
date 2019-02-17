import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'api.dart';

class ProblemViewer extends StatefulWidget {
  String id;
  ProblemViewer({Key key, this.id}) : super(key: key);

  @override
  ProblemViewerState createState() => new ProblemViewerState(id: id);
}


class ProblemViewerState extends State<ProblemViewer> with AutomaticKeepAliveClientMixin<ProblemViewer> {
  final String id;
  String problem;
  final numText = TextEditingController();
  final denText = TextEditingController();


  @override
  bool get wantKeepAlive => true;

  // In the constructor, require a Todo
  ProblemViewerState({Key key, @required this.id}) : super();


  static String checkAns(String num, String den, String ans){
    int n = int.parse(num);
    int d = int.parse(den);

    List<String> s = ans.split("}");
    int numAns = int.parse(s[0].substring(1));
    int denAns = int.parse(s[1].substring(1));
    if (n == numAns && d == denAns){ //equal -- right ans
      return "Your answer is correct! Yay :)";
    }
    else if(n/numAns == d/denAns){//equal but not simplified
      return "Your answer is technically correct, but it is not fully simplified";
    }
    else{//not eqal - wrong
      return "Wrong answer, try again!";
    }
  }

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
            if(problem == null) {
              problem = snapshot.data.toString();
            }
            Map<String, dynamic> info = jsonDecode(problem);

            return new Scaffold(
              backgroundColor: Theme
                  .of(context)
                  .primaryColorLight,
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
                          controller: numText,
                          decoration: new InputDecoration(
                              labelText: "Enter The NUMERATOR for your solution"),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Container(
                        alignment: Alignment(0, -0.25),
                        child: TextField(
                          controller: denText,
                          decoration: new InputDecoration(
                              labelText: "Enter The DENOMINATOR for your solution"),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Container(
                          alignment: Alignment(0, 0),
                          child: MaterialButton(
                            color: Theme.of(context).buttonColor,
                            highlightColor: Theme.of(context).accentColor,
                            child: Text("Submit Answer"),
                            onPressed: () {
                              debugPrint(info['question']);
                              debugPrint(info['answer']); // In the Form "{NUM}{DENUM}"
                              debugPrint(info['solution']);
                              return showDialog(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    content: Text(checkAns(numText.text, denText.text, info['answer'])),
                                  );
                                }
                              );
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