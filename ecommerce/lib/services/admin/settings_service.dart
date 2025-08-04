import 'package:ecommerce/models/admin/customization_settings.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SettingsService {
  static final SettingsService instance = SettingsService._internal();
  Database? _db;

  SettingsService._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_settings.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS customization_settings (
            key TEXT PRIMARY KEY,
            value TEXT
          )
        ''');
      },
    );
  }

  Future<void> saveCustomizationSettings(CustomizationSettings settings) async {
    final db = await database;
    await db.insert(
      'customization_settings',
      {'key': 'customization', 'value': settings.toJson().toString()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<CustomizationSettings?> fetchCustomizationSettings() async {
    final db = await database;
    final result = await db.query(
      'customization_settings',
      where: 'key = ?',
      whereArgs: ['customization'],
      limit: 1,
    );
    if (result.isNotEmpty) {
      final value = result.first['value'] as String;
      // Parse the string to Map
      final Map<String, dynamic> map = _parseStringToMap(value);
      return CustomizationSettings.fromJson(map);
    }
    return null;
  }

  Map<String, dynamic> _parseStringToMap(String value) {
    // This is a simple parser for Map<String, dynamic> from a string
    // In production, use jsonEncode/jsonDecode
    value = value.replaceAll(RegExp(r'[{}]'), '');
    final map = <String, dynamic>{};
    for (var pair in value.split(',')) {
      var kv = pair.split(':');
      if (kv.length == 2) {
        map[kv[0].trim()] = kv[1].trim();
      }
    }
    return map;
  }
}
