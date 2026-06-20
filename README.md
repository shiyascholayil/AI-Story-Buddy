# AI Story Buddy 

A complete implementation of the **AI Story Buddy & Quiz Component** for the Peblo Flutter Developer Intern Challenge. This project demonstrates a kid-friendly storytelling experience with Text-to-Speech narration, interactive quiz mechanics, smooth animations, and data-driven UI rendering designed for young learners.

---

## Features

* AI Buddy character with expressive states
* Text-to-Speech story narration using Flutter TTS
* Loading and error handling for audio playback
* Automatic quiz reveal after narration completes
* Fully data-driven quiz rendering from JSON
* Dynamic support for any number of answer options
* Wrong-answer feedback with shake animation and haptic response
* Success celebration with confetti animation
* Smooth and responsive Flutter UI
* Optimized for mid-range Android devices

---

## Tech Stack

* Flutter
* Dart
* Riverpod
* flutter_tts
* Lottie
* Confetti
* Flutter Animate
* Google Fonts

---

## Demo video

[▶ Watch Demo Video](assets/video/demo-video.mp4)


---

## Architecture Highlights

* Provider-based state management
* Separation of UI, business logic, and services
* Data-driven quiz rendering from JSON
* Reusable widget architecture
* Robust audio state handling
* Graceful error and retry mechanisms
* Performance-focused implementation

---

## Project Structure

```text
lib/
├── models/
│   ├── quiz_model.dart
│   ├── quiz_model.g.dart
│   └── story_state.dart
│
├── providers/
│   ├── quiz_provider.dart
│   └── story_provider.dart
│
├── screens/
│   └── story_screen.dart
│
├── services/
│   ├── audio_cache_service.dart
│   └── tts_service.dart
│
├── utils/
│   ├── animations.dart
│   └── constants.dart
│
├── widgets/
│   ├── quiz_widget.dart
│   ├── buddy_character.dart
│   └── celebration_effects.dart
│
└── main.dart
```

---

## Story Content

```text
Once upon a time, a clever little robot named Pip lost his shiny blue gear in the Whispering Woods...
```

---

## Quiz JSON

```json
{
  "question": "What colour was Pip the Robot's lost gear?",
  "options": ["Red", "Green", "Blue", "Yellow"],
  "answer": "Blue"
}
```

The quiz UI is generated dynamically from JSON data, allowing future questions to contain different text and varying numbers of answer options without requiring UI changes.

---

## Application Flow

1. User opens the application.
2. AI Buddy and story card are displayed.
3. User taps **Read Me a Story**.
4. TTS narration begins.
5. Loading and playback states are handled.
6. Quiz appears automatically after narration completes.
7. Wrong answers trigger shake animation and haptic feedback.
8. Correct answers trigger confetti and success state.

## Installation

### Clone Repository

```bash
git clone https://github.com/shiyascholayil/ai-story-buddy.git
```

### Install Dependencies

```bash
flutter pub get
```

### Run Application

```bash
flutter run
```

---

## Future Enhancements

* Multiple story support
* AI-generated stories
* Voice selection options
* Story progress tracking
* Multi-language narration
* Personalized quiz generation
* Offline story downloads
* Achievement and reward system

---

## Author

**Shiyas Cholayil**

GitHub: https://github.com/shiyascholayil
