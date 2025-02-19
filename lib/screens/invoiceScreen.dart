import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_frontend/models/cartModel/cartItem.dart';
import 'package:pos_frontend/models/customerModel/customerEntity.dart';
import 'package:pos_frontend/models/invoiceModel/invoiceEntity.dart';
import 'package:pos_frontend/widgets/app_drawer.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

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



  void printInvoice(BuildContext context, InvoiceEntity invoice, String paymentMethod) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Invoice #${invoice.invoiceNumber}', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text('Date: ${invoice.createdAt}'),
            pw.Divider(),

            pw.Text('Customer Details', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Text('Name: ${invoice.customerName}'),
            pw.Text('Phone: ${invoice.customerPhone}'),
            pw.Divider(),

            pw.Text('Items', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),

            pw.Table.fromTextArray(
              headers: ['Item', 'Qty', 'Price', 'Total'],
              data: invoice.items.map((item) => [
                item.productName,
                '${item.quantity}',
                'Rs.${item.unitPrice}',
                'Rs.${item.totalPrice}'
              ]).toList(),
            ),

            pw.SizedBox(height: 16),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text('Total: Rs.${invoice.totalAmount}', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 16),

            pw.Text('Payment Method: $paymentMethod'),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}
 
  Future<File> generateAndSavePDF() async {
    // Request storage permission
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      throw Exception('Storage permission is required to save invoice');
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Text(
                'Invoice #${invoice.invoiceNumber}',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Date: ${DateFormat('dd/MM/yyyy HH:mm').format(invoice.createdAt!)}',
              ),
              pw.Divider(),

              // Customer Details
              pw.Text(
                'Customer Details',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text('Name: ${invoice.customerName}'),
              pw.Text('Phone: ${invoice.customerPhone}'),
              pw.Divider(),

              // Items Table
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FlexColumnWidth(3),
                  1: pw.FlexColumnWidth(1),
                  2: pw.FlexColumnWidth(2),
                  3: pw.FlexColumnWidth(2),
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'Item',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'Qty',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'Price',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                          'Total',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  // Table Items
                  ...invoice.items.map(
                    (item) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text(item.productName),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('${item.quantity}'),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('Rs.${item.unitPrice}'),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(5),
                          child: pw.Text('Rs.${item.totalPrice}'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),

              // Total and Payment Method
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'Total: Rs.${invoice.totalAmount}',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text('Payment Method: $paymentMethod'),
            ],
          );
        },
      ),
    );

    // Get the downloads directory
    Directory? downloadsDir;
    if (Platform.isAndroid) {
      downloadsDir = Directory('/storage/emulated/0/Download');
    } else {
      downloadsDir = await getApplicationDocumentsDirectory();
    }

    // Create a unique filename with timestamp
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File(
        '${downloadsDir.path}/Invoice_${invoice.invoiceNumber}_$timestamp.pdf');

    // Save the PDF
    await file.writeAsBytes(await pdf.save());
    return file;
  }



//   String generatePDFContent(InvoiceEntity invoice, List<CartItem> cartItems, double total, String paymentMethod, Customer customer, String customerNumber) {
//   String content = 'Invoice Details:\n\n';
  
//   // Add invoice information
//   content += 'Invoice Number: ${invoice.invoiceNumber}\n';
//   content += 'Date: ${DateFormat('dd/MM/yyyy HH:mm').format(invoice.createdAt!)}\n\n';

//   // Add customer details
//   content += 'Customer Details:\n';
//   content += 'Name: ${invoice.customerName}\n';
//   content += 'Phone: ${invoice.customerPhone}\n\n';

//   // Add items table
//   content += 'Items:\n';
//   content += '-----------------------------------------\n';
//   content += 'Item\t\tQty\tPrice\tTotal\n';
//   content += '-----------------------------------------\n';
//   for (var item in cartItems) {
//     content += '${item.product}\t${item.quantity}\tRs.${item.product.price}\tRs.${invoice.totalAmount}\n';
//   }
//   content += '-----------------------------------------\n\n';

//   // Add total and payment method
//   content += 'Total: Rs.${total}\n';
//   content += 'Payment Method: ${paymentMethod}\n\n';

//   // Add customer contact information
//   content += 'Customer Contact:\n';
//   content += 'Name: ${customer.name}\n';
//   content += 'Phone: ${customerNumber}\n';

//   return content;
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              try {
                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );

                final file = await generateAndSavePDF();

                // Hide loading indicator
                Navigator.pop(context);

                // Show success message with file path
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Invoice saved to: ${file.path}'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 5),
                    action: SnackBarAction(
                      label: 'OPEN',
                      onPressed: () => OpenFile.open(file.path),
                    ),
                  ),
                );
              } catch (e) {
                // Hide loading indicator if showing
                if (context.mounted) {
                  Navigator.pop(context);
                }

                // Show error message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error saving PDF: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              try {
                final file = await generateAndSavePDF();
                await Share.shareXFiles(
                  [XFile(file.path)],
                  subject: 'Invoice ${invoice.invoiceNumber}',
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error sharing PDF: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
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
                ...invoice.items
                    .map((item) => TableRow(
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
                        ))
                    .toList(),
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(width: 8), // Add padding at start
                ElevatedButton.icon(
                  onPressed: () => printInvoice(context, invoice, paymentMethod),
                  icon: Icon(Icons.print_outlined),
                  label: const Text('Print'),
                ),
                const SizedBox(width: 8), // Add padding at start
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/dashboard',
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Back to Home'),
                ),
                const SizedBox(width: 16), // Add spacing between buttons
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      // Show loading indicator
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );

                      final file = await generateAndSavePDF();

                      // Hide loading indicator
                      if (context.mounted) {
                        Navigator.pop(context);
                      }

                      // Show success message
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Invoice saved to: ${file.path}'),
                            backgroundColor: Colors.green,
                            duration: const Duration(seconds: 5),
                            action: SnackBarAction(
                              label: 'OPEN',
                              onPressed: () => OpenFile.open(file.path),
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      // Hide loading indicator if showing
                      if (context.mounted) {
                        Navigator.pop(context);
                      }

                      // Show error message
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error generating PDF: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.picture_as_pdf),
                  label: const Text('Download PDF'),
                ),
                const SizedBox(width: 16), // Add spacing between buttons
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      // Show loading indicator
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );

                      final file = await generateAndSavePDF();

                      // Hide loading indicator
                      if (context.mounted) {
                        Navigator.pop(context);
                      }

                      // Share the file
                      await Share.shareXFiles(
                        [XFile(file.path)],
                        subject: 'Invoice ${invoice.invoiceNumber}',
                      );
                    } catch (e) {
                      // Hide loading indicator if showing
                      if (context.mounted) {
                        Navigator.pop(context);
                      }

                      // Show error message
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error sharing PDF: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
                const SizedBox(width: 8), // Add padding at end
              ],
            ),
          ),
        ),
      ),
    );
  }
}
