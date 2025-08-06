/// Model for admin customization settings (theme, color, logo, etc.)
class CustomizationSettings {
  final String themeMode;
  final String? primaryColor;
  final String? logoUrl;

  CustomizationSettings({
    required this.themeMode,
    this.primaryColor,
    this.logoUrl,
  });

  factory CustomizationSettings.fromJson(Map<String, dynamic> json) {
    return CustomizationSettings(
      themeMode: json['themeMode'] ?? 'light',
      primaryColor: json['primaryColor'],
      logoUrl: json['logoUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        'themeMode': themeMode,
        'primaryColor': primaryColor,
        'logoUrl': logoUrl,
      };

  CustomizationSettings copyWith({
    String? themeMode,
    String? primaryColor,
    String? logoUrl,
  }) {
    return CustomizationSettings(
      themeMode: themeMode ?? this.themeMode,
      primaryColor: primaryColor ?? this.primaryColor,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }
}
