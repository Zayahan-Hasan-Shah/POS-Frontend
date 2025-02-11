// class SalesTrendEntity {
//   final String date;
//   final double amount;

//   SalesTrendEntity({
//     required this.date,
//     required this.amount,
//   });

//   factory SalesTrendEntity.fromJson(Map<String, dynamic> json) {
//     return SalesTrendEntity(
//       date: json['date'] as String,
//       amount: (json['amount'] as num).toDouble(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'date': date,
//       'amount': amount,
//     };
//   }
// }

// class ProductPerformanceEntity {
//   final String name;
//   final int sales;

//   ProductPerformanceEntity({
//     required this.name,
//     required this.sales,
//   });

//   factory ProductPerformanceEntity.fromJson(Map<String, dynamic> json) {
//     return ProductPerformanceEntity(
//       name: json['name'] as String,
//       sales: json['sales'] as int,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'sales': sales,
//     };
//   }
// }

// class DashboardChartEntity {
//   final List<SalesTrendEntity> salesTrend;
//   final List<ProductPerformanceEntity> productPerformance;

//   DashboardChartEntity({
//     required this.salesTrend,
//     required this.productPerformance,
//   });

//   factory DashboardChartEntity.fromJson(Map<String, dynamic> json) {
//     return DashboardChartEntity(
//       salesTrend: (json['salesTrend'] as List)
//           .map((e) => SalesTrendEntity.fromJson(e as Map<String, dynamic>))
//           .toList(),
//       productPerformance: (json['productPerformance'] as List)
//           .map((e) =>
//               ProductPerformanceEntity.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'salesTrend': salesTrend.map((e) => e.toJson()).toList(),
//       'productPerformance': productPerformance.map((e) => e.toJson()).toList(),
//     };
//   }
// }

// class DashboardChartEntity {
//   final List<SalesTrendEntity> salesTrend;
//   final List<ProductPerformanceEntity> productPerformance;

//   DashboardChartEntity({
//     required this.salesTrend,
//     required this.productPerformance,
//   });

//   factory DashboardChartEntity.fromJson(Map<String, dynamic> json) {
//     return DashboardChartEntity(
//       salesTrend: (json['salesTrend'] as List)
//           .map((e) => SalesTrendEntity.fromJson(e as Map<String, dynamic>))
//           .toList(),
//       productPerformance: (json['productPerformance'] as List)
//           .map((e) =>
//               ProductPerformanceEntity.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }
// }

// class SalesTrendEntity {
//   final String date;
//   final double amount;

//   SalesTrendEntity({
//     required this.date,
//     required this.amount,
//   });

//   factory SalesTrendEntity.fromJson(Map<String, dynamic> json) {
//     return SalesTrendEntity(
//       date: json['date'] as String,
//       amount: (json['amount'] as num).toDouble(),
//     );
//   }
// }

// class ProductPerformanceEntity {
//   final String name;
//   final int sales;

//   ProductPerformanceEntity({
//     required this.name,
//     required this.sales,
//   });
//   factory ProductPerformanceEntity.fromJson(Map<String, dynamic> json) {
//     return ProductPerformanceEntity(
//       name: json['name'] as String,
//       sales: json['sales'] as int,
//     );
//   }
// }

class DashboardChartEntity {
  final List<SalesTrendEntity> salesTrend;
  final List<ProductPerformanceEntity> productPerformance;

  DashboardChartEntity({
    required this.salesTrend,
    required this.productPerformance,
  });

  factory DashboardChartEntity.fromJson(Map<String, dynamic> json) {
    return DashboardChartEntity(
      salesTrend: (json['salesTrend'] as List)
          .map((e) => SalesTrendEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      productPerformance: (json['productPerformance'] as List)
          .map((e) =>
              ProductPerformanceEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Add toJson method if needed
  Map<String, dynamic> toJson() => {
        'salesTrend': salesTrend.map((e) => e.toJson()).toList(),
        'productPerformance':
            productPerformance.map((e) => e.toJson()).toList(),
      };
}

class SalesTrendEntity {
  final String date;
  final double amount;

  SalesTrendEntity({
    required this.date,
    required this.amount,
  });

  factory SalesTrendEntity.fromJson(Map<String, dynamic> json) {
    return SalesTrendEntity(
      date: json['date'] as String,
      amount: (json['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'date': date,
        'amount': amount,
      };
}

class ProductPerformanceEntity {
  final String name;
  final int sales;

  ProductPerformanceEntity({
    required this.name,
    required this.sales,
  });

  factory ProductPerformanceEntity.fromJson(Map<String, dynamic> json) {
    return ProductPerformanceEntity(
      name: json['name'] as String,
      sales: json['sales'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'sales': sales,
      };
}
