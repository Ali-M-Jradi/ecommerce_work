import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/brand.dart';

class BrandProvider with ChangeNotifier {
  List<Brand> _brands = [];
  bool _isLoading = false;

  List<Brand> get brands => List.unmodifiable(_brands);
  List<Brand> get activeBrands => _brands.where((brand) => brand.isActive).toList();
  bool get isLoading => _isLoading;

  BrandProvider() {
    _loadBrands();
  }

  Future<void> _loadBrands() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final brandsJson = prefs.getString('brands');
      if (brandsJson != null) {
        final List<dynamic> brandsList = json.decode(brandsJson);
        _brands = brandsList.map((json) => Brand.fromJson(json)).toList();
      } else {
        _brands = _getDefaultBrands();
        await _saveBrands();
      }
    } catch (e) {
      debugPrint('Error loading brands: $e');
      _brands = _getDefaultBrands();
    }
    _setLoading(false);
  }

  List<Brand> _getDefaultBrands() {
    return [
      Brand(
        id: '1',
        nameEn: 'L\'Oréal Paris',
        nameFr: 'L\'Oréal Paris',
        nameAr: 'لوريال باريس',
        description: 'French cosmetics company offering makeup, skincare, and hair care products',
        websiteUrl: 'https://loreal-paris.com',
      ),
      Brand(
        id: '2',
        nameEn: 'Maybelline',
        nameFr: 'Maybelline',
        nameAr: 'مايبلين',
        description: 'American cosmetics brand known for affordable and trendy makeup',
        websiteUrl: 'https://maybelline.com',
      ),
      Brand(
        id: '3',
        nameEn: 'Clinique',
        nameFr: 'Clinique',
        nameAr: 'كلينيك',
        description: 'Premium skincare and cosmetics brand with dermatologist-developed products',
        websiteUrl: 'https://clinique.com',
      ),
      Brand(
        id: '4',
        nameEn: 'The Ordinary',
        nameFr: 'The Ordinary',
        nameAr: 'ذا أورديناري',
        description: 'Skincare brand offering clinical formulations with integrity',
        websiteUrl: 'https://theordinary.com',
      ),
      Brand(
        id: '5',
        nameEn: 'CeraVe',
        nameFr: 'CeraVe',
        nameAr: 'سيرافي',
        description: 'Dermatologist-recommended skincare brand with ceramides',
        websiteUrl: 'https://cerave.com',
      ),
      Brand(
        id: '6',
        nameEn: 'Neutrogena',
        nameFr: 'Neutrogena',
        nameAr: 'نيوتروجينا',
        description: 'Skincare and cosmetics brand recommended by dermatologists',
        websiteUrl: 'https://neutrogena.com',
      ),
      Brand(
        id: '7',
        nameEn: 'Garnier',
        nameFr: 'Garnier',
        nameAr: 'غارنييه',
        description: 'French beauty brand focused on natural ingredients',
        websiteUrl: 'https://garnier.com',
      ),
      Brand(
        id: '8',
        nameEn: 'Revlon',
        nameFr: 'Revlon',
        nameAr: 'ريفلون',
        description: 'American cosmetics company offering makeup and beauty tools',
        websiteUrl: 'https://revlon.com',
      ),
    ];
  }

  Future<void> _saveBrands() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final brandsJson = json.encode(_brands.map((brand) => brand.toJson()).toList());
      await prefs.setString('brands', brandsJson);
    } catch (e) {
      debugPrint('Error saving brands: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> addBrand(Brand brand) async {
    _brands.add(brand);
    await _saveBrands();
    notifyListeners();
  }

  Future<void> updateBrand(Brand updatedBrand) async {
    final index = _brands.indexWhere((brand) => brand.id == updatedBrand.id);
    if (index != -1) {
      _brands[index] = updatedBrand.copyWith(updatedAt: DateTime.now());
      await _saveBrands();
      notifyListeners();
    }
  }

  Future<void> deleteBrand(Brand brand) async {
    _brands.removeWhere((b) => b.id == brand.id);
    await _saveBrands();
    notifyListeners();
  }

  Future<void> toggleBrandStatus(Brand brand) async {
    final updatedBrand = brand.copyWith(
      isActive: !brand.isActive,
      updatedAt: DateTime.now(),
    );
    await updateBrand(updatedBrand);
  }

  Brand? getBrandById(String id) {
    try {
      return _brands.firstWhere((brand) => brand.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Brand> searchBrands(String query) {
    if (query.isEmpty) return _brands;
    
    return _brands.where((brand) {
      return brand.nameEn.toLowerCase().contains(query.toLowerCase()) ||
             brand.nameFr.toLowerCase().contains(query.toLowerCase()) ||
             brand.nameAr.contains(query) ||
             (brand.description?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();
  }

  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  Future<Brand> createBrand({
    required String nameEn,
    required String nameFr,
    required String nameAr,
    String? description,
    String? logoUrl,
    String? websiteUrl,
    bool isActive = true,
  }) async {
    final brand = Brand(
      id: _generateId(),
      nameEn: nameEn,
      nameFr: nameFr,
      nameAr: nameAr,
      description: description,
      logoUrl: logoUrl,
      websiteUrl: websiteUrl,
      isActive: isActive,
    );

    await addBrand(brand);
    return brand;
  }

  Future<void> refreshBrands() async {
    await _loadBrands();
  }

  List<Brand> getBrandsByStatus(bool isActive) {
    return _brands.where((brand) => brand.isActive == isActive).toList();
  }

  int get totalBrands => _brands.length;
  int get activeBrandsCount => _brands.where((brand) => brand.isActive).length;
  int get inactiveBrandsCount => _brands.where((brand) => !brand.isActive).length;
}
