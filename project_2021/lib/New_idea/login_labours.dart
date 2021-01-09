import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_2021/New_idea/signup_labours.dart';

import 'homepage_labour.dart';





class NavigationLabours extends StatefulWidget {
  @override
  _NavigationLaboursState createState() => _NavigationLaboursState();
}

class _NavigationLaboursState extends State<NavigationLabours> {
  
  bool isSigned = false;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.onAuthStateChanged.listen((useraccount) {
      if (useraccount != null) {
        setState(() {
          isSigned = true;
        });
      } else {
        setState(() {
          isSigned = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isSigned == false ? LoginLabour() : HomePageLabour(),
    );
  }
}



class LoginLabour extends StatefulWidget {
  @override
  _LoginLabourState createState() => _LoginLabourState();
}

class _LoginLabourState extends State<LoginLabour> {
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();

  loginlabour() {
    FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailcontroller.text, 
      password: passwordcontroller.text
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  controller: emailcontroller,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Enter your email',
                    labelText: 'E-mail',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, right: 20),
                child: TextFormField(
                  controller: passwordcontroller,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Enter your password',
                    labelText: 'Password',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
              onTap: () => loginlabour(),
              child: Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
                height: 20,
              ),
           Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Dont have an account?",
                ),
                SizedBox(width: 10),
                InkWell(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpLabour())),
                  child: Text(
                    "Register!",
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}