# Roadmap

This tracks planned work beyond the current `0.1.0` MVP. Nothing here is committed to a date — it's ordered roughly by dependency and impact, not by quarter.

## Near-term

- **Real PULSE AI.** Replace the static rotating copy in `pulse_ai_card.dart` with a genuine insight: a Cloud Function reads a user's `completions` subcollection and returns a short, model-generated observation. The card's layout and copy rhythm are already final, so this is a data-source swap, not a UI rewrite — see the [PULSE AI](../README.md#pulse-ai) section in the README for why it was built in this order.
- **Google Sign-In.** Add as a second provider alongside email/password, sharing the same `AuthController`/`AuthService` flow and error-handling path already in place.
- **Advanced/recurring reminder rules.** Move beyond a single daily reminder time per habit — specific weekdays, multiple reminders per day, snooze behavior.

## Mid-term

- **Home screen widgets** (iOS/Android) surfacing today's rhythm score and next unfinished habit without opening the app.
- **Deeper analytics.** Expand beyond the current key-event logging (`lib/services/analytics/analytics_service.dart`) into funnels and retention views in Firebase Analytics/BigQuery.
- **Cloud Functions for server-side streak recompute.** Today, streak/rate/rhythm math (`completion_stats.dart`) runs client-side against data already fetched. A server-side recompute path would enable notifications and the real PULSE AI feature to reason about streaks without a client being open.

## Longer-term / exploratory

- **Apple Watch companion.** Quick-complete a habit from the wrist; would reuse the existing Firestore completion write path.
- **Smart habit recommendations.** Suggest new habits based on completion patterns — depends on the real PULSE AI backend landing first.

## Explicitly out of scope for now

- Team/social features (sharing, following, leaderboards) — PULSE is single-user by design in this version; see [SRS §2.2](./SRS.md#22-user-class).
- A custom backend server — Firebase Security Rules remain the trust boundary; see [SRS NFR-1](./SRS.md#nfr-1--security).

---

For requirement-level detail on what's already shipped, see [SRS.md](./SRS.md). For the day-to-day list also visible to a casual reader, the README keeps a short mirror of this file under its own [Roadmap](../README.md#roadmap) section.
