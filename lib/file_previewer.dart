import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' show extension;
import 'package:pdfx/pdfx.dart';

class FilePreview {
  static const MethodChannel _channel = MethodChannel('file_preview');

  /// Create a preview [Image] of a file from a given [filePath]. In case it's an image extension it will invoke the default flutter Image providers,
  /// in case its a pdf it will invoke the native pdf renderer. For iOS it will try to use the native previewer,
  /// which is the same preview you would see in the files app on iOS.
  static Future<Widget> getThumbnail(
    String filePath, {
    double? height,
    double? width,
    Widget? defaultImage,
  }) async {
    switch (extension(filePath.toLowerCase())) {
      case ".pdf":
        return await generatePDFPreview(
          filePath,
          height: height,
          width: width,
          defaultImage: defaultImage,
        );
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
          return defaultImage ?? _defaultImage;
        }
    }
  }

  /// Creates a file preview of a .pdf file of the given [filePath]. In case it cannot be properly rendered, invoke [_defaultImage] instead.
  static Future generatePDFPreview(
    String filePath, {
    double? height,
    double? width,
    Widget? defaultImage,
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
          : defaultImage ?? _defaultImage;
    } catch (e) {
      return defaultImage ?? _defaultImage;
    }
  }

  /// In case a file preview cannot be properly rendered, and no default image is provided show a placeholder image
  static Image get _defaultImage => Image.asset('assets/img.png');
}
