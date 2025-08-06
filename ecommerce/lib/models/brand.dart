class Brand {
  final String id;
  final String nameEn;
  final String nameFr;
  final String nameAr;
  final String? description;
  final String? logoUrl;
  final String? websiteUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Brand({
    required this.id,
    required this.nameEn,
    required this.nameFr,
    required this.nameAr,
    this.description,
    this.logoUrl,
    this.websiteUrl,
    this.isActive = true,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameFr': nameFr,
      'nameAr': nameAr,
      'description': description,
      'logoUrl': logoUrl,
      'websiteUrl': websiteUrl,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'],
      nameEn: json['nameEn'],
      nameFr: json['nameFr'],
      nameAr: json['nameAr'],
      description: json['description'],
      logoUrl: json['logoUrl'],
      websiteUrl: json['websiteUrl'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Brand copyWith({
    String? id,
    String? nameEn,
    String? nameFr,
    String? nameAr,
    String? description,
    String? logoUrl,
    String? websiteUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Brand(
      id: id ?? this.id,
      nameEn: nameEn ?? this.nameEn,
      nameFr: nameFr ?? this.nameFr,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String getLocalizedName(String locale) {
    switch (locale) {
      case 'fr':
        return nameFr;
      case 'ar':
        return nameAr;
      default:
        return nameEn;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Brand && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Brand{id: $id, nameEn: $nameEn, nameFr: $nameFr, nameAr: $nameAr}';
  }
}
