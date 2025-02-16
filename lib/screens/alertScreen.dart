import 'package:flutter/material.dart';
import 'package:pos_frontend/models/inventoryModel/inventoryEntity.dart';
import 'package:pos_frontend/services/apiService.dart';
import 'package:pos_frontend/widgets/app_drawer.dart';

class AlertScreen extends StatefulWidget {
  final ApiService apiService;
  const AlertScreen({super.key, required this.apiService});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  late Future<List<InventoryEntity>> _lowStockProducts;

  @override
  void initState() {
    super.initState();
    _lowStockProducts = widget.apiService.getLowStockProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SidebarScreen(apiService: widget.apiService),
      appBar: AppBar(
        title: Text('Low Stock Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _lowStockProducts = widget.apiService.getLowStockProducts();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<InventoryEntity>>(
        future: _lowStockProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No low stock products found'),
            );
          }
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final product = snapshot.data![index];
              return Card(
                elevation: 2,
                margin: EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getStockLevelColor(product.quantity),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${product.quantity}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    product.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price: Rs.${product.price.toStringAsFixed(2)}'),
                      if (product.categoryName != null)
                        Text('Category: ${product.categoryName}'),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Navigate to update product screen
                      Navigator.pushNamed(
                        context,
                        '/inventory',
                        arguments: product,
                      ).then((_) {
                        // Refresh the list when returning
                        setState(() {
                          _lowStockProducts =
                              widget.apiService.getLowStockProducts();
                        });
                      });
                    },
                    child: Text('Restock'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

Color _getStockLevelColor(int quantity) {
  if (quantity <= 5) {
    return Colors.red;
  } else if (quantity <= 10) {
    return Colors.orange;
  } else {
    return Colors.yellow[700]!;
  }
}
