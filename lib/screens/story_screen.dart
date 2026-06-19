import 'package:flutter/material.dart';
import 'package:peblo_story_buddy/widgets/%20quiz_widget.dart';
import 'package:provider/provider.dart';
import '../providers/story_provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/buddy_character.dart';
import '../widgets/celebration_effects.dart';
import '../models/story_state.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade50,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer2<StoryProvider, QuizProvider>(
            builder: (context, storyProvider, quizProvider, _) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeader(context),

                    const SizedBox(height: 12),

                    SizedBox(
                      height: 130,
                      child: BuddyCharacter(
                        state: storyProvider.buddyState,
                        size: 130,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _buildStoryControls(context, storyProvider),

                    const SizedBox(height: 12),

                    _buildStoryCard(context, storyProvider),

                    const SizedBox(height: 12),

                    Expanded(
                      child: _buildQuizSection(storyProvider, quizProvider),
                    ),

                    if (storyProvider.errorMessage != null)
                      _buildErrorStatus(storyProvider),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.auto_stories,
          color: Theme.of(context).primaryColor,
          size: 28,
        ),
        const SizedBox(width: 8),
        const Text(
          'Story Buddy',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6C63FF),
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            final storyProvider = Provider.of<StoryProvider>(context, listen: false);
            final quizProvider = Provider.of<QuizProvider>(context, listen: false);
            storyProvider.resetStory();
            quizProvider.resetQuiz();
            quizProvider.fetchNewQuiz();
          },
          icon: const Icon(Icons.refresh),
          tooltip: 'Reset Story',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildStoryControls(BuildContext context, StoryProvider storyProvider) {
    final state = storyProvider.currentState;
    final isPlaying = state == StoryState.playing;
    final isLoading = state == StoryState.loading;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: isLoading ? null : () => storyProvider.readStory(),
          icon: isLoading
              ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
              : Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          label: Text(
            isLoading
                ? 'Loading...'
                : isPlaying
                ? 'Pause'
                : 'Read Me a Story',
            style: const TextStyle(fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            backgroundColor: isLoading
                ? Colors.grey
                : (isPlaying ? Colors.orange : const Color(0xFF6C63FF)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 4,
            minimumSize: const Size(200, 48),
          ),
        ),
        const SizedBox(width: 12),
        if (isPlaying)
          IconButton(
            onPressed: () => storyProvider.resetStory(),
            icon: const Icon(Icons.stop),
            color: Colors.red,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
      ],
    );
  }

  Widget _buildStoryCard(BuildContext context, StoryProvider storyProvider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.format_quote,
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                storyProvider.currentStory,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: Colors.black87,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizSection(StoryProvider storyProvider, QuizProvider quizProvider) {
    final state = storyProvider.currentState;

    if (state == StoryState.quizReady ||
        state == StoryState.quizActive ||
        state == StoryState.quizSuccess ||
        state == StoryState.quizFailure) {

      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state == StoryState.quizSuccess)
              const CelebrationEffects(isActive: true),

            QuizWidget(
              quizProvider: quizProvider,
              storyProvider: storyProvider,
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildErrorStatus(StoryProvider storyProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              storyProvider.errorMessage ?? 'Something went wrong',
              style: const TextStyle(color: Colors.red, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: () => storyProvider.readStory(),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
            ),
            child: const Text('Retry', style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}