/// Model for admin customization settings (theme, color, logo, etc.)
class CustomizationSettings {
  final String themeMode;
  final String? primaryColor;
  final String? secondaryColor;
  final String? logoUrl;

  CustomizationSettings({
    required this.themeMode,
    this.primaryColor,
    this.secondaryColor,
    this.logoUrl,
  });

  factory CustomizationSettings.fromJson(Map<String, dynamic> json) {
    return CustomizationSettings(
      themeMode: json['themeMode'] ?? 'light',
      primaryColor: json['primaryColor'],
      secondaryColor: json['secondaryColor'],
      logoUrl: json['logoUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        'themeMode': themeMode,
        'primaryColor': primaryColor,
        'secondaryColor': secondaryColor,
        'logoUrl': logoUrl,
      };

  CustomizationSettings copyWith({
    String? themeMode,
    String? primaryColor,
    String? secondaryColor,
    String? logoUrl,
  }) {
    return CustomizationSettings(
      themeMode: themeMode ?? this.themeMode,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }
}
