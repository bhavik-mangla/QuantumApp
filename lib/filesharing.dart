import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quantum_supreme/api/api.dart';

class FileSharingScreen extends StatefulWidget {
  final String username;

  FileSharingScreen({required this.username});

  @override
  _FileSharingScreenState createState() => _FileSharingScreenState();
}

class _FileSharingScreenState extends State<FileSharingScreen> {
  File? selectedFile;
  final String type = 'file';
  Future<void> _pickFile() async {
    final filePicker = await FilePicker.platform.pickFiles();
    if (filePicker == null) return;

    final path = filePicker.files.single.path;
    final file = File(path!);

    setState(() {
      selectedFile = file;
    });
  }

  Future<void> _storeFile() async {
    if (selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a file first.")),
      );
      return;
    }

    final fileBytes = await selectedFile!.readAsBytes();
    final filename = selectedFile!.path.split('/').last; // Extract the filename

    // Convert fileBytes to a base64-encoded string
    final fileBase64 = base64Encode(fileBytes);
    print(fileBase64);

    final success =
        await storePassword(widget.username, filename, fileBase64, type);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File shared successfully.")),
      );
      setState(() {
        selectedFile = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to share the file.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.username + "'s Files",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await _pickFile();
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //get files
            // FutureBuilder(
            //   future: getFiles(widget.username, type),
            //   builder: (context, AsyncSnapshot<List<String>> snapshot) {
            //     if (snapshot.hasData) {
            //       return Expanded(
            //         child: ListView.builder(
            //           itemCount: snapshot.data!.length,
            //           itemBuilder: (context, index) {
            //             return ListTile(
            //               title: Text(snapshot.data![index]),
            //               onTap: () async {
            //                 final file = await getFile(
            //                     widget.username, snapshot.data![index], type);
            //                 if (file == null) {
            //                   ScaffoldMessenger.of(context).showSnackBar(
            //                     SnackBar(
            //                         content: Text("Failed to get the file.")),
            //                   );
            //                   return;
            //                 }
            //
            //                 final fileBytes = base64Decode(file);
            //                 final filename = snapshot.data![index];
            //
            //                 final directory =
            //                     await getExternalStorageDirectory();
            //                 final path = directory!.path + '/' + filename;
            //                 final newFile = File(path);
            //                 await newFile.writeAsBytes(fileBytes);
            //
            //                 ScaffoldMessenger.of(context).showSnackBar(
            //                   SnackBar(
            //                       content: Text("File downloaded to $path.")),
            //                 );
            //               },
            //             );
            //           },
            //         ),
            //       );
            //     } else {
            //       return CircularProgressIndicator();
            //     }
            //   },
            // ),
            ElevatedButton(
              onPressed: _pickFile,
              child: Text("Pick a File"),
            ),
            SizedBox(
              height: 10,
            ),
            //show file logo
            selectedFile != null
                ? Column(
                    children: [
                      Icon(
                        Icons.file_present,
                        size: 80,
                      ),
                      Text(
                        "Selected File: " + selectedFile!.path.split('/').last,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  )
                : Container(),

            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: _storeFile,
              child: Text("Store File"),
            ),
            ElevatedButton(
              onPressed: _storeFile,
              child: Text("Share File"),
            ),
          ],
        ),
      ),
    );
  }
}
