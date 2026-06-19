import 'dart:async';
import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:peblo_story_buddy/models/story_state.dart';

class TTSService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;
  bool _isSpeaking = false;

  final _stateController = StreamController<StoryState>.broadcast();
  Stream<StoryState> get stateStream => _stateController.stream;

  TTSService() {
    _initializeTTS();
  }

  Future<void> _initializeTTS() async {
    try {
      await _flutterTts.setLanguage("en-IN");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setPitch(1.0);

      if (Platform.isIOS) {
        try {
          await _flutterTts.setIosAudioCategory(
            IosTextToSpeechAudioCategory.playback,
            [IosTextToSpeechAudioCategoryOptions.mixWithOthers], // Wrap in list
          );
        } catch (e) {
          print('iOS audio category setting failed: $e');
        }
      }

      _flutterTts.setStartHandler(() {
        _isSpeaking = true;
        _stateController.add(StoryState.playing);
      });

      _flutterTts.setCompletionHandler(() {
        _isSpeaking = false;
        _stateController.add(StoryState.quizReady);
      });

      _flutterTts.setErrorHandler((message) {
        _isSpeaking = false;
        _stateController.add(StoryState.error);
        print('TTS Error: $message');
      });

      _isInitialized = true;
    } catch (e) {
      print('TTS Initialization Error: $e');
      _stateController.add(StoryState.error);
    }
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await _initializeTTS();
    }

    if (_isSpeaking) {
      await stop();
    }

    try {
      _stateController.add(StoryState.loading);
      await _flutterTts.speak(text);
    } catch (e) {
      print('TTS Speak Error: $e');
      _stateController.add(StoryState.error);
    }
  }

  Future<void> stop() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
      _isSpeaking = false;
    }
  }

  Future<void> dispose() async {
    await _flutterTts.stop();
    await _stateController.close();
  }

  bool get isSpeaking => _isSpeaking;
}