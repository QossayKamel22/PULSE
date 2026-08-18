# Software Requirements Specification — PULSE

Version 0.1.0 · Last updated 2026-08-18

## 1. Introduction

### 1.1 Purpose

This document specifies the functional and non-functional requirements for PULSE, a habit and daily-rhythm tracking application. It is written against the app as implemented, not as a forward-looking pitch — every requirement below maps to code that exists in this repository today, with the exception of items explicitly marked *(planned)*, which are tracked in [ROADMAP.md](./ROADMAP.md).

### 1.2 Scope

PULSE lets a single authenticated user create habits, mark daily completions, and view derived statistics (streaks, completion rate, a daily rhythm score) across mobile, desktop, and web from one Flutter codebase and one Firebase backend. It is not a team/social product — there is no sharing, following, or cross-user visibility in this version.

### 1.3 Definitions

| Term | Meaning |
|---|---|
| Habit | A user-defined recurring action tracked by PULSE (e.g. "Read 20 minutes"). |
| Completion | A record that a given habit was done on a given calendar day. |
| Streak | The count of consecutive days a habit has been completed, ending today or yesterday. |
| Rhythm score | The percentage of today's active habits already completed. |

### 1.4 Intended Audience

Contributors and reviewers who need to know what PULSE is supposed to do, independent of reading the implementation directly.

## 2. Overall Description

### 2.1 Product Perspective

PULSE is a standalone client application (Flutter) backed by Firebase managed services (Authentication, Firestore, Cloud Messaging, Analytics). There is no custom backend server; all business logic that must be trusted (access control) is enforced by Firestore Security Rules, not by client code.

### 2.2 User Class

A single class of user: an authenticated individual managing their own habits. There is no admin role, no multi-tenant organization concept, and no distinction between "free" and "paid" tiers in this version.

### 2.3 Operating Environment

- **Mobile:** iOS and Android, via Flutter.
- **Desktop:** macOS, via Flutter desktop.
- **Web:** any evergreen browser, via Flutter web.
- **Backend:** Firebase (Authentication, Cloud Firestore, Cloud Messaging, Analytics), one project per deployment.

## 3. Functional Requirements

### FR-1 — Authentication

- FR-1.1: The system shall allow a new user to create an account with an email address and password.
- FR-1.2: The system shall allow an existing user to sign in with email and password.
- FR-1.3: The system shall allow a signed-in user to sign out.
- FR-1.4: The system shall persist the authenticated session across app restarts using Firebase's own session persistence.
- FR-1.5: The system shall route the user to the login screen automatically when no session is active, and away from it automatically once one is, driven by live auth-state changes rather than a one-time check at launch.
- FR-1.6: The system shall present a clean, user-facing error message for known failure cases (invalid email, wrong password, disabled account, account already exists, weak password, network failure) without crashing, and a generic fallback message for any other Firebase Auth error.
- FR-1.7 *(planned)*: The system shall support Google Sign-In as an additional auth provider. See [ROADMAP.md](./ROADMAP.md).

### FR-2 — Habit Management

- FR-2.1: The system shall allow a signed-in user to create a habit with a name, frequency, optional reminder time, and icon.
- FR-2.2: The system shall allow a user to edit an existing habit's name, frequency, reminder time, and icon.
- FR-2.3: The system shall allow a user to delete a habit.
- FR-2.4: The system shall allow a user to deactivate a habit (`isActive = false`) without deleting its history.
- FR-2.5: The system shall persist every habit under that user's own Firestore document tree, never under another user's.

### FR-3 — Completions

- FR-3.1: The system shall allow a user to mark a habit complete or incomplete for a specific calendar day.
- FR-3.2: The system shall store one completion record per habit per day, keyed by date (`yyyy-MM-dd`), not as an appended array entry, so that history growth does not increase the cost of reading a single day's state.

### FR-4 — Derived Statistics

- FR-4.1: The system shall compute a habit's current streak as the number of consecutive completed days ending today or yesterday (a not-yet-completed today does not break the streak).
- FR-4.2: The system shall compute a habit's best (longest) streak across its full completion history.
- FR-4.3: The system shall compute a 7-day completion rate as a percentage.
- FR-4.4: The system shall compute a daily rhythm score as the percentage of the user's active habits completed today.
- FR-4.5: All statistics in FR-4.1–4.4 shall be computed by pure functions with no Firestore or Flutter dependency, enabling deterministic unit testing.

### FR-5 — Insights

- FR-5.1: The system shall present a weekly activity chart summarizing completions over the trailing 7 days.
- FR-5.2: The system shall present the daily rhythm score and streak summaries on the home screen.

### FR-6 — Notifications

- FR-6.1: The system shall schedule a local notification for a habit's reminder time when one is set.
- FR-6.2: The system shall not send any notification not derived from an explicit habit reminder (no marketing pushes, no re-engagement nudges) in this version.
- FR-6.3: The system shall be capable of receiving remote push messages via Firebase Cloud Messaging for future server-initiated notifications.

### FR-7 — Theming

- FR-7.1: The system shall provide Light and Dark visual themes.
- FR-7.2: The system shall allow the user to select Light, Dark, or System theme mode at runtime, applied immediately without restart.

### FR-8 — Responsive Layout

- FR-8.1: The system shall present a bottom-navigation, single-column layout below the mobile breakpoint (600px).
- FR-8.2: The system shall present a persistent sidebar and multi-column dashboard at tablet/desktop/web widths, using the same controllers and data as the mobile layout.

### FR-9 — Analytics

- FR-9.1: The system shall log key product events (e.g. habit created, habit completed) to Firebase Analytics.

### FR-10 — PULSE AI (placeholder)

- FR-10.1: The system shall display a card with short, locally-generated rotating copy suggesting the shape of a future insights feature.
- FR-10.2: The system shall not call any external LLM or AI service in this version; FR-10.1's copy is static and generated entirely on-device.
- FR-10.3 *(planned)*: A real, data-driven insight generated server-side from a user's completion history. See [ROADMAP.md](./ROADMAP.md).

## 4. Non-Functional Requirements

### NFR-1 — Security

- NFR-1.1: A user shall only be able to read or write their own `users/{uid}` document and everything beneath it in Firestore. Cross-user access shall be denied by Firestore Security Rules (see [`firestore.rules`](../firestore.rules)), not merely hidden by client-side UI.
- NFR-1.2: No public (unauthenticated) read or write access shall exist on any user data path.
- NFR-1.3: No Firebase API keys or credentials shall be committed to the repository; `firebase_options.dart` ships as a placeholder, and platform credential files (`google-services.json`, `GoogleService-Info.plist`) are git-ignored.

### NFR-2 — Testability

- NFR-2.1: Streak, best-streak, completion-rate, and rhythm-score logic shall be covered by automated unit tests independent of any live Firebase connection.
- NFR-2.2: Habit model (de)serialization shall be covered by automated unit tests, including graceful defaulting when fields are missing from stored data.

### NFR-3 — Portability

- NFR-3.1: The application shall run from a single Dart/Flutter codebase across iOS, Android, macOS, and Web without a forked or duplicated business-logic layer per platform.

### NFR-4 — Maintainability

- NFR-4.1: UI code shall not call Firebase SDKs directly; all Firebase access shall be mediated through the `services/` layer.
- NFR-4.2: UI code shall not hardcode colors, spacing, or typography; all such values shall come from `core/theme/`.

### NFR-5 — Performance

- NFR-5.1: Reading a single day's completion state for a habit shall not require reading or scanning that habit's full completion history (see FR-3.2).

## 5. Constraints & Assumptions

- Firebase is treated as the system of record; there is no offline-first conflict-resolution layer beyond what the Firestore SDK provides by default.
- The app assumes exactly one Firebase project per deployment/environment; there is no multi-project or multi-tenant switching in the UI.
- `PULSE AI` (FR-10) is explicitly a placeholder by design in this version — see the README's [PULSE AI](../README.md#pulse-ai) section for the rationale.

## 6. Traceability

Each functional requirement above corresponds to code under `lib/`:

| Requirement | Primary implementation |
|---|---|
| FR-1 | `lib/features/auth/`, `lib/services/auth/auth_service.dart` |
| FR-2, FR-3 | `lib/features/habits/`, `lib/services/firestore/firestore_service.dart` |
| FR-4 | `lib/features/habits/models/completion_stats.dart` |
| FR-5 | `lib/features/insights/views/insights_view.dart` |
| FR-6 | `lib/services/notifications/notification_service.dart` |
| FR-7 | `lib/core/theme/` |
| FR-8 | `lib/core/responsive/` |
| FR-9 | `lib/services/analytics/analytics_service.dart` |
| FR-10 | `lib/core/widgets/pulse_ai_card.dart` |
| NFR-1 | `firestore.rules` |
