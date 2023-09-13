import 'package:flutter/material.dart';

import 'api/api.dart';

class TextManagerScreen extends StatefulWidget {
  final String username; // Add the username parameter
  const TextManagerScreen(this.username, {Key? key}) : super(key: key);

  @override
  _TextManagerScreenState createState() => _TextManagerScreenState();
}

class _TextManagerScreenState extends State<TextManagerScreen> {
  final String type = "text";
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Map<String, String>> texts = []; // Initialize texts as an empty list

  TextEditingController textController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  Future<List<Map<String, String>>> fetchPasswords() async {
    return getPasswords(widget.username, type);
  }

  @override
  void initState() {
    super.initState();

    // Fetch passwords for the current user (widget.username)
    getPasswords(widget.username, type).then((result) {
      setState(() {
        texts = result;
      });
    });
  }

  void refreshPasswords() {
    // Fetch passwords for the current user (widget.username)
    getPasswords(widget.username, type).then((result) {
      setState(() {
        texts = result;
      });
    });
  }

  void _addPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Text"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: "Title",
                  border: OutlineInputBorder(),
                ),
                controller: titleController,
              ),
              SizedBox(height: 10),
              TextField(
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Text",
                  border: OutlineInputBorder(),
                ),
                controller: textController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final addedSitename = titleController.text;
                final addedPassword = textController.text;

                // Store the password on the server
                final success = await storePassword(
                    widget.username, addedSitename, addedPassword, type);

                if (success) {
                  // Password was successfully stored
                  refreshPasswords();

                  // Clear text fields and close dialog
                  textController.clear();
                  titleController.clear();
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
        TextEditingController(text: texts[index]["password"]);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Edit Text"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Text",
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
                    texts[index]["sitename"]!,
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
                          content: Text("Failed to update the text."),
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
          title: Text("Share Text"),
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
                          texts[index]["sitename"]!,
                          texts[index]["password"]!,
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
                          content: Text("Failed to share the text."),
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
                    widget.username, texts[index]["sitename"]!)) {
                  setState(() {
                    texts.removeAt(index);
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Failed to delete the texts."),
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
        title: Text("${widget.username}'s Texts"),
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
                      subtitle: Container(
                        child: Text(
                          passwords[index]["password"]!,
                          style: TextStyle(
                            fontFamily: "monospace",
                            fontSize: 15,
                          ),
                          maxLines: null,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey[300],
                        ),
                      ),
                      trailing: Transform.translate(
                        offset: Offset(-5, 10),
                        child: Wrap(
                          spacing: -10,
                          children: <Widget>[
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
