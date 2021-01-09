import 'package:flutter/material.dart';

import 'navigation.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Story-Share',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff15202C),
        primaryColorDark: Color(0xff1B2939),
        iconTheme: IconThemeData(color: Color(0xff1CA1F1))
      ),
      home: NavigationPage(),
    );
  }
}

