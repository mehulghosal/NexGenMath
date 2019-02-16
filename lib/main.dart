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
          primaryColor: const Color(0xFF4c5c68),
          primaryColorLight: const Color(0xFFdcdcdd),
          primaryColorDark: const Color(0xFF46494c),
          secondaryHeaderColor: const Color(0xFF46494c),
          buttonColor: const Color(0xFF46494c),
          errorColor: const Color(0xFFFFAD32),
          splashColor: const Color(0xFFc5c3c6),
          accentColor: const Color(0xFF1985a1),
          unselectedWidgetColor: const Color(0xFFEAEBF3),
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