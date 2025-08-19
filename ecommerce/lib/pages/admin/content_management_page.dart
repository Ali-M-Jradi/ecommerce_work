import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/providers/content_provider.dart';
import '../../models/content_item.dart';

class AdminContentManagementPage extends StatefulWidget {
  const AdminContentManagementPage({super.key});

  @override
  State<AdminContentManagementPage> createState() => _AdminContentManagementPageState();
}

class _AdminContentManagementPageState extends State<AdminContentManagementPage> {
  String _selectedPage = 'All';
  String _selectedSection = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddContentDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ContentProvider>().refreshContent();
            },
          ),
        ],
      ),
      body: Consumer<ContentProvider>(
        builder: (context, contentProvider, child) {
          if (contentProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (contentProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(contentProvider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => contentProvider.refreshContent(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final items = _getFilteredItems(contentProvider.items);
          final pages = _getUniquePages(contentProvider.items);
          final sections = _getUniqueSections(contentProvider.items, _selectedPage);

          return Column(
            children: [
              // Filters
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedPage,
                        decoration: const InputDecoration(
                          labelText: 'Page',
                          border: OutlineInputBorder(),
                        ),
                        items: ['All', ...pages].map((page) {
                          return DropdownMenuItem(value: page, child: Text(page));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPage = value!;
                            _selectedSection = 'All';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedSection,
                        decoration: const InputDecoration(
                          labelText: 'Section',
                          border: OutlineInputBorder(),
                        ),
                        items: ['All', ...sections].map((section) {
                          return DropdownMenuItem(value: section, child: Text(section));
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSection = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              // Content List
              Expanded(
                child: items.isEmpty
                    ? const Center(
                        child: Text('No content items found'),
                      )
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ListTile(
                              title: Text(
                                item.description,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${item.pageName} > ${item.section}'),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.contentData,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: const Row(
                                      children: [
                                        Icon(Icons.edit),
                                        SizedBox(width: 8),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: const Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Delete'),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _showEditContentDialog(item);
                                  } else if (value == 'delete') {
                                    _showDeleteConfirmation(item);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<ContentItem> _getFilteredItems(List<ContentItem> items) {
    return items.where((item) {
      final pageMatch = _selectedPage == 'All' || item.pageName == _selectedPage;
      final sectionMatch = _selectedSection == 'All' || item.section == _selectedSection;
      return pageMatch && sectionMatch;
    }).toList();
  }

  List<String> _getUniquePages(List<ContentItem> items) {
    return items.map((item) => item.pageName).toSet().toList()..sort();
  }

  List<String> _getUniqueSections(List<ContentItem> items, String selectedPage) {
    if (selectedPage == 'All') {
      return items.map((item) => item.section).toSet().toList()..sort();
    }
    return items
        .where((item) => item.pageName == selectedPage)
        .map((item) => item.section)
        .toSet()
        .toList()
      ..sort();
  }

  void _showAddContentDialog() {
    _showContentDialog(null);
  }

  void _showEditContentDialog(ContentItem item) {
    _showContentDialog(item);
  }

  void _showContentDialog(ContentItem? item) {
    final isEdit = item != null;
    final pageController = TextEditingController(text: item?.pageName ?? '');
    final sectionController = TextEditingController(text: item?.section ?? '');
    final descriptionController = TextEditingController(text: item?.description ?? '');
    final contentController = TextEditingController(text: item?.contentData ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Edit Content' : 'Add Content'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: pageController,
                decoration: const InputDecoration(
                  labelText: 'Page Name',
                  hintText: 'e.g., home, footer, AboutUS',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: sectionController,
                decoration: const InputDecoration(
                  labelText: 'Section',
                  hintText: 'e.g., UpperBanner, SocialMedia, Color',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'e.g., PhoneNumber, MainColor, Logo image',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Content Data',
                  hintText: 'The actual content value',
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newItem = ContentItem(
                id: item?.id ?? 0,
                pageName: pageController.text.trim(),
                section: sectionController.text.trim(),
                description: descriptionController.text.trim(),
                contentData: contentController.text.trim(),
              );

              bool success;
              if (isEdit) {
                success = await context.read<ContentProvider>().updateContentItem(newItem);
              } else {
                success = await context.read<ContentProvider>().addContentItem(newItem);
              }

              if (success) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isEdit ? 'Content updated successfully' : 'Content added successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to ${isEdit ? 'update' : 'add'} content'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text(isEdit ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(ContentItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Content'),
        content: Text('Are you sure you want to delete "${item.description}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final success = await context.read<ContentProvider>().deleteContentItem(item.id);
              Navigator.pop(context);
              
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Content deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to delete content'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
