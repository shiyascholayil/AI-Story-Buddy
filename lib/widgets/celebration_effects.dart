import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class CelebrationEffects extends StatefulWidget {
  final bool isActive;

  const CelebrationEffects({
    Key? key,
    required this.isActive,
  }) : super(key: key);

  @override
  State<CelebrationEffects> createState() => _CelebrationEffectsState();
}

class _CelebrationEffectsState extends State<CelebrationEffects> {
  late ConfettiController _confettiController;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void didUpdateWidget(CelebrationEffects oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) return const SizedBox.shrink();

    return Stack(
      children: [
        ConfettiWidget(
          confettiController: _confettiController, // Required parameter
          blastDirectionality: BlastDirectionality.explosive,
          particleDrag: 0.05,
          emissionFrequency: 0.05,
          numberOfParticles: 20,
          gravity: 0.1,
          colors: const [
            Colors.red,
            Colors.blue,
            Colors.green,
            Colors.yellow,
            Colors.purple,
            Colors.orange,
            Colors.pink,
          ],
          strokeWidth: 2,
          strokeColor: Colors.white,
          shouldLoop: false,
        ),

        // Star bursts
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: widget.isActive ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.yellow.withValues(alpha: 0.3),
                      Colors.transparent,
                    ],
                    radius: 0.7,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Floating emojis
        if (widget.isActive)
          ...List.generate(8, (index) {
            return Positioned(
              left: _random.nextDouble() * MediaQuery.of(context).size.width,
              top: _random.nextDouble() * MediaQuery.of(context).size.height,
              child: _buildFloatingEmoji(),
            );
          }),
      ],
    );
  }

  Widget _buildFloatingEmoji() {
    const emojis = ['🌟', '⭐', '🎉', '🎊', '✨', '💫', '🎈', '🎁'];
    final emoji = emojis[_random.nextInt(emojis.length)];
    final size = 20 + _random.nextDouble() * 20;
    final duration = 1000 + _random.nextInt(2000);
    final delay = _random.nextInt(500);

    return AnimatedOpacity(
      opacity: 1.0,
      duration: Duration(milliseconds: duration),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: Duration(milliseconds: duration + delay),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(
          (_random.nextDouble() - 0.5) * 100,
          -_random.nextDouble() * 100,
          0,
        ),
        child: Text(
          emoji,
          style: TextStyle(
            fontSize: size,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}