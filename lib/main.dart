import 'package:flutter/material.dart';
import 'login.dart';
import 'dashboard.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'NexGenMath',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'Roboto'
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => new Login(),
        '/dashboard': (_) => new Dashboard(),

      },
    );
  }
}