import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class FilePreview {
  static const MethodChannel _channel = const MethodChannel('file_preview');

  static Future<Image> getThumbnail(String filePath) async {
    final Uint8List byteList =
        await _channel.invokeMethod('getThumbnail', filePath);
    return Image.memory(byteList);
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
