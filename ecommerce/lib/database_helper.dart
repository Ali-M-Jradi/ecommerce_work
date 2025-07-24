
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/product.dart';
import 'models/cart_item.dart';

class DatabaseHelper {
  // Clear all items from cart table (for schema/data reset)
  Future<void> clearCartTable() async {
    final db = await database;
    await db.delete('cart');
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
      version: 1,
      onCreate: _onCreate,
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
        description TEXT
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
        productId INTEGER
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
    };
    return await db.insert('cart', map);
  }

  Future<List<CartItem>> getCartItems() async {
    final db = await database;
    final maps = await db.query('cart');
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
