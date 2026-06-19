import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../providers/quiz_provider.dart';
import '../providers/story_provider.dart';
import 'dart:math';


class QuizWidget extends StatefulWidget {
  final QuizProvider quizProvider;
  final StoryProvider storyProvider;

  const QuizWidget({
    Key? key,
    required this.quizProvider,
    required this.storyProvider,
  }) : super(key: key);

  @override
  State<QuizWidget> createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  bool _isShaking = false;
  double _shakeOffset = 0;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _shakeController.addListener(() {
      setState(() {
        final double value = _shakeController.value;
        final double intensity = 10.0;
        _shakeOffset = sin(value * 2 * pi) * intensity * (1 - value);
      });
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quiz = widget.quizProvider.quiz;
    if (quiz == null) return const SizedBox.shrink();

    return Transform.translate(
      offset: Offset(_shakeOffset, 0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question
              Row(
                children: [
                  Icon(
                    Icons.quiz,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      quiz.question,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Options
              ...quiz.options.map((option) => _buildOption(option)),

              const SizedBox(height: 8),

              // Feedback
              if (widget.quizProvider.isAnswered)
                _buildFeedback(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(String option) {
    final isSelected = widget.quizProvider.selectedOption == option;
    final isCorrect = widget.quizProvider.isCorrect;
    final isAnswered = widget.quizProvider.isAnswered;

    Color? backgroundColor;
    Color? textColor = Colors.black;

    if (isAnswered && isSelected) {
      if (isCorrect) {
        backgroundColor = Colors.green;
        textColor = Colors.white;
      } else {
        backgroundColor = Colors.red;
        textColor = Colors.white;
      }
    } else if (isAnswered && option == widget.quizProvider.quiz!.answer) {
      backgroundColor = Colors.green.shade100;
    }

    return GestureDetector(
      onTap: isAnswered ? null : () => _onOptionTap(option),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (isCorrect ? Colors.green : Colors.red)
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: (isCorrect ? Colors.green : Colors.red).withValues(alpha: 0.3),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ]
              : null,
        ),
        child: Row(
          children: [
            if (isAnswered && isSelected)
              Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: Colors.white,
                size: 20,
              )
            else if (isAnswered && option == widget.quizProvider.quiz!.answer)
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 20,
              ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 16,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedback() {
    if (widget.quizProvider.isCorrect) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: const Row(
          children: [
            Icon(Icons.celebration, color: Colors.green),
            SizedBox(width: 8),
            Text(
              '🎉 Amazing job! You got it right!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: const Row(
          children: [
            Icon(Icons.refresh, color: Colors.red),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Oops! Try again! 🤔',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _onOptionTap(String option) {
    widget.quizProvider.selectOption(option);

    if (widget.quizProvider.isCorrect) {
      widget.storyProvider.handleQuizSuccess();

      HapticFeedback.mediumImpact();
    } else {
      _triggerShake();

      HapticFeedback.lightImpact();

      widget.storyProvider.handleQuizFailure();

      Future.delayed(const Duration(seconds: 1), () {
        widget.quizProvider.resetQuiz();
        widget.storyProvider.resetQuizState();
      });
    }
  }

  void _triggerShake() {
    if (_isShaking) return;

    setState(() {
      _isShaking = true;
    });

    _shakeController.reset();
    _shakeController.forward();

    _shakeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isShaking = false;
          _shakeOffset = 0;
        });
      }
    });
  }
}