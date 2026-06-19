import 'package:flutter/material.dart';
import '../models/story_state.dart';
import '../services/tts_service.dart';
import '../services/audio_cache_service.dart';

class StoryProvider extends ChangeNotifier {
  final TTSService _ttsService;
  final AudioCacheService _audioCacheService;

  StoryState _currentState = StoryState.idle;
  BuddyState _buddyState = BuddyState.idle;
  String _currentStory =
      "Once upon a time, a clever little robot named Pip lost his shiny blue gear in the Whispering Woods...";
  String? _errorMessage;

  StoryProvider({
    required TTSService ttsService,
    required AudioCacheService audioCacheService,
  }) : _ttsService = ttsService, _audioCacheService = audioCacheService {
    // Listen to TTS state changes
    _ttsService.stateStream.listen((state) {
      _currentState = state;
      _updateBuddyState(state);
      notifyListeners();
    });
  }

  StoryState get currentState => _currentState;
  BuddyState get buddyState => _buddyState;
  String get currentStory => _currentStory;
  String? get errorMessage => _errorMessage;

  void _updateBuddyState(StoryState state) {
    switch (state) {
      case StoryState.idle:
        _buddyState = BuddyState.idle;
        break;
      case StoryState.loading:
        _buddyState = BuddyState.thinking;
        break;
      case StoryState.playing:
        _buddyState = BuddyState.listening;
        break;
      case StoryState.quizReady:
        _buddyState = BuddyState.thinking;
        break;
      case StoryState.quizActive:
        _buddyState = BuddyState.thinking;
        break;
      case StoryState.quizSuccess:
        _buddyState = BuddyState.happy;
        break;
      case StoryState.quizFailure:
        _buddyState = BuddyState.sad;
        break;
      case StoryState.error:
        _buddyState = BuddyState.idle;
        break;
    }
  }

  Future<void> readStory() async {
    _errorMessage = null;

    final hasNetwork = await _audioCacheService.hasNetwork();
    if (!hasNetwork) {
      _currentState = StoryState.error;
      _errorMessage = "Please check your internet connection! 🌐";
      notifyListeners();
      return;
    }

    try {
      final audioId = 'story_1';
      final isCached = await _audioCacheService.isAudioCached(audioId);

      if (isCached) {

        await _ttsService.speak(_currentStory);
      } else {

        await _ttsService.speak(_currentStory);

      }
    } catch (e) {
      _currentState = StoryState.error;
      _errorMessage = "Oops! Something went wrong. Let's try again! 🎮";
      notifyListeners();
    }
  }

  void resetStory() {
    _currentState = StoryState.idle;
    _buddyState = BuddyState.idle;
    _errorMessage = null;
    _ttsService.stop();
    notifyListeners();
  }

  void handleQuizSuccess() {
    _currentState = StoryState.quizSuccess;
    _buddyState = BuddyState.happy;
    notifyListeners();
  }

  void handleQuizFailure() {
    _currentState = StoryState.quizFailure;
    _buddyState = BuddyState.sad;
    notifyListeners();
  }

  void resetQuizState() {
    _currentState = StoryState.quizActive;
    _buddyState = BuddyState.thinking;
    notifyListeners();
  }

  @override
  void dispose() {
    _ttsService.dispose();
    super.dispose();
  }
}