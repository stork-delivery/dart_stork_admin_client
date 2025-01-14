# Dart Stork Client

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

Dart package to access apps open APIs

## Installation 💻

**❗ In order to start using Dart Stork Client you must have the [Dart SDK][dart_install_link] installed on your machine.**

Install via `dart pub add`:

```sh
dart pub add dart_stork_admin_client
```

## Usage 🚀

To use the Dart Stork Admin Client, first create an instance with your API key:

```dart
final client = DartStorkAdminClient(apiKey: 'your-api-key');
```

### Managing apps
```dart

// List all apps
final apps = await client.listApps();

// Get a specific app
final app = await client.getApp(1);

// Create a new app
final newApp = await client.createApp(
  name: 'My App',
  publicMetadata: true,
);

// Update an app
final updatedApp = await client.updateApp(
  id: 1,
  name: 'Updated App Name',
  publicMetadata: false,
);

// Remove an app
await client.removeApp(1);
```

### Managing versions

```dart
// List all versions for an app
final versions = await client.listVersions(1);

// Get a specific version
final version = await client.getVersion(1, '1.0.0');
```

### Managing artifacts

```dart
// List artifacts for a version
final artifacts = await client.listArtifacts(1, '1.0.0');

// Download an artifact
final bytes = await client.downloadArtifact(1, '1.0.0', 'android');
```

### Custom Base URL

When using a custom deployed API, you can set the base URL using the `baseUrl` constructor parameter:

```dart
final client = DartStorkAdminClient(
  apiKey: 'your-api-key',
  baseUrl: 'https://your-api-url.com',
);
```

---


## Running Tests 🧪

To run all unit tests:

```sh
dart pub global activate coverage 1.2.0
dart test --coverage=coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

[dart_install_link]: https://dart.dev/get-dart
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
