import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_2021/signup.dart';



class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> { 
  var passwordcontroller = TextEditingController();
  var emailcontroller = TextEditingController();


  loginContractors() {
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
              onTap: () => loginContractors(),
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
                      MaterialPageRoute(builder: (context) => SignUp())),
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