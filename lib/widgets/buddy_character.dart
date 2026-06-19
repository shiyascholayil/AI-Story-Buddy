import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/story_state.dart';

class BuddyCharacter extends StatelessWidget {
  final BuddyState state;
  final double size;

  const BuddyCharacter({
    Key? key,
    required this.state,
    this.size = 120,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: size,
      height: size,
      child: Stack(
        children: [
          _buildBuddyBody(),

          if (state == BuddyState.happy)
            _buildHappyAnimation(),
          if (state == BuddyState.sad)
            _buildSadAnimation(),
          if (state == BuddyState.thinking)
            _buildThinkingAnimation(),
        ],
      ),
    );
  }

  Widget _buildBuddyBody() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            _getBuddyColor().withOpacity(0.8),
            _getBuddyColor().withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _getBuddyColor().withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Eyes
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildEye(),
                const SizedBox(width: 20),
                _buildEye(),
              ],
            ),
            const SizedBox(height: 10),
            // Mouth
            _buildMouth(),
          ],
        ),
      ),
    );
  }

  Widget _buildEye() {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildMouth() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 30,
      height: _getMouthHeight(),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  double _getMouthHeight() {
    switch (state) {
      case BuddyState.happy:
        return 15; // Wide smile
      case BuddyState.sad:
        return 5; // Frown
      case BuddyState.listening:
        return 10; // Slight smile
      case BuddyState.thinking:
        return 8; // Thinking mouth
      default:
        return 8;
    }
  }

  Color _getBuddyColor() {
    switch (state) {
      case BuddyState.happy:
        return Colors.green;
      case BuddyState.sad:
        return Colors.red;
      case BuddyState.listening:
        return Colors.blue;
      case BuddyState.thinking:
        return Colors.orange;
      default:
        return Colors.purple;
    }
  }

  Widget _buildHappyAnimation() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.yellow.withOpacity(0.3),
              Colors.transparent,
            ],
            radius: 0.5,
          ),
        ),
      ),
    ).animate(
      onPlay: (controller) => controller.repeat(),
    ).scale(
      duration: 800.ms,
      begin: const Offset(1.0, 1.0),
      end: const Offset(1.2, 1.2),
    );
  }

  Widget _buildSadAnimation() {
    return Positioned(
      top: 10,
      right: 10,
      child: const Icon(
        Icons.cloud,
        color: Colors.grey,
        size: 30,
      ),
    ).animate(
      onPlay: (controller) => controller.repeat(),
    ).moveY(
      duration: 1000.ms,
      begin: 0,
      end: -20,
    );
  }

  Widget _buildThinkingAnimation() {
    return Positioned(
      top: -15,
      right: -15,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: const Icon(
          Icons.lightbulb,
          color: Colors.orange,
          size: 24,
        ),
      ),
    ).animate(
      onPlay: (controller) => controller.repeat(),
    ).scale(
      duration: 800.ms,
      begin: const Offset(1.0, 1.0),
      end: const Offset(1.2, 1.2),
    );
  }
}