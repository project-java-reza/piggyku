import 'package:flutter/material.dart';

class CategoryModel {
  final int id;
  final String name;
  final String type; // 'income' or 'expense'
  final String icon;
  final Color color;

  CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
  });
}

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data for categories
  final List<CategoryModel> _incomeCategories = [
    CategoryModel(
      id: 1,
      name: 'Salary',
      type: 'income',
      icon: '💰',
      color: Colors.green,
    ),
    CategoryModel(
      id: 2,
      name: 'Freelance',
      type: 'income',
      icon: '💻',
      color: Colors.blue,
    ),
    CategoryModel(
      id: 3,
      name: 'Business',
      type: 'income',
      icon: '💼',
      color: Colors.purple,
    ),
    CategoryModel(
      id: 4,
      name: 'Investment',
      type: 'income',
      icon: '📈',
      color: Colors.orange,
    ),
    CategoryModel(
      id: 5,
      name: 'Rental',
      type: 'income',
      icon: '🏠',
      color: Colors.teal,
    ),
    CategoryModel(
      id: 6,
      name: 'Other Income',
      type: 'income',
      icon: '💵',
      color: Colors.grey,
    ),
  ];

  final List<CategoryModel> _expenseCategories = [
    CategoryModel(
      id: 7,
      name: 'Food & Beverages',
      type: 'expense',
      icon: '🍔',
      color: Colors.red,
    ),
    CategoryModel(
      id: 8,
      name: 'Shopping',
      type: 'expense',
      icon: '🛍️',
      color: Colors.pink,
    ),
    CategoryModel(
      id: 9,
      name: 'Transportation',
      type: 'expense',
      icon: '🚗',
      color: Colors.indigo,
    ),
    CategoryModel(
      id: 10,
      name: 'Bills & Utilities',
      type: 'expense',
      icon: '📱',
      color: Colors.blueGrey,
    ),
    CategoryModel(
      id: 11,
      name: 'Healthcare',
      type: 'expense',
      icon: '🏥',
      color: Colors.green,
    ),
    CategoryModel(
      id: 12,
      name: 'Education',
      type: 'expense',
      icon: '📚',
      color: Colors.amber,
    ),
    CategoryModel(
      id: 13,
      name: 'Entertainment',
      type: 'expense',
      icon: '🎮',
      color: Colors.deepOrange,
    ),
    CategoryModel(
      id: 14,
      name: 'Travel',
      type: 'expense',
      icon: '✈️',
      color: Colors.cyan,
    ),
    CategoryModel(
      id: 15,
      name: 'Other Expense',
      type: 'expense',
      icon: '📝',
      color: Colors.grey,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: const Color(0xFF2196F3),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Income'),
            Tab(text: 'Expense'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddCategoryDialog,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCategoryList(_incomeCategories, true),
          _buildCategoryList(_expenseCategories, false),
        ],
      ),
    );
  }

  Widget _buildCategoryList(List<CategoryModel> categories, bool isIncome) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryCard(category);
        },
      ),
    );
  }

  Widget _buildCategoryCard(CategoryModel category) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              category.color.withValues(alpha: 0.1),
              category.color.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: InkWell(
          onTap: () {
            _showCategoryOptions(category);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: category.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    category.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: category.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    category.type,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: category.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddCategoryDialog() {
    final nameController = TextEditingController();
    String selectedType = 'expense';
    String selectedIcon = '📝';
    Color selectedColor = Colors.grey;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Category'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'income', child: Text('Income')),
                    DropdownMenuItem(value: 'expense', child: Text('Expense')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text('Icon'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ['💰', '💻', '💼', '📈', '🏠', '🍔', '🛍️', '🚗', '📱', '🏥', '📚', '🎮', '✈️', '📝']
                      .map((icon) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIcon = icon;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: selectedIcon == icon
                                ? const Color(0xFF2196F3)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(icon, style: const TextStyle(fontSize: 20)),
                        ),
                      ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                const Text('Color'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Colors.red,
                    Colors.pink,
                    Colors.purple,
                    Colors.blue,
                    Colors.green,
                    Colors.orange,
                    Colors.amber,
                    Colors.grey,
                  ]
                      .map((color) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColor = color;
                          });
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: selectedColor == color
                                ? Border.all(color: Colors.black, width: 2)
                                : null,
                          ),
                        ),
                      ))
                      .toList(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  // TODO: Save category to database
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Category added successfully')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryOptions(CategoryModel category) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit, color: Colors.blue),
              title: const Text('Edit Category'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Show edit dialog
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Category'),
              onTap: () {
                Navigator.of(context).pop();
                _showDeleteConfirmation(category);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(CategoryModel category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Delete category from database
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Category deleted successfully')),
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