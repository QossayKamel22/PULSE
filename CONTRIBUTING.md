# Contributing to PULSE

## Before you start

Read [`docs/ARCHITECTURE.md`](./docs/ARCHITECTURE.md) first — three rules there (controllers never touch Firebase SDKs directly, views never hardcode styling, one logic layer for all platforms) shape almost every review comment you'd otherwise get. [`docs/SRS.md`](./docs/SRS.md) has the full requirement list if you need to check whether something is in scope.

## Setup

```
flutter pub get
```

Firebase credentials are not included in this repo — follow the [Firebase Setup](./README.md#firebase-setup) section of the README before running the app against a real backend. Without it, the app still boots (see `lib/main.dart`'s guarded `Firebase.initializeApp` call); Firebase-backed screens will just show their own error state.

## Before opening a PR

```
flutter analyze
flutter test
```

Both must be clean. `flutter analyze` should report no warnings or errors from your change (pre-existing `info`-level style suggestions unrelated to your change are not blocking). `flutter test` must pass in full — if you touch `completion_stats.dart` or `habit_model.dart`, add or update a case in `test/unit/` rather than only testing manually.

## Conventions

- **Firebase access goes through `services/`.** If your controller needs to read/write Firestore, add or extend a method in the relevant `services/*_service.dart` — don't import `cloud_firestore`/`firebase_auth` into a controller or view.
- **Styling goes through `core/theme/`.** No literal `Color(0x...)`, no ad-hoc `EdgeInsets` numbers — use `PulseColors` / `PulseSpacing` / the existing text theme.
- **New screens should be responsive.** Use `ResponsiveLayout` / the existing breakpoints (`core/responsive/breakpoints.dart`) rather than hardcoding a single layout and bolting on desktop support later.
- **Security rules changes need a reason in the PR description.** Anything touching `firestore.rules` should explain what access pattern it enables and why it doesn't cross the `users/{uid}` boundary — see [SRS NFR-1](./docs/SRS.md#nfr-1--security).

## Commit messages

Keep them in the imperative mood, one logical change per commit (`feat: add streak freeze grace day`, not `fixes and updates`). If a change is purely docs, prefix with `docs:`.

## Reporting issues

Open a GitHub issue with: what you expected, what happened instead, and which platform (iOS/Android/macOS/Web) you saw it on — PULSE's shared-logic architecture means most bugs reproduce everywhere, but layout issues are often platform- or breakpoint-specific.
