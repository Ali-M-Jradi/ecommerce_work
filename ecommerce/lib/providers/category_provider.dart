import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Category {
  final int id;
  final String en;
  final String fr;
  final String ar;
  final IconData icon;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id, 
    required this.en, 
    required this.fr, 
    required this.ar, 
    required this.icon,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Category copyWith({
    String? en, 
    String? fr, 
    String? ar, 
    IconData? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id,
      en: en ?? this.en,
      fr: fr ?? this.fr,
      ar: ar ?? this.ar,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'en': en,
      'fr': fr,
      'ar': ar,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      en: json['en'],
      fr: json['fr'],
      ar: json['ar'],
      icon: IconData(
        json['iconCodePoint'], 
        fontFamily: json['iconFontFamily'],
      ),
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Category{id: $id, en: $en, fr: $fr, ar: $ar}';
}

class CategoryProvider extends ChangeNotifier {
  List<Category> _categories = [];
  bool _isLoading = false;
  int _nextId = 1;

  List<Category> get categories => List.unmodifiable(_categories);
  bool get isLoading => _isLoading;

  CategoryProvider() {
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final categoriesJson = prefs.getString('categories');
      
      if (categoriesJson != null) {
        final List<dynamic> categoriesList = json.decode(categoriesJson);
        _categories = categoriesList.map((json) {
          try {
            return Category.fromJson(json);
          } catch (e) {
            // Handle old format or corrupted data
            debugPrint('Error parsing category JSON, creating fallback: $e');
            return Category(
              id: json['id'] ?? 1,
              en: json['en'] ?? 'Unknown',
              fr: json['fr'] ?? 'Inconnu',
              ar: json['ar'] ?? 'غير معروف',
              icon: Icons.category,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
          }
        }).toList();
        
        // Update next ID based on existing categories
        if (_categories.isNotEmpty) {
          _nextId = _categories.map((c) => c.id).reduce((a, b) => a > b ? a : b) + 1;
        }
      } else {
        // First time - load default categories
        _categories = _getDefaultCategories();
        _nextId = _categories.length + 1;
        await _saveCategories();
      }
    } catch (e) {
      debugPrint('Error loading categories: $e');
      _categories = _getDefaultCategories();
      _nextId = _categories.length + 1;
      // Try to save the default categories
      try {
        await _saveCategories();
      } catch (saveError) {
        debugPrint('Error saving default categories: $saveError');
      }
    }
    _setLoading(false);
  }

  List<Category> _getDefaultCategories() {
    return [
      Category(
        id: 1, 
        en: 'FACE', 
        fr: 'VISAGE', 
        ar: 'وجه', 
        icon: Icons.face,
      ),
      Category(
        id: 2, 
        en: 'SKINCARE', 
        fr: 'SOIN DE LA PEAU', 
        ar: 'العناية بالبشرة', 
        icon: Icons.spa,
      ),
      Category(
        id: 3, 
        en: 'MAKEUP', 
        fr: 'MAQUILLAGE', 
        ar: 'مكياج', 
        icon: Icons.brush,
      ),
      Category(
        id: 4, 
        en: 'HAIR CARE', 
        fr: 'SOIN DES CHEVEUX', 
        ar: 'العناية بالشعر', 
        icon: Icons.face_retouching_natural,
      ),
      Category(
        id: 5, 
        en: 'BODY CARE', 
        fr: 'SOIN DU CORPS', 
        ar: 'العناية بالجسم', 
        icon: Icons.accessibility_new,
      ),
      Category(
        id: 6, 
        en: 'FRAGRANCE', 
        fr: 'PARFUM', 
        ar: 'عطر', 
        icon: Icons.local_florist,
      ),
      Category(
        id: 7, 
        en: 'LIPS', 
        fr: 'LÈVRES', 
        ar: 'شفاه', 
        icon: Icons.favorite,
      ),
      Category(
        id: 8, 
        en: 'EYES', 
        fr: 'YEUX', 
        ar: 'عيون', 
        icon: Icons.visibility,
      ),
    ];
  }

  Future<void> _saveCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final categoriesJson = json.encode(_categories.map((cat) => cat.toJson()).toList());
      await prefs.setString('categories', categoriesJson);
    } catch (e) {
      debugPrint('Error saving categories: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> addCategory(String en, String fr, String ar, {IconData? icon}) async {
    final category = Category(
      id: _nextId++,
      en: en,
      fr: fr,
      ar: ar,
      icon: icon ?? Icons.category,
    );
    
    _categories.add(category);
    await _saveCategories();
    notifyListeners();
  }

  Future<void> updateCategory(Category category, String en, String fr, String ar, {IconData? icon}) async {
    final idx = _categories.indexWhere((c) => c.id == category.id);
    if (idx != -1) {
      _categories[idx] = category.copyWith(
        en: en, 
        fr: fr, 
        ar: ar,
        icon: icon,
        updatedAt: DateTime.now(),
      );
      await _saveCategories();
      notifyListeners();
    }
  }

  Future<void> deleteCategory(Category category) async {
    _categories.removeWhere((c) => c.id == category.id);
    await _saveCategories();
    notifyListeners();
  }

  // Additional utility methods
  Category? getCategoryById(int id) {
    try {
      return _categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Category> searchCategories(String query) {
    if (query.isEmpty) return _categories;
    
    return _categories.where((category) {
      return category.en.toLowerCase().contains(query.toLowerCase()) ||
             category.fr.toLowerCase().contains(query.toLowerCase()) ||
             category.ar.contains(query);
    }).toList();
  }

  Future<void> refreshCategories() async {
    await _loadCategories();
  }

  // Migration method to clear old incompatible data
  Future<void> clearStorageAndReload() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('categories');
      debugPrint('Cleared categories storage');
      await _loadCategories();
    } catch (e) {
      debugPrint('Error clearing categories storage: $e');
    }
  }

  // Statistics
  int get totalCategories => _categories.length;
  
  List<Category> get recentlyAddedCategories {
    final now = DateTime.now();
    return _categories
        .where((cat) {
          try {
            return now.difference(cat.createdAt).inDays <= 7;
          } catch (e) {
            debugPrint('Error checking createdAt for category ${cat.id}: $e');
            return false;
          }
        })
        .toList()
      ..sort((a, b) {
        try {
          return b.createdAt.compareTo(a.createdAt);
        } catch (e) {
          debugPrint('Error sorting categories by createdAt: $e');
          return 0;
        }
      });
  }

  List<Category> get recentlyUpdatedCategories {
    final now = DateTime.now();
    return _categories
        .where((cat) {
          try {
            return now.difference(cat.updatedAt).inDays <= 7;
          } catch (e) {
            debugPrint('Error checking updatedAt for category ${cat.id}: $e');
            return false;
          }
        })
        .toList()
      ..sort((a, b) {
        try {
          return b.updatedAt.compareTo(a.updatedAt);
        } catch (e) {
          debugPrint('Error sorting categories by updatedAt: $e');
          return 0;
        }
      });
  }
}
