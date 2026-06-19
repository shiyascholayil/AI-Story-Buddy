class AppConstants {
  static const String appName = 'Peblo Story Buddy';
  static const String defaultStory =
      "Once upon a time, a clever little robot named Pip lost his shiny blue gear in the Whispering Woods...";

  static const List<String> buddyEmojis = ['🤖', '🌟', '💫', '⭐'];

  static const Duration ttsTimeout = Duration(seconds: 30);
  static const int maxCacheSize = 10;
}

class QuizConstants {
  static const String defaultQuizJson = '''
    {
      "question": "What colour was Pip the Robot's lost gear?",
      "options": ["Red", "Green", "Blue", "Yellow"],
      "answer": "Blue"
    }
  ''';
}