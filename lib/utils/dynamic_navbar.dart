import 'package:flutter/material.dart';
import 'package:pura_crm/core/utils/secure_storage_helper.dart';

class MainLayout extends StatefulWidget {
  final Widget child; // Page content
  const MainLayout({Key? key, required this.child}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  String? userRole;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  // Load user role from secure storage
  void _loadUserRole() async {
    final user = await SecureStorageHelper.getUserData(); // Fetch user data
    if (user != null) {
      setState(() {
        // Assuming user.roles is a list of roles, we're hardcoding as "salesman" for now
        userRole =
            "salesman"; // You can modify this based on actual roles from user data
      });
    }
  }

  // Handle item taps in the bottom navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Define routes per role
    final routes = {
      'admin': ['/dashboard', '/users', '/reports'],
      'salesman': ['/products', '/cart', '/orders'],
      'customer': ['/home', '/orders', '/profile'],
      'supplier': ['/inventory', '/orders', '/profile'],
    };

    // Check if role is loaded and navigate accordingly
    if (userRole != null && routes.containsKey(userRole)) {
      final selectedRoute = routes[userRole!]![index];
      Navigator.pushNamed(context, selectedRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    // If userRole is null or loading, show a default bottom nav with at least two items
    List<BottomNavigationBarItem> navItems = [];

    // Define navigation items based on user role
    switch (userRole) {
      case 'admin':
        navItems = [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics), label: 'Reports'),
        ];
        break;
      case 'salesman':
        navItems = [
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: 'Products'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'Orders'),
        ];
        break;
      case 'customer':
        navItems = [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ];
        break;
      case 'supplier':
        navItems = [
          BottomNavigationBarItem(
              icon: Icon(Icons.inventory), label: 'Inventory'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ];
        break;
      default:
        // Ensure there's always at least one navigation item
        navItems = [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.error), label: 'Error'), // Fallback item
        ];
    }

    // Ensure navItems has at least two items
    if (navItems.length < 2) {
      navItems.add(
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Fallback'),
      );
    }

    return Scaffold(
      body: widget.child, // Load the current page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: navItems,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
