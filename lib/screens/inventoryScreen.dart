import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_frontend/blocs/inventoryBloc/inventory_bloc.dart';
import 'package:pos_frontend/blocs/inventoryBloc/inventory_event.dart';
import 'package:pos_frontend/blocs/inventoryBloc/inventory_state.dart';
import 'package:pos_frontend/models/inventoryModel/inventoryEntity.dart';
import 'package:pos_frontend/services/apiService.dart';
import 'package:pos_frontend/widgets/app_drawer.dart';
import 'package:pos_frontend/models/categoryModel/categoryEntity.dart';

class InventoryScreen extends StatefulWidget {
  final ApiService apiService;

  const InventoryScreen({Key? key, required this.apiService}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late final InventoryBloc _inventoryBloc;

  @override
  void initState() {
    super.initState();
    _inventoryBloc = InventoryBloc(apiService: widget.apiService);
    _inventoryBloc.add(LoadInventory());
  }

  @override
  void dispose() {
    _inventoryBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _inventoryBloc,
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Inventory'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showAddProductDialog(context),
              ),
            ],
          ),
          drawer: const SidebarScreen(),
          body: BlocBuilder<InventoryBloc, InventoryState>(
            builder: (context, state) {
              if (state is InventoryLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is InventoryError) {
                return Center(child: Text(state.message));
              }
              if (state is InventoryLoaded) {
                return _buildProductList(context, state.products);
              }
              return const Center(child: Text('No products found'));
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProductList(
      BuildContext context, List<InventoryEntity> products) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(
              product.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Price: \$${product.price.toStringAsFixed(2)}'),
                Text('Quantity: ${product.quantity}'),
                if (product.categoryName != null)
                  Text('Category: ${product.categoryName}'),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete'),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  _showEditProductDialog(context, product);
                } else if (value == 'delete') {
                  _showDeleteConfirmation(context, product);
                }
              },
            ),
          ),
        );
      },
    );
  }

  void _showAddProductDialog(BuildContext parentContext) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final quantityController = TextEditingController();
    CategoryEntity? selectedCategory;

    showDialog(
      context: parentContext,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                autofocus: true,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<CategoryEntity>>(
                future: widget.apiService.getCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    print('Category loading error: ${snapshot.error}');
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No categories available');
                  }

                  final categories = snapshot.data!;
                  // Debug prints
                  print('Categories loaded:');
                  for (var category in categories) {
                    print('Category: ${category.name}, ID: ${category.id}');
                  }

                  // Force initialize selectedCategory if it's null
                  selectedCategory ??= categories.first;
                  print(
                      'Selected category: ${selectedCategory?.name}, ID: ${selectedCategory?.id}');

                  return Column(
                    children: [
                      DropdownButtonFormField<CategoryEntity>(
                        decoration: const InputDecoration(
                          labelText: 'Category',
                        ),
                        value: selectedCategory,
                        items: categories.map((category) {
                          return DropdownMenuItem<CategoryEntity>(
                            value: category,
                            child: Text(
                                '${category.name} (ID: ${category.id})'), // Show ID in dropdown
                          );
                        }).toList(),
                        onChanged: (CategoryEntity? value) {
                          print(
                              'Category changed to: ${value?.name}, ID: ${value?.id}');
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),
                      // Debug text to show current selection
                      Text(
                          'Current selection: ${selectedCategory?.name ?? "none"} (ID: ${selectedCategory?.id})')
                    ],
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    priceController.text.isNotEmpty &&
                    quantityController.text.isNotEmpty &&
                    selectedCategory?.id != null) {
                  print('Adding product with data:');
                  print('Name: ${nameController.text}');
                  print('Price: ${priceController.text}');
                  print('Quantity: ${quantityController.text}');
                  print('Category ID: ${selectedCategory!.id}');

                  parentContext.read<InventoryBloc>().add(
                        AddProduct(
                          name: nameController.text,
                          price: double.parse(priceController.text),
                          quantity: int.parse(quantityController.text),
                          categoryId: selectedCategory!.id!,
                        ),
                      );
                  Navigator.pop(dialogContext);
                } else {
                  print('Validation failed:');
                  print('Name empty: ${nameController.text.isEmpty}');
                  print('Price empty: ${priceController.text.isEmpty}');
                  print('Quantity empty: ${quantityController.text.isEmpty}');
                  print('Category null: ${selectedCategory?.id == null}');
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProductDialog(
      BuildContext parentContext, InventoryEntity product) {
    if (product.id == null) return;

    print('Editing product: ${product}'); // Debug print for product data

    final nameController = TextEditingController(text: product.name);
    final priceController =
        TextEditingController(text: product.price.toStringAsFixed(2));
    final quantityController =
        TextEditingController(text: product.quantity.toString());
    CategoryEntity? selectedCategory;

    showDialog(
      context: parentContext,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Edit Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                autofocus: true,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              FutureBuilder<List<CategoryEntity>>(
                future: widget.apiService.getCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    print('Category loading error: ${snapshot.error}');
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No categories available');
                  }

                  final categories = snapshot.data!;
                  print(
                      'Available categories: ${categories.map((c) => 'Name: ${c.name}').join(', ')}');
                  print(
                      'Product being edited: ID: ${product.id}, CategoryName: ${product.categoryName}');

                  // Initialize selectedCategory with the matching category name from the product
                  if (selectedCategory == null &&
                      product.categoryName != null) {
                    selectedCategory = categories.firstWhere(
                      (category) {
                        print(
                            'Comparing category name ${category.name} with product category name ${product.categoryName}');
                        return category.name == product.categoryName;
                      },
                      orElse: () {
                        print(
                            'No matching category found, using first category');
                        return categories.first;
                      },
                    );
                    print(
                        'Initialized selected category: Name: ${selectedCategory?.name}');
                  }

                  return Column(
                    children: [
                      DropdownButtonFormField<CategoryEntity>(
                        decoration: const InputDecoration(
                          labelText: 'Category',
                        ),
                        value: selectedCategory,
                        items: categories.map((category) {
                          return DropdownMenuItem<CategoryEntity>(
                            value: category,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (CategoryEntity? value) {
                          print('Category changed to: Name: ${value?.name}');
                          setState(() {
                            selectedCategory = value;
                          });
                        },
                      ),
                      if (selectedCategory != null)
                        Text('Selected: ${selectedCategory?.name}'),
                    ],
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                print('Attempting to update product:');
                print('Name: ${nameController.text}');
                print('Price: ${priceController.text}');
                print('Quantity: ${quantityController.text}');
                print(
                    'Category: ${selectedCategory?.name}, ID: ${selectedCategory?.id}');

                if (nameController.text.isNotEmpty &&
                    priceController.text.isNotEmpty &&
                    quantityController.text.isNotEmpty &&
                    selectedCategory?.id != null) {
                  parentContext.read<InventoryBloc>().add(
                        UpdateProduct(
                          id: product.id!,
                          name: nameController.text,
                          price: double.parse(priceController.text),
                          quantity: int.parse(quantityController.text),
                          categoryId: selectedCategory!.id!,
                        ),
                      );
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext parentContext, InventoryEntity product) {
    if (product.id == null) return;

    showDialog(
      context: parentContext,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete ${product.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              parentContext
                  .read<InventoryBloc>()
                  .add(DeleteProduct(id: product.id!));
              Navigator.pop(dialogContext);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
