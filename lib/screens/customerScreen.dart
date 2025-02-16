// import 'package:flutter/material.dart';
// import 'package:pos_frontend/models/customerModel/customerEntity.dart';
// import 'package:pos_frontend/services/apiService.dart';

// class CustomerScreen extends StatefulWidget {
//   final ApiService apiService;
//   const CustomerScreen({Key? key, required this.apiService}) : super(key: key);

//   @override
//   State<CustomerScreen> createState() => CustomerScreenState();
// }

// class CustomerScreenState extends State<CustomerScreen> {
//   List<Customer> customers = [];
//   bool isLoading = true;
//   final formKey = GlobalKey<FormState>();

//   // Controllers for add/edit form
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();
//   final phoneController = TextEditingController();
//   final addressController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//    loadCustomers();
//   }

//   @override
//   void dispose() {
//    nameController.dispose();
//    emailController.dispose();
//    phoneController.dispose();
//    addressController.dispose();
//     super.dispose();
//   }

//   Future<void> loadCustomers() async {
//     try {
//       setState(() => isLoading = true);
//       final customers = await apiService;
//       setState(() {
//        customers = customers;
//        isLoading = false;
//       });
//     } catch (e) {
//       setState(() => isLoading = false);
//       showErrorDialog('Error loading customers: $e');
//     }
//   }

//   void showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Error'),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   void clearForm() {
//     nameController.clear();
//     emailController.clear();
//     phoneController.clear();
//     addressController.clear();
//   }

//   Future<void> showCustomerForm({Customer? customer}) async {
//     if (customer != null) {
//      nameController.text = customer.name;
//      emailController.text = customer.email;
//      phoneController.text = customer.phone;
//      addressController.text = customer.address;
//     } else {
//       clearForm();
//     }

//     await showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(customer == null ? 'Add Customer' : 'Edit Customer'),
//         content: SingleChildScrollView(
//           child: Form(
//             key: formKey,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextFormField(
//                   controller: nameController,
//                   decoration: const InputDecoration(labelText: 'Name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a name';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: emailController,
//                   decoration: const InputDecoration(labelText: 'Email'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter an email';
//                     }
//                     if (!value.contains('@')) {
//                       return 'Please enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: phoneController,
//                   decoration: const InputDecoration(labelText: 'Phone'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter a phone number';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: addressController,
//                   decoration: const InputDecoration(labelText: 'Address'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter an address';
//                     }
//                     return null;
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               clearForm();
//               Navigator.pop(context);
//             },
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () async {
//               if (formKey.currentState!.validate()) {
//                 try {
//                   final newCustomer = Customer(
//                     id: customer?.id,
//                     name: nameController.text,
//                     email: emailController.text,
//                     phone: phoneController.text,
//                     address: addressController.text,
//                   );

//                   if (customer == null) {
//                     await apiService.createCustomer(newCustomer);
//                   } else {
//                     await apiService.updateCustomer(customer.id!, newCustomer);
//                   }

//                   clearForm();
//                   Navigator.pop(context);
//                    loadCustomers();
//                 } catch (e) {
//                   showErrorDialog('Error saving customer: $e');
//                 }
//               }
//             },
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> confirmDelete(Customer customer) async {
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Confirm Delete'),
//         content: Text('Are you sure you want to delete ${customer.name}?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Delete'),
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       try {
//         await apiService.deleteCustomer(customer.id!);
//         loadCustomers();
//       } catch (e) {
//         showErrorDialog('Error deleting customer: $e');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: SidebarScreen(apiService: widget.apiService),
//       appBar: AppBar(
//         title: const Text('Customers'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: loadCustomers,
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : customers.isEmpty
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         'No customers found',
//                         style: TextStyle(fontSize: 18),
//                       ),
//                       const SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: () => showCustomerForm(),
//                         child: const Text('Add Customer'),
//                       ),
//                     ],
//                   ),
//                 )
//               : ListView.builder(
//                   itemCount: customers.length,
//                   itemBuilder: (context, index) {
//                     final customer = customers[index];
//                     return Card(
//                       margin: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 8,
//                       ),
//                       child: ListTile(
//                         title: Text(
//                           customer.name,
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(height: 4),
//                             Row(
//                               children: [
//                                 const Icon(Icons.email, size: 16),
//                                 const SizedBox(width: 8),
//                                 Text(customer.email),
//                               ],
//                             ),
//                             const SizedBox(height: 4),
//                             Row(
//                               children: [
//                                 const Icon(Icons.phone, size: 16),
//                                 const SizedBox(width: 8),
//                                 Text(customer.phone),
//                               ],
//                             ),
//                             const SizedBox(height: 4),
//                             Row(
//                               children: [
//                                 const Icon(Icons.locationon, size: 16),
//                                 const SizedBox(width: 8),
//                                 Expanded(child: Text(customer.address)),
//                               ],
//                             ),
//                           ],
//                         ),
//                         trailing: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               icon: const Icon(Icons.edit),
//                               onPressed: () =>
//                                   showCustomerForm(customer: customer),
//                             ),
//                             IconButton(
//                               icon: const Icon(Icons.delete),
//                               onPressed: () => confirmDelete(customer),
//                               color: Colors.red,
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => showCustomerForm(),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:pos_frontend/models/customerModel/customerEntity.dart';
import 'package:pos_frontend/services/apiService.dart';
import 'package:pos_frontend/widgets/app_drawer.dart'; // Add this import

class CustomerScreen extends StatefulWidget {
  final ApiService apiService;
  const CustomerScreen({Key? key, required this.apiService}) : super(key: key);

  @override
  State<CustomerScreen> createState() => CustomerScreenState();
}

class CustomerScreenState extends State<CustomerScreen> {
  List<Customer> customers = [];
  bool isLoading = true;
  final formKey = GlobalKey<FormState>();

  // Controllers for add/edit form
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> loadCustomers() async {
    try {
      setState(() => isLoading = true);
      final loadedCustomers = await widget.apiService
          .getCustomers(); // Fixed: Use widget.apiService and store result
      setState(() {
        customers = loadedCustomers; // Fixed: Assign to customers list
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      showErrorDialog('Error loading customers: $e');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void clearForm() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
  }

  Future<void> showCustomerForm({Customer? customer}) async {
    if (customer != null) {
      nameController.text = customer.name;
      emailController.text = customer.email;
      phoneController.text = customer.phone;
      addressController.text = customer.address;
    } else {
      clearForm();
    }

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(customer == null ? 'Add Customer' : 'Edit Customer'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              clearForm();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  final newCustomer = Customer(
                    id: customer?.id,
                    name: nameController.text,
                    email: emailController.text,
                    phone: phoneController.text,
                    address: addressController.text,
                  );

                  if (customer == null) {
                    await widget.apiService.createCustomer(
                        newCustomer); // Fixed: Use widget.apiService
                  } else {
                    await widget.apiService.updateCustomer(customer.id!,
                        newCustomer); // Fixed: Use widget.apiService
                  }

                  clearForm();
                  Navigator.pop(context);
                  loadCustomers();
                } catch (e) {
                  showErrorDialog('Error saving customer: $e');
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> confirmDelete(Customer customer) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete ${customer.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await widget.apiService
            .deleteCustomer(customer.id!); // Fixed: Use widget.apiService
        loadCustomers();
      } catch (e) {
        showErrorDialog('Error deleting customer: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SidebarScreen(apiService: widget.apiService),
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadCustomers,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : customers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'No customers found',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => showCustomerForm(),
                        child: const Text('Add Customer'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    return Card(
                      color: Theme.of(context).primaryColor.withOpacity(0.4),
                        shadowColor: Colors.black26,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(
                          customer.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.email, size: 16),
                                const SizedBox(width: 8),
                                Text(customer.email),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.phone, size: 16),
                                const SizedBox(width: 8),
                                Text(customer.phone),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    size: 16), // Fixed: Icon name
                                const SizedBox(width: 8),
                                Expanded(child: Text(customer.address)),
                              ],
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  showCustomerForm(customer: customer),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => confirmDelete(customer),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCustomerForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
