import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/currency.dart';

class CurrencyProvider with ChangeNotifier {
  List<Currency> _currencies = [];
  Currency? _defaultCurrency;
  
  List<Currency> get currencies => _currencies;
  Currency? get defaultCurrency => _defaultCurrency;
  
  CurrencyProvider() {
    _loadCurrencies();
  }

  Future<void> _loadCurrencies() async {
    final prefs = await SharedPreferences.getInstance();
    final currenciesJson = prefs.getStringList('currencies') ?? [];
    
    _currencies = currenciesJson
        .map((json) => Currency.fromMap(jsonDecode(json)))
        .toList();
    
    // Find default currency
    _defaultCurrency = _currencies.firstWhere(
      (currency) => currency.isDefault,
      orElse: () => _currencies.isNotEmpty ? _currencies.first : _getDefaultUSDCurrency(),
    );
    
    // If no currencies exist, add some defaults
    if (_currencies.isEmpty) {
      await _addDefaultCurrencies();
    }
    
    notifyListeners();
  }

  Future<void> _saveCurrencies() async {
    final prefs = await SharedPreferences.getInstance();
    final currenciesJson = _currencies
        .map((currency) => jsonEncode(currency.toMap()))
        .toList();
    await prefs.setStringList('currencies', currenciesJson);
  }

  Currency _getDefaultUSDCurrency() {
    return const Currency(
      id: '1',
      code: 'USD',
      symbol: '\$',
      nameAr: 'دولار أمريكي',
      nameEn: 'US Dollar',
      nameFr: 'Dollar Américain',
      exchangeRate: 1.0,
      isDefault: true,
    );
  }

  Future<void> _addDefaultCurrencies() async {
    final defaultCurrencies = [
      _getDefaultUSDCurrency(),
      const Currency(
        id: '2',
        code: 'EUR',
        symbol: '€',
        nameAr: 'يورو',
        nameEn: 'Euro',
        nameFr: 'Euro',
        exchangeRate: 0.85,
      ),
      const Currency(
        id: '3',
        code: 'FCFA',
        symbol: 'FCFA',
        nameAr: 'فرنك أفريقي',
        nameEn: 'West African CFA franc',
        nameFr: 'Franc CFA',
        exchangeRate: 600.0,
      ),
      const Currency(
        id: '4',
        code: 'GBP',
        symbol: '£',
        nameAr: 'جنيه إسترليني',
        nameEn: 'British Pound',
        nameFr: 'Livre Sterling',
        exchangeRate: 0.73,
      ),
    ];

    _currencies = defaultCurrencies;
    _defaultCurrency = defaultCurrencies.first;
    await _saveCurrencies();
    notifyListeners();
  }

  Future<void> addCurrency(Currency currency) async {
    // Generate new ID
    final newId = (_currencies.length + 1).toString();
    final newCurrency = currency.copyWith(id: newId);
    
    _currencies.add(newCurrency);
    await _saveCurrencies();
    notifyListeners();
  }

  Future<void> updateCurrency(String id, Currency updatedCurrency) async {
    final index = _currencies.indexWhere((currency) => currency.id == id);
    if (index != -1) {
      _currencies[index] = updatedCurrency.copyWith(id: id);
      
      // Update default currency if this was the default
      if (updatedCurrency.isDefault) {
        await _setDefaultCurrency(id);
      }
      
      await _saveCurrencies();
      notifyListeners();
    }
  }

  Future<void> deleteCurrency(String id) async {
    final currency = _currencies.firstWhere((c) => c.id == id);
    
    // Don't allow deleting the default currency
    if (currency.isDefault) {
      throw Exception('Cannot delete the default currency');
    }
    
    _currencies.removeWhere((currency) => currency.id == id);
    await _saveCurrencies();
    notifyListeners();
  }

  Future<void> _setDefaultCurrency(String id) async {
    // Remove default from all currencies
    _currencies = _currencies.map((currency) => 
        currency.copyWith(isDefault: false)).toList();
    
    // Set new default
    final index = _currencies.indexWhere((currency) => currency.id == id);
    if (index != -1) {
      _currencies[index] = _currencies[index].copyWith(isDefault: true);
      _defaultCurrency = _currencies[index];
    }
    
    await _saveCurrencies();
    notifyListeners();
  }

  Future<void> setDefaultCurrency(String id) async {
    await _setDefaultCurrency(id);
  }

  Future<void> toggleCurrencyStatus(String id) async {
    final index = _currencies.indexWhere((currency) => currency.id == id);
    if (index != -1) {
      final currency = _currencies[index];
      
      // Don't allow deactivating the default currency
      if (currency.isDefault && currency.isActive) {
        throw Exception('Cannot deactivate the default currency');
      }
      
      _currencies[index] = currency.copyWith(isActive: !currency.isActive);
      await _saveCurrencies();
      notifyListeners();
    }
  }

  bool codeExists(String code, [String? excludeId]) {
    return _currencies.any((currency) => 
        currency.code.toLowerCase() == code.toLowerCase() && 
        currency.id != excludeId);
  }

  double convertAmount(double amount, String fromCode, String toCode) {
    if (fromCode == toCode) return amount;
    
    final fromCurrency = _currencies.firstWhere(
      (currency) => currency.code == fromCode,
      orElse: () => _defaultCurrency!,
    );
    
    final toCurrency = _currencies.firstWhere(
      (currency) => currency.code == toCode,
      orElse: () => _defaultCurrency!,
    );
    
    // Convert to USD first, then to target currency
    final usdAmount = amount / fromCurrency.exchangeRate;
    return usdAmount * toCurrency.exchangeRate;
  }

  String formatAmount(double amount, String currencyCode) {
    final currency = _currencies.firstWhere(
      (c) => c.code == currencyCode,
      orElse: () => _defaultCurrency!,
    );
    
    return '${currency.symbol}${amount.toStringAsFixed(2)}';
  }
}
