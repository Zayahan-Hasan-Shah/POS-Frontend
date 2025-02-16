// import 'package:flutter/material.dart';
// import 'package:pos_frontend/models/dashboardModel/dashboardEntity.dart';
// import 'package:pos_frontend/services/apiService.dart';
// import 'package:pos_frontend/widgets/app_drawer.dart';
// import 'package:fl_chart/fl_chart.dart';

// class HomeScreen extends StatefulWidget {
//   final ApiService apiService;

//   const HomeScreen({required this.apiService});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late Future<DashboardEntity> dashboardFuture;

//   @override
//   void initState() {
//     super.initState();
//     print('-----Current token in HomeScreen: ${widget.apiService.accessToken}');
//     dashboardFuture = Future.delayed(
//       Duration(milliseconds: 200),
//       () => widget.apiService.getDashboardData(),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dashboard'),
//       ),
//       drawer: SidebarScreen(apiService: widget.apiService),
//       body: FutureBuilder<DashboardEntity>(
//         future: dashboardFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData) {
//             return Center(child: Text('No data available'));
//           }

//           final dashboard = snapshot.data!;
//           return SafeArea(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildUserInfoCard(dashboard),
//                   SizedBox(height: 16),
//                   _buildStatsGrid(dashboard),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildUserInfoCard(DashboardEntity dashboard) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.width / 2,
//       child: Card(
//         elevation: 2,
//         color: Theme.of(context).primaryColor,
//         child: Padding(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Welcome, ${dashboard.userName}!',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'Shop: ${dashboard.shopName}',
//                 style: TextStyle(fontSize: 16, color: Colors.white),
//               ),
//               Text(
//                 'Address: ${dashboard.shopAddress}',
//                 style: TextStyle(fontSize: 16, color: Colors.white),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   Widget _buildStatsGrid(DashboardEntity dashboard) {
//     final stats = [
//       StatItem(
//         'Categories',
//         '${dashboard.totalCategories}',
//         Icons.category,
//         Colors.blue,
//       ),
//       StatItem(
//         'Products',
//         '${dashboard.totalProducts}',
//         Icons.inventory,
//         Colors.green,
//       ),
//       StatItem(
//         'Today\'s Income',
//         '\$${dashboard.incomeToday.toStringAsFixed(2)}',
//         Icons.attach_money,
//         Colors.orange,
//       ),
//       StatItem(
//         'Monthly Income',
//         '\$${dashboard.incomeMonth.toStringAsFixed(2)}',
//         Icons.calendar_today,
//         Colors.purple,
//       ),
//       StatItem(
//         'Total Sales',
//         '${dashboard.totalSales}',
//         Icons.shopping_cart,
//         Colors.red,
//       ),
//       StatItem(
//         'Products Sold',
//         '${dashboard.productsSold}',
//         Icons.local_shipping,
//         Colors.teal,
//       ),
//       StatItem(
//         'Net Profit',
//         '\$${dashboard.netProfit.toStringAsFixed(2)}',
//         Icons.trending_up,
//         Colors.indigo,
//       ),
//       StatItem(
//         'Stock',
//         '${dashboard.productsInStock}',
//         Icons.inventory_2,
//         Colors.brown,
//       ),
//     ];
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       itemCount: stats.length,
//       itemBuilder: (context, index) {
//         final stat = stats[index];
//         return Padding(
//           padding: EdgeInsets.only(bottom: 8),
//           child: _buildStatCard(
//             stat.title,
//             stat.value,
//             stat.icon,
//             stat.color,
//           ),
//         );
//       },
//     );
//   }
//   Widget _buildStatCard(
//       String title, String value, IconData icon, Color color) {
//     return Card(
//       elevation: 2,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         child: Row(
//           children: [
//             Icon(icon, color: color, size: 28),
//             SizedBox(width: 16),
//             Expanded(
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     value,
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: color,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class StatItem {
//   final String title;
//   final String value;
//   final IconData icon;
//   final Color color;

//   StatItem(this.title, this.value, this.icon, this.color);
// }

import 'package:flutter/material.dart';
import 'package:pos_frontend/models/dashboardModel/dashboardEntity.dart';
import 'package:pos_frontend/models/chartModel/chartEntity.dart';
import 'package:pos_frontend/services/apiService.dart';
import 'package:pos_frontend/widgets/app_drawer.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  final ApiService apiService;

  const HomeScreen({required this.apiService});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<DashboardEntity> dashboardFuture;
  late Future<DashboardChartEntity> chartDataFuture;

  @override
  void initState() {
    super.initState();
    print('-----Current token in HomeScreen: ${widget.apiService.accessToken}');
    dashboardFuture = Future.delayed(
      Duration(milliseconds: 200),
      () => widget.apiService.getDashboardData(),
    );
    chartDataFuture = widget.apiService.getDashboardChartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: () {
                  ApiService().logout(); // Clear token

                  // Navigate to login screen and remove dashboard from history
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                },
                icon: Icon(Icons.login_outlined)),
          )
        ],
      ),
      drawer: SidebarScreen(apiService: widget.apiService),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([dashboardFuture, chartDataFuture]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }
          final dashboard = snapshot.data![0] as DashboardEntity;
          final chartData = snapshot.data![1] as DashboardChartEntity;

          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfoCard(dashboard),
                  SizedBox(height: 16),
                  _buildStatsGrid(dashboard),
                  SizedBox(height: 16),
                  _buildSalesTrendChart(chartData),
                  SizedBox(height: 16),
                  _buildProductPerformanceChart(chartData),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserInfoCard(DashboardEntity dashboard) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 2,
      child: Card(
        elevation: 2,
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Welcome, ${dashboard.userName}!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Shop: ${dashboard.shopName}',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                'Address: ${dashboard.shopAddress}',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(DashboardEntity dashboard) {
    final stats = [
      StatItem(
        'Categories',
        '${dashboard.totalCategories}',
        Icons.category,
        Colors.blue,
      ),
      StatItem(
        'Products',
        '${dashboard.totalProducts}',
        Icons.inventory,
        Colors.green,
      ),
      StatItem(
        'Today\'s Revenue',
        'Rs.${dashboard.todayRevenue.toStringAsFixed(2)}',
        Icons.attach_money,
        Colors.orange,
      ),
      StatItem(
        'Monthly Revenue',
        'Rs.${dashboard.monthlyRevenue.toStringAsFixed(2)}',
        Icons.calendar_today,
        Colors.purple,
      ),
      StatItem(
        'Total Sales',
        '${dashboard.totalSales}',
        Icons.shopping_cart,
        Colors.red,
      ),
      StatItem(
        'Products Sold',
        '${dashboard.productsSold}',
        Icons.local_shipping,
        Colors.teal,
      ),
      StatItem(
        'Net Profit',
        'Rs.${dashboard.netProfit.toStringAsFixed(2)}',
        Icons.trending_up,
        Colors.indigo,
      ),
      StatItem(
        'Stock',
        '${dashboard.productsInStock}',
        Icons.inventory_2,
        Colors.brown,
      ),
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: _buildStatCard(
            stat.title,
            stat.value,
            stat.icon,
            stat.color,
          ),
        );
      },
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(width: 16),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesTrendChart(DashboardChartEntity chartData) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sales Trend (Last 7 Days)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= chartData.salesTrend.length) {
                            return Text('');
                          }
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              chartData.salesTrend[value.toInt()].date
                                  .substring(5),
                              style: TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: chartData.salesTrend.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          entry.value.amount,
                        );
                      }).toList(),
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductPerformanceChart(DashboardChartEntity chartData) {
    double maxY = 0;
    for (var item in chartData.productPerformance) {
      if (item.sales > maxY) {
        maxY = item.sales.toDouble();
      }
    }
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Products Performance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        reservedSize: 40,
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >=
                              chartData.productPerformance.length) {
                            return Text('');
                          }
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              chartData.productPerformance[value.toInt()].name,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups:
                      chartData.productPerformance.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.sales.toDouble(),
                          color: Theme.of(context).primaryColor,
                          width: 16,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  StatItem(this.title, this.value, this.icon, this.color);
}
