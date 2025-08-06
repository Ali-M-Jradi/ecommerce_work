class Currency {
  final String id;
  final String code;
  final String symbol;
  final String nameAr;
  final String nameEn;
  final String nameFr;
  final double exchangeRate;
  final bool isDefault;
  final bool isActive;

  const Currency({
    required this.id,
    required this.code,
    required this.symbol,
    required this.nameAr,
    required this.nameEn,
    required this.nameFr,
    required this.exchangeRate,
    this.isDefault = false,
    this.isActive = true,
  });

  Currency copyWith({
    String? id,
    String? code,
    String? symbol,
    String? nameAr,
    String? nameEn,
    String? nameFr,
    double? exchangeRate,
    bool? isDefault,
    bool? isActive,
  }) {
    return Currency(
      id: id ?? this.id,
      code: code ?? this.code,
      symbol: symbol ?? this.symbol,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      nameFr: nameFr ?? this.nameFr,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'symbol': symbol,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'nameFr': nameFr,
      'exchangeRate': exchangeRate,
      'isDefault': isDefault,
      'isActive': isActive,
    };
  }

  factory Currency.fromMap(Map<String, dynamic> map) {
    return Currency(
      id: map['id'] ?? '',
      code: map['code'] ?? '',
      symbol: map['symbol'] ?? '',
      nameAr: map['nameAr'] ?? '',
      nameEn: map['nameEn'] ?? '',
      nameFr: map['nameFr'] ?? '',
      exchangeRate: (map['exchangeRate'] ?? 0.0).toDouble(),
      isDefault: map['isDefault'] ?? false,
      isActive: map['isActive'] ?? true,
    );
  }

  @override
  String toString() {
    return 'Currency(id: $id, code: $code, symbol: $symbol, nameEn: $nameEn, exchangeRate: $exchangeRate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Currency && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
