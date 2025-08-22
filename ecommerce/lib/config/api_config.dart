import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Centralized API configuration with sensible development defaults.
///
/// Goals:
/// - Provide base URI candidates that work across emulator/device/desktop.
/// - Prefer HTTPS localhost in dev if the certificate is trusted; otherwise provide HTTP fallbacks.
/// - Allow optional LAN IP override when testing on a physical device.
class ApiConfig {
  /// Optionally override the base host:port at runtime (e.g., from settings).
  /// Set to something like '192.168.1.8:7184' to use your machine's LAN IP.
  static String? overrideHostWithPort;

  /// Default dev port for the ASP.NET backend.
  static const int defaultPort = 7184;

  /// Returns a list of base candidates to try, in priority order.
  /// Each entry is a tuple-like map: { 'scheme': 'https'|'http', 'host': '...', 'port': int }
  static List<({String scheme, String host, int port})> baseCandidates() {
    final List<({String scheme, String host, int port})> list = [];

    // If user provided an explicit override, try it first (https then http)
    final override = overrideHostWithPort;
    if (override != null && override.trim().isNotEmpty) {
      final parts = override.split(':');
      final host = parts.first;
      final port = parts.length > 1 ? int.tryParse(parts[1]) ?? defaultPort : defaultPort;
      list.add((scheme: 'https', host: host, port: port));
      list.add((scheme: 'http', host: host, port: port));
    }

    // Web: use current origin host if possible (localhost during dev)
    if (kIsWeb) {
      // On web, localhost is typically fine in dev if served from same host.
      list.add((scheme: 'https', host: 'localhost', port: defaultPort));
      list.add((scheme: 'http', host: 'localhost', port: defaultPort));
    } else {
      // Mobile/Desktop
      final bool isAndroid = Platform.isAndroid;
      // 1) Prefer HTTPS localhost (works for desktop/simulator with trusted cert)
      list.add((scheme: 'https', host: 'localhost', port: defaultPort));

      // 2) Emulator/loopback fallbacks (HTTP) for when HTTPS certs aren't trusted
      if (isAndroid) {
        // Android emulator loopback
        list.add((scheme: 'http', host: '10.0.2.2', port: defaultPort));
      }
      list.add((scheme: 'http', host: '127.0.0.1', port: defaultPort));
      list.add((scheme: 'http', host: 'localhost', port: defaultPort));
    }

    return list;
  }

  static Uri itemsUriForBase(({String scheme, String host, int port}) base) =>
      Uri(scheme: base.scheme, host: base.host, port: base.port, path: '/api/items');

  static Uri itemPhotoUriForBase(({String scheme, String host, int port}) base, String id) =>
      Uri(scheme: base.scheme, host: base.host, port: base.port, path: '/api/item-photo/$id');
}
