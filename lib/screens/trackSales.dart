import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pos_frontend/blocs/salesSummaryBloc/sales_summary_bloc.dart';
import 'package:pos_frontend/services/apiService.dart';
import '../models/salesModel/salesSummary.dart';
import '../widgets/app_drawer.dart';

class TrackSalesScreen extends StatefulWidget {
  final ApiService apiService;

  const TrackSalesScreen({
    Key? key,
    required this.apiService,
  }) : super(key: key);

  @override
  _TrackSalesScreenState createState() => _TrackSalesScreenState();
}

class _TrackSalesScreenState extends State<TrackSalesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late SalesSummaryBloc _salesBloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _salesBloc = SalesSummaryBloc(apiService: widget.apiService);
    _fetchSalesData();

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _fetchSalesData();
      }
    });
  }

  void _fetchSalesData() {
    if (_tabController.index == 0) {
      _salesBloc.add(FetchDailySales());
    } else {
      _salesBloc.add(FetchMonthlySales());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _salesBloc,
      child: Scaffold(
        drawer: SidebarScreen(apiService: widget.apiService),
        appBar: AppBar(
          title: Text('Track Sales'),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Daily Sales'),
              Tab(text: 'Monthly Sales'),
            ],
          ),
        ),
        body: BlocBuilder<SalesSummaryBloc, SalesSummaryState>(
          builder: (context, state) {
            if (state is SalesLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is SalesError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('You didn\'t sale anything today!'),
                    ElevatedButton(
                      onPressed: _fetchSalesData,
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is SalesLoaded) {
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildSalesView(state.salesData),
                  _buildSalesView(state.salesData),
                ],
              );
            }

            return Center(child: Text('No sales data available'));
          },
        ),
      ),
    );
  }

  Widget _buildSalesView(List<SalesSummary> salesData) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSalesChart(salesData),
          _buildSalesTable(salesData),
        ],
      ),
    );
  }

  Widget _buildSalesChart(List<SalesSummary> salesData) {
    if (salesData.isEmpty) return SizedBox.shrink();

    return Container(
      height: 500,
      padding: EdgeInsets.all(16),
      child: BarChart(
        BarChartData(
          gridData: FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          maxY: salesData
                  .map((e) => e.totalRevenue)
                  .reduce((a, b) => a > b ? a : b) *
              1.2,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: false,
            )),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 20,
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= salesData.length) return Text('');
                  return Padding(
                    padding: const EdgeInsets.all(2),
                    child: SizedBox(
                      width: 30,
                      child: Transform.rotate(
                        angle:
                            -0.5, // Rotate text (negative for left tilt, positive for right)
                        child: Text(
                          salesData[value.toInt()].productName.split(' ')[0],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 40,
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text('Rs.${value.toInt()}',
                      style: TextStyle(fontSize: 10));
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: salesData.asMap().entries.map((entry) {
            return BarChartGroupData(
              barsSpace: 12,
              x: entry.key,
              barRods: [
                BarChartRodData(
                  gradient: LinearGradient(colors: [
                    Theme.of(context).primaryColor.withOpacity(0.8),
                    Colors.pinkAccent
                  ], transform: const GradientRotation(pi / 40)),
                  toY: entry.value.totalRevenue,
                  color: Theme.of(context).primaryColor,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSalesTable(List<SalesSummary> salesData) {
    return Card(
      margin: EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Product')),
            DataColumn(label: Text('Quantity')),
            DataColumn(label: Text('Revenue')),
            if (_tabController.index == 1) DataColumn(label: Text('Date')),
          ],
          rows: salesData.map((sale) {
            return DataRow(
              color: MaterialStateProperty.all(
                  Colors.transparent), // Make row transparent
              cells: [
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 12), // Adjust spacing
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.8),
                          Colors.pinkAccent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(
                          5), // Optional for rounded corners
                    ),
                    child: Text(sale.productName,
                        style: TextStyle(
                            color: Colors.white)), // Ensure text visibility
                  ),
                ),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.8),
                          Colors.pinkAccent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(sale.totalQuantity.toString(),
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.8),
                          Colors.pinkAccent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text('Rs.${sale.totalRevenue.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                if (_tabController.index == 1)
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.8),
                            Colors.pinkAccent,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(sale.date ?? '',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _salesBloc.close();
    super.dispose();
  }
}
