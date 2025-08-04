import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  int _nextId = 4;
  final List<Map<String, dynamic>> _categories = [
    {'id': 1, 'en': 'FACE', 'fr': 'VISAGE', 'ar': 'وجه', 'icon': Icons.face},
    {'id': 2, 'en': 'BODY', 'fr': 'CORPS', 'ar': 'جسم', 'icon': Icons.accessibility_new},
    {'id': 3, 'en': 'HAIR', 'fr': 'CHEVEUX', 'ar': 'شعر', 'icon': Icons.face_retouching_natural},
  ];
  String _search = '';

  void _showCategoryModal({Map<String, dynamic>? category}) {
    final enController = TextEditingController(text: category?['en'] ?? '');
    final frController = TextEditingController(text: category?['fr'] ?? '');
    final arController = TextEditingController(text: category?['ar'] ?? '');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16, right: 16, top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category == null ? 'Add Category' : 'Edit Category',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: enController,
                decoration: const InputDecoration(labelText: 'Description (EN)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: frController,
                decoration: const InputDecoration(labelText: 'Description (FR)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: arController,
                textDirection: TextDirection.rtl,
                decoration: const InputDecoration(labelText: 'الوصف (AR)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('CANCEL'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      final en = enController.text.trim();
                      final fr = frController.text.trim();
                      final ar = arController.text.trim();
                      if (en.isEmpty && fr.isEmpty && ar.isEmpty) return;
                      setState(() {
                        if (category == null) {
                          _categories.add({
                            'id': _nextId++,
                            'en': en,
                            'fr': fr,
                            'ar': ar,
                            'icon': Icons.category,
                          });
                        } else {
                          category['en'] = en;
                          category['fr'] = fr;
                          category['ar'] = ar;
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('SAVE'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryModal(),
        child: const Icon(Icons.add),
        tooltip: 'Add Category',
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _categories.isEmpty
                  ? Center(child: Text('No categories found', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))))
                  : ListView.separated(
                      itemCount: _categories.where((cat) =>
                        cat['en'].toString().toLowerCase().contains(_search.toLowerCase()) ||
                        cat['fr'].toString().toLowerCase().contains(_search.toLowerCase()) ||
                        cat['ar'].toString().toLowerCase().contains(_search.toLowerCase())
                      ).length,
                      separatorBuilder: (context, idx) => const SizedBox(height: 10),
                      itemBuilder: (context, idx) {
                        final filtered = _categories.where((cat) =>
                          cat['en'].toString().toLowerCase().contains(_search.toLowerCase()) ||
                          cat['fr'].toString().toLowerCase().contains(_search.toLowerCase()) ||
                          cat['ar'].toString().toLowerCase().contains(_search.toLowerCase())
                        ).toList();
                        final cat = filtered[idx];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.outline.withOpacity(0.18),
                              width: 1.2,
                            ),
                          ),
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                              child: Icon(cat['icon'] as IconData, color: Theme.of(context).colorScheme.onPrimaryContainer),
                            ),
                            title: Text(cat['en'], style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                            subtitle: Row(
                              children: [
                                Flexible(child: Text(cat['fr'], style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)))),
                                const SizedBox(width: 8),
                                Flexible(child: Text(cat['ar'], style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), fontFamily: 'Roboto', fontWeight: FontWeight.w500, fontSize: 13), textDirection: TextDirection.rtl)),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
                                  onPressed: () => _showCategoryModal(category: cat),
                                  tooltip: 'Edit',
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: Theme.of(context).colorScheme.error),
                                  onPressed: () {
                                    setState(() {
                                      _categories.remove(cat);
                                    });
                                  },
                                  tooltip: 'Delete',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
