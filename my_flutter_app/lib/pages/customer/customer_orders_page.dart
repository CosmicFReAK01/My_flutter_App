import 'package:flutter/material.dart';
import '../../widgets/customer_bottom_nav.dart';
import '../../widgets/customer_toggle_menu.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);
  
  // Background image asset - developers can change this path manually
  static const String backgroundImageAsset = 'assets/images/laundry_background.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: const Color(0xFF2A62FF),
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
            opacity: 1.0,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildOrderCard('Wash & Fold', 'Completed', '₹299', '5 Shirts, 3 Pants, 2 T-shirts', '25 Oct 2023', Icons.check_circle, const Color(
                0xFF094511)),
            const SizedBox(height: 16),
            _buildOrderCard('Dry Cleaning', 'In Progress', '₹449', '2 Suits, 1 Dress', '24 Oct 2023', Icons.access_time, const Color(
                0xFFFF6200)),
            const SizedBox(height: 16),
            _buildOrderCard('Ironing', 'Scheduled', '₹199', '5 Shirts', '26 Oct 2023', Icons.calendar_today, const Color(
                0xFF10779C)),
            const SizedBox(height: 16),
            _buildOrderCard('Premium Laundry', 'Delivered', '₹599', 'Bed Sheets, Curtains', '22 Oct 2023', Icons.local_shipping, const Color(
                0xFF490F73)),
            const SizedBox(height: 16),
            _buildOrderCard('Express Service', 'Cancelled', '₹349', '2 Jeans, 3 Shirts', '20 Oct 2023', Icons.cancel, const Color(
                0xFFBF0000)),
          ],
        ),
      ),
      bottomNavigationBar: CustomerBottomNav(
        currentIndex: 2, // Orders tab
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/cart');
              break;
            case 2:
              // Already on orders page
              break;
            case 3:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }

  Widget _buildOrderCard(String service, String status, String price, String items, String date, IconData icon, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xBB676767),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFFFFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                service,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                price,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            items,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: statusColor, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Text(
                date,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}