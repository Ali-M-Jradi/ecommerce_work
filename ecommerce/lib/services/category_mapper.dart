import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';

/// Map classifier keys (like 'face_care') to app Category ids.
/// Uses CategoryProvider to search localized names (en/fr) and returns the matching id or null.
int? mapClassifierKeyToCategoryId(BuildContext context, String classifierKey) {
  final provider = Provider.of<CategoryProvider>(context, listen: false);
  final key = classifierKey.toString().toLowerCase();

  // Common mappings from classifier keys to human-friendly names
  final Map<String, List<String>> canonical = {
    'face_care': ['face', 'visage', 'skincare', 'soin de la peau', 'skin'],
    'body_care': ['body', 'corps', 'body care', 'soin du corps'],
    'hair_care': ['hair', 'cheveux', 'hair care', 'soin des cheveux'],
    'fragrance': ['fragrance', 'parfum'],
    'makeup': ['makeup', 'maquillage'],
    'baby_care': ['baby', 'bebe', 'enfant'],
  // 'pharmaceutical' removed intentionally
  };

  final candidates = canonical[key] ?? [key];

  for (final cat in provider.categories) {
    final en = cat.en.toLowerCase();
    final fr = cat.fr.toLowerCase();
    for (final cand in candidates) {
      final c = cand.toLowerCase();
      if (en.contains(c) || fr.contains(c) || c.contains(en) || c.contains(fr)) {
        return cat.id;
      }
    }
  }

  return null;
}

/// Given a numeric category id (or its string), try to return the canonical classifier key
String? mapCategoryIdToClassifierKey(BuildContext context, dynamic categoryId) {
  final provider = Provider.of<CategoryProvider>(context, listen: false);
  final idStr = categoryId?.toString() ?? '';
  if (idStr.isEmpty) return null;
  int? id;
  try {
    id = int.tryParse(idStr) ?? -1;
  } catch (_) {
    id = -1;
  }

  final cat = provider.getCategoryById(id ?? -1);
  if (cat == null) return null;

  final en = cat.en.toLowerCase();
  final fr = cat.fr.toLowerCase();

  final Map<String, List<String>> canonical = {
    'face_care': ['face', 'visage', 'skincare', 'soin de la peau', 'skin'],
    'body_care': ['body', 'corps', 'body care', 'soin du corps'],
    'hair_care': ['hair', 'cheveux', 'hair care', 'soin des cheveux'],
    'fragrance': ['fragrance', 'parfum'],
    'makeup': ['makeup', 'maquillage'],
    'baby_care': ['baby', 'bebe', 'enfant'],
  // 'pharmaceutical' intentionally omitted
  };

  for (final entry in canonical.entries) {
    for (final cand in entry.value) {
      final c = cand.toLowerCase();
      if (en.contains(c) || fr.contains(c) || c.contains(en) || c.contains(fr)) {
        return entry.key;
      }
    }
  }

  return null;
}
