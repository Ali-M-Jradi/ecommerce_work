# Firebase Setup Instructions

Follow these steps to properly set up Firebase for notifications in your app:

## Step 1: Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Name your project (e.g., "E-commerce App")
4. Follow the setup wizard (you can disable Google Analytics if not needed)
5. Click "Create project"

## Step 2: Register Your Android App

1. In the Firebase console, click on the Android icon to add an Android app
2. Enter your app's package name (e.g., `com.example.ecommerce`)
   - You can find this in your `android/app/build.gradle.kts` under `namespace`
3. Enter app nickname (optional)
4. Click "Register app"

## Step 3: Download Config File

1. Download the `google-services.json` file
2. Place it in your project's `android/app` directory

## Step 4: Update Build Files

1. Add the Firebase SDK to your project-level `build.gradle.kts` file:

```kotlin
// android/build.gradle.kts
buildscript {
    dependencies {
        // ...
        classpath("com.google.gms:google-services:4.4.0")
    }
}
```

2. Apply the Google services plugin in your app-level `build.gradle.kts`:

```kotlin
// android/app/build.gradle.kts
plugins {
    // ...
    id("com.google.gms.google-services")
}
```

## Step 5: Setup iOS App (if applicable)

1. In the Firebase console, click on the iOS icon
2. Enter your iOS bundle ID
3. Download `GoogleService-Info.plist` file
4. Place it in the `ios/Runner` directory using Xcode

## Step 6: Update main.dart

Make sure your main.dart initializes Firebase properly:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize Notification Service
  await NotificationService.instance.initialize();
  
  runApp(const MyApp());
}
```

## Step 7: Send Test Notification

1. In Firebase Console, go to "Cloud Messaging"
2. Click "Send your first message"
3. Add notification title and text
4. Target your app by selecting the app package name
5. Click "Review" and then "Publish"

If you've followed all steps correctly, you should receive a notification on your device!
