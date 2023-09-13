import 'package:flutter/material.dart';
import 'package:quantum_supreme/signup.dart';

import 'login.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    //password manager app
    //user sign up/register/login

    return Scaffold(
      appBar: AppBar(
        title: Text('Quantum Supreme'),
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/images/a.png',
              width: 300,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                      onPressed: () {
                        //navigate to sign up page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()));
                      },
                      child: Text("Sign Up",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ))),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextButton(
                      onPressed: () {
                        //navigate to login page
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: Text("Log In",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ))),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Image.asset(
              'assets/images/img.png',
              width: 350,
            ),
          ],
        ),
      ),
    );
  }
}
