<img src="web/icons/interledger.jpg" alt="VibePayments" width="120" />

# VibePayments

Interledger-powered payments for tourism: instant, transparent, multi-currency.

## Overview

VibePayments is a production-ready client application that uses Interledger technology to streamline cross-border payments in the tourism industry. It delivers instant settlement, real-time FX quotes, and transparent pricing for travel agencies, hotels, tours, and marketplaces.

Built with Flutter, VibePayments runs on iOS, Android, Web, Windows, Linux, and macOS from a single codebase.

## Why Interledger

- Instant settlement across networks using ILP.
- Real-time quotes and currency conversion.
- Open, provider-agnostic integrations (connect your preferred ILP-enabled PSPs).
- Fine-grained control over fees and transparency for travelers and merchants.

## Key Features

- Multi-currency pricing and settlement with real-time FX.
- Payment links and QR for quick checkouts on-device or on web.
- Payout orchestration to local accounts via ILP-enabled providers.
- Reconciliation dashboard-ready data (exports, webhooks).
- Secure token storage and session management.
- Cross-platform UI with theming and localization-ready structure.

## How It Works

1) Create quote: request an FX quote for the customer’s preferred currency.
2) Confirm payment: the client initiates an ILP payment via the configured PSP.
3) Settle: Interledger packets settle across connected networks.
4) Reconcile: confirmations and receipts are recorded for reporting.

The client communicates with your gateway or directly with ILP-enabled endpoints (depending on your deployment). PSPs can be swapped without changing the app’s core flows.

## Getting Started

### Prerequisites

- Flutter SDK 3.22+ (Dart 3.8+).
- Platform toolchains as needed (Android Studio/Xcode/Chrome).

### Setup

- Install dependencies: `flutter pub get`
- (Optional) Configure environment endpoints and feature flags in your app config. A common pattern is a file like `lib/app/config/env.dart` exporting constants for base API URLs and Interledger endpoints.

### Run

- Mobile: `flutter run -d android` or `flutter run -d ios`
- Web: `flutter run -d chrome`
- Desktop (if enabled): `flutter run -d windows` / `macos` / `linux`

### Build

- Android APK: `flutter build apk --release`
- Android AAB: `flutter build appbundle --release`
- iOS: `flutter build ios --release` (archive and distribute from Xcode)
- Web: `flutter build web`

## Configuration

Use a small config layer to avoid hardcoding service URLs and keys:

```dart
// lib/app/config/env.dart
class Env {
  static const apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'https://api.example.com');
  static const ilpEndpoint = String.fromEnvironment('ILP_ENDPOINT', defaultValue: 'https://ilp.example.com');
}
```

You can pass values at build/run time with `--dart-define`:

- Run: `flutter run --dart-define=API_BASE_URL=https://api.yourdomain.com --dart-define=ILP_ENDPOINT=https://ilp.yourdomain.com`
- Build: `flutter build apk --release --dart-define=API_BASE_URL=... --dart-define=ILP_ENDPOINT=...`

## Project Structure

The codebase follows a feature-first structure with clear separation of layers. Core libraries include `flutter_riverpod`, `go_router`, `http`, and `shared_preferences`.

```
lib/
  main.dart
  app/
    config/           # env, routes, theme
    di/               # dependency injection (optional)
  core/               # constants, errors, network, utils, widgets
  features/           # domain-driven features (auth, payments, quotes, etc.)
  l10n/               # localization (if enabled)
```

## Security

- Never commit secrets. Use `--dart-define` or your CI/CD secrets store.
- Store tokens securely (e.g., Keychain/Keystore on mobile; guarded storage on web/desktop).
- Restrict network calls to trusted domains and use TLS everywhere.

## Support and Next Steps

- Integrate your preferred ILP-enabled PSP.
- Connect dashboards and webhooks for reconciliation.
- Customize theming and localization for your markets.
