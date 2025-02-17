import 'package:flutter/material.dart';
import 'package:pos_frontend/models/cartModel/cartItem.dart';
import 'package:pos_frontend/models/customerModel/customerEntity.dart';
import 'package:pos_frontend/models/invoiceModel/invoiceEntity.dart';
import 'package:pos_frontend/widgets/app_drawer.dart';
import 'package:intl/intl.dart';

// class InvoiceScreen extends StatelessWidget {
//   final InvoiceEntity invoice;
//   final List<CartItem> cartItems;
//   final double total;
//   final String paymentMethod;
//   final Customer customer;
//   final String customerNumber;

//   const InvoiceScreen({
//     Key? key,
//     required this.invoice,
//     required this.cartItems,
//     required this.total,
//     required this.paymentMethod,
//     required this.customer,
//     required this.customerNumber,
//   }) : super(key: key);



//   @override
//   Widget build(BuildContext context) {
//     final now = DateTime.now();
//     final invoiceNumber = 'INV${now.millisecondsSinceEpoch}';

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Invoice'),
//       ),
//       // drawer: const SidebarScreen(),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Invoice #$invoiceNumber',
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(now)}',
//               style: const TextStyle(color: Colors.grey),
//             ),
//             const Divider(height: 32),
//             const Text(
//               'Items',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             ListView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: cartItems.length,
//               itemBuilder: (context, index) {
//                 final item = cartItems[index];
//                 return ListTile(
//                   title: Text(item.product.name),
//                   subtitle: Text('${item.quantity} x Rs.${item.product.price}'),
//                   trailing: Text(
//                     'Rs.${(item.quantity * item.product.price).toStringAsFixed(2)}',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 );
//               },
//             ),
//             const Divider(height: 32),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Payment Method:',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 Text(
//                   paymentMethod,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Total Amount:',
//                   style: TextStyle(fontSize: 20),
//                 ),
//                 Text(
//                   'Rs.${total.toStringAsFixed(2)}',
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Printing invoice...')),
//                   );
//                   // Navigate to home screen
//                   Navigator.pushNamedAndRemoveUntil(
//                     context,
//                     '/dashboard',
//                     (route) => false,
//                   );
//                 },
//                 icon: const Icon(Icons.print),
//                 label: const Text('Print'),
//               ),
//               ElevatedButton.icon(
//                 onPressed: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Downloading invoice...')),
//                   );
//                   // Navigate to home screen
//                   Navigator.pushNamedAndRemoveUntil(
//                     context,
//                     '/dashboard',
//                     (route) => false,
//                   );
//                 },
//                 icon: const Icon(Icons.download),
//                 label: const Text('Download'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


class InvoiceScreen extends StatelessWidget {
  final InvoiceEntity invoice;
  final List<CartItem> cartItems;
  final double total;
  final String paymentMethod;
  final Customer customer;
  final String customerNumber;

  const InvoiceScreen({
    Key? key,
    required this.invoice,
    required this.cartItems,
    required this.total,
    required this.paymentMethod,
    required this.customer,
    required this.customerNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // Implement print functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Invoice Header
            Text(
              'Invoice #${invoice.invoiceNumber}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${DateFormat('dd/MM/yyyy HH:mm').format(invoice.createdAt!)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Divider(),

            // Customer Details
            Text(
              'Customer Details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Name: ${invoice.customerName}'),
            Text('Phone: ${invoice.customerPhone}'),
            const Divider(),

            // Items Table
            Text(
              'Items',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
              },
              children: [
                const TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Item'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Qty'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Price'),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Total'),
                    ),
                  ],
                ),
                ...invoice.items.map((item) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item.productName),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${item.quantity}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Rs.${item.unitPrice}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Rs.${item.totalPrice}'),
                    ),
                  ],
                )).toList(),
              ],
            ),
            const SizedBox(height: 16),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Total: Rs.${invoice.totalAmount}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Payment Method
            Text(
              'Payment Method: $paymentMethod',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate back to home/POS screen
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', // Replace with your home route name
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.home),
                label: const Text('Back to Home'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Share invoice (e.g., via WhatsApp)
                },
                icon: const Icon(Icons.share),
                label: const Text('Share'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}