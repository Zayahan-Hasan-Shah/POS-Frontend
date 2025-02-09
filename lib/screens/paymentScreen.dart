import 'package:flutter/material.dart';
import 'package:pos_frontend/models/cartModel/cartItem.dart';
import 'package:pos_frontend/screens/invoiceScreen.dart';

class PaymentScreen extends StatefulWidget {
  final List<CartItem> cartItems;
  final double total;

  const PaymentScreen({
    Key? key,
    required this.cartItems,
    required this.total,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? _selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Order Summary Section
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Summary',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // List of cart items
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.cartItems.length,
                          itemBuilder: (context, index) {
                            final item = widget.cartItems[index];
                            return CartItemTile(item: item);
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Amount',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '\$${widget.total.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Payment Methods Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Payment Method',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Cash Option
                        PaymentMethodCard(
                          title: 'Cash Payment',
                          icon: Icons.money,
                          isSelected: _selectedPaymentMethod == 'cash',
                          onTap: () {
                            setState(() {
                              _selectedPaymentMethod = 'cash';
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        // Online Option
                        PaymentMethodCard(
                          title: 'Online Payment',
                          icon: Icons.payment,
                          isSelected: _selectedPaymentMethod == 'online',
                          onTap: () {
                            setState(() {
                              _selectedPaymentMethod = 'online';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Payment Button
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: FloatingActionButton.extended(
              onPressed: _selectedPaymentMethod == null
                  ? null
                  : () {
                      // Process payment here
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InvoiceScreen(
                            cartItems: widget.cartItems,
                            total: widget.total,
                            paymentMethod: _selectedPaymentMethod ?? 'Cash',
                          ),
                        ),
                      );
                    },
              label: const Text(
                'Pay Now',
                style: TextStyle(fontSize: 24),
              ),
              icon: const Icon(
                Icons.payment,
                size: 32,
              ),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentMethodCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final CartItem item;

  const CartItemTile({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(item.product.name),
          ),
          Expanded(
            child: Text(
              '${item.quantity}x',
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
