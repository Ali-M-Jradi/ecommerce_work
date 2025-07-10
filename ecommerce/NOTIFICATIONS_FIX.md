# Flutter Local Notifications Fix

## Issue
The flutter_local_notifications package version 16.3.3 has an issue with ambiguous method references in the Android implementation:
```
reference to bigLargeIcon is ambiguous
bigPictureStyle.bigLargeIcon(null);
both method bigLargeIcon(Bitmap) in BigPictureStyle and method bigLargeIcon(Icon) in BigPictureStyle match
```

## Solution Applied
We downgraded flutter_local_notifications to version 14.1.4 which doesn't have this issue.

In pubspec.yaml:
```yaml
flutter_local_notifications: 14.1.4 # Downgraded to avoid bigLargeIcon ambiguity
```

## Alternative Solutions

If you need to use a newer version of flutter_local_notifications in the future, you can:

1. Manually patch the plugin source code:
   - Find the file: `[YOUR_PUB_CACHE]/flutter_local_notifications/android/src/main/java/com/dexterous/flutterlocalnotifications/FlutterLocalNotificationsPlugin.java`
   - Locate the line with `bigPictureStyle.bigLargeIcon(null);`
   - Replace with:
   ```java
   if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
       bigPictureStyle.bigLargeIcon((android.graphics.drawable.Icon)null);
   } else {
       bigPictureStyle.bigLargeIcon((android.graphics.Bitmap)null);
   }
   ```

2. Create a fork of the plugin with the fix applied

## Other Changes Made

1. Updated NDK version in build.gradle.kts:
   ```kotlin
   ndkVersion = "27.0.12077973" // Updated to match required plugins
   ```

2. Updated Java and Kotlin versions:
   ```kotlin
   compileOptions {
       sourceCompatibility = JavaVersion.VERSION_17
       targetCompatibility = JavaVersion.VERSION_17
       // Enable desugaring to support newer Java features
       isCoreLibraryDesugaringEnabled = true
   }

   kotlinOptions {
       jvmTarget = JavaVersion.VERSION_17.toString()
   }
   ```

3. Added desugaring support:
   ```kotlin
   dependencies {
       coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:1.2.2")
   }
   ```

4. Enabled Developer Mode in Windows for symlink support
