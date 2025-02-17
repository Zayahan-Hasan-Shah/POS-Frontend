// class InvoiceEntity {
//   final int? id;
//   final String? invoiceNumber;
//   final String? customerName;
//   final double totalAmount;
//   final String? status;
//   final DateTime? createdAt;
//   final List<InvoiceItem> items;

//   InvoiceEntity({
//     this.id,
//     this.invoiceNumber,
//     this.customerName,
//     required this.totalAmount,
//     this.status,
//     this.createdAt,
//     required this.items,
//   });

//   factory InvoiceEntity.fromJson(Map<String, dynamic> json) {
//     return InvoiceEntity(
//       id: json['id'],
//       invoiceNumber: json['invoice_number'],
//       customerName: json['customer_name'],
//       totalAmount: (json['total_amount'] ?? 0.0).toDouble(),
//       status: json['status'],
//       createdAt: json['created_at'] != null
//           ? DateTime.parse(json['created_at'])
//           : null,
//       items: (json['items'] as List<dynamic>?)
//           ?.map((item) => InvoiceItem.fromJson(item))
//           .toList() ?? [],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'invoice_number': invoiceNumber,
//       'customer_name': customerName,
//       'total_amount': totalAmount,
//       'status': status,
//       'created_at': createdAt?.toIso8601String(),
//       'items': items.map((item) => item.toJson()).toList(),
//     };
//   }
// }

// class InvoiceItem {
//   final int? id;
//   final String productName;
//   final int quantity;
//   final double unitPrice;
//   final double totalPrice;

//   InvoiceItem({
//     this.id,
//     required this.productName,
//     required this.quantity,
//     required this.unitPrice,
//     required this.totalPrice,
//   });

//   factory InvoiceItem.fromJson(Map<String, dynamic> json) {
//     return InvoiceItem(
//       id: json['id'],
//       productName: json['product_name'] ?? '',
//       quantity: json['quantity'] ?? 0,
//       unitPrice: (json['unit_price'] ?? 0.0).toDouble(),
//       totalPrice: (json['total_price'] ?? 0.0).toDouble(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'product_name': productName,
//       'quantity': quantity,
//       'unit_price': unitPrice,
//       'total_price': totalPrice,
//     };
//   }
// }

// class InvoiceEntity {
//   final int? id;
//   final String? invoiceNumber;
//   final int customerId;
//   final List<InvoiceItem> items;
//   final double totalAmount;
//   final String paymentMethod;
//   final String status;
//   final DateTime? createdAt;

//   InvoiceEntity({
//     this.id,
//     this.invoiceNumber,
//     required this.customerId,
//     required this.items,
//     required this.totalAmount,
//     required this.paymentMethod,
//     this.status = 'PAID',
//     this.createdAt,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'customer_id': customerId,
//       'items': items.map((item) => item.toJson()).toList(),
//       'total_amount': totalAmount,
//       'payment_method': paymentMethod,
//       'status': status,
//     };
//   }

//   factory InvoiceEntity.fromJson(Map<String, dynamic> json) {
//     return InvoiceEntity(
//       id: json['id'],
//       invoiceNumber: json['invoice_number'],
//       customerId: json['customer_id'],
//       items: (json['items'] as List)
//           .map((item) => InvoiceItem.fromJson(item))
//           .toList(),
//       totalAmount: json['total_amount'].toDouble(),
//       paymentMethod: json['payment_method'],
//       status: json['status'],
//       createdAt: json['created_at'] != null
//           ? DateTime.parse(json['created_at'])
//           : null,
//     );
//   }
// }

// class InvoiceItem {
//   final int productId;
//   final String invoice_number;
//   final String productName;
//   final int quantity;
//   final double unitPrice;
//   final double totalPrice;

//   InvoiceItem({
//     required this.productId,
//     required this.productName,
//     required this.quantity,
//     required this.unitPrice,
//     required this.totalPrice,
//     required this.invoice_number,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'product_id': productId,
//       'product_name': productName,
//       'quantity': quantity,
//       'unit_price': unitPrice,
//       'total_price': totalPrice,
//     };
//   }

//   factory InvoiceItem.fromJson(Map<String, dynamic> json) {
//     return InvoiceItem(
//       productId: json['product_id'],
//       productName: json['product_name'],
//       quantity: json['quantity'],
//       unitPrice: json['unit_price'].toDouble(),
//       totalPrice: json['total_price'].toDouble(),
//       invoice_number: '',
//     );
//   }
// }

// class InvoiceEntity {
//   final int? id;
//   final String customerName;
//   final String customerPhone;
//   final List<InvoiceItem> items;
//   final double totalAmount;
//   final String paymentMethod;
//   final DateTime? createdAt;

//   InvoiceEntity({
//     this.id,
//     required this.customerName,
//     required this.customerPhone,
//     required this.items,
//     required this.totalAmount,
//     required this.paymentMethod,
//     this.createdAt,
//     required int customerId,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'customer_name': customerName,
//       'customer_phone': customerPhone,
//       'total_amount': totalAmount,
//       'payment_method': paymentMethod,
//       'items': items.map((item) => item.toJson()).toList(),
//     };
//   }

//   factory InvoiceEntity.fromJson(Map<String, dynamic> json) {
//     return InvoiceEntity(
//       id: json['id'],
//       customerName: json['customer_name'],
//       customerPhone: json['customer_phone'],
//       items: (json['items'] as List)
//           .map((item) => InvoiceItem.fromJson(item))
//           .toList(),
//       totalAmount: json['total_amount'].toDouble(),
//       paymentMethod: json['payment_method'],
//       createdAt: json['created_at'] != null
//           ? DateTime.parse(json['created_at'])
//           : null,
//       customerId: json['customerId'],
//     );
//   }
// }

// class InvoiceItem {
//   final int? id;
//   final String productName;
//   final int quantity;
//   final double unitPrice;
//   final double totalPrice;

//   InvoiceItem({
//     this.id,
//     required this.productName,
//     required this.quantity,
//     required this.unitPrice,
//     required this.totalPrice,
//     required int productId,
//     required String invoice_number,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'product_name': productName,
//       'quantity': quantity,
//       'unit_price': unitPrice,
//       'total_price': totalPrice,
//     };
//   }

//   factory InvoiceItem.fromJson(Map<String, dynamic> json) {
//     return InvoiceItem(
//       id: json['id'],
//       productName: json['product_name'],
//       quantity: json['quantity'],
//       unitPrice: json['unit_price'].toDouble(),
//       totalPrice: json['total_price'].toDouble(),
//       productId: json['id'],
//       invoice_number: json['invoice_number'],
//     );
//   }
// }

class InvoiceEntity {
  final int? id;
  final String customerName;
  final String customerPhone;
  final String invoiceNumber; // Changed from customer_phone_invoice_number
  final List<InvoiceItem> items;
  final double totalAmount;
  final DateTime? createdAt;

  InvoiceEntity({
    this.id,
    required this.customerName,
    required this.customerPhone,
    required this.invoiceNumber,
    required this.items,
    required this.totalAmount,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'total_amount': totalAmount,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  factory InvoiceEntity.fromJson(Map<String, dynamic> json) {
    return InvoiceEntity(
      id: json['id'],
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'],
      invoiceNumber: json['invoice_number'],
      items: (json['items'] as List)
          .map((item) => InvoiceItem.fromJson(item))
          .toList(),
      totalAmount: json['total_amount'].toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
}

class InvoiceItem {
  final int? id;
  final int? invoiceId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  InvoiceItem({
    this.id,
    this.invoiceId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
    };
  }

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      id: json['id'],
      invoiceId: json['invoice_id'],
      productName: json['product_name'],
      quantity: json['quantity'],
      unitPrice: json['unit_price'].toDouble(),
      totalPrice: json['total_price'].toDouble(),
    );
  }
}
