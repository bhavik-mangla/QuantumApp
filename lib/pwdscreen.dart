import 'package:flutter/material.dart';

import 'api/api.dart';

class PasswordManagerScreen extends StatefulWidget {
  final String username; // Add the username parameter
  const PasswordManagerScreen(this.username, {Key? key}) : super(key: key);

  @override
  _PasswordManagerScreenState createState() => _PasswordManagerScreenState();
}

class _PasswordManagerScreenState extends State<PasswordManagerScreen> {
  final String type = "password";
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Map<String, String>> passwords =
      []; // Initialize passwords as an empty list

  TextEditingController passwordController = TextEditingController();
  TextEditingController sitenameController = TextEditingController();
  Future<List<Map<String, String>>> fetchPasswords() async {
    return getPasswords(widget.username, type);
  }

  @override
  void initState() {
    super.initState();

    // Fetch passwords for the current user (widget.username)
    getPasswords(widget.username, type).then((result) {
      setState(() {
        passwords = result;
      });
    });
  }

  void refreshPasswords() {
    // Fetch passwords for the current user (widget.username)
    getPasswords(widget.username, type).then((result) {
      setState(() {
        passwords = result;
      });
    });
  }

  void _addPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: "Sitename",
                  border: OutlineInputBorder(),
                ),
                controller: sitenameController,
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(),
                ),
                controller: passwordController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final addedSitename = sitenameController.text;
                final addedPassword = passwordController.text;

                // Store the password on the server
                final success = await storePassword(
                    widget.username, addedSitename, addedPassword, type);

                if (success) {
                  // Password was successfully stored
                  refreshPasswords();

                  // Clear text fields and close dialog
                  passwordController.clear();
                  sitenameController.clear();
                  Navigator.of(context).pop();
                } else {
                  // Handle the case when storing the password fails
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Failed to store the password."),
                    ),
                  );
                }
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _editPassword(int index) {
    TextEditingController newPasswordController =
        TextEditingController(text: passwords[index]["password"]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: "Password",
                  border: OutlineInputBorder(),
                ),
                controller: newPasswordController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newPasswordController.text != "") {
                  // Update the password on the server
                  updatePassword(
                    widget.username,
                    passwords[index]["sitename"]!,
                    newPasswordController.text,
                  ).then((success) {
                    if (success) {
                      // Password was successfully updated
                      refreshPasswords();

                      // Clear text fields and close dialog
                      newPasswordController.clear();
                      Navigator.of(context).pop();
                    } else {
                      // Handle the case when updating the password fails
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Failed to update the password."),
                        ),
                      );
                    }
                  });
                }
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void sharePassword(int index) {
    TextEditingController shareUsernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Share Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: "Username",
                  border: OutlineInputBorder(),
                ),
                controller: shareUsernameController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (shareUsernameController.text != "") {
                  // Update the password on the server
                  share_Password(
                          shareUsernameController.text,
                          widget.username,
                          passwords[index]["sitename"]!,
                          passwords[index]["password"]!,
                          type)
                      .then((success) {
                    if (success) {
                      // Password was successfully updated
                      refreshPasswords();

                      // Clear text fields and close dialog
                      shareUsernameController.clear();
                      Navigator.of(context).pop();
                    } else {
                      // Handle the case when updating the password fails
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Failed to share the password."),
                        ),
                      );
                    }
                  });
                }
              },
              child: Text("Share"),
            ),
          ],
        );
      },
    );
  }

  void _deletePassword(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this password?"),
          actions: [
            TextButton(
              onPressed: () async {
                if (await deletePassword(
                    widget.username, passwords[index]["sitename"]!)) {
                  setState(() {
                    passwords.removeAt(index);
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Failed to delete the password."),
                    ),
                  );
                }
              },
              child: Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.username}'s Passwords"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addPassword,
          ),
        ],
      ),
      body: Center(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            await fetchPasswords();
            _refreshIndicatorKey.currentState?.show();
          },
          child: FutureBuilder(
            future: fetchPasswords(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else {
                // Passwords are available, build the UI with ListView.builder
                final passwords = snapshot.data as List<Map<String, String>>;
                return ListView.builder(
                  itemCount: passwords.length,
                  itemBuilder: (context, index) {
                    // Build your list items here
                    return ListTile(
                      title: Text(passwords[index]["sitename"]!),
                      subtitle: Text(passwords[index]["password"]!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _editPassword(index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deletePassword(index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {
                              sharePassword(index);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addPassword();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
