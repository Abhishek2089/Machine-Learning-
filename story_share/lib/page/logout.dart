import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Logout extends StatefulWidget {
  @override
  _LogoutState createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  @override
  Widget build(BuildContext context) {

    Logout() {
      FirebaseAuth.instance.signOut();
    }

    return Scaffold(
      body: Center(
        child: InkWell(
          onTap: Logout(),
          child: Container(
            height: 50,
            width: 150,
            child: Text("Logout"),
            decoration: BoxDecoration(
              color: Colors.black26,
            ),
          ),
        ),
      ),
    );
  }
}
