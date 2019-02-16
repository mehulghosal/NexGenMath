import 'package:flutter/material.dart';
import 'auth.dart';
import 'lessons.dart';
import 'home.dart';
import 'practice.dart';

class Dashboard extends StatefulWidget {
  static String title = 'NexGenMath';
  static DashboardState of(BuildContext context) => context.ancestorStateOfType(const TypeMatcher<DashboardState>());
  @override
  DashboardState createState() => new DashboardState();
}

class DashboardState extends State<Dashboard> {
  var auth = new Authentication();
  PageController _pageController;
  int _page = 1;
  @override
  void initState() {
    super.initState();
    _pageController = new PageController(
      initialPage: 1,
    );
  }
  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
  void navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
  }
  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  void onItemMenuPress(Choice item) {
    if (item.title == 'Log out') {
      auth.signOut(context);
    } else if (item.title == 'Settings') {
      onPageChanged(2);
      navigationTapped(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: new Text (
            Dashboard.title,
            style: new TextStyle(
              color: const Color(0xFFFFFFFF),
              fontSize: 28.0,
            ),
          ),
          actions: <Widget>[
            PopupMenuButton<Choice>(
              onSelected: onItemMenuPress,
              itemBuilder: (BuildContext context) {
                return const <Choice>[
                  const Choice(title: 'Log out', icon: Icons.exit_to_app),
                ].map((Choice choice) {
                  return PopupMenuItem<Choice>(
                      value: choice,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            choice.icon,
                            color: Colors.black,
                          ),
                          Container(
                            width: 10.0,
                          ),
                          Text(
                            choice.title,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ));
                }).toList();
              },
            ),
          ],
        ),
      ),
      body: new PageView(
        children: [
          new Practice(),
          new Home(),
          new Lessons(),
        ],
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
      ),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Theme.of(context).primaryColor,
        ),
        child: new BottomNavigationBar(
          onTap: navigationTapped,
          currentIndex: _page,
          items: [
            new BottomNavigationBarItem(
              icon: new Icon(
                Icons.import_contacts,
                color: const Color(0xFFFFFFFF),
              ),
              title: new Text(
                'Practice',
                style: new TextStyle(
                  color: const Color(0xFFFFFFFF),
                ),
              ),
            ),
            new BottomNavigationBarItem(
              icon: new Icon(
                Icons.home,
                color: const Color(0xFFFFFFFF),
              ),
              title: new Text(
                'Home',
                style: new TextStyle(
                  color: const Color(0xFFFFFFFF),
                ),
              ),
            ),
            new BottomNavigationBarItem(
                icon: new Icon(
                  Icons.school,
                  color: const Color(0xFFFFFFFF),
                ),
                title: new Text(
                  'Lessons',
                  style: new TextStyle(
                    color: const Color(0xFFFFFFFF),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});
  final String title;
  final IconData icon;
}