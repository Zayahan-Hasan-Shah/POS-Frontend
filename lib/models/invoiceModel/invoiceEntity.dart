class InvoiceEntity {
  final int id;
  final String invoiceNumber;
  final DateTime date;
  final double totalAmount;
  final String paymentMethod;
  final List<InvoiceItem> items;

  InvoiceEntity({
    required this.id,
    required this.invoiceNumber,
    required this.date,
    required this.totalAmount,
    required this.paymentMethod,
    required this.items,
  });

  factory InvoiceEntity.fromJson(Map<String, dynamic> json) {
    return InvoiceEntity(
      id: json['id'],
      invoiceNumber: json['invoice_number'],
      date: DateTime.parse(json['date']),
      totalAmount: json['total_amount'].toDouble(),
      paymentMethod: json['payment_method'],
      items: (json['items'] as List)
          .map((item) => InvoiceItem.fromJson(item))
          .toList(),
    );
  }
}

class InvoiceItem {
  final String productName;
  final int quantity;
  final double price;
  final double total;

  InvoiceItem({
    required this.productName,
    required this.quantity,
    required this.price,
    required this.total,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      productName: json['product_name'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      total: json['total'].toDouble(),
    );
  }
}
