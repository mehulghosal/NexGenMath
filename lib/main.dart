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
          primaryColor: const Color(0xFF02BB9F),
          primaryColorLight: const Color(0xFFDCF3EF),
          primaryColorDark: const Color(0xFF167F67),
          secondaryHeaderColor: const Color(0xFF4302BB),
          buttonColor: const Color(0xFFCC6030),
          errorColor: const Color(0xFFFFAD32),
          accentColor: const Color(0xFF4E488B),
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