import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ProductsApiService {

	static Future<List<Map<String, dynamic>>> fetchProducts() async {
		Exception? lastError;
		for (final base in ApiConfig.baseCandidates()) {
			final uri = ApiConfig.itemsUriForBase(base);
			try {
				final resp = await http.get(uri).timeout(const Duration(seconds: 6));
				if (resp.statusCode == 200) {
					final decoded = jsonDecode(resp.body);
					if (decoded is List) {
						final List<Map<String, dynamic>> items = [];
						for (int i = 0; i < decoded.length; i++) {
							final raw = decoded[i];
							if (raw is Map<String, dynamic>) {
								items.add(_normalizeItem(raw, i + 1, base));
							}
						}
						return items;
					} else if (decoded is Map<String, dynamic> && decoded['items'] is List) {
						final list = (decoded['items'] as List).whereType<Map<String, dynamic>>().toList();
						final items = <Map<String, dynamic>>[];
						for (int i = 0; i < list.length; i++) {
							items.add(_normalizeItem(list[i], i + 1, base));
						}
						return items;
					} else {
						throw Exception('Unexpected items payload');
					}
				} else {
					lastError = Exception('Failed with ${resp.statusCode} at ${uri.toString()}');
				}
			} catch (e) {
				lastError = e is Exception ? e : Exception(e.toString());
			}
		}
		throw lastError ?? Exception('Failed to fetch products');
	}

	static Map<String, dynamic> _normalizeItem(Map<String, dynamic> raw, int fallbackId, ({String scheme, String host, int port}) base) {
		// Extract id
		String id = raw['id']?.toString() ?? fallbackId.toString();
		// Try reading price
		double price;
		final rawPrice = raw['price'];
		if (rawPrice is num) {
			price = rawPrice.toDouble();
		} else {
			price = double.tryParse(rawPrice?.toString() ?? '') ?? 0.0;
		}
		// Optional rating
		double rating = 0.0;
		final rawRating = raw['rating'];
		if (rawRating is num) {
			rating = rawRating.toDouble();
		} else {
			rating = double.tryParse(rawRating?.toString() ?? '') ?? 0.0;
		}
		// Build photo URL from id using the selected base
		final photoUrl = ApiConfig.itemPhotoUriForBase(base, id).toString();

		return {
			'id': id,
			'name': raw['name'] ?? raw['title'] ?? {'en': raw['title']?.toString() ?? 'Unnamed Product'},
			'price': price,
			'image': photoUrl, // Prefer a direct URL so widgets load via network immediately
			'brand': raw['brand']?.toString() ?? '',
			'category': raw['category']?.toString() ?? '',
			'description': raw['description'] ?? {'en': ''},
			'size': raw['size']?.toString() ?? 'Not specified',
			'rating': rating,
			'soldOut': raw['soldOut'] == true,
		};
	}
}

