import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_2021/collection_ref.dart';


class SignUpLabour extends StatefulWidget {
  @override
  _SignUpLabourState createState() => _SignUpLabourState();
}

class _SignUpLabourState extends State<SignUpLabour> {
  var usernamecontroller = TextEditingController();
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  var categorycontroller = TextEditingController();
  var phonenumbercontroller = TextEditingController();



  signuplabour() {
    FirebaseAuth.instance
    .createUserWithEmailAndPassword(
      email: emailcontroller.text, 
      password: passwordcontroller.text).then((signeduser) {
        labourcollection.doc(signeduser.user.uid).set({
          'username': usernamecontroller.text,
          'password': passwordcontroller.text,
          'email': emailcontroller.text,
          'category': categorycontroller.text,
          'phone': phonenumbercontroller.text,
          'uid': signeduser.user.uid,
        });
      });
      Navigator.pop(context);
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      body:  SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 100),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Registeration of labours",
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: emailcontroller,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      filled: true,
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      prefixIcon: Icon(Icons.email)),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: passwordcontroller,
                  obscureText: true,
                  decoration: InputDecoration(
                      filled: true,
                      labelText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      prefixIcon: Icon(Icons.lock)),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: usernamecontroller,
                  obscureText: true,
                  decoration: InputDecoration(
                      filled: true,
                      labelText: 'Username',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      prefixIcon: Icon(Icons.person)),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: categorycontroller,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      filled: true,
                      labelText: 'category',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      prefixIcon: Icon(Icons.email)),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: phonenumbercontroller,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      filled: true,
                      labelText: 'phone',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      prefixIcon: Icon(Icons.phone)),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () => signuplabour(),
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      'SignUp',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}