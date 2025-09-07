import 'package:flutter/material.dart';
import '../../widgets/customer_bottom_nav.dart';
import '../../widgets/customer_toggle_menu.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);
  
  // Background image asset - developers can change this path manually
  static const String backgroundImageAsset = 'assets/images/laundry_background.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: const Color(0xFF2A62FF),
        actions: const [
          CustomerToggleMenu(),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          // Background image - fully visible
          image: DecorationImage(
            image: AssetImage(backgroundImageAsset),
            fit: BoxFit.cover,
            opacity: 1.0,
          ),
        ),
        child: const Center(child: Text('Notifications content here', style: TextStyle(color: Colors.white))),
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
