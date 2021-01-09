import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_2021/New_idea/first_page.dart';
import 'package:project_2021/workers_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "prototype-2021",
      theme: ThemeData.dark(),
      //home: Login(),
      initialRoute: '/',
      routes: {
        '/': (context) => Navigation(),
        CategoriesScreen.routeName: (context) => CategoriesScreen(),
      },
    );
  }
}

