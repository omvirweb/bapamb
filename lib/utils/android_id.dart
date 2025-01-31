import 'package:flutter/services.dart';

class AndroidId {
  static const MethodChannel _channel =
      MethodChannel('com.example.jewelbook_bapa/android_id');

  static Future<String?> getAndroidId() async {
    try {
      final String? androidId = await _channel.invokeMethod('getAndroidId');
      return androidId;
    } on PlatformException catch (e) {
      print("Failed to get ANDROID_ID: '${e.message}'.");
      return null;
    }
  }
}
