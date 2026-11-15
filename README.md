# Paripadi (പരിപാടി)

**Paripadi** — Malayalam for "event" / "program" — is an Apple-inspired event
management app for **festivals and games/sports events**, built in Flutter
with a full iOS design language: Cupertino navigation with large titles,
`CupertinoTabBar`, iOS segmented controls, Cupertino switches, iOS-style
sheets, and Apple system colors.

> Project directory is `~/workspace/eventos/` and the package stays
> `com.nuvish.eventos` — only the user-visible name is Paripadi.

## Screens (4 tabs)

| Tab | What it does |
| --- | --- |
| **Bento (Overview)** | Large-title header with the പരിപാടി tagline, user chip (Arjun Krishna, Lead Organizer • Admin), live match pill, Sports Fest / Batch Reunion switcher, KPI cards (2 events, 6 participants, 3 live/scheduled, 4 checked-in), Live Match Control with working −/+ score steppers, fixtures, championship standings, RSVP & catering tracker, smart expense splitter |
| **Events** | Your Managed Events with All / Live / Upcoming segmented filter; tapping a card opens that event's dashboard on the Overview tab |
| **Passes** | Participants & QR passes — search, All / Checked-In / Pending filter, "Add & Generate QR" sheet, tap a participant for the Apple Wallet-style QR pass sheet (decorative QR matrix, check-in toggle, payment toggle) |
| **Create** | Create a new event — Sports / Athletics or Get-Together / Social. Sports covers **tournaments, matches & track events** (tournament format, team/house mode, fixtures, live scores, standings); Social covers RSVP, catering headcount and bill split. "Launch Event Workspace" adds the event and opens the Events tab |

## Sample data

All data is local, in-memory sample data (`lib/store.dart`) — no backend.
Two events: **Annual Athletics & Football 2026** (Sports Fest) and
**Batch 2020 Grand Reunion & Dinner** (Batch Reunion). Six participants,
live score Red House 2 – 1 Blue House, standings Red 145 / Blue 128 /
Green 96, reunion expense ₹63,000 split ₹1,500 per person.

## Tech

- Flutter 3.47.7 / Dart 3.13.5, package `com.nuvish.eventos`
- `google_fonts` (Inter — the closest free match to SF Pro)
- Plain Flutter state: one in-memory `EventStore` + `StatefulWidget`s
- Pure logic in `lib/logic.dart` (expense split, RSVP %, standings sort,
  live points, initials, next pass ID) — unit-tested in `test/logic_test.dart`
- No backend, no Firebase, no auth, no payments, no network calls at runtime

## Run

```sh
~/development/flutter/bin/flutter pub get
~/development/flutter/bin/flutter analyze   # clean
~/development/flutter/bin/flutter test      # 19 unit tests
```

A faithful static HTML mockup of the four screens lives at
`~/workspace/eventos-preview/flutter-prototype-preview.html` with
screenshots in the same folder.

## Intentionally NOT in this prototype

Backend / cloud sync, real QR code scanning, payments, notifications,
accounts/auth, and a real APK build (Gradle builds are broken in this VM —
build the release APK on a machine with a working Android toolchain).
