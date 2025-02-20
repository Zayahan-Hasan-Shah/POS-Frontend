// import 'package:flutter/material.dart';
// import 'package:pos_frontend/models/inventoryModel/inventoryEntity.dart';
// import 'package:pos_frontend/services/apiService.dart';
// import 'package:pos_frontend/widgets/app_drawer.dart';
// import 'package:pos_frontend/screens/paymentScreen.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import 'package:pos_frontend/models/cartModel/cartItem.dart';

// class CartScreen extends StatefulWidget {
//   final ApiService apiService;

//   const CartScreen({super.key, required this.apiService});

//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   List<InventoryEntity> _products = [];
//   Map<InventoryEntity, int> cart = {};
//   double total = 0;
//   List<InventoryEntity> _filteredProducts = [];
//   bool _isLoading = true;
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _loadInventory();
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadInventory() async {
//     try {
//       final products = await widget.apiService.getInventory();
//       setState(() {
//         _products = products;
//         _filteredProducts = products;
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading inventory: $e');
//       setState(() => _isLoading = false);
//     }
//   }

//   void _filterProducts(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         _filteredProducts = _products;
//       } else {
//         _filteredProducts = _products
//             .where((product) =>
//                 product.name.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       }
//     });
//   }

//   Future<void> _loadProducts() async {
//     try {
//       setState(() => _isLoading = true);
//       final products = await widget.apiService.getProducts();
//       setState(() {
//         _products = products;
//         _filteredProducts = products; // Initialize filtered list
//         _isLoading = false;
//       });
//     } catch (e) {
//       print('Error loading products: $e');
//       setState(() => _isLoading = false);
//     }
//   }

//   void _updateTotal() {
//     setState(() {
//       total = cart.entries.fold(
//         0,
//         (sum, item) => sum + (item.key.price * item.value),
//       );
//     });
//   }

//   void _addToCart(InventoryEntity product, int quantity) {
//     setState(() {
//       if (cart.containsKey(product)) {
//         cart[product] = cart[product]! + quantity;
//       } else {
//         cart[product] = quantity;
//       }
//       _updateTotal();
//     });
//   }

//   void _updateQuantity(InventoryEntity product, int newQuantity) {
//     if (newQuantity > product.quantity) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Not enough stock for ${product.name}'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//       return;
//     }

//     setState(() {
//       if (newQuantity > 0) {
//         cart[product] = newQuantity;
//       } else {
//         cart.remove(product);
//       }
//       _updateTotal();
//     });
//   }

//   void _removeFromCart(InventoryEntity product) {
//     setState(() {
//       cart.remove(product);
//       _updateTotal();

//       ScaffoldMessenger.of(context)
//         ..clearSnackBars()
//         ..showSnackBar(
//           SnackBar(
//             content: Text('${product.name} removed from cart'),
//             duration: const Duration(seconds: 1),
//             behavior: SnackBarBehavior.floating,
//             margin: EdgeInsets.only(
//               bottom: MediaQuery.of(context).size.height - 100,
//               right: 20,
//               left: 20,
//             ),
//           ),
//         );
//     });
//   }

//   void _checkStock(InventoryEntity product) {
//     if (product.quantity <
//         _filteredProducts.fold(0, (sum, item) => sum + item.quantity)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Not enough stock for ${product.name}')),
//       );
//     }
//   }

//   List<CartItem> _getCartItems() {
//     return cart.entries
//         .map((entry) => CartItem(
//               product: entry.key,
//               quantity: entry.value,
//             ))
//         .toList();
//   }

//   Future<void> _scanBarcode(BuildContext context) async {
//     MobileScannerController cameraController = MobileScannerController();
//     String? scannedCode;

//     try {
//       print('Starting barcode scanner...');
//       scannedCode = await Navigator.of(context).push<String>(
//         MaterialPageRoute(
//           builder: (context) => Scaffold(
//             appBar: AppBar(
//               title: const Text('Scan Barcode'),
//               leading: IconButton(
//                 icon: const Icon(Icons.arrow_back),
//                 onPressed: () {
//                   cameraController.dispose();
//                   Navigator.pop(context);
//                 },
//               ),
//             ),
//             body: MobileScanner(
//               controller: cameraController,
//               onDetect: (capture) {
//                 final List<Barcode> barcodes = capture.barcodes;
//                 if (barcodes.isNotEmpty && barcodes[0].rawValue != null) {
//                   print('Successfully scanned barcode: ${barcodes[0].rawValue}');
//                   Navigator.pop(context, barcodes[0].rawValue);
//                 }
//               },
//             ),
//           ),
//         ),
//       );

//       if (scannedCode != null && mounted) {
//         // Check if we have saved data for this barcode
//         final savedProduct = await _getProductByBarcode(scannedCode);

//         if (savedProduct != null) {
//           if (mounted) {
//             _showAddProductDialog(
//               context,
//               barcode: scannedCode,
//               prefillName: savedProduct['name'],
//               prefillPrice: savedProduct['price'].toDouble(),
//               prefillCategory: null,
//             );
//           }
//         } else {
//           // Show dialog to enter new product details
//           if (mounted) {
//             final result = await showDialog<Map<String, dynamic>>(
//               context: context,
//               builder: (BuildContext context) {
//                 final nameController = TextEditingController();
//                 final priceController = TextEditingController();

//                 return AlertDialog(
//                   title: Text('Barcode: $scannedCode'),
//                   content: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       TextField(
//                         controller: nameController,
//                         decoration: const InputDecoration(labelText: 'Product Name'),
//                         autofocus: true,
//                       ),
//                       TextField(
//                         controller: priceController,
//                         decoration: const InputDecoration(labelText: 'Price'),
//                         keyboardType: TextInputType.number,
//                       ),
//                     ],
//                   ),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text('Cancel'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context, {
//                           'name': nameController.text,
//                           'price': double.tryParse(priceController.text) ?? 0.0,
//                         });
//                       },
//                       child: const Text('Save & Add'),
//                     ),
//                   ],
//                 );
//               },
//             );

//             if (result != null && mounted) {
//               // Save the product data
//               await _saveProductBarcode(
//                 scannedCode,
//                 result['name'],
//                 result['price'],
//               );

//               // Show add product dialog
//               _showAddProductDialog(
//                 context,
//                 barcode: scannedCode,
//                 prefillName: result['name'],
//                 prefillPrice: result['price'],
//                 prefillCategory: null,
//               );
//             }
//           }
//         }
//       }
//     } catch (e) {
//       print('Error during scanning: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error scanning: $e'),
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }
//     } finally {
//       if (cameraController.isStarting) {
//         await cameraController.stop();
//       }
//       cameraController.dispose();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final cartItems = _getCartItems();

//     return Scaffold(
//       drawer: SidebarScreen(apiService: widget.apiService),
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'POS System',
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               '${cart.length} items in cart',
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontSize: 14,
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             child: Row(
//               children: [
//                 Icon(Icons.shopping_cart,
//                     color: Theme.of(context).primaryColor),
//                 IconButton(
//                 icon: const Icon(Icons.qr_code_scanner),
//                 onPressed: () => _scanBarcode(context),
//               ),
//               ],
//             ),

//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Container(
//                   color: Colors.white,
//                   padding: const EdgeInsets.all(16),
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: InputDecoration(
//                       hintText: 'Search products...',
//                       hintStyle: TextStyle(color: Colors.grey[400]),
//                       prefixIcon: const Icon(Icons.search),
//                       suffixIcon: _searchController.text.isNotEmpty
//                           ? IconButton(
//                               icon: const Icon(Icons.clear),
//                               onPressed: () {
//                                 _searchController.clear();
//                                 _filterProducts('');
//                               },
//                             )
//                           : null,
//                       filled: true,
//                       fillColor: Colors.grey[100],
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding:
//                           const EdgeInsets.symmetric(horizontal: 16),
//                     ),
//                     onChanged: _filterProducts,
//                   ),
//                 ),
//                 Expanded(
//                   child: GridView.builder(
//                     padding: const EdgeInsets.all(16),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 1,
//                       childAspectRatio: 3.5,
//                       mainAxisSpacing: 16,
//                     ),
//                     itemCount: _filteredProducts.length,
//                     itemBuilder: (context, index) {
//                       final product = _filteredProducts[index];
//                       return GestureDetector(
//                         onTap: () => _addToCart(product, 1),
//                         child: Container(
//                           width: MediaQuery.of(context).size.width,
//                           height: MediaQuery.of(context).size.width / 2,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.grey.withOpacity(0.1),
//                                 spreadRadius: 1,
//                                 blurRadius: 5,
//                                 offset: const Offset(0, 2),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(12),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       product.name,
//                                       style: const TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 16,
//                                       ),
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       'Stock: ${product.quantity}',
//                                       style: TextStyle(
//                                         color: Colors.grey[600],
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 1),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(
//                                           'Rs.${product.price.toStringAsFixed(2)}',
//                                           style: TextStyle(
//                                             color:
//                                                 Theme.of(context).primaryColor,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 18,
//                                           ),
//                                         ),
//                                         Container(
//                                           padding: const EdgeInsets.all(4),
//                                           decoration: BoxDecoration(
//                                             color:
//                                                 Theme.of(context).primaryColor,
//                                             borderRadius:
//                                                 BorderRadius.circular(8),
//                                           ),
//                                           child: const Icon(
//                                             Icons.add,
//                                             color: Colors.white,
//                                             size: 20,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//       bottomSheet: cart.isEmpty
//           ? null
//           : Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     spreadRadius: 1,
//                     blurRadius: 5,
//                     offset: const Offset(0, -2),
//                   ),
//                 ],
//               ),
//               padding: const EdgeInsets.all(16),
//               child: SafeArea(
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '${cart.length} items',
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 14,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             'Rs.${total.toStringAsFixed(2)}',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 20,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         _showCart(context);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Theme.of(context).primaryColor,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 32, vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: Text(
//                         'View Cart',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   void _showCart(BuildContext context) {
//     final cartItems = _getCartItems();

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         height: MediaQuery.of(context).size.height * 0.75,
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//         ),
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(20),
//                   topRight: Radius.circular(20),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     spreadRadius: 1,
//                     blurRadius: 5,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Your Cart (${cart.length})',
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.close),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: cartItems.length,
//                 itemBuilder: (context, index) {
//                   final item = cartItems[index];
//                   return Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       border: Border(
//                         bottom: BorderSide(
//                           color: Colors.grey[200]!,
//                           width: 1,
//                         ),
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 60,
//                           height: 60,
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[200],
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Center(
//                             child: Icon(
//                               Icons.inventory_2,
//                               color: Theme.of(context).primaryColor,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 item.product.name,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 'Rs.${item.product.price.toStringAsFixed(2)}',
//                                 style: TextStyle(
//                                   color: Theme.of(context).primaryColor,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.remove_circle_outline),
//                               onPressed: () => _updateQuantity(
//                                   item.product, item.quantity - 1),
//                             ),
//                             Text(
//                               '${item.quantity}',
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.add_circle_outline),
//                               onPressed: () => _updateQuantity(
//                                   item.product, item.quantity + 1),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     spreadRadius: 1,
//                     blurRadius: 5,
//                     offset: const Offset(0, -2),
//                   ),
//                 ],
//               ),
//               child: SafeArea(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           'Total Amount',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           'Rs.${total.toStringAsFixed(2)}',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Theme.of(context).primaryColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: cartItems.isEmpty
//                           ? null
//                           : () => _showCheckoutConfirmation(context),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Theme.of(context).primaryColor,
//                         foregroundColor: Colors.white,
//                         minimumSize: const Size.fromHeight(50),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: const Text(
//                         'Proceed to Checkout',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showCheckoutConfirmation(BuildContext context) {
//     final cartItems = _getCartItems();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           title: Row(
//             children: [
//               Icon(
//                 Icons.shopping_cart_checkout,
//                 color: Theme.of(context).primaryColor,
//               ),
//               const SizedBox(width: 10),
//               const Text('Confirm Checkout'),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Total Items: ${cart.length}',
//                 style: const TextStyle(fontSize: 16),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Total Amount: Rs.${total.toStringAsFixed(2)}',
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text('Do you want to proceed with checkout?'),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close dialog
//               },
//               child: Text(
//                 'No',
//                 style: TextStyle(
//                   color: Colors.grey[600],
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close dialog
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => PaymentScreen(
//                       cartItems: cartItems,
//                       total: total,
//                       apiService: widget.apiService,
//                     ),
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Theme.of(context).primaryColor,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text(
//                 'Yes',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _scanProductForCart(BuildContext context) async {
//     MobileScannerController cameraController = MobileScannerController();
//     String? scannedCode;

//     try {
//       print('Starting barcode scanner...');
//       scannedCode = await Navigator.of(context).push<String>(
//         MaterialPageRoute(
//           builder: (context) => Scaffold(
//             appBar: AppBar(
//               title: const Text('Scan Product'),
//               leading: IconButton(
//                 icon: const Icon(Icons.arrow_back),
//                 onPressed: () {
//                   cameraController.dispose();
//                   Navigator.pop(context);
//                 },
//               ),
//             ),
//             body: MobileScanner(
//               controller: cameraController,
//               onDetect: (capture) {
//                 final List<Barcode> barcodes = capture.barcodes;
//                 if (barcodes.isNotEmpty && barcodes[0].rawValue != null) {
//                   print(
//                       'Successfully scanned barcode: ${barcodes[0].rawValue}');
//                   Navigator.pop(context, barcodes[0].rawValue);
//                 }
//               },
//             ),
//           ),
//         ),
//       );

//       if (scannedCode != null && mounted) {
//         final savedProduct = await _getProductByBarcode(scannedCode);

//         if (savedProduct != null) {
//           final inventoryProduct = _products.firstWhere(
//             (product) => product.name == savedProduct['name'],
//             orElse: () => InventoryEntity(
//               id: null,
//               name: '',
//               price: 0,
//               cost_price: 0,
//               quantity: 0,
//               categoryId: null,
//               categoryName: null,
//             ),
//           );

//           if (inventoryProduct.id != null) {
//             if (mounted) {
//               final quantity = await showDialog<int>(
//                 context: context,
//                 builder: (BuildContext context) {
//                   final quantityController = TextEditingController(text: '1');
//                   return AlertDialog(
//                     title: Text('Add ${inventoryProduct.name} to Cart'),
//                     content: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text('Available: ${inventoryProduct.quantity}'),
//                         TextField(
//                           controller: quantityController,
//                           decoration:
//                               const InputDecoration(labelText: 'Quantity'),
//                           keyboardType: TextInputType.number,
//                           autofocus: true,
//                         ),
//                       ],
//                     ),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: const Text('Cancel'),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           final qty =
//                               int.tryParse(quantityController.text) ?? 0;
//                           if (qty > 0 && qty <= inventoryProduct.quantity) {
//                             Navigator.pop(context, qty);
//                           } else {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Invalid quantity'),
//                                 duration: Duration(seconds: 2),
//                               ),
//                             );
//                           }
//                         },
//                         child: const Text('Add to Cart'),
//                       ),
//                     ],
//                   );
//                 },
//               );

//               if (quantity != null && mounted) {
//                 _addToCart(inventoryProduct, quantity);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('Added ${inventoryProduct.name} to cart'),
//                     duration: const Duration(seconds: 2),
//                   ),
//                 );
//               }
//             }
//           } else {
//             if (mounted) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Product not found in inventory'),
//                   duration: Duration(seconds: 2),
//                 ),
//               );
//             }
//           }
//         } else {
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text(
//                     'Product not recognized. Please add it to inventory first.'),
//                 duration: Duration(seconds: 2),
//               ),
//             );
//           }
//         }
//       }
//     } catch (e) {
//       print('Error during scanning: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error scanning: $e'),
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }
//     } finally {
//       if (cameraController.isStarting) {
//         await cameraController.stop();
//       }
//       cameraController.dispose();
//     }
//   }

//   Future<Map<String, dynamic>?> _getProductByBarcode(String barcode) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final productData = prefs.getString('barcode_$barcode');
//       if (productData != null) {
//         return json.decode(productData);
//       }
//       return null;
//     } catch (e) {
//       print('Error retrieving product data: $e');
//       return null;
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:pos_frontend/models/inventoryModel/inventoryEntity.dart';
import 'package:pos_frontend/services/apiService.dart';
import 'package:pos_frontend/widgets/app_drawer.dart';
import 'package:pos_frontend/screens/paymentScreen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:pos_frontend/models/cartModel/cartItem.dart';

class CartScreen extends StatefulWidget {
  final ApiService apiService;

  const CartScreen({super.key, required this.apiService});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<InventoryEntity> _products = [];
  Map<InventoryEntity, int> cart = {};
  double total = 0;
  List<InventoryEntity> _filteredProducts = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInventory();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInventory() async {
    try {
      final products = await widget.apiService.getInventory();
      setState(() {
        _products = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading inventory: $e');
      setState(() => _isLoading = false);
    }
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

  void _updateTotal() {
    setState(() {
      total = cart.entries.fold(
        0,
        (sum, item) => sum + (item.key.price * item.value),
      );
    });
  }

  void _addToCart(InventoryEntity product, int quantity) {
    setState(() {
      if (cart.containsKey(product)) {
        cart[product] = cart[product]! + quantity;
      } else {
        cart[product] = quantity;
      }
      _updateTotal();
    });
  }

  void _updateQuantity(InventoryEntity product, int newQuantity) {
    if (newQuantity > product.quantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Not enough stock for ${product.name}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      if (newQuantity > 0) {
        cart[product] = newQuantity;
      } else {
        cart.remove(product);
      }
      _updateTotal();
    });
  }

  void _removeFromCart(InventoryEntity product) {
    setState(() {
      cart.remove(product);
      _updateTotal();

      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text('${product.name} removed from cart'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 100,
              right: 20,
              left: 20,
            ),
          ),
        );
    });
  }

  List<CartItem> _getCartItems() {
    return cart.entries
        .map((entry) => CartItem(
              product: entry.key,
              quantity: entry.value,
            ))
        .toList();
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
                  print(
                      'Successfully scanned barcode: ${barcodes[0].rawValue}');
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

        // if (savedProduct != null) {
        //   // Check if the product exists in the inventory
        //   final inventoryProduct = _products.firstWhere(
        //     (product) => product.name == savedProduct['name'],
        //     orElse: () => null,
        //   );

        //   if (inventoryProduct != null) {
        //     // If the product exists, add it to the cart
        //     _addToCart(inventoryProduct, 1); // You can change the quantity as needed
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(
        //         content: Text('${inventoryProduct.name} added to cart'),
        //         duration: const Duration(seconds: 2),
        //       ),
        //     );
        //   } else {
        //     // Show a message if the product is not found in inventory
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(
        //         content: Text('Product not found in inventory'),
        //         duration: const Duration(seconds: 2),
        //       ),
        //     );
        //   }
        // } else {
        //   // Show a message if the product is not recognized
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text('Product not recognized. Please add it to inventory first.'),
        //       duration: const Duration(seconds: 2),
        //     ),
        //   );
        // }

        if (savedProduct != null) {
          // Check if the product exists in the inventory
          final inventoryProduct = _products.firstWhere(
            (product) => product.name == savedProduct['name'],
            orElse: () => InventoryEntity(
              id: null,
              name: '',
              price: 0,
              cost_price: 0,
              quantity: 0,
              categoryId: null,
              categoryName: null,
            ),
          );

          if (inventoryProduct.name.isNotEmpty) {
            // If the product exists, add it to the cart
            _addToCart(
                inventoryProduct, 1); // You can change the quantity as needed
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${inventoryProduct.name} added to cart'),
                duration: const Duration(seconds: 2),
              ),
            );
          } else {
            // Show a message if the product is not found in inventory
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Product not found in inventory'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } else {
          // Show a message if the product is not recognized
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Product not recognized. Please add it to inventory first.'),
              duration: const Duration(seconds: 2),
            ),
          );
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

  @override
  Widget build(BuildContext context) {
    final cartItems = _getCartItems();

    return Scaffold(
      drawer: SidebarScreen(apiService: widget.apiService),
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'POS System',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${cart.length} items in cart',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.shopping_cart,
                    color: Theme.of(context).primaryColor),
                IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () => _scanBarcode(context),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _filterProducts('');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onChanged: _filterProducts,
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 3.5,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return GestureDetector(
                        onTap: () => _addToCart(product, 1),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width / 2,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Stock: ${product.quantity}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Rs.${product.price.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
      bottomSheet: cart.isEmpty
          ? null
          : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${cart.length} items',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rs.${total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showCart(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'View Cart',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _showCart(BuildContext context) {
    final cartItems = _getCartItems();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Cart (${cart.length})',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[200]!,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.inventory_2,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Rs.${item.product.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => _updateQuantity(
                                  item.product, item.quantity - 1),
                            ),
                            Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => _updateQuantity(
                                  item.product, item.quantity + 1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Rs.${total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: cartItems.isEmpty
                          ? null
                          : () => _showCheckoutConfirmation(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Proceed to Checkout',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCheckoutConfirmation(BuildContext context) {
    final cartItems = _getCartItems();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(
                Icons.shopping_cart_checkout,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(width: 10),
              const Text('Confirm Checkout'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Items: ${cart.length}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Total Amount: Rs.${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text('Do you want to proceed with checkout?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text(
                'No',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(
                      cartItems: cartItems,
                      total: total,
                      apiService: widget.apiService,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Yes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
