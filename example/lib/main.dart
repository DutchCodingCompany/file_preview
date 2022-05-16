import 'package:file_picker/file_picker.dart';
import 'package:file_previewer/file_previewer.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget? image;
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
              TextButton(
                child: const Text("Pick file"),
                onPressed: () async {
                  FilePickerResult? file =
                      await FilePicker.platform.pickFiles();
                  try {
                    if (file != null) {
                      final thumbnail = await FilePreview.getThumbnail(
                        file.files.first.path!,
                      );
                      setState(() {
                        image = thumbnail;
                      });
                    }
                  } catch (e) {
                    image = Image.asset("");
                  }
                },
              ),
              image != null
                  ? Container(
                      width: 210,
                      height: 297,
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.white,
                      child: image,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
