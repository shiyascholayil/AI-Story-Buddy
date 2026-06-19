import 'package:flutter/material.dart';

class CustomAnimations {
  static Animation<double> shakeAnimation(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -10.0),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -10.0, end: 10.0),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 10.0, end: -10.0),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: -10.0, end: 10.0),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 10.0, end: 0.0),
        weight: 1,
      ),
    ]).animate(controller);
  }

  // Bounce animation for buddy
  static Animation<double> bounceAnimation(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.2),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.2, end: 0.8),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.8, end: 1.0),
        weight: 1,
      ),
    ]).animate(controller);
  }

  // Celebration animation
  static Animation<double> celebrationAnimation(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.5),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.5, end: 1.0),
        weight: 1,
      ),
    ]).animate(controller);
  }

  static Widget fadeTransition({
    required Widget child,
    required Animation<double> animation,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}