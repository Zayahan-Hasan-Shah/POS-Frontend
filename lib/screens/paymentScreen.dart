// import 'package:flutter/material.dart';
// import 'package:pos_frontend/models/cartModel/cartItem.dart';
// import 'package:pos_frontend/models/salesModel/salesModel.dart';
// import 'package:pos_frontend/screens/invoiceScreen.dart';
// import 'package:pos_frontend/services/apiService.dart';

// class PaymentScreen extends StatefulWidget {
//   final List<CartItem> cartItems;
//   final double total;
//   final ApiService apiService;

//   const PaymentScreen({
//     Key? key,
//     required this.cartItems,
//     required this.total,
//     required this.apiService,
//   }) : super(key: key);

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   String? _selectedPaymentMethod;
//   String? _selectedOnlineMethod;
//   final TextEditingController _numberController = TextEditingController();

//   void _showNumberDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Enter Customer Number'),
//           content: TextField(
//             controller: _numberController,
//             keyboardType: TextInputType.phone,
//             decoration: const InputDecoration(
//               hintText: 'Enter phone number',
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Save the customer's number and navigate to the invoice screen
//                 final String number = _numberController.text;
//                 Navigator.pop(context);
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => InvoiceScreen(
//                       cartItems: widget.cartItems,
//                       total: widget.total,
//                       paymentMethod: _selectedPaymentMethod ?? 'Cash',
//                       customerNumber: number,
//                     ),
//                   ),
//                   (route) => false,
//                 );
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showOnlinePaymentMethods() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Select Payment Method'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: Image.asset(
//                   'lib/assets/images/jazzcash.png',
//                   width: 40,
//                   height: 40,
//                   errorBuilder: (context, error, stackTrace) =>
//                       const Icon(Icons.payment, size: 40),
//                 ),
//                 title: const Text('JazzCash'),
//                 onTap: () {
//                   setState(() {
//                     _selectedPaymentMethod = 'online';
//                     _selectedOnlineMethod = 'JazzCash';
//                   });
//                   Navigator.pop(context);
//                   _showNumberDialog();
//                 },
//               ),
//               ListTile(
//                 leading: Image.asset(
//                   'lib/assets/images/easypaisa.png',
//                   width: 40,
//                   height: 40,
//                   errorBuilder: (context, error, stackTrace) =>
//                       const Icon(Icons.payment, size: 40),
//                 ),
//                 title: const Text('EasyPaisa'),
//                 onTap: () {
//                   setState(() {
//                     _selectedPaymentMethod = 'online';
//                     _selectedOnlineMethod = 'EasyPaisa';
//                   });
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Payment'),
//         // elevation: 0,
//       ),
//       body: Column(
//         children: [
//           // Order Summary Section
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     color: Colors.white,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Order Summary',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         // List of cart items
//                         ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: widget.cartItems.length,
//                           itemBuilder: (context, index) {
//                             final item = widget.cartItems[index];
//                             return CartItemTile(item: item);
//                           },
//                         ),
//                         const SizedBox(height: 16),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               'Total Amount',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               'Rs.${widget.total.toStringAsFixed(2)}',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Theme.of(context).primaryColor,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   // Payment Methods Section
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     color: Colors.white,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Payment Method',
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         // Cash Option
//                         PaymentMethodCard(
//                           title: 'Cash Payment',
//                           icon: Icons.money,
//                           isSelected: _selectedPaymentMethod == 'cash',
//                           onTap: () {
//                             setState(() {
//                               _selectedPaymentMethod = 'cash';
//                             });
//                           },
//                         ),
//                         const SizedBox(height: 12),
//                         // Online Option
//                         PaymentMethodCard(
//                           title: _selectedOnlineMethod ?? 'Online Payment',
//                           icon: Icons.payment,
//                           isSelected: _selectedPaymentMethod == 'online',
//                           onTap: () {
//                             _showOnlinePaymentMethods();
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // Bottom Payment Button
//           Container(
//             padding: const EdgeInsets.all(16),
//             width: double.infinity,
//             child: FloatingActionButton.extended(
//               onPressed: _selectedPaymentMethod == null
//                   ? null
//                   : () async {
//                       try {
//                         // Update inventory for each item
//                         for (var item in widget.cartItems) {
//                           await widget.apiService.updateProduct(
//                             item.product.id!,
//                             item.product.name,
//                             item.product.price,
//                             item.product.cost_price,
//                             item.product.quantity - item.quantity,
//                             item.product.categoryId!,
//                           );
//                         }

//                         // Add sales to the database
//                         for (var item in widget.cartItems) {
//                           await widget.apiService.addSales(
//                             SalesEntity(
//                               product_id: item.product.id,
//                               quantity: item.quantity,
//                               total_price: item.product.price * item.quantity,
//                               payment_method: _selectedPaymentMethod ?? 'Cash',
//                             ),
//                           );
//                         }

//                         // Navigate to invoice and clear previous screens
//                         Navigator.pushAndRemoveUntil(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => InvoiceScreen(
//                               cartItems: widget.cartItems,
//                               total: widget.total,
//                               paymentMethod: _selectedPaymentMethod ?? 'Cash',
//                               customerNumber: _numberController.text,
//                             ),
//                           ),
//                           (route) =>
//                               false, // This will clear all previous routes
//                         );
//                       } catch (e) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                               content: Text('Error processing payment: $e')),
//                         );
//                       }
//                     },
//               label: const Text(
//                 'Pay Now',
//                 style: TextStyle(fontSize: 24),
//               ),
//               icon: const Icon(
//                 Icons.payment,
//                 size: 32,
//               ),
//               backgroundColor: Theme.of(context).primaryColor,
//               foregroundColor: Colors.white,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class CartItemTile extends StatelessWidget {
//   final CartItem item;

//   const CartItemTile({Key? key, required this.item}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       decoration: BoxDecoration(
//         border: Border(
//           bottom: BorderSide(
//             color: Colors.grey[200]!,
//             width: 1,
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(item.product.name),
//           ),
//           Expanded(
//             child: Text(
//               '${item.quantity}x',
//               textAlign: TextAlign.center,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
//               textAlign: TextAlign.right,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_frontend/blocs/customerBloc/customer_bloc.dart';
import 'package:pos_frontend/models/cartModel/cartItem.dart';
import 'package:pos_frontend/models/salesModel/salesModel.dart';
import 'package:pos_frontend/screens/invoiceScreen.dart';
import 'package:pos_frontend/services/apiService.dart';
import 'package:pos_frontend/models/customerModel/customerEntity.dart';

class PaymentScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double total;
  final ApiService apiService;

  const PaymentScreen({
    Key? key,
    required this.cartItems,
    required this.total,
    required this.apiService,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod;
  String? _selectedOnlineMethod;
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _nameCustomerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CustomerBloc>().add(LoadCustomers());
  }

  void _showCustomerSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<CustomerBloc, CustomerState>(
          builder: (context, state) {
            if (state is CustomerLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CustomerError) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text(state.message),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              );
            }

            if (state is CustomerLoaded) {
              return AlertDialog(
                title: const Text('Select Customer'),
                content: SizedBox(
                  width: double.maxFinite,
                  height: 400,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.customers.length,
                          itemBuilder: (context, index) {
                            final customer = state.customers[index];
                            return ListTile(
                              title: Text(customer.name),
                              subtitle: Text(customer.phone),
                              onTap: () {
                                context.read<CustomerBloc>().add(
                                      SelectCustomer(customer),
                                    );
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _showNewCustomerForm();
                        },
                        child: const Text('Add New Customer'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        );
      },
    );
  }

  void _showNewCustomerForm() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Customer'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Required' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newCustomer = Customer(
                    name: nameController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                    address: addressController.text,
                  );

                  context.read<CustomerBloc>().add(AddCustomer(newCustomer));
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // void _showNumberDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Enter Customer Number'),
  //         content: Column(
  //           children: [
  //             TextField(
  //               controller: _numberController,
  //               keyboardType: TextInputType.phone,
  //               decoration: const InputDecoration(
  //                 hintText: 'Enter phone number',
  //               ),
  //             ),
  //             TextField(
  //               controller: _nameCustomerController,
  //               keyboardType: TextInputType.phone,
  //               decoration: const InputDecoration(
  //                 hintText: 'Enter name',
  //               ),
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: const Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               // Save the customer's number and navigate to the invoice screen
  //               final String number = _numberController.text;
  //               Navigator.pop(context);
  //               Navigator.pushAndRemoveUntil(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => InvoiceScreen(
  //                     cartItems: widget.cartItems,
  //                     total: widget.total,
  //                     paymentMethod: _selectedPaymentMethod ?? 'Cash',
  //                     customerNumber: number, customer: _nameCustomerController,
  //                   ),
  //                 ),
  //                 (route) => false,
  //               );
  //             },
  //             child: const Text('OK'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _showNumberDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<CustomerBloc, CustomerState>(
          builder: (context, state) {
            if (state is CustomerLoaded && state.selectedCustomer != null) {
              return AlertDialog(
                title: const Text('Enter Customer Number'),
                content: TextField(
                  controller: _numberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: 'Enter phone number',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      final String number = _numberController.text;
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InvoiceScreen(
                            cartItems: widget.cartItems,
                            total: widget.total,
                            paymentMethod: _selectedPaymentMethod ?? 'Cash',
                            customerNumber: number,
                            customer: state
                                .selectedCustomer!, // Pass the actual Customer object
                          ),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }

  void _showOnlinePaymentMethods() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Payment Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Image.asset(
                  'lib/assets/images/jazzcash.png',
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.payment, size: 40),
                ),
                title: const Text('JazzCash'),
                onTap: () {
                  setState(() {
                    _selectedPaymentMethod = 'online';
                    _selectedOnlineMethod = 'JazzCash';
                  });
                  Navigator.pop(context);
                  _showNumberDialog();
                },
              ),
              ListTile(
                leading: Image.asset(
                  'lib/assets/images/easypaisa.png',
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.payment, size: 40),
                ),
                title: const Text('EasyPaisa'),
                onTap: () {
                  setState(() {
                    _selectedPaymentMethod = 'online';
                    _selectedOnlineMethod = 'EasyPaisa';
                  });
                  Navigator.pop(context);
                },
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
      appBar: AppBar(title: const Text('Payment')),
      body: BlocBuilder<CustomerBloc, CustomerState>(
        builder: (context, state) {
          if (state is CustomerLoaded) {
            return Column(
              children: [
                // Order Summary Section
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Order Summary',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // List of cart items
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: widget.cartItems.length,
                                itemBuilder: (context, index) {
                                  final item = widget.cartItems[index];
                                  return CartItemTile(item: item);
                                },
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Amount',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Rs.${widget.total.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Customer Information Section
                        if (state.selectedCustomer != null)
                          Container(
                            padding: const EdgeInsets.all(16),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Customer Information',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: _showCustomerSelectionDialog,
                                      child: const Text('Change Customer'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text('Name: ${state.selectedCustomer!.name}'),
                                Text('Phone: ${state.selectedCustomer!.phone}'),
                                Text('Email: ${state.selectedCustomer!.email}'),
                                Text(
                                    'Address: ${state.selectedCustomer!.address}'),
                              ],
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(16),
                            color: Colors.white,
                            child: Column(
                              children: [
                                const Text(
                                  'Select Customer',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _showCustomerSelectionDialog,
                                  child: const Text('Select Customer'),
                                ),
                              ],
                            ),
                          ),

                        // Payment Methods Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Payment Method',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Cash Option
                              PaymentMethodCard(
                                title: 'Cash Payment',
                                icon: Icons.money,
                                isSelected: _selectedPaymentMethod == 'cash',
                                onTap: () {
                                  setState(() {
                                    _selectedPaymentMethod = 'cash';
                                  });
                                },
                              ),
                              const SizedBox(height: 12),
                              // Online Option
                              PaymentMethodCard(
                                title:
                                    _selectedOnlineMethod ?? 'Online Payment',
                                icon: Icons.payment,
                                isSelected: _selectedPaymentMethod == 'online',
                                onTap: () {
                                  setState(() {
                                    _selectedPaymentMethod = 'online';
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Payment Button
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  child: FloatingActionButton.extended(
                    onPressed: (_selectedPaymentMethod == null ||
                            state.selectedCustomer == null)
                        ? null
                        : () async {
                            try {
                              // Update inventory for each item
                              for (var item in widget.cartItems) {
                                await widget.apiService.updateProduct(
                                  item.product.id!,
                                  item.product.name,
                                  item.product.price,
                                  item.product.cost_price,
                                  item.product.quantity - item.quantity,
                                  item.product.categoryId!,
                                );
                              }

                              // Add sales to the database
                              for (var item in widget.cartItems) {
                                await widget.apiService.addSales(
                                  SalesEntity(
                                    product_id: item.product.id,
                                    quantity: item.quantity,
                                    total_price:
                                        item.product.price * item.quantity,
                                    payment_method:
                                        _selectedPaymentMethod ?? 'Cash',
                                  ),
                                );
                              }

                              // Navigate to invoice
                              if (!mounted) return;
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InvoiceScreen(
                                    cartItems: widget.cartItems,
                                    total: widget.total,
                                    paymentMethod:
                                        _selectedPaymentMethod ?? 'Cash',
                                    customer: state.selectedCustomer!,
                                    customerNumber:
                                        state.selectedCustomer!.phone,
                                  ),
                                ),
                                (route) => false,
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error processing payment: $e'),
                                ),
                              );
                            }
                          },
                    label: const Text(
                      'Pay Now',
                      style: TextStyle(fontSize: 24),
                    ),
                    icon: const Icon(
                      Icons.payment,
                      size: 32,
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: const Text('Payment')),
  //     body: BlocBuilder<CustomerBloc, CustomerState>(
  //       builder: (context, state) {
  //         if (state is CustomerLoaded) {
  //           return Column(
  //             children: [
  //               // ... existing order summary ...

  //               // Customer Information Section
  //               if (state.selectedCustomer != null)
  //                 Container(
  //                   padding: const EdgeInsets.all(16),
  //                   color: Colors.white,
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const Text(
  //                         'Customer Information',
  //                         style: TextStyle(
  //                           fontSize: 20,
  //                           fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                       const SizedBox(height: 8),
  //                       Text('Name: ${state.selectedCustomer!.name}'),
  //                       Text('Phone: ${state.selectedCustomer!.phone}'),
  //                       Text('Email: ${state.selectedCustomer!.email}'),
  //                     ],
  //                   ),
  //                 ),

  //               // ... payment method widgets ...

  //               // Pay Now Button
  //               FloatingActionButton.extended(
  //                 onPressed: (_selectedPaymentMethod == null ||
  //                         state.selectedCustomer == null)
  //                     ? null
  //                     : () async {
  //                         // ... payment processing ...
  //                         Navigator.pushAndRemoveUntil(
  //                           context,
  //                           MaterialPageRoute(
  //                             builder: (context) => InvoiceScreen(
  //                               cartItems: widget.cartItems,
  //                               total: widget.total,
  //                               paymentMethod: _selectedPaymentMethod ?? 'Cash',
  //                               customer: state.selectedCustomer!,
  //                               customerNumber: '',
  //                             ),
  //                           ),
  //                           (route) => false,
  //                         );
  //                       },
  //                 label: const Text('Pay Now'),
  //                 icon: const Icon(Icons.payment),
  //               ),
  //             ],
  //           );
  //         }

  //         return const Center(child: CircularProgressIndicator());
  //       },
  //     ),
  //   );
  // }
}

class PaymentMethodCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final CartItem item;

  const CartItemTile({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
          Expanded(
            flex: 2,
            child: Text(item.product.name),
          ),
          Expanded(
            child: Text(
              '${item.quantity}x',
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              'Rs.${(item.product.price * item.quantity).toStringAsFixed(2)}',
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
