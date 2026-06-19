import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/story_provider.dart';
import 'providers/quiz_provider.dart';
import 'services/tts_service.dart';
import 'services/audio_cache_service.dart';
import 'screens/story_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final ttsService = TTSService();
  final audioCacheService = AudioCacheService(prefs);
  final storyProvider = StoryProvider(
    ttsService: ttsService,
    audioCacheService: audioCacheService,
  );
  final quizProvider = QuizProvider();

  await quizProvider.fetchNewQuiz();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<StoryProvider>.value(value: storyProvider),
        ChangeNotifierProvider<QuizProvider>.value(value: quizProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peblo Story Buddy',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Roboto',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C63FF),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 4,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const StoryScreen(),
    );
  }
}