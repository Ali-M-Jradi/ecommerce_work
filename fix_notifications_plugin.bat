@echo off
echo Fixing flutter_local_notifications plugin...
set PLUGIN_DIR=%LOCALAPPDATA%\Pub\Cache\hosted\pub.dev\flutter_local_notifications-14.1.4\android\src\main\java\com\dexterous\flutterlocalnotifications
set PLUGIN_FILE=%PLUGIN_DIR%\FlutterLocalNotificationsPlugin.java

if not exist "%PLUGIN_FILE%" (
  echo ERROR: Plugin file not found at %PLUGIN_FILE%
  echo Please check if the path is correct or if you have a different version installed.
  exit /b 1
)

echo Creating backup of the plugin file...
copy "%PLUGIN_FILE%" "%PLUGIN_FILE%.bak"

echo Patching the plugin file...
powershell -Command "$content = Get-Content -Path '%PLUGIN_FILE%' -Raw; $content = $content -replace 'bigPictureStyle.bigLargeIcon\(null\);', 'bigPictureStyle.bigLargeIcon((android.graphics.Bitmap)null);'; Set-Content -Path '%PLUGIN_FILE%' -Value $content"

echo Done!
echo Please run 'flutter clean' and then 'flutter run' to test the fix.
