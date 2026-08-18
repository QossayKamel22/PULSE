# Architecture

## Layering

```
lib/
├── core/          # theme, responsive system, routes, shared widgets, constants
├── features/      # auth, home, habits, insights, profile — each with
│                  # bindings/controllers/models/views/widgets
├── services/      # firebase/auth/firestore/notifications/analytics wrappers
└── main.dart
```

Three rules hold across the codebase:

1. **Controllers never call Firebase SDKs directly.** Every Firebase interaction — auth, Firestore reads/writes, messaging, analytics — goes through a class in `services/`. A `HabitsController` calls `FirestoreService`; it never imports `cloud_firestore` itself. This keeps the Firebase surface area in one place and means the statistics/streak logic (`completion_stats.dart`) has zero Firebase dependency at all — it's pure Dart, fed plain data.
2. **Views never hardcode styling.** Colors, spacing, radii, and typography all come from `core/theme/`. A screen that needs a color asks `PulseColors`, not a literal hex value.
3. **One codebase, one logic layer, four platforms.** `core/responsive/` decides *layout* (bottom nav vs. sidebar, single vs. multi-column) per breakpoint, but the controllers and services beneath every layout are identical. There is no `lib/mobile/` vs `lib/desktop/` fork.

## State management & navigation

GetX (`get` package) is used for three things, deliberately not more:

- **Dependency injection** via `Bindings` (`AuthBinding`, `HabitsBinding`, `HomeBinding`) — each route wires up the controllers it needs.
- **Reactive state** via `.obs` / `Obx` — controllers expose observable fields (`status`, `errorMessage`, habit lists); views rebuild reactively.
- **Routing** via `GetMaterialApp` / named routes (`AppRoutes`, `AppPages`) — including redirect-style navigation driven by live auth state (see `AuthController.onInit`).

## Data flow (habit completion, as an example)

1. User taps a habit's completion toggle in `HabitTile`.
2. `HabitsController` calls `FirestoreService` to write/update the completion document at `users/{uid}/habits/{habitId}/completions/{yyyy-MM-dd}`.
3. Firestore's snapshot stream pushes the change back down; `HabitsController`'s observable habit/completion state updates.
4. `Obx`-wrapped widgets (home rhythm score, habit tile streak badge, insights chart) rebuild automatically — no manual `setState` orchestration.
5. `completion_stats.dart` recomputes streak/rate/rhythm from the fetched completion data, entirely client-side, entirely testable without Firestore.

## Why Firestore Security Rules are the real access-control layer

The Flutter client never encodes "you can't see someone else's data" as application logic — it doesn't have to, because [`firestore.rules`](../firestore.rules) enforces `request.auth.uid == uid` on every path under `users/{uid}`. A compromised or modified client cannot read another user's habits; the enforcement point is the database, not the app. See [SRS NFR-1](./SRS.md#nfr-1--security).

## Testing boundary

Because `completion_stats.dart` and `habit_model.dart`'s (de)serialization logic have no Firestore or Flutter widget dependency, `test/unit/` exercises them directly with plain Dart objects — no emulator, no mocking of the Firestore SDK required. This is a deliberate architectural choice, not an accident of what happened to be easy to test.

## Related documents

- [SRS.md](./SRS.md) — what the system is required to do.
- [ROADMAP.md](./ROADMAP.md) — what's planned next and why it's sequenced that way.
