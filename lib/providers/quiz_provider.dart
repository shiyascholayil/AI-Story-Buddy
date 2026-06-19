import 'package:flutter/material.dart';
import '../models/quiz_model.dart';

class QuizProvider extends ChangeNotifier {
  QuizModel? _quiz;
  String? _selectedOption;
  bool _isAnswered = false;
  bool _isCorrect = false;

  QuizModel? get quiz => _quiz;
  String? get selectedOption => _selectedOption;
  bool get isAnswered => _isAnswered;
  bool get isCorrect => _isCorrect;

  void loadQuiz(Map<String, dynamic> jsonData) {
    _quiz = QuizModel.fromJson(jsonData);
    _selectedOption = null;
    _isAnswered = false;
    _isCorrect = false;
    notifyListeners();
  }

  void selectOption(String option) {
    if (_isAnswered) return;

    _selectedOption = option;
    _isAnswered = true;
    _isCorrect = option == _quiz!.answer;

    notifyListeners();
  }

  void resetQuiz() {
    _selectedOption = null;
    _isAnswered = false;
    _isCorrect = false;
    notifyListeners();
  }

  Future<void> fetchNewQuiz() async {
    final json = {
      "question": "What colour was Pip the Robot's lost gear?",
      "options": ["Red", "Green", "Blue", "Yellow"],
      "answer": "Blue"
    };
    loadQuiz(json);
  }
}