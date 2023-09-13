import 'package:flutter/material.dart';
import 'package:quantum_supreme/api/api.dart';
import 'mainhome.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // email and password
  String username = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up Page"),
      ),
      // body
      body: Center(
        child: Column(
          children: [
            // email
            TextField(
              onChanged: (value) {
                username = value;
              },
              decoration: InputDecoration(
                hintText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // password
            TextField(
              onChanged: (value) {
                password = value;
              },
              decoration: InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // sign-up button
            TextButton(
              onPressed: () async {
                if (username == "" || password == "") {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please enter a username and password")));
                } else if (await registerUser(username, password)
                    .then((value) => value == true)) {
                  // navigate to home page
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PasswordManager(
                              username: username,
                            )),
                    (route) => false,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Username already exists")));
                }
              },
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
