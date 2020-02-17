import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' show extension;
import 'package:pdf_previewer/pdf_previewer.dart';

class FilePreview {
  static const MethodChannel _channel = const MethodChannel('file_preview');

  static Future<Widget> getThumbnail(String filePath) async {
    if (Platform.isIOS) {
      final Uint8List byteList =
          await _channel.invokeMethod('getThumbnail', filePath);
      return Image.memory(byteList);
    } else {
      return await previewFactory(filePath);
    }
  }

  static Future<Image> previewFactory(String filePath) async {
    switch (extension(filePath)) {
      case ".pdf":
        final filePreview =
            await PdfPreviewer.getPagePreview(filePath: filePath);
        return Image.file(
          File(filePreview),
          fit: BoxFit.fitHeight,
        );
      case ".jpg":
      case ".jpeg":
      case ".png":
      case ".gif":
        return Image.file(File(filePath));
      default:
        return Image.network("https://via.placeholder.com/80x100?text=${extension(filePath)}");
    }
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
