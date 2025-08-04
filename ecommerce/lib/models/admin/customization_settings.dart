class CustomizationSettings {
  final String themeMode; // e.g. 'light', 'dark', 'system'
  final String? primaryColor; // hex string, e.g. '#673AB7'
  final String? logoUrl; // URL or asset path

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
}
