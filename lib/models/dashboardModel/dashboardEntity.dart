class DashboardEntity {
  final String userName;
  final String shopName;
  final String shopAddress;
  final int totalCategories;
  final int totalProducts;
  final double incomeToday;
  final double incomeMonth;
  final int totalSales;
  final int productsSold;
  final double netProfit;
  final int productsInStock;

  DashboardEntity({
    required this.userName,
    required this.shopName,
    required this.shopAddress,
    required this.totalCategories,
    required this.totalProducts,
    required this.incomeToday,
    required this.incomeMonth,
    required this.totalSales,
    required this.productsSold,
    required this.netProfit,
    required this.productsInStock,
  });

  factory DashboardEntity.fromJson(Map<String, dynamic> json) {
    return DashboardEntity(
      userName: json['user_name'],
      shopName: json['shop_name'],
      shopAddress: json['shop_address'],
      totalCategories: json['total_categories'],
      totalProducts: json['total_products'],
      incomeToday: json['income_today'].toDouble(),
      incomeMonth: json['income_month'].toDouble(),
      totalSales: json['total_sales'],
      productsSold: json['products_sold'],
      netProfit: json['net_profit'].toDouble(),
      productsInStock: json['products_in_stock'],
    );
  }
}
