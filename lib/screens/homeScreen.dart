import 'package:flutter/material.dart';
import 'package:pos_frontend/models/dashboardModel/dashboardEntity.dart';
import 'package:pos_frontend/services/apiService.dart';
import 'package:pos_frontend/widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  final ApiService apiService;

  const HomeScreen({required this.apiService});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<DashboardEntity> dashboardFuture;

  @override
  void initState() {
    super.initState();
    print('-----Current token in HomeScreen: ${widget.apiService.accessToken}');
    dashboardFuture = Future.delayed(
      Duration(milliseconds: 200),
      () => widget.apiService.getDashboardData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      drawer: const SidebarScreen(),
      body: FutureBuilder<DashboardEntity>(
        future: dashboardFuture,
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

          final dashboard = snapshot.data!;
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfoCard(dashboard),
                  SizedBox(height: 16),
                  _buildStatsGrid(dashboard),
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
        color: Colors.black,
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
        'Today\'s Income',
        '\$${dashboard.incomeToday.toStringAsFixed(2)}',
        Icons.attach_money,
        Colors.orange,
      ),
      StatItem(
        'Monthly Income',
        '\$${dashboard.incomeMonth.toStringAsFixed(2)}',
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
        '\$${dashboard.netProfit.toStringAsFixed(2)}',
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
}

class StatItem {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  StatItem(this.title, this.value, this.icon, this.color);
}
