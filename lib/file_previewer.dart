import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_previewer/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:path/path.dart' show extension;

class FilePreview {
  static const MethodChannel _channel = MethodChannel('file_preview');

  /// Create a preview [Image] of a file from a given [filePath]. In case it's an image extension it will invoke the default flutter Image providers,
  /// in case its a pdf it will invoke the native pdf renderer. For iOS it will try to use the native previewer,
  /// which is the same preview you would see in the files app on iOS.
  static Future<Widget> getThumbnail(
    String filePath, {
    double? height,
    double? width,
  }) async {
    switch (extension(filePath.toLowerCase())) {
      case ".pdf":
        return await generatePDFPreview(filePath, height: height, width: width);
      case ".jpg":
      case ".jpeg":
      case ".png":
      case ".gif":
        return Image.file(
          File(filePath),
          width: width,
          height: height,
        );
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

  /// Creates a file preview of a .pdf file of the given [filePath]. In case it cannot be properly rendered, invoke [_defaultImage] instead.
  static Future generatePDFPreview(
    String filePath, {
    double? height,
    double? width,
  }) async {
    try {
      final document = await PdfDocument.openFile(filePath);
      final page = await document.getPage(1);
      final image = await page.render(
        width: width ?? 80,
        height: height ?? 100,
      );
      return image != null
          ? Image.memory(image.bytes)
          : _defaultImage(filePath);
    } catch (e) {
      return _defaultImage(filePath);
    }
  }

  /// In case a file preview cannot be properly rendered, show a placeholder image with the extension in the center
  static Image _defaultImage(String filePath) {
    return Image.network(placeholderImageUrl(extension(filePath)));
  }
}
