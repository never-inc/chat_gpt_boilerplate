# chat_gpt_boilerplate

[![never-light-log](./img/logo_blk.png)](https://neverjp.com)

Developed with 💙 by [Never inc](https://neverjp.com/).

This is Flutter's Chat GPT boilerplate.

[![video](https://img.youtube.com/vi/bsoiFm989Y8/hqdefault.jpg)](https://www.youtube.com/embed/bsoiFm989Y8)

## Stack

| Item      | Description          |
|------------|-------------------------------|
| Flutter SDK  | Check the [.tool-versions](https://asdf-vm.com/) [.fvmrc](https://fvm.app/) |
| Directory Structure  | [Feature-first](https://codewithandrea.com/articles/flutter-project-structure/) |
| State   | [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) [riverpod_generator](https://pub.dev/packages/riverpod_generator) |
| Navigation   | [go_router](https://pub.dev/packages/go_router) [go_router_builder](https://pub.dev/packages/go_router_builder) |
| Localizations | [l10n](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization) |
| Assets | [flutter_gen_runner](https://pub.dev/packages/flutter_gen_runner) |
| Lint   | [very_good_analysis](https://pub.dev/packages/very_good_analysis) [riverpod_lint](https://pub.dev/packages/riverpod_lint) |
| Local DB | [shared_preferences](https://pub.dev/packages/shared_preferences) [isar](https://pub.dev/packages/isar) [isar_flutter_libs](https://pub.dev/packages/isar_flutter_libs) [isar_generator](https://pub.dev/packages/isar_generator) |
| Open AI | [dart_openai](https://pub.dev/packages/dart_openai) |

## System Requirements

```sh
[✓] Flutter (Channel stable, 3.22.1, on macOS 14.3.1 23D60 darwin-arm64, locale ja-JP)
[✓] Android toolchain - develop for Android devices (Android SDK version 34.0.0)
[✓] Xcode - develop for iOS and macOS (Xcode 15.4)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2023.3)
[✓] VS Code (version 1.89.1)
```

Android, iOS, macOS apps are guaranteed to work, but other platforms are not covered.

## Getting Started

Install packages and launch the application.

```sh
flutter pub get
flutter run
```

### Code Generation

```sh
dart run build_runner watch
```

### Other Commands

Please check the [Makefile](./Makefile).

## References

### Design

- [Apple - UI Design Dos and Don’ts](https://developer.apple.com/design/tips/)
- [Glossary – Material Design 3](https://m3.material.io/foundations/glossary)

### Localization

- [Internationalizing Flutter apps](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)

### Open AI

- [Overview - OpenAI API](https://platform.openai.com/docs/overview)