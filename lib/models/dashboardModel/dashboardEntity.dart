class DashboardEntity {
  final String userName;
  final String shopName;
  final String shopAddress;
  final int totalCategories;
  final int totalProducts;
  final double totalRevenue;
  final double totalCost;
  final double netProfit;
  final double todayRevenue;
  final double todayProfit;
  final double monthlyRevenue;
  final double monthlyProfit;
  final int totalSales;
  final int productsSold;
  final int productsInStock;

  DashboardEntity({
    required this.userName,
    required this.shopName,
    required this.shopAddress,
    required this.totalCategories,
    required this.totalProducts,
    required this.totalRevenue,
    required this.totalCost,
    required this.netProfit,
    required this.todayProfit,
    required this.todayRevenue,
    required this.monthlyRevenue,
    required this.monthlyProfit,
    required this.totalSales,
    required this.productsSold,
    required this.productsInStock,
  });

  factory DashboardEntity.fromJson(Map<String, dynamic> json) {
    return DashboardEntity(
      userName: json['user_name'],
      shopName: json['shop_name'],
      shopAddress: json['shop_address'],
      totalCategories: json['total_categories'],
      totalProducts: json['total_products'],
      totalRevenue: (json['totalRevenue'] ?? 0.0).toDouble(),
      totalCost: (json['totalCost'] ?? 0.0).toDouble(),
      netProfit: (json['netProfit'] ?? 0.0).toDouble(),
      todayRevenue: (json['todayRevenue'] ?? 0.0).toDouble(),
      todayProfit: (json['todayProfit'] ?? 0.0).toDouble(),
      monthlyRevenue: (json['monthlyRevenue'] ?? 0.0).toDouble(),
      monthlyProfit: (json['monthlyProfit'] ?? 0.0).toDouble(),
      totalSales: json['total_sales'],
      productsSold: json['products_sold'],
      productsInStock: json['products_in_stock'],
    );
  }
}
