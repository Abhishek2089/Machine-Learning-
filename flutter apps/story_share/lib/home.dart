import 'package:flutter/material.dart';
import 'package:story_share/page/notifications.dart';
import 'package:story_share/page/profile.dart';
import 'package:story_share/page/search.dart';
import 'package:story_share/page/tweets.dart';
import 'package:story_share/variable.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int page = 0;
  List pageoptions = [
    TweetsPage('uid'),
    Search(),
    Notifications(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageoptions[page],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            page = index;
          });
        },
        backgroundColor: Theme.of(context).primaryColorDark,
        selectedItemColor: Colors.lightBlue,
        unselectedItemColor: Colors.black,
        currentIndex: page,
        items: [
          BottomNavigationBarItem(icon: Icon(
            Icons.home,
          ),
          title: Text("Stories", style: mystyle(10),)),
          BottomNavigationBarItem(icon: Icon(
            Icons.search,
          ),
              title: Text("Search", style: mystyle(10),)),
          BottomNavigationBarItem(icon: Icon(
            Icons.notifications,
          ),
              title: Text("Notification", style: mystyle(10),)),
          BottomNavigationBarItem(icon: Icon(
            Icons.person,
          ),
              title: Text("Profile", style: mystyle(10),)),
        ],
      ),
    );
  }
}