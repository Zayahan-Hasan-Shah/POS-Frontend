import 'package:flutter/material.dart';
import '../services/apiService.dart';

class SidebarScreen extends StatefulWidget {
  final ApiService apiService;

  const SidebarScreen({
    Key? key,
    required this.apiService,
  }) : super(key: key);

  @override
  State<SidebarScreen> createState() => _SidebarScreenState();
}

class _SidebarScreenState extends State<SidebarScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          Container(
            height: 275, // Increased height
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 45, // Increased avatar size
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 50, color: Colors.black),
                  ),
                  const SizedBox(height: 20), // Increased spacing
                  const Text(
                    'My POS System',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28, // Increased font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // const SizedBox(height: 12), // Increased spacing
                  // Text(
                  //   'Welcome, ${widget.apiService.userName}!',
                  //   style: const TextStyle(
                  //     color: Colors.white70,
                  //     fontSize: 18,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),

          // Menu Items
          _buildMenuItem(
            icon: Icons.dashboard,
            title: 'Dashboard',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          ),

          _buildMenuItem(
            icon: Icons.category,
            title: 'Categories',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/categories');
            },
          ),

          _buildMenuItem(
            icon: Icons.inventory,
            title: 'Inventory/Products',
            onTap: () => Navigator.pushReplacementNamed(context, '/inventory'),
          ),

          _buildMenuItem(
            icon: Icons.crop_sharp,
            title: 'Alerts',
            onTap: () => Navigator.pushReplacementNamed(context, '/alerts'),
          ),

          _buildMenuItem(
            icon: Icons.bar_chart,
            title: 'Track Sales',
            onTap: () => Navigator.pushReplacementNamed(context, '/tracksales'),
          ),

          _buildMenuItem(
            icon: Icons.shopping_cart, // Changed icon to be more appropriate
            title: 'Add to Cart',
            onTap: () =>
                Navigator.pushReplacementNamed(context, '/addproductstocart'),
          ),

          _buildMenuItem(
            icon: Icons.people,
            title: 'Customers',
            onTap: () => Navigator.pushReplacementNamed(context, '/customers'),
          ),

          _buildMenuItem(
            icon: Icons.local_shipping, // Changed icon to be more appropriate
            title: 'Suppliers',
            onTap: () => Navigator.pushReplacementNamed(context, '/suppliers'),
          ),

          const Divider(),

          _buildMenuItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () => Navigator.pushReplacementNamed(context, '/settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 24), // Added padding
      dense: true, // Makes the ListTile more compact
    );
  }
}
