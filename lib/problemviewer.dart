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
    return Scaffold(
      appBar: AppBar(
        title: Text('Sample Code'),
      ),
      body: Center(
        child: Text('Welcome to viewing problems for ' + id.toString()),
      ),
    );
  }

}