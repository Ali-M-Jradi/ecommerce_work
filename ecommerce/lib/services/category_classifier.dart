// Improved rule-based category classifier with tokenization and field-weighted scoring.
// Returns a category id string matching the app's category keys (e.g. 'face_care').
String classifyCategory(Map<String, dynamic> item) {
  // Helper to extract textual content from a field (works with String or Map-localized values)
  String _fieldText(dynamic v) {
    if (v == null) return '';
    if (v is String) return v.toLowerCase();
    if (v is Map) {
      return v.values.map((e) => (e == null ? '' : e.toString().toLowerCase())).join(' ');
    }
    return v.toString().toLowerCase();
  }

  final nameText = _fieldText(item['name']);
  final descText = _fieldText(item['description']);
  final brandText = _fieldText(item['brand']);
  final sizeText = _fieldText(item['size']);
  final specsText = _fieldText(item['specifications']);
  final extraText = _fieldText(item['UsedTo']) + ' ' + _fieldText(item['Indication']) + ' ' + _fieldText(item['Mechanism']) + ' ' + _fieldText(item['SideEffects']) + ' ' + _fieldText(item['Ingredients']) + ' ' + _fieldText(item['Composition']);

  final combined = ('$nameText $descText $brandText $sizeText $specsText $extraText').replaceAll(RegExp(r"[\p{P}\p{S}]", unicode: true), ' ');

  // Token set for whole word matching
  final tokenReg = RegExp(r"[A-Za-z0-9]+", caseSensitive: false);
  final tokens = <String>{};
  for (final m in tokenReg.allMatches(combined)) {
    tokens.add(m.group(0)!.toLowerCase());
  }

  // Normalize tokens to remove common French accents for matching (e.g., 'lèvres' -> 'levres')
  String _stripAccents(String s) {
    final Map<String, String> map = {
      'à': 'a', 'â': 'a', 'ä': 'a', 'á': 'a', 'ã': 'a', 'å': 'a',
      'ç': 'c',
      'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e',
      'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i',
      'ò': 'o', 'ó': 'o', 'ô': 'o', 'ö': 'o', 'õ': 'o',
      'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u',
      'ý': 'y', 'ÿ': 'y',
      'œ': 'oe', 'æ': 'ae'
    };
    var out = s;
    map.forEach((k, v) {
      out = out.replaceAll(k, v).replaceAll(k.toUpperCase(), v.toUpperCase());
    });
    return out;
  }
  final normalizedTokens = tokens.map((t) => _stripAccents(t)).toSet();

  // Keywords per category (concise but focused). Expand these lists as needed.
  final Map<String, List<String>> keywords = {
    'face_care': [
      'face', 'facial', 'skin', 'moisturizer', 'serum', 'acne', 'cleanser', 'toner', 'spf', 'sunscreen', 'sunblock', 'anti-aging', 'wrinkle', 'eye', 'lip', 'mask',
      // French
      'visage', 'peau', 'hydratant', 'serum', 'nettoyant', 'tonique', 'ecran solaire', 'protection solaire', 'anti-age', 'ride', 'oeil', 'levre'
    ],
    'body_care': [
      'body', 'lotion', 'butter', 'wash', 'shower', 'soap', 'hand', 'foot', 'deodorant', 'body spray', 'body mist', 'moisturizer',
      // French
      'corps', 'lotion', 'beurre', 'gommage', 'bain', 'savon', 'mains', 'pieds', 'deodorant', 'gel douche', 'hydratant'
    ],
    'hair_care': [
      'hair', 'shampoo', 'conditioner', 'scalp', 'dandruff', 'styling', 'leave-in', 'serum', 'treatment',
      // French
      'cheveux', 'shampoing', 'apres-shampoing', 'cuir chevelu', 'pellicule', 'soin', 'coiffant'
    ],
    'fragrance': [
  // Use stronger, explicit fragrance tokens only. Avoid weak/ambiguous words
  // like 'mist' or 'deodorant' which commonly appear in non-fragrance products.
  'perfume', 'fragrance', 'aftershave', 'cologne',
  // French / phrases
  'parfum', 'eau de parfum', 'eau de toilette'
    ],
    'makeup': [
      'makeup', 'foundation', 'concealer', 'eyeshadow', 'mascara', 'lipstick', 'blush', 'primer', 'highlighter',
      // French
      'maquillage', 'fond de teint', 'anticerne', 'fard a paupieres', 'mascara', 'rouge a levres', 'blush'
    ],
    'baby_care': [
      'baby', 'infant', 'toddler', 'kids', 'children', 'baby lotion', 'baby oil', 'baby wipes', 'nappy', 'diaper',
      // French
      'bebe', 'enfant', 'lingette', 'creme bebe', 'huile bebe'
    ],
  // 'pharmaceutical' category removed by request
  };

  // Field weights - name is most important, then description, then brand/specs/extra
  const int NAME_WEIGHT = 5;
  const int DESC_WEIGHT = 3;
  const int BRAND_WEIGHT = 2;
  const int EXTRA_WEIGHT = 1;

  final Map<String, int> scores = {};

  keywords.forEach((cat, keys) {
    int score = 0;
    for (final k in keys) {
      final key = k.toLowerCase();
      final keyNorm = _stripAccents(key);
      // whole-token match on normalized tokens (preferred)
      if (normalizedTokens.contains(keyNorm)) {
        if (_stripAccents(nameText).contains(keyNorm)) score += NAME_WEIGHT;
        if (_stripAccents(descText).contains(keyNorm)) score += DESC_WEIGHT;
        if (_stripAccents(brandText).contains(keyNorm) || _stripAccents(specsText).contains(keyNorm)) score += BRAND_WEIGHT;
        if (_stripAccents(extraText).contains(keyNorm)) score += EXTRA_WEIGHT;
      } else {
        // fallback substring check on normalized combined text
        if (_stripAccents(combined).contains(keyNorm)) score += 1;
      }
    }
    scores[cat] = score;
  });

  // Minimum score thresholds to reduce false positives for some categories
  final Map<String, int> minScores = {
  'fragrance': 4, // require stronger evidence for fragrance
  };

  // Prefer categories with highest score; resolve ties with a priority list
  final sorted = scores.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
  if (sorted.isEmpty) return item['category']?.toString() ?? 'body_care';

  final best = sorted.first;
  final required = minScores[best.key] ?? 0;
  if (best.value < required || best.value == 0) {
    // No matches: prefer original category if present and not empty
    final orig = item['category']?.toString();
    if (orig != null && orig.isNotEmpty) return orig;
    return 'body_care';
  }

  // tie-breaker
  // If top two are very close, prefer original or fall back to safer choice
  // If makeup-related tokens are present, give makeup a small boost so it wins over general 'face' matches
  try {
    final makeupKeys = keywords['makeup']?.map((k) => _stripAccents(k)).toSet() ?? <String>{};
    final bool makeupPresent = normalizedTokens.any((t) => makeupKeys.contains(t));
    if (makeupPresent) {
      scores['makeup'] = (scores['makeup'] ?? 0) + NAME_WEIGHT;
    }
  } catch (_) {}

  if (sorted.length > 1 && (sorted[0].value == sorted[1].value || (sorted[0].value - sorted[1].value) < 2)) {
    // Prefer makeup over face_care when ambiguous
    final preferred = ['makeup', 'face_care', 'hair_care', 'body_care', 'fragrance', 'baby_care'];
    for (final p in preferred) {
      if (scores[p] != null && scores[p] == best.value) return p;
    }
  }

  return best.key;
}
