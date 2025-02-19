import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_frontend/blocs/inventoryBloc/inventory_bloc.dart';
import 'package:pos_frontend/blocs/inventoryBloc/inventory_event.dart';
import 'package:pos_frontend/blocs/inventoryBloc/inventory_state.dart';
import 'package:pos_frontend/models/inventoryModel/inventoryEntity.dart';
import 'package:pos_frontend/services/apiService.dart';
import 'package:pos_frontend/widgets/app_drawer.dart';
import 'package:pos_frontend/models/categoryModel/categoryEntity.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class InventoryScreen extends StatefulWidget {
  final ApiService apiService;

  const InventoryScreen({Key? key, required this.apiService}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late final InventoryBloc _inventoryBloc;
  List<InventoryEntity> _filteredProducts = [];
  List<InventoryEntity> _products = [];
  final TextEditingController _searchController = TextEditingController();
  String _sortOrder = 'none'; // Add this variable for tracking sort order
  List<InventoryEntity> _currentProducts = [];

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

  void _sortProducts(String order) {
    setState(() {
      _sortOrder = order;
      switch (order) {
        case 'high_to_low':
          _products.sort((a, b) => b.quantity.compareTo(a.quantity));
          break;
        case 'low_to_high':
          _products.sort((a, b) => a.quantity.compareTo(b.quantity));
          break;
        default:
          // Reset to original order if needed
          _inventoryBloc.add(LoadInventory());
          break;
      }
    });
  }

  void _filterProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _products;
      } else {
        _filteredProducts = _products
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
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
              // Add scan button
              IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                onPressed: () => _scanBarcode(context),
              ),
              // Add PopupMenuButton for sorting
              PopupMenuButton<String>(
                icon: const Icon(Icons.filter_list),
                tooltip: 'Sort Products',
                onSelected: (String value) {
                  setState(() {
                    _sortOrder = value;
                    if (_currentProducts.isNotEmpty) {
                      switch (value) {
                        case 'high_to_low':
                          _currentProducts
                              .sort((a, b) => b.quantity.compareTo(a.quantity));
                          break;
                        case 'low_to_high':
                          _currentProducts
                              .sort((a, b) => a.quantity.compareTo(b.quantity));
                          break;
                        case 'none':
                          _currentProducts = List.from(_products);
                          break;
                      }
                    }
                  });
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 'high_to_low',
                    child: Text('Quantity: High to Low'),
                  ),
                  const PopupMenuItem(
                    value: 'low_to_high',
                    child: Text('Quantity: Low to High'),
                  ),
                  const PopupMenuItem(
                    value: 'none',
                    child: Text('Clear Sorting'),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showAddProductDialog(context, barcode: ''),
              ),
            ],
          ),
          drawer: SidebarScreen(apiService: widget.apiService),
          body: BlocBuilder<InventoryBloc, InventoryState>(
            builder: (context, state) {
              if (state is InventoryLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is InventoryError) {
                return Center(child: Text(state.message));
              }
              if (state is InventoryLoaded) {
                List<InventoryEntity> _currentProducts =
                    List.from(state.products);
                // Apply sorting
                switch (_sortOrder) {
                  case 'high_to_low':
                    _currentProducts
                        .sort((a, b) => b.quantity.compareTo(a.quantity));
                    break;
                  case 'low_to_high':
                    _currentProducts
                        .sort((a, b) => a.quantity.compareTo(b.quantity));
                    break;
                  case 'none':
                    // Use original order
                    break;
                }
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
    // Store the products in the state
    _products = List.from(products);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          elevation: 0,
          // color: Colors.green[400],
          margin: const EdgeInsets.only(bottom: 12),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(colors: [
                  Theme.of(context).primaryColor.withOpacity(0.8),
                  Colors.pinkAccent
                ])),
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
                  Text('Price: Rs.${product.price.toStringAsFixed(2)}'),
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
          ),
        );
      },
    );
  }

  Future<void> _scanBarcode(BuildContext context) async {
    MobileScannerController cameraController = MobileScannerController();
    String? scannedCode;

    try {
      print('Starting barcode scanner...');
      scannedCode = await Navigator.of(context).push<String>(
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Scan Barcode'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  cameraController.dispose();
                  Navigator.pop(context);
                },
              ),
            ),
            body: MobileScanner(
              controller: cameraController,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty && barcodes[0].rawValue != null) {
                  print('Successfully scanned barcode: ${barcodes[0].rawValue}');
                  Navigator.pop(context, barcodes[0].rawValue);
                }
              },
            ),
          ),
        ),
      );

      if (scannedCode != null && mounted) {
        // Check if we have saved data for this barcode
        final savedProduct = await _getProductByBarcode(scannedCode);
        
        if (savedProduct != null) {
          if (mounted) {
            _showAddProductDialog(
              context,
              barcode: scannedCode,
              prefillName: savedProduct['name'],
              prefillPrice: savedProduct['price'].toDouble(),
              prefillCategory: null,
            );
          }
        } else {
          // Show dialog to enter new product details
          if (mounted) {
            final result = await showDialog<Map<String, dynamic>>(
              context: context,
              builder: (BuildContext context) {
                final nameController = TextEditingController();
                final priceController = TextEditingController();

                return AlertDialog(
                  title: Text('Barcode: $scannedCode'),
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
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, {
                          'name': nameController.text,
                          'price': double.tryParse(priceController.text) ?? 0.0,
                        });
                      },
                      child: const Text('Save & Add'),
                    ),
                  ],
                );
              },
            );

            if (result != null && mounted) {
              // Save the product data
              await _saveProductBarcode(
                scannedCode,
                result['name'],
                result['price'],
              );

              // Show add product dialog
              _showAddProductDialog(
                context,
                barcode: scannedCode,
                prefillName: result['name'],
                prefillPrice: result['price'],
                prefillCategory: null,
              );
            }
          }
        }
      }
    } catch (e) {
      print('Error during scanning: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error scanning: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (cameraController.isStarting) {
        await cameraController.stop();
      }
      cameraController.dispose();
    }
  }

  Future<void> _saveProductBarcode(String barcode, String name, double price) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final productData = json.encode({
        'name': name,
        'price': price,
      });
      await prefs.setString('barcode_$barcode', productData);
      print('Saved product data for barcode: $barcode');
    } catch (e) {
      print('Error saving product data: $e');
    }
  }

  Future<Map<String, dynamic>?> _getProductByBarcode(String barcode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final productData = prefs.getString('barcode_$barcode');
      if (productData != null) {
        return json.decode(productData);
      }
      return null;
    } catch (e) {
      print('Error retrieving product data: $e');
      return null;
    }
  }

  void _showProductSelectionDialog(BuildContext context, String barcode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Product'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Price: ${product.price}'),
                  onTap: () {
                    Navigator.pop(context); // Close selection dialog
                    _showAddProductDialog(
                      context,
                      barcode: barcode,
                      prefillName: product.name,
                      prefillPrice: product.price,
                      prefillCategory: product.categoryId,
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showAddProductDialog(context, barcode: barcode);
              },
              child: const Text('New Product'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showAddProductDialog(
    BuildContext parentContext, {
    required String barcode,
    String? prefillName,
    double? prefillPrice,
    int? prefillCategory,
  }) {
    final nameController = TextEditingController(text: prefillName ?? '');
    final priceController =
        TextEditingController(text: prefillPrice?.toStringAsFixed(2) ?? '');
    final costPriceController = TextEditingController();
    final quantityController = TextEditingController();
    CategoryEntity? selectedCategory;

    showDialog(
      context: parentContext,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  readOnly: prefillName != null, // Make read-only if pre-filled
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  readOnly:
                      prefillPrice != null, // Make read-only if pre-filled
                ),
                TextField(
                  controller: costPriceController,
                  decoration: const InputDecoration(labelText: 'Cost Price'),
                  keyboardType: TextInputType.number,
                  autofocus: true, // Focus here since it needs manual input
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

                    // Initialize selected category if prefilled
                    if (prefillCategory != null && selectedCategory == null) {
                      selectedCategory = categories.firstWhere(
                        (cat) => cat.id == prefillCategory,
                        orElse: () => categories.first,
                      );
                    }

                    return Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
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
                      ),
                    );
                  },
                ),
              ],
            ),
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
                          costPrice: double.parse(costPriceController.text),
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
    final costPriceController =
        TextEditingController(text: product.cost_price.toStringAsFixed(2));
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
                controller: costPriceController,
                decoration: const InputDecoration(labelText: 'Cost price'),
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
                print('Price: ${costPriceController.text}');
                print('Quantity: ${quantityController.text}');
                print(
                    'Category: ${selectedCategory?.name}, ID: ${selectedCategory?.id}');

                if (nameController.text.isNotEmpty &&
                    priceController.text.isNotEmpty &&
                    costPriceController.text.isNotEmpty &&
                    quantityController.text.isNotEmpty &&
                    selectedCategory?.id != null) {
                  parentContext.read<InventoryBloc>().add(
                        UpdateProduct(
                          id: product.id!,
                          name: nameController.text,
                          price: double.parse(priceController.text),
                          costPrice: double.parse(costPriceController.text),
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
