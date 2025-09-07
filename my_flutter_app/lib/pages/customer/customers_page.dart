import 'package:flutter/material.dart';
import '../../widgets/customer_bottom_nav.dart';
import '../../widgets/customer_toggle_menu.dart';

class CustomersPage extends StatelessWidget {
  final VoidCallback? onBack;
  const CustomersPage({Key? key, this.onBack}) : super(key: key);
  
  // Background image asset - developers can change this path manually
  static const String backgroundImageAsset = 'assets/images/laundry_background.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        backgroundColor: const Color(0xFF2A62FF),
        leading: onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBack,
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
          const CustomerToggleMenu(),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          // Background image - developers can enable/disable by commenting/uncommenting
          image: DecorationImage(
            image: AssetImage(backgroundImageAsset),
            fit: BoxFit.cover,
            opacity: 1,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2A62FF),
              Color(0xFF6C8EFD),
              Color(0xFFF8F9FF),
            ],
          ),
        ),
        child: const Center(child: Text('Customers list here', style: TextStyle(color: Colors.white))),
      ),
      bottomNavigationBar: CustomerBottomNav(
        currentIndex: 0, // Default to home
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/cart');
              break;
            case 2:
              Navigator.pushNamed(context, '/orders');
              break;
            case 3:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
