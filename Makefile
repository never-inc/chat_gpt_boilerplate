# Automatic code generation.
run_build_runner:
	dart run build_runner build

# Monitor and automatically generate code.
watch_build_runner:
	dart run build_runner watch

# Pub get.
pub_get:
	flutter pub get

# Create icon.
create_icon:
	flutter pub run flutter_launcher_icons:main

# Change package name.
package_rename:
	dart run package_rename

# [Flavor is development] Run.
run_dev:
	flutter run --dart-define=FLAVOR=dev --target lib/main.dart

# [Flavor is production] Run.
run_prod:
	flutter run --dart-define=FLAVOR=prod --target lib/main.dart

# [Android] Release build.
release_build_android:
	flutter build appbundle --release --dart-define=FLAVOR=prod --target lib/main.dart

# [Android + Obfuscate] Release build.
release_build_obfuscate_android:
	flutter build appbundle --release --obfuscate --split-debug-info=obfuscate/android --dart-define=FLAVOR=prod --target lib/main.dart

# [iOS] Release build.
release_build_ios:
	flutter build ipa --release --dart-define=FLAVOR=prod --target lib/main.dart

# [iOS + Obfuscate] Release build.
release_build_obfuscate_ios:
	flutter build ipa --release --obfuscate --split-debug-info=obfuscate/ios --dart-define=FLAVOR=prod --target lib/main.dart

# Test with coverage.
flutter_test_c:
	flutter test --coverage
