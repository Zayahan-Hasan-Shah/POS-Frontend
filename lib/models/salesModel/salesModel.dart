class SalesEntity {
  final int? id;
  final int? product_id;
  final int? quantity;
  final double? total_price;
  final String? payment_method;

  SalesEntity({
    this.id,
    this.product_id,
    this.quantity,
    this.total_price,
    this.payment_method,
  });

  factory SalesEntity.fromJson(Map<String, dynamic> json) {
    return SalesEntity(
      id: json['id'],
    );
  }

  Object? toJson() {
    return {
      'product_id': product_id,
      'quantity': quantity,
      'total_price': total_price,
      'payment_method': payment_method,
    };
  }
}
