# iStudy — Flutter app

A Grade 12 CAPS revision quiz app for **Life Sciences** and **Agricultural Sciences**,
covering MCQ quizzes (with explanations) and practical/memo questions, built from
your `life.json` and `agri.json` question banks (857 questions total).

This was written by hand outside of a Flutter environment, so it has **not** been
compiled or run yet. Follow the steps below on your own machine to get it going.

## Setup

You need the Flutter SDK installed (`flutter --version` should work). If not,
install it from flutter.dev first.

1. Create a fresh Flutter project shell (this generates the Android/iOS/web
   platform folders, which aren't included here):
   ```bash
   flutter create istudy_app
   cd istudy_app
   ```

2. Delete the generated `lib/main.dart` and copy in everything from this
   package's `lib/` folder (keep the same folder structure: `lib/models/`,
   `lib/data/`, `lib/screens/`).

3. Copy the `assets/` folder (containing `assets/data/life.json` and
   `assets/data/agri.json`) into the project root.

4. Replace the generated `pubspec.yaml` with the one in this package (or just
   add the `cupertino_icons`/`flutter_lints` dependencies and the `assets:`
   section to your existing one — see below).

5. Replace `analysis_options.yaml` with the one provided (optional, just lint config).

6. Fetch packages and run:
   ```bash
   flutter pub get
   flutter run
   ```

## Project structure

```
lib/
  main.dart                    # App entry point, theme
  models/
    models.dart                 # MCQ, PracticeQuestion, Topic, Paper, Subject
  data/
    data_repository.dart        # Loads + parses the bundled JSON once
  screens/
    home_screen.dart            # Subject picker (Life Sciences / Agric)
    paper_screen.dart           # Paper 1 / Paper 2 picker
    topic_screen.dart           # Topic list + mode picker (MCQ vs Practice)
    quiz_screen.dart            # MCQ flow: answer, see explanation, score
    quiz_result_screen.dart     # Final score screen
    practice_screen.dart        # Practical questions with "Show memo"
assets/
  data/
    life.json
    agri.json
```

## How it works

- `DataRepository` loads both JSON files once (cached after first load) and
  builds a `Subject -> Paper -> Topic -> [MCQ]/[Practice]` tree, using the
  same topic id/name mapping as the original web app's `index.ts`.
- MCQ quiz: questions are shuffled per session, one shown at a time. Tapping
  an option locks it in, highlights correct (green) / incorrect (red), and
  shows the explanation. Score is tallied and shown on a results screen at
  the end.
- Practice mode: shows each practical question with its subtopic and mark
  allocation; tapping "Show memo" reveals the full marking memo.

## Things worth checking once it's running

Since I couldn't compile this myself:
- Run `flutter analyze` first — it'll catch any typos/import issues immediately.
- If you used a different Flutter/Dart SDK version than the `environment:`
  range in `pubspec.yaml`, adjust that range.
- The accent colours (green for Life Sciences, amber for Agric) are set in
  `data_repository.dart` if you want to tweak the look.

## Adding more questions later

Just edit `assets/data/life.json` / `assets/data/agri.json` directly (same
format as the web app: `{"p1": {"topic-id": {"mcq": [...], "practice": [...]}}}`)
and hot-reload — no Dart code changes needed.
