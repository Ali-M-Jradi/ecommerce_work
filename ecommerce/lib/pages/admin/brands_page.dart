import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/brand_provider.dart';
import '../../models/brand.dart';
import '../../utils/app_colors.dart';

class BrandsPage extends StatefulWidget {
  const BrandsPage({super.key});

  @override
  State<BrandsPage> createState() => _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage> {
  String _searchQuery = '';
  bool _showActiveOnly = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Brand Management'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => context.read<BrandProvider>().refreshBrands(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Consumer<BrandProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildHeader(context, provider),
                const SizedBox(height: 16),
                _buildFilters(),
                const SizedBox(height: 16),
                Expanded(
                  child: isDesktop 
                      ? _buildDesktopView(provider)
                      : _buildMobileView(provider),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _showBrandModal(context),
          icon: Icon(Icons.store_mall_directory, size: 24),
          label: Text(
            'Add Brand',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          elevation: 8,
          highlightElevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, BrandProvider provider) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Brands Overview',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${provider.totalBrands} total brands • ${provider.activeBrandsCount} active • ${provider.inactiveBrandsCount} inactive',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.branding_watermark,
                size: 32,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search brands...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              isDense: true,
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),
        ),
        const SizedBox(width: 16),
        FilterChip(
          label: const Text('Active Only'),
          selected: _showActiveOnly,
          onSelected: (selected) => setState(() => _showActiveOnly = selected),
          selectedColor: Theme.of(context).colorScheme.primaryContainer,
        ),
      ],
    );
  }

  Widget _buildDesktopView(BrandProvider provider) {
    final filteredBrands = _getFilteredBrands(provider);
    
    if (filteredBrands.isEmpty) {
      return _buildEmptyState();
    }

    return Card(
      elevation: 1,
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Brand')),
            DataColumn(label: Text('Names (EN/FR/AR)')),
            DataColumn(label: Text('Description')),
            DataColumn(label: Text('Website')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Actions')),
          ],
          rows: filteredBrands.map((brand) {
            return DataRow(
              cells: [
                DataCell(
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: brand.logoUrl != null
                            ? ClipOval(child: Image.network(brand.logoUrl!, errorBuilder: (_, __, ___) => 
                                Icon(Icons.branding_watermark, color: Theme.of(context).colorScheme.onPrimaryContainer)))
                            : Icon(Icons.branding_watermark, color: Theme.of(context).colorScheme.onPrimaryContainer),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        brand.nameEn,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                DataCell(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(brand.nameEn, style: const TextStyle(fontSize: 12)),
                      Text(brand.nameFr, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      Text(brand.nameAr, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant), textDirection: TextDirection.rtl),
                    ],
                  ),
                ),
                DataCell(
                  SizedBox(
                    width: 150,
                    child: Text(
                      brand.description ?? 'No description',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: brand.description == null 
                            ? Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6)
                            : null,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  brand.websiteUrl != null
                      ? InkWell(
                          onTap: () {
                            // Open URL logic would go here
                          },
                          child: Text(
                            brand.websiteUrl!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              decoration: TextDecoration.underline,
                              fontSize: 12,
                            ),
                          ),
                        )
                      : Text('--', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.6))),
                ),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: brand.isActive 
                          ? AppColors.success(context).withOpacity(0.1)
                          : AppColors.error(context).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: brand.isActive ? AppColors.success(context) : AppColors.error(context),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      brand.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        color: brand.isActive ? AppColors.success(context) : AppColors.error(context),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          brand.isActive ? Icons.visibility_off : Icons.visibility,
                          size: 18,
                        ),
                        onPressed: () => provider.toggleBrandStatus(brand),
                        tooltip: brand.isActive ? 'Deactivate' : 'Activate',
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        onPressed: () => _showBrandModal(context, brand: brand),
                        tooltip: 'Edit',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 18),
                        onPressed: () => _showDeleteConfirmation(context, brand, provider),
                        tooltip: 'Delete',
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMobileView(BrandProvider provider) {
    final filteredBrands = _getFilteredBrands(provider);
    
    if (filteredBrands.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      itemCount: filteredBrands.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final brand = filteredBrands[index];
        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: brand.logoUrl != null
                          ? ClipOval(child: Image.network(brand.logoUrl!, errorBuilder: (_, __, ___) => 
                              Icon(Icons.branding_watermark, color: Theme.of(context).colorScheme.onPrimaryContainer)))
                          : Icon(Icons.branding_watermark, color: Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            brand.nameEn,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '${brand.nameFr} • ${brand.nameAr}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: brand.isActive 
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: brand.isActive ? Colors.green : Colors.red,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        brand.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(
                          color: brand.isActive ? Colors.green.shade700 : Colors.red.shade700,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                if (brand.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    brand.description!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
                if (brand.websiteUrl != null) ...[
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () {
                      // Open URL logic would go here
                    },
                    child: Text(
                      brand.websiteUrl!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => provider.toggleBrandStatus(brand),
                      icon: Icon(
                        brand.isActive ? Icons.visibility_off : Icons.visibility,
                        size: 16,
                      ),
                      label: Text(brand.isActive ? 'Deactivate' : 'Activate'),
                    ),
                    TextButton.icon(
                      onPressed: () => _showBrandModal(context, brand: brand),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit'),
                    ),
                    TextButton.icon(
                      onPressed: () => _showDeleteConfirmation(context, brand, provider),
                      icon: const Icon(Icons.delete, size: 16),
                      label: const Text('Delete'),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.branding_watermark_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No brands found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty 
                ? 'Try adjusting your search terms'
                : 'Start by adding your first brand',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  List<Brand> _getFilteredBrands(BrandProvider provider) {
    var brands = provider.searchBrands(_searchQuery);
    if (_showActiveOnly) {
      brands = brands.where((brand) => brand.isActive).toList();
    }
    return brands;
  }

  void _showBrandModal(BuildContext context, {Brand? brand}) {
    showDialog(
      context: context,
      builder: (context) => _BrandFormDialog(brand: brand),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Brand brand, BrandProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Brand'),
        content: Text('Are you sure you want to delete "${brand.nameEn}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteBrand(brand);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Brand "${brand.nameEn}" deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _BrandFormDialog extends StatefulWidget {
  final Brand? brand;

  const _BrandFormDialog({this.brand});

  @override
  State<_BrandFormDialog> createState() => _BrandFormDialogState();
}

class _BrandFormDialogState extends State<_BrandFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameEnController;
  late final TextEditingController _nameFrController;
  late final TextEditingController _nameArController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _logoUrlController;
  late final TextEditingController _websiteUrlController;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _nameEnController = TextEditingController(text: widget.brand?.nameEn ?? '');
    _nameFrController = TextEditingController(text: widget.brand?.nameFr ?? '');
    _nameArController = TextEditingController(text: widget.brand?.nameAr ?? '');
    _descriptionController = TextEditingController(text: widget.brand?.description ?? '');
    _logoUrlController = TextEditingController(text: widget.brand?.logoUrl ?? '');
    _websiteUrlController = TextEditingController(text: widget.brand?.websiteUrl ?? '');
    _isActive = widget.brand?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameEnController.dispose();
    _nameFrController.dispose();
    _nameArController.dispose();
    _descriptionController.dispose();
    _logoUrlController.dispose();
    _websiteUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.brand == null ? 'Add Brand' : 'Edit Brand'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameEnController,
                  decoration: const InputDecoration(
                    labelText: 'Brand Name (English) *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.isEmpty == true ? 'English name is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameFrController,
                  decoration: const InputDecoration(
                    labelText: 'Brand Name (French) *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.isEmpty == true ? 'French name is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameArController,
                  decoration: const InputDecoration(
                    labelText: 'Brand Name (Arabic) *',
                    border: OutlineInputBorder(),
                  ),
                  textDirection: TextDirection.rtl,
                  validator: (value) => value?.isEmpty == true ? 'Arabic name is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _logoUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Logo URL',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _websiteUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Website URL',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Active'),
                  value: _isActive,
                  onChanged: (value) => setState(() => _isActive = value),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveBrand,
          child: Text(widget.brand == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }

  void _saveBrand() {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<BrandProvider>();
    
    if (widget.brand == null) {
      // Adding new brand
      provider.createBrand(
        nameEn: _nameEnController.text,
        nameFr: _nameFrController.text,
        nameAr: _nameArController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        logoUrl: _logoUrlController.text.isEmpty ? null : _logoUrlController.text,
        websiteUrl: _websiteUrlController.text.isEmpty ? null : _websiteUrlController.text,
        isActive: _isActive,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Brand added successfully')),
      );
    } else {
      // Updating existing brand
      final updatedBrand = widget.brand!.copyWith(
        nameEn: _nameEnController.text,
        nameFr: _nameFrController.text,
        nameAr: _nameArController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        logoUrl: _logoUrlController.text.isEmpty ? null : _logoUrlController.text,
        websiteUrl: _websiteUrlController.text.isEmpty ? null : _websiteUrlController.text,
        isActive: _isActive,
      );
      provider.updateBrand(updatedBrand);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Brand updated successfully')),
      );
    }

    Navigator.pop(context);
  }
}
