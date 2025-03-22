// i
//
//mport 'package:flutter/material.dart';
// import 'package:pura_crm/core/utils/secure_storage_helper.dart';

// class MainLayout extends StatefulWidget {
//   final Widget
//       child; // For   also be wrapped)
//   const MainLayout({super.key, required this.child});

//   @override
//   _MainLayoutState createState() => _MainLayoutState();
// }

// class _MainLayoutState extends State<MainLayout> {
//   String? userRole;

//   // Mapping of salesman route names to bottom navigation bar indices.
//   // Make sure these route names match those in your main.dart.
//   final Map<String, int> salesmanRouteToIndex = {
//     '/cart': 0,
//     '/products': 1,
//     '/salesmanHome': 2, // Salesman Home route in your main.dart (_buildPage)
//     '/deals': 3,
//     '/customer/list': 4,
//   };

//   @override
//   void initState() {
//     super.initState();
//     _loadUserRole();
//   }

//   // Load the user role from secure storage.
//   void _loadUserRole() async {
//     final user = await SecureStorageHelper.getUserData();
//     if (user != null) {
//       setState(() {
//         // For demonstration, we're hardcoding as "salesman".
//         // Adjust this logic according to your actual user data.
//         userRole = "salesman";
//       });
//     }
//   }

//   // Handle bottom navigation taps.
//   void _onItemTapped(int index) {
//     // Define the route mappings for each role.
//     final routes = {
//       'admin': ['/dashboard', '/users', '/reports'],
//       'salesman': [
//         '/cart',
//         '/products',
//         '/salesmanHome',
//         '/deals',
//         '/customer/list'
//       ],
//       'customer': ['/home', '/orders', '/profile'],
//       'supplier': ['/inventory', '/orders', '/profile'],
//     };

//     if (userRole != null && routes.containsKey(userRole)) {
//       final selectedRoute = routes[userRole!]![index];

//       // If we're not already on the selected route, navigate.
//       if (ModalRoute.of(context)?.settings.name != selectedRoute) {
//         Navigator.pushNamed(context, selectedRoute);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Determine the selected index based on the current route name.
//     int selectedIndex = 0;
//     final currentRoute = ModalRoute.of(context)?.settings.name ?? '';
//     if (userRole == 'salesman') {
//       if (currentRoute.startsWith('/product')) {
//         selectedIndex = 1;
//       } else if (currentRoute.startsWith('/cart')) {
//         selectedIndex = 0;
//       } else if (currentRoute.startsWith('/deals')) {
//         selectedIndex = 3;
//       } else if (currentRoute.startsWith('/customer')) {
//         selectedIndex = 4;
//       } else if (currentRoute.startsWith('/salesmanHome')) {
//         selectedIndex = 2;
//       } else {
//         selectedIndex = salesmanRouteToIndex[currentRoute] ?? 2;
//       }
//     }

//     // Build the bottom navigation bar items based on the user role.
//     List<BottomNavigationBarItem> navItems = [];
//     switch (userRole) {
//       case 'admin':
//         navItems = [
//           BottomNavigationBarItem(
//               icon: Icon(Icons.dashboard), label: 'Dashboard'),
//           BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.analytics), label: 'Reports'),
//         ];
//         break;
//       case 'salesman':
//         navItems = [
//           // Left side: Cart, Products.
//           BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_cart), label: 'Cart'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_bag), label: 'Products'),
//           // Center: Home.
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           // Right side: Deals, Customers.
//           BottomNavigationBarItem(
//               icon: Icon(Icons.local_offer), label: 'Deals'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Customers'),
//         ];
//         break;
//       case 'customer':
//         navItems = [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.receipt_long), label: 'Orders'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ];
//         break;
//       case 'supplier':
//         navItems = [
//           BottomNavigationBarItem(
//               icon: Icon(Icons.inventory), label: 'Inventory'),
//           BottomNavigationBarItem(
//               icon: Icon(Icons.receipt_long), label: 'Orders'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ];
//         break;
//       default:
//         navItems = [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.error), label: 'Error'),
//         ];
//     }

//     return Scaffold(
//       body: widget.child,
//       bottomNavigationBar: BottomNavigationBar(
//         type:
//             BottomNavigationBarType.fixed, // Ensure labels are always visible.
//         currentIndex: selectedIndex,
//         onTap: _onItemTapped,
//         items: navItems,
//         selectedItemColor: const Color(0xFFE41B47), // Primary color.
//         unselectedItemColor: Colors.grey,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:pura_crm/core/utils/secure_storage_helper.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  String? userRole;

  // For example, mapping for salesman routes.
  final Map<String, int> salesmanRouteToIndex = {
    '/cart': 0,
    '/products': 1,
    '/salesmanHome': 2,
    '/deals': 3,
    '/customer/list': 4,
  };

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  // Load the user role from secure storage.
  void _loadUserRole() async {
    final user = await SecureStorageHelper.getUserData();
    if (user != null) {
      setState(() {
        // For demonstration, you might hardcode the role.
        // Replace with actual user data logic.
        userRole =
            "salesman"; // Change to "manager" to test the manager navbar.
      });
    }
  }

  // Handle bottom navigation taps.
  void _onItemTapped(int index) {
    // Define the route mappings for each role.
    final routes = {
      'admin': ['/dashboard', '/users', '/reports'],
      'salesman': [
        '/cart',
        '/products',
        '/salesmanHome',
        '/deals',
        '/customer/list'
      ],
      'manager': [
        '/products',
        '/deals',
        '/managerHome',
        '/managerReports',
        '/customer/list'
      ],
      'customer': ['/home', '/orders', '/profile'],
      'supplier': ['/inventory', '/orders', '/profile'],
    };

    if (userRole != null && routes.containsKey(userRole)) {
      final selectedRoute = routes[userRole!]![index];
      // Navigate if not already on the selected route.
      if (ModalRoute.of(context)?.settings.name != selectedRoute) {
        Navigator.pushNamed(context, selectedRoute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the selected index based on the current route name.
    int selectedIndex = 0;
    final currentRoute = ModalRoute.of(context)?.settings.name ?? '';

    if (userRole == 'salesman') {
      if (currentRoute.startsWith('/product')) {
        selectedIndex = 1;
      } else if (currentRoute.startsWith('/cart')) {
        selectedIndex = 0;
      } else if (currentRoute.startsWith('/deals')) {
        selectedIndex = 3;
      } else if (currentRoute.startsWith('/customer')) {
        selectedIndex = 4;
      } else if (currentRoute.startsWith('/salesmanHome')) {
        selectedIndex = 2;
      } else {
        selectedIndex = salesmanRouteToIndex[currentRoute] ?? 2;
      }
    } else if (userRole == 'manager') {
      // Manager role route matching.
      if (currentRoute.startsWith('/managerProduct')) {
        selectedIndex = 0;
      } else if (currentRoute.startsWith('/managerDealDetail')) {
        selectedIndex = 1;
      } else if (currentRoute.startsWith('/managerHome')) {
        selectedIndex = 2;
      } else if (currentRoute.startsWith('/managerReports')) {
        selectedIndex = 3;
      } else if (currentRoute.startsWith('/managerAddUsers')) {
        selectedIndex = 4;
      }
    }

    // Build bottom navigation bar items based on the user role.
    List<BottomNavigationBarItem> navItems = [];
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
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_offer), label: 'Deals'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Customers'),
        ];
        break;
      case 'manager':
        navItems = [
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: 'Product'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_offer), label: 'Deal Detail'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics), label: 'Reports'),
          BottomNavigationBarItem(
              icon: Icon(Icons.group_add), label: 'Add Users'),
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
        navItems = [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.error), label: 'Error'),
        ];
    }

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Labels always visible.
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        items: navItems,
        selectedItemColor: const Color(0xFFE41B47), // Primary color.
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
