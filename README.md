# KorpoMap

Cross-platform mobile application for physiotherapists to manage patients and visually track injuries through an interactive body map with color-coded status.

Final project (Trabajo Fin de Grado) for the CFGS Cross-Platform Application Development programme (academic year 2025-2026, online).

## Download

Pre-built signed APKs are published in the [v1.0.0 Release](https://github.com/aquileorl/korpomap/releases/tag/v1.0.0). The Release includes four APK variants: three split per architecture (`arm64-v8a`, `armeabi-v7a`, `x86_64`) and a universal build that runs on any compatible Android device. The Release notes describe how to verify the signature with `apksigner`.

## Features

- Physiotherapist authentication via Supabase Auth (email + password).
- Patient management (CRUD) with real-time autocomplete search.
- Interactive body map with 30 tappable muscle groups (16 anterior + 14 posterior), zoom and pan.
- Injury tracking by muscle group with severity, description, date and status.
- Color-coded body map (red: active injury; yellow: recovered injury).
- Patient injury history, filterable by status and muscle group.

## Tech stack

| Layer | Technology |
|-------|------------|
| Frontend | Flutter 3.41.1 + Dart 3.11.0 |
| Routing | go_router 14.x |
| Backend | Supabase (Auth + PostgreSQL 17 + Storage) |
| Data isolation | PostgreSQL Row Level Security (RLS) |
| Typography | Plus Jakarta Sans + Inter (via `google_fonts`) |

Main dependencies: `supabase_flutter`, `go_router`, `flutter_svg`, `google_fonts`, `intl`, `path_parsing`, `xml`.

## Project structure

```
korpomap/
├── lib/
│   ├── config/            # Supabase init, router, visual theme
│   ├── models/            # Patient, Injury, MuscleGroup
│   ├── services/          # AuthService, PatientService, InjuryService
│   ├── screens/           # auth, dashboard, patient, injury
│   ├── widgets/body_map/  # CustomPainter for the interactive body map
│   └── main.dart
├── assets/images/         # Logo and visual assets
├── android/               # Android configuration (Gradle, manifest)
├── ios/                   # iOS configuration
└── db_backup/             # Full schema and demo data backup
```

## Prerequisites

- Flutter SDK 3.41.1 or later
- Dart 3.11.0 or later
- Android Studio or IntelliJ IDEA with the Flutter and Dart plugins
- JDK 17 or later (required to sign the release APK)
- Free [Supabase](https://supabase.com) account if you want to deploy your own backend instance

## Installation

```bash
git clone https://github.com/aquileorl/korpomap.git
cd korpomap
flutter pub get
```

## Credentials configuration

Supabase keys are injected at compile time through `--dart-define`, so they never appear in source code or in the repository. The initialisation logic lives in `lib/config/supabase_config.dart`.

The Supabase project URL has a default value baked into the code. Only `SUPABASE_ANON_KEY` is mandatory.

### Run in debug mode

```bash
flutter run --dart-define=SUPABASE_ANON_KEY=<your_anon_key>
```

### Point to a different Supabase instance

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://<your_project>.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=<your_anon_key>
```

## Building a release APK

```bash
flutter build apk --release --split-per-abi \
  --dart-define=SUPABASE_ANON_KEY=<your_anon_key>
```

This produces three APKs in `build/app/outputs/flutter-apk/`, one per architecture (`armeabi-v7a`, `arm64-v8a`, `x86_64`). The deliverable uses the `arm64-v8a` build, which targets the most common Android devices.

## APK signing

The release APK must be digitally signed before it can be installed on a device. The keystore is kept out of the repository: `key.properties` and `*.keystore` / `*.jks` files are listed in `.gitignore`.

1. Generate your own keystore:

   ```bash
   keytool -genkey -v -keystore korpomap-release.keystore \
     -alias korpomap -keyalg RSA -keysize 2048 -validity 10000
   ```

2. Create `android/key.properties` with the keystore credentials (this file is not versioned):

   ```properties
   storePassword=<password>
   keyPassword=<password>
   keyAlias=korpomap
   storeFile=<absolute path to korpomap-release.keystore>
   ```

3. In `android/app/build.gradle.kts`, declare a `signingConfigs` block that reads `key.properties` and assign it to `buildTypes.release`.

## Database

The backend runs on Supabase with two main tables (`patients`, `injuries`) and Row Level Security policies that ensure each physiotherapist can only access their own data.

### Restoring the backup

The `db_backup/` directory contains an exportable copy of the backend:

- `korpomap_backup.sql` — full schema (tables, indexes, RLS policies).
- `korpomap_data.sql` — demo dataset with a fictional user (`fisiodemo1@example.com`).

Restore on a clean PostgreSQL instance:

```bash
psql -h <host> -U postgres -d postgres -f db_backup/korpomap_backup.sql
psql -h <host> -U postgres -d postgres -f db_backup/korpomap_data.sql
```

## Author

**Emilio José Ruiz Linares** — Student of the CFGS DAM programme (online), academic year 2025-2026.

**Project supervisor**: Olga M. Moreno Martín ([@olga3emes](https://github.com/olga3emes)).

**Centre**: Caja Mágica — thePower FP Oficial / Prometeo by thePower.
