# Flutter Local Notifications Plugin Fix

This directory contains information about a fix for an issue with the `flutter_local_notifications` plugin.

## The Problem

When using version 16.3.0+ of the plugin, there is a compilation error related to an ambiguous method reference:

```
error: reference to bigLargeIcon is ambiguous
      bigPictureStyle.bigLargeIcon(null);
                     ^
  both method bigLargeIcon(Bitmap) in BigPictureStyle and method bigLargeIcon(Icon) in BigPictureStyle match
```

This happens because in newer Android SDK versions, there are two overloaded versions of the `bigLargeIcon` method:
- One that takes a `Bitmap` parameter
- One that takes an `Icon` parameter (added in Android 12/API 31)

## The Solution

### Option 1: Downgrade the Plugin (Applied)

We've downgraded the plugin to version 16.0.0+1 in the pubspec.yaml file:

```yaml
flutter_local_notifications: ^16.0.0+1
```

This version doesn't have the issue with the ambiguous method call.

### Option 2: Manual Fix (Alternative)

If upgrading the plugin becomes necessary in the future, you can manually fix the plugin code:

1. Locate the plugin's Java file in your Pub cache folder:
   ```
   C:/Users/[USERNAME]/AppData/Local/Pub/Cache/hosted/pub.dev/flutter_local_notifications-16.3.3/android/src/main/java/com/dexterous/flutterlocalnotifications/FlutterLocalNotificationsPlugin.java
   ```

2. Find line ~1033 with:
   ```java
   bigPictureStyle.bigLargeIcon(null);
   ```

3. Replace it with:
   ```java
   // Handle API compatibility
   if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
       bigPictureStyle.bigLargeIcon((android.graphics.drawable.Icon)null);
   } else {
       bigPictureStyle.bigLargeIcon((android.graphics.Bitmap)null);
   }
   ```

## Other Changes Made

We've also updated:

1. The minimum SDK version to 21 in app/build.gradle.kts
2. The NDK version to 27.0.12077973 for compatibility with Firebase plugins
3. The Java and Kotlin versions to 17 (from 11) to avoid warnings about obsolete options

These changes ensure the app builds correctly with the required plugins.
