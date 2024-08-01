# Smart Farm

Precision Farming using on-device ML and AI.

## Getting Started

This project is a Flutter application.

A few resources on Flutter:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

To get started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Project set up

The project is configured with Firebase. To run it include the following files:

1. `firebase_options.dart` file at the root of the project. This file contains the firebase configuration.
2. `google-services.json` file at the `android/app/` folder. This file contains the firebase configuration for android.

For more information, check out the setup guide [Add Firebase to your Flutter app](https://firebase.google.com/docs/flutter/setup?platform=android).

## CI/CD

Continuous integration and Continuous delivery/deployment is setup using [GitHub Actions](https://docs.github.com/en/actions).

The `firebase_app_distribution.dart` file found on the path `.github/workflows`, contains workflow that runs the tests and deploys the Android apk file to [Firebase App Distribution](https://firebase.google.com/docs/app-distribution).

The following secrets are required:

1. `FIREBASE_OPTION` - containing contents of the `firebase_options.dart` file.
2. `GOOGLE_SERVICES_JSON` - containing contents of the `google-services.json` file.
3. `FIREBASE_APP_ID` - containing the Android App ID found on the Firebase project settings.
4. `FIREBASE_TOKEN` - containing the output of the `firebase login:ci` command.

## Running the project

To run it on Visual Studio Code, create a new `launch.json` file with the following configuration:

```
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "smart_farm",
      "request": "launch",
      "type": "dart"
    },
    {
      "name": "smart_farm (profile mode)",
      "request": "launch",
      "type": "dart",
      "flutterMode": "profile"
    },
    {
      "name": "smart_farm (release mode)",
      "request": "launch",
      "type": "dart",
      "flutterMode": "release"
    }
  ]
}
```
