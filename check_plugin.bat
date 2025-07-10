@echo off
cd C:\Users\hp 15\AppData\Local\Pub\Cache\hosted\pub.dev\flutter_local_notifications-14.1.4\android\src\main\java\com\dexterous\flutterlocalnotifications\
type FlutterLocalNotificationsPlugin.java | findstr /n "bigLargeIcon" | findstr /i "1010"
