# PULSE

**Build your rhythm.**

<img width="1312" height="1199" alt="BBF49430-E3D6-4E84-AECC-857901B7F898" src="https://github.com/user-attachments/assets/cfaf0ea6-1dba-4eec-a4e4-e48d8bd741c9" />

---

A small, premium habit and daily-rhythm tracking app, built with Flutter and Firebase. Small app, premium execution — not a tutorial project, not a feature dump.

---

## Overview

PULSE helps you track a handful of daily habits, see your streaks, and understand your rhythm at a glance — on iOS, Android, macOS, and the web, from one Flutter codebase.

## Features

- Real Firebase Authentication (email/password)
- Real Firestore persistence, scoped per user with security rules
- Real streak and completion-rate calculations (unit tested)
- Daily rhythm score, weekly insights, weekly activity chart
- Add / edit / delete / complete habits
- Local + push notification reminders
- Firebase Analytics on key product events
- Light, Dark, and System themes
- Fully responsive: mobile bottom nav, desktop/web sidebar dashboard
- `PULSE AI` — a visual placeholder for a future real AI layer (static mock copy only, no LLM integration in this version)

## Tech Stack

| Layer | Choice |
|---|---|
| UI | Flutter (Material 3) |
| State/Nav | GetX |
| Auth | Firebase Authentication |
| Database | Cloud Firestore |
| Push | Firebase Cloud Messaging + flutter_local_notifications |
| Analytics | Firebase Analytics |
| Charts | fl_chart |

## Architecture

Feature-based, clean separation between UI, state, and data access:

```
lib/
├── core/          # theme, responsive system, routes, shared widgets, constants
├── features/      # auth, home, habits, insights, profile — each with
│                  # bindings/controllers/models/views/widgets
├── services/      # firebase/auth/firestore/notifications/analytics wrappers
└── main.dart
```

Controllers never call Firebase SDKs directly — everything goes through `services/`. Screens never hardcode styling — everything goes through `core/theme`.

## Firestore Structure

```
users/{userId}
  email, name, photoUrl, createdAt

users/{userId}/habits/{habitId}
  name, frequency, reminderTime, icon, createdAt, isActive

users/{userId}/habits/{habitId}/completions/{yyyy-MM-dd}
  completed, completedAt
```

Completions are a subcollection keyed by date — not an ever-growing array on the habit document — so streak queries stay cheap as history grows.

## Security Rules

See [`firestore.rules`](./firestore.rules). Users may only read/write their own `users/{uid}` document and everything beneath it; there is no cross-user access and no public read/write.

## Authentication

Email/password only in this MVP (no Google Sign-In yet — see Roadmap). Sessions persist across app restarts via Firebase's own persistence; auth state changes drive routing automatically.

## Streak Calculation

Implemented in `lib/features/habits/models/completion_stats.dart` as pure, framework-free Dart — no Firestore dependency — so it's fully unit tested in `test/unit/streak_test.dart`. Covers current streak, best streak, 7-day completion rate, and daily rhythm score.

## Notifications

`services/notifications/notification_service.dart` wraps Firebase Cloud Messaging (remote) and `flutter_local_notifications` (local, scheduled from each habit's own reminder time). PULSE does not send unsolicited notifications beyond what a habit's reminder is set to.

## Theme System

`core/theme/` centralizes color, typography, spacing, radius, and component themes for both Light and Dark mode. `ThemeController` (GetX) switches between Light / Dark / System at runtime.

## Responsive Design

`core/responsive/` defines breakpoints (mobile < 600, tablet < 1024, desktop < 1440, large desktop beyond) and a `ResponsiveLayout` widget used per-screen. Mobile gets a bottom nav and single-column layout; desktop/web get a persistent sidebar and multi-column dashboards, constrained to a comfortable max content width. The same business logic and Firebase-backed controllers drive every layout — there is no duplicated app underneath.

## PULSE AI (Visual Placeholder)

`core/widgets/pulse_ai_card.dart` renders a small card with static, locally-rotated mock copy (e.g. *"You're most consistent on weekdays."*). There is intentionally **no** OpenAI/Claude/Gemini/any LLM integration in this version — the component exists so a real AI backend can be dropped in later without redesigning the UI.

## Screenshots

_Add screenshots here once captured:_ Home / Habit Details / Insights / Profile in both Light and Dark mode, plus the macOS dashboard and desktop/tablet/mobile Web layouts.

## Firebase Setup

This repo intentionally ships **without** real Firebase credentials. To run it:

1. Create a Firebase project at console.firebase.google.com.
2. Enable **Authentication → Email/Password**.
3. Enable **Cloud Firestore** and deploy `firestore.rules`:
   ```
   firebase deploy --only firestore:rules
   ```
4. Install the FlutterFire CLI and generate real config:
   ```
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   This overwrites the placeholder `lib/services/firebase/firebase_options.dart` with your project's real, non-secret client config, and adds the platform-specific files (`google-services.json`, `GoogleService-Info.plist`) which are already git-ignored.
5. Enable Cloud Messaging and Analytics if you want notifications/analytics active.

## Local Installation

```
flutter pub get
flutter run
```

## Running on iOS / Android / macOS / Web

```
flutter run -d ios
flutter run -d android
flutter run -d macos
flutter run -d chrome
```

## Web Deployment

Build and deploy to Firebase Hosting:

```
flutter build web --release
firebase deploy --only hosting
```

## Testing

```
flutter test
```

Covers streak/best-streak/completion-rate/rhythm-score math and `HabitModel` (de)serialization.

## Roadmap

- Real PULSE AI (actual LLM-backed insights)
- Google Sign-In
- Advanced/recurring reminder rules
- Home screen widgets
- Apple Watch companion
- Deeper analytics
- Cloud Functions for server-side streak recompute
- Smart habit recommendations

## Screenshots 

<img width="1536" height="1024" alt="57347B47-9328-4DED-870E-8830974D8E8C" src="https://github.com/user-attachments/assets/044a67ce-0b9b-4f20-b019-4eaa42a7b043" />

---

<img width="1536" height="1024" alt="1C3FC01B-3D67-45AC-BDD6-EBB4E306CABF" src="https://github.com/user-attachments/assets/3f4981df-2eaa-4484-abef-a364b31d3f31" />

---

<img width="1536" height="1024" alt="485742D3-484B-4AF0-8BAC-C56BC9A7775D" src="https://github.com/user-attachments/assets/b3791855-ed02-4c04-8940-632843b7d28e" />


---






