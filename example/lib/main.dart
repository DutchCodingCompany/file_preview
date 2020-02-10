import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:file_preview/file_preview.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Image image;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              FlatButton(
                child: Text("Pick file"),
                onPressed: () async {
                  File file = await FilePicker.getFile();
                  final thumbnail = await FilePreview.getThumbnail(file.path);
                  print("got here");
                  setState(() {
                    image = thumbnail;
                  });
                },
              ),
              image != null ? image : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
