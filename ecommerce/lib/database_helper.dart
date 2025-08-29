

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/product.dart';
import 'models/cart_item.dart';

class DatabaseHelper {
  // Save user theme preference
  Future<void> setUserTheme(String themeMode) async {
    final db = await database;
    int count = await db.update(
      'user_preferences',
      {'value': themeMode},
      where: 'key = ?',
      whereArgs: ['theme'],
    );
    if (count == 0) {
      await db.insert(
        'user_preferences',
        {'key': 'theme', 'value': themeMode},
      );
    }
  }

  // Get user theme preference
  Future<String?> getUserTheme() async {
    final db = await database;
    final result = await db.query(
      'user_preferences',
      where: 'key = ?',
      whereArgs: ['theme'],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return result.first['value'] as String?;
    }
    return null;
  }
  // Save user custom primary color hex string
  Future<void> setUserPrimaryColor(String? colorHex) async {
    final db = await database;
    print('[DatabaseHelper] Saving primary color: $colorHex');
    int count = await db.update(
      'user_preferences',
      {'value': colorHex ?? ''},
      where: 'key = ?',
      whereArgs: ['primaryColor'],
    );
    if (count == 0) {
      await db.insert(
        'user_preferences',
        {'key': 'primaryColor', 'value': colorHex ?? ''},
      );
    }
  }

  // Get user custom primary color hex string
  Future<String?> getUserPrimaryColor() async {
    final db = await database;
    final result = await db.query(
      'user_preferences',
      where: 'key = ?',
      whereArgs: ['primaryColor'],
      limit: 1,
    );
    print('[DatabaseHelper] Loaded primary color result: $result');
    if (result.isNotEmpty) {
      print('[DatabaseHelper] Returning primary color: ${result.first['value']}');
      return result.first['value'] as String?;
    }
    print('[DatabaseHelper] No primary color found, returning null');
    return null;
  }

  // Save user custom secondary color hex string
  Future<void> setUserSecondaryColor(String? colorHex) async {
    final db = await database;
    print('[DatabaseHelper] Saving secondary color: $colorHex');
    int count = await db.update(
      'user_preferences',
      {'value': colorHex ?? ''},
      where: 'key = ?',
      whereArgs: ['secondaryColor'],
    );
    if (count == 0) {
      await db.insert(
        'user_preferences',
        {'key': 'secondaryColor', 'value': colorHex ?? ''},
      );
    }
  }

  // Get user custom secondary color hex string
  Future<String?> getUserSecondaryColor() async {
    final db = await database;
    final result = await db.query(
      'user_preferences',
      where: 'key = ?',
      whereArgs: ['secondaryColor'],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return result.first['value'] as String?;
    }
    return null;
  }

  // Save user custom tertiary color hex string
  Future<void> setUserTertiaryColor(String? colorHex) async {
    final db = await database;
    print('[DatabaseHelper] Saving tertiary color: $colorHex');
    int count = await db.update(
      'user_preferences',
      {'value': colorHex ?? ''},
      where: 'key = ?',
      whereArgs: ['tertiaryColor'],
    );
    if (count == 0) {
      await db.insert(
        'user_preferences',
        {'key': 'tertiaryColor', 'value': colorHex ?? ''},
      );
    }
  }

  // Get user custom tertiary color hex string
  Future<String?> getUserTertiaryColor() async {
    final db = await database;
    final result = await db.query(
      'user_preferences',
      where: 'key = ?',
      whereArgs: ['tertiaryColor'],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return result.first['value'] as String?;
    }
    return null;
  }
  
  // Save whether semantic colors are locked to defaults (true/false)
  // Semantic lock persistence removed from database helper
  // Save user language preference
  Future<void> setUserLanguage(String languageCode) async {
    final db = await database;
    print('[DatabaseHelper] Saving language: $languageCode');
    // Try to update first
    int count = await db.update(
      'user_preferences',
      {'value': languageCode},
      where: 'key = ?',
      whereArgs: ['language'],
    );
    if (count == 0) {
      // If no row was updated, insert new
      await db.insert(
        'user_preferences',
        {'key': 'language', 'value': languageCode},
      );
    }
  }

  // Get user language preference
  Future<String?> getUserLanguage() async {
    final db = await database;
    final result = await db.query(
      'user_preferences',
      where: 'key = ?',
      whereArgs: ['language'],
      limit: 1,
    );
    print('[DatabaseHelper] Loaded language result: $result');
    if (result.isNotEmpty) {
      print('[DatabaseHelper] Returning language: ${result.first['value']}');
      return result.first['value'] as String?;
    }
    print('[DatabaseHelper] No language found, returning null');
    return null;
  }
  // Clear all items from cart table (for schema/data reset)
  // Note: cart-clear helper intentionally removed to prevent accidental DB wipes.

  // Clear persisted theme-related preferences (primary/secondary/tertiary/lockSemanticColors)
  Future<void> clearUserThemePreferences() async {
    final db = await database;
    try {
      await db.delete(
        'user_preferences',
        where: 'key IN (?, ?, ?)',
        whereArgs: ['primaryColor', 'secondaryColor', 'tertiaryColor'],
      );
      print('[DatabaseHelper] Cleared user theme preferences');
    } catch (e) {
      print('[DatabaseHelper] Error clearing theme preferences: $e');
    }
  }
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'ecommerce.db');
    return await openDatabase(
      path,
      version: 2, // Incremented version for userId column
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        price REAL,
        imageUrl TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE cart (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId TEXT,
        name TEXT,
        brand TEXT,
        price REAL,
        image TEXT,
        size TEXT,
        category TEXT,
        quantity INTEGER,
        description TEXT,
        userId TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        total REAL
      )
    ''');
    await db.execute('''
      CREATE TABLE wishlist (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productId TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE user_preferences (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT,
        value TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        body TEXT,
        date TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE scan_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT,
        date TEXT
      )
    ''');
  }

  // Wishlist CRUD
  Future<void> addProductToWishlist(String productId) async {
    final db = await database;
    // prevent duplicates by checking existence
    final existing = await db.query('wishlist', where: 'productId = ?', whereArgs: [productId], limit: 1);
    if (existing.isEmpty) {
      await db.insert('wishlist', {'productId': productId});
    }
  }

  Future<void> removeProductFromWishlist(String productId) async {
    final db = await database;
    await db.delete('wishlist', where: 'productId = ?', whereArgs: [productId]);
  }

  Future<List<String>> getWishlistProductIds() async {
    final db = await database;
    final rows = await db.query('wishlist');
    return rows.map<String>((r) => (r['productId']?.toString() ?? '')).where((s) => s.isNotEmpty).toList();
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('DatabaseHelper: Upgrading database from version $oldVersion to $newVersion');
    
    if (oldVersion < 2) {
      // Add userId column to cart table
      await db.execute('ALTER TABLE cart ADD COLUMN userId TEXT');
      print('DatabaseHelper: Added userId column to cart table');
      
      // Clear existing cart items since they don't have userId
      await db.delete('cart');
      print('DatabaseHelper: Cleared existing cart items (no userId association)');
    }
  }

  // CRUD methods for Product model
  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert('products', product.toMap());
  }

  Future<List<Product>> getProducts() async {
    final db = await database;
    final maps = await db.query('products');
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // CRUD methods for CartItem model
  Future<int> insertCartItem(CartItem cartItem) async {
    final db = await database;
    // Only store fields relevant for display/persistence
    final map = {
      'productId': cartItem.productId,
      'name': cartItem.name,
      'brand': cartItem.brand,
      'price': cartItem.price,
      'image': cartItem.image,
      'size': cartItem.size,
      'category': cartItem.category,
      'quantity': cartItem.quantity,
      'description': cartItem.description,
      'userId': cartItem.userId,
    };
    return await db.insert('cart', map);
  }

  Future<List<CartItem>> getCartItems({String? userId}) async {
    final db = await database;
    final maps = userId != null 
        ? await db.query('cart', where: 'userId = ?', whereArgs: [userId])
        : await db.query('cart');
    return List.generate(maps.length, (i) => CartItem.fromMap(maps[i]));
  }

  Future<int> updateCartItem(CartItem cartItem) async {
    final db = await database;
    final map = {
      'productId': cartItem.productId,
      'name': cartItem.name,
      'brand': cartItem.brand,
      'price': cartItem.price,
      'image': cartItem.image,
      'size': cartItem.size,
      'category': cartItem.category,
      'quantity': cartItem.quantity,
      'description': cartItem.description,
      'userId': cartItem.userId,
    };
    return await db.update(
      'cart',
      map,
      where: 'id = ?',
      whereArgs: [cartItem.id],
    );
  }

  Future<int> deleteCartItem(int id) async {
    final db = await database;
    return await db.delete(
      'cart',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Add similar CRUD methods for other tables as needed
}
