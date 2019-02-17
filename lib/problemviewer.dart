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
  bool right = false;
  final numText = TextEditingController();
  final denText = TextEditingController();


  @override
  bool get wantKeepAlive => true;

  // In the constructor, require a Todo
  ProblemViewerState({Key key, @required this.id}) : super();

  int sign(double x) {
    if(x < 0)
      return -1;
    return 1;
  }
//  3 question types: 1 is linear equation; 2 is len/width of matrix; 3 is det
  String checkAns(String num, String den, String ans, String questionType){
    int n = int.parse(num);
    int d = int.parse(den);

    List<String> s = ans.split("}");
    int numAns = int.parse(s[0].substring(1));
    int denAns = int.parse(s[1].substring(1));
    if (questionType!="cde3ga0zlmRWzPPyCFgV" && n == numAns && d == denAns){ //equal -- right ans
      right = true;
      return "Your answer is correct! Yay :)";
    }
    //only lin eq has simplifying
    else if(questionType=="w7N6Foj7vLd8q6l1j66R" && (numAns/denAns - n/d)<.0000001 && sign(n/d) == sign(numAns/denAns)){//equal but not simplified
      return "Your answer is technically correct, but it is not fully simplified";
    }
    else if(questionType=="cde3ga0zlmRWzPPyCFgV" && n == numAns){
      return "Your answer is correct! Yay :)";
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
            if (problem == null) {
              problem = snapshot.data.toString();
            }
            String a, b;
            if (id == "w7N6Foj7vLd8q6l1j66R") {
              a = "NUMERATOR";
              b = "DENOMINATOR";
            }
            else if(id == "vEpLFEDV9uvWcsCN3pQ4") {
              a = "LENGTH";
              b = "WIDTH";
            }
            else if(id == "cde3ga0zlmRWzPPyCFgV") {
              a = "DETERMINANT";
              b = null;
            }
            Map<String, dynamic> info = jsonDecode(problem);

              return new Scaffold(
                backgroundColor: Theme
                    .of(context)
                    .primaryColorLight,
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
                                labelText: "Enter The " + a + " for your solution"),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Container(
                          alignment: Alignment(0, -0.25),
                          child: TextField(
                            controller: denText,
                            decoration: new InputDecoration(
                                labelText: "Enter The " + b + " for your solution"),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Container(
                            alignment: Alignment(0, 0),
                            child: MaterialButton(
                              textColor: Theme
                                  .of(context)
                                  .primaryColorLight,
                              color: Theme
                                  .of(context)
                                  .buttonColor,
                              highlightColor: Theme
                                  .of(context)
                                  .accentColor,
                              child: Text("Submit Answer"),
                              onPressed: () {
                                debugPrint(info['question']);
                                debugPrint(
                                    info['answer']); // In the Form "{NUM}{DENUM}"
                                debugPrint(info['solution']);
                                return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(checkAns(
                                            numText.text, denText.text,
                                            info['answer'], this.id)),
                                      );
                                    }
                                );
                              },
                            )
                        ),
                        Container(
                          alignment: Alignment(0, 0.2),
                          child: MaterialButton(
                              color: Theme
                                  .of(context)
                                  .buttonColor,
                              textColor: Theme
                                  .of(context)
                                  .primaryColorLight,
                              highlightColor: Theme
                                  .of(context)
                                  .accentColor,
                              onPressed: () {
                                return showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                          content: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                                maxHeight: 200),
                                            child: WebView(
                                              initialUrl: info['solution'],
                                              javascriptMode: JavascriptMode
                                                  .unrestricted,
                                            ),
                                          )
                                      );
                                    }
                                );
                              },
                              child: Text("View Solution")
                          ),
                        ),
                        Container(
                          alignment: Alignment(0, 0.4),
                          child: MaterialButton(
                              color: Theme
                                  .of(context)
                                  .buttonColor,
                              textColor: Theme
                                  .of(context)
                                  .primaryColorLight,
                              highlightColor: Theme
                                  .of(context)
                                  .accentColor,
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProblemViewer(id: id),
                                  ),
                                );
                              },
                              child: Text("Get New Problem")
                          ),
                        )
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