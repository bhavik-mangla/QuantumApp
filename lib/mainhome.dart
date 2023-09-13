import 'package:flutter/material.dart';
import 'package:quantum_supreme/api/api.dart';
import 'package:quantum_supreme/pwdscreen.dart';
import 'package:quantum_supreme/txtscreen.dart';

import 'filesharing.dart';
import 'home.dart';
import 'login.dart';

class PasswordManager extends StatefulWidget {
  final String username; // Add the username parameter
  const PasswordManager({Key? key, required this.username}) : super(key: key);

  @override
  _PasswordManagerState createState() => _PasswordManagerState();
}

class _PasswordManagerState extends State<PasswordManager> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quantum Supreme"),
        actions: [
          // Logout button
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (BuildContext context) {
                  return MyHomePage();
                },
              ));
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          PasswordManagerScreen(widget.username),
          FileSharingScreen(username: widget.username),
          TextManagerScreen(widget.username),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (index) {
          setState(() {
            _currentPage = index;
            _pageController.jumpToPage(index);
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.vpn_key),
            label: 'Password Manager',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_file),
            label: 'File Sharing',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_fields),
            label: 'Text Sharing',
          ),
        ],
      ),
    );
  }
}
