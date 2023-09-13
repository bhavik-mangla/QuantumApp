import 'package:flutter/material.dart';
import 'package:quantum_supreme/api/api.dart';
import 'mainhome.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key})
      : super(key: key); // Use the 'key' parameter correctly

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // email and password
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      // body
      body: Center(
        child: Column(
          children: [
            // email
            TextField(
              controller: username,
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
              controller: password,
              decoration: InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // login button
            TextButton(
              onPressed: () async {
                if (username.text == "" || password.text == "") {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Please enter a username and password")));
                } else if (await loginUser(username.text, password.text)
                    .then((value) => value == true)) {
                  // navigate to home page
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PasswordManager(
                              username: username.text,
                            )),
                    (route) => false,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Invalid username or password")));
                }
              },
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
