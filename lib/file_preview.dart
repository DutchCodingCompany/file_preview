import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' show extension;
import 'package:pdf_previewer/pdf_previewer.dart';

class FilePreview {
  static const MethodChannel _channel = const MethodChannel('file_preview');

  static Future<Widget> getThumbnail(String filePath) async {
    switch (extension(filePath)) {
      case ".pdf":
        final filePreview =
            await PdfPreviewer.getPagePreview(filePath: filePath);
        return imageWithBackground(filePreview);
      case ".jpg":
      case ".jpeg":
      case ".png":
      case ".gif":
        return Image.file(File(filePath));
      default:
        if (Platform.isIOS) {
          final Uint8List byteList =
              await _channel.invokeMethod('getThumbnail', filePath);
          return Image.memory(byteList);
        } else {
          return Image.network(
            "https://via.placeholder.com/80x100?text=${extension(filePath)}",
          );
        }
    }
  }

  static Widget imageWithBackground(String imagePath) {
    return Container(
      color: Colors.white,
      child: Image.file(
        File(imagePath),
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
