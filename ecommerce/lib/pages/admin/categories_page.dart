import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/providers/category_provider.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories Management'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<CategoryProvider>().refreshCategories(),
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCategoryModal(),
            tooltip: 'Add Category',
          ),
        ],
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final filteredCategories = provider.categories.where((cat) =>
            cat.en.toLowerCase().contains(_search.toLowerCase()) ||
            cat.fr.toLowerCase().contains(_search.toLowerCase()) ||
            cat.ar.toLowerCase().contains(_search.toLowerCase())
          ).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with search
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.category, color: Theme.of(context).primaryColor),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Product Categories',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Flexible(
                              child: Chip(
                                avatar: const Icon(Icons.folder, size: 16),
                                label: Text('${provider.categories.length} Categories'),
                                backgroundColor: Colors.blue.shade50,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (provider.recentlyAddedCategories.isNotEmpty)
                              Flexible(
                                child: Chip(
                                  avatar: const Icon(Icons.new_releases, size: 16),
                                  label: Text('${provider.recentlyAddedCategories.length} New'),
                                  backgroundColor: Colors.green.shade50,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Search categories...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            isDense: true,
                          ),
                          onChanged: (value) => setState(() => _search = value),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Categories list
                Expanded(
                  child: filteredCategories.isEmpty
                      ? _buildEmptyState()
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth > 600;
                            return isWide
                                ? _buildDataTable(filteredCategories, provider)
                                : _buildMobileList(filteredCategories, provider);
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            _search.isEmpty ? 'No categories found' : 'No matching categories',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            _search.isEmpty 
                ? 'Add categories to organize your products'
                : 'Try a different search term',
            style: TextStyle(color: Colors.grey.shade500),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showCategoryModal(),
            icon: const Icon(Icons.add),
            label: const Text('Add Category'),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable(List<Category> categories, CategoryProvider provider) {
    return Card(
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('English')),
            DataColumn(label: Text('French')),
            DataColumn(label: Text('Arabic')),
            DataColumn(label: Text('Actions')),
          ],
          rows: categories.map((category) => DataRow(
            cells: [
              DataCell(
                Text(
                  category.en,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              DataCell(Text(category.fr)),
              DataCell(
                Text(
                  category.ar,
                  textDirection: TextDirection.rtl,
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showCategoryModal(category: category),
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                      onPressed: () => _confirmDelete(category, provider),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ),
            ],
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildMobileList(List<Category> categories, CategoryProvider provider) {
    return ListView.separated(
      itemCount: categories.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        category.en,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _showCategoryModal(category: category);
                        } else if (value == 'delete') {
                          _confirmDelete(category, provider);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 20),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (category.fr.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text('Français: ${category.fr}'),
                ],
                if (category.ar.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'عربي: ${category.ar}',
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCategoryModal({Category? category}) {
    final formKey = GlobalKey<FormState>();
    final enController = TextEditingController(text: category?.en ?? '');
    final frController = TextEditingController(text: category?.fr ?? '');
    final arController = TextEditingController(text: category?.ar ?? '');

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category == null ? 'Add Category' : 'Edit Category',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: enController,
                    decoration: const InputDecoration(
                      labelText: 'Name (English)*',
                      hintText: 'e.g., Face Care',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'English name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: frController,
                    decoration: const InputDecoration(
                      labelText: 'Name (French)',
                      hintText: 'e.g., Soin du Visage',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: arController,
                    decoration: const InputDecoration(
                      labelText: 'Name (Arabic)',
                      hintText: 'e.g., العناية بالوجه',
                      border: OutlineInputBorder(),
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => _saveCategory(
                          category,
                          enController,
                          frController,
                          arController,
                          formKey,
                        ),
                        child: Text(category == null ? 'Add' : 'Update'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveCategory(
    Category? category,
    TextEditingController enController,
    TextEditingController frController,
    TextEditingController arController,
    GlobalKey<FormState> formKey,
  ) async {
    if (!formKey.currentState!.validate()) return;

    final en = enController.text.trim();
    final fr = frController.text.trim();
    final ar = arController.text.trim();

    final provider = Provider.of<CategoryProvider>(context, listen: false);

    try {
      if (category == null) {
        await provider.addCategory(en, fr, ar);
      } else {
        await provider.updateCategory(category, en, fr, ar);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              category == null 
                  ? 'Category added successfully' 
                  : 'Category updated successfully',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _confirmDelete(Category category, CategoryProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to delete this category?'),
            const SizedBox(height: 8),
            Text(
              category.en,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (category.fr.isNotEmpty) Text('(${category.fr})'),
            if (category.ar.isNotEmpty) Text('(${category.ar})'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                border: Border.all(color: Colors.orange.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This action cannot be undone.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await provider.deleteCategory(category);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${category.en} deleted successfully')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting category: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
