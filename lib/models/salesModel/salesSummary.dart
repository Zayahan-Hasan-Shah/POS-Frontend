class SalesSummary {
  final String productName;
  final int totalQuantity;
  final double totalRevenue;
  final String? date;

  SalesSummary({
    required this.productName,
    required this.totalQuantity,
    required this.totalRevenue,
    this.date,
  });

  factory SalesSummary.fromJson(Map<String, dynamic> json) {
    return SalesSummary(
      productName: json['product_name'] ?? '',
      totalQuantity: json['total_quantity'] ?? 0,
      totalRevenue: (json['total_revenue'] ?? 0).toDouble(),
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_name': productName,
      'total_quantity': totalQuantity,
      'total_revenue': totalRevenue,
      'date': date,
    };
  }
}