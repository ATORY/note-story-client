# note_story_flutter

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## environment
Like that Seth Ladd guy answered in the StackOverflow question, we can run the different variants by running flutter run with the --target or -t argument for short.

So, in our case:

to run the development build, we call flutter run -t lib/main_dev.dart
to run the production build, we call flutter run -t lib/main_prod.dart
To create a release build on Android, we can run flutter build apk -t lib/main_<environment>.dart and we will get the correct APK for our environment. To do a release build on iOS, just replace apk with ios.
