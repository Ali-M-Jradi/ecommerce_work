


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String _searchQuery = '';
  String _sortBy = 'A to Z';
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductProvider>();
    final products = provider.getFilteredSortedProducts(
      searchQuery: _searchQuery,
      sortBy: _sortBy,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            tooltip: _isGridView ? 'List View' : 'Grid View',
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add Product',
            onPressed: () => _showProductDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (val) => setState(() => _searchQuery = val),
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _sortBy,
                  items: const [
                    DropdownMenuItem(value: 'A to Z', child: Text('A to Z')),
                    DropdownMenuItem(value: 'Z to A', child: Text('Z to A')),
                    DropdownMenuItem(value: 'Price Low', child: Text('Price Low to High')),
                    DropdownMenuItem(value: 'Price High', child: Text('Price High to Low')),
                  ],
                  onChanged: (val) => setState(() => _sortBy = val ?? 'A to Z'),
                ),
              ],
            ),
          ),
          Expanded(
            child: products.isEmpty
                ? Center(child: Text('No products found.'))
                : _isGridView
                    ? GridView.builder(
                        padding: const EdgeInsets.all(16.0),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return _ProductCard(
                            product: product,
                            onEdit: () => _showProductDialog(context, product: product),
                            onDelete: () => provider.deleteProduct(product.id),
                          );
                        },
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: products.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return _ProductListItem(
                            product: product,
                            onEdit: () => _showProductDialog(context, product: product),
                            onDelete: () => provider.deleteProduct(product.id),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void _showProductDialog(BuildContext context, {Product? product}) {
    final nameController = TextEditingController(text: product?.name ?? '');
    final priceController = TextEditingController(text: product?.price.toString() ?? '');
    final brandController = TextEditingController(text: product?.brand ?? '');
    final categoryController = TextEditingController(text: product?.category ?? '');
    final descriptionController = TextEditingController(text: product?.description ?? '');
    final imageController = TextEditingController(text: product?.image ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product == null ? 'Add Product' : 'Edit Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
              TextField(controller: brandController, decoration: const InputDecoration(labelText: 'Brand')),
              TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Category')),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
              TextField(controller: imageController, decoration: const InputDecoration(labelText: 'Image URL')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newProduct = Product(
                id: product?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameController.text,
                price: double.tryParse(priceController.text) ?? 0.0,
                image: imageController.text,
                brand: brandController.text,
                category: categoryController.text,
                description: descriptionController.text,
                size: '',
                rating: 0.0,
                soldOut: false,
              );
              if (product == null) {
                context.read<ProductProvider>().addProduct(newProduct);
              } else {
                context.read<ProductProvider>().updateProduct(newProduct);
              }
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _ProductCard({required this.product, required this.onEdit, required this.onDelete});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: product.image.isNotEmpty
                  ? Image.network(product.image, fit: BoxFit.cover, width: double.infinity)
                  : Container(color: Colors.grey.shade200, child: const Icon(Icons.image, size: 48)),
            ),
            const SizedBox(height: 8),
            Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(product.brand, style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
            Text('Price: ${product.price.toStringAsFixed(2)}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
                IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductListItem extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _ProductListItem({required this.product, required this.onEdit, required this.onDelete});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: product.image.isNotEmpty
            ? Image.network(product.image, width: 48, height: 48, fit: BoxFit.cover)
            : const Icon(Icons.image, size: 48),
        title: Text(product.name),
        subtitle: Text('${product.brand} • ${product.category}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
