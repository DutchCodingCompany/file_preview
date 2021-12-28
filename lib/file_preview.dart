import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:path/path.dart' show extension;

class FilePreview {
  static const MethodChannel _channel = const MethodChannel('file_preview');

  static Future<Widget> getThumbnail(String filePath) async {
    switch (extension(filePath.toLowerCase())) {
      case ".pdf":
        return await generatePDFPreview(filePath);
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
          return _defaultImage(filePath);
        }
    }
  }

  static Future generatePDFPreview(String filePath) async {
    try {
      final document = await PdfDocument.openFile(filePath);
      final page = await document.getPage(1);
      final image = await page.render(width: 80, height: 100);
      return image != null
          ? Image.memory(image.bytes)
          : _defaultImage(filePath);
    } catch (e) {
      return _defaultImage(filePath);
    }
  }

  static Image _defaultImage(String filePath) {
    return Image.network(
      "https://via.placeholder.com/80x100?text=${extension(filePath)}",
    );
  }
}
