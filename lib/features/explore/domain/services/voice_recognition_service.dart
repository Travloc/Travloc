import 'package:flutter/services.dart';

class VoiceRecognitionService {
  final MethodChannel _channel = const MethodChannel(
    'com.travloc/voice_recognition',
  );

  Future<void> startListening() async {
    try {
      await _channel.invokeMethod('startListening');
    } on PlatformException catch (e) {
      throw Exception('Failed to start voice recognition: ${e.message}');
    }
  }

  Future<String> stopListening() async {
    try {
      final result = await _channel.invokeMethod<String>('stopListening');
      return result ?? '';
    } on PlatformException catch (e) {
      throw Exception('Failed to stop voice recognition: ${e.message}');
    }
  }
}
