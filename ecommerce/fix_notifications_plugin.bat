@echo off
echo Fixing flutter_local_notifications plugin...

set PLUGIN_PATH="%LOCALAPPDATA%\Pub\Cache\hosted\pub.dev\flutter_local_notifications-14.1.4\android\src\main\java\com\dexterous\flutterlocalnotifications\FlutterLocalNotificationsPlugin.java"

if not exist %PLUGIN_PATH% (
  echo Error: Plugin file not found at %PLUGIN_PATH%
  exit /b 1
)

echo Creating backup of original file...
copy %PLUGIN_PATH% %PLUGIN_PATH%.bak

echo Patching plugin file...
powershell -Command "(Get-Content %PLUGIN_PATH%) -replace 'bigPictureStyle.bigLargeIcon\(null\);', '// Handle API compatibility for bigLargeIcon method^
if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {^
    bigPictureStyle.bigLargeIcon((android.graphics.drawable.Icon)null);^
} else {^
    bigPictureStyle.bigLargeIcon((android.graphics.Bitmap)null);^
}' | Set-Content %PLUGIN_PATH%"

if %ERRORLEVEL% == 0 (
  echo Plugin successfully patched.
  echo Now try building your app again with: flutter run
) else (
  echo Failed to patch the plugin.
  echo Restoring backup...
  copy %PLUGIN_PATH%.bak %PLUGIN_PATH%
  echo Please check the plugin path and try again.
)
