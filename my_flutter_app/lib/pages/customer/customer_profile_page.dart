import 'package:flutter/material.dart';
import '../../widgets/customer_bottom_nav.dart';
import '../../widgets/customer_toggle_menu.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  // Background image asset - developers can change this path manually
  static const String backgroundImageAsset = 'assets/images/laundry_background.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
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
          // Background image - fully visible
          image: DecorationImage(
            image: AssetImage(backgroundImageAsset),
            fit: BoxFit.cover,
            opacity: 1.0,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xCB686565),
                    child: Icon(Icons.person, color: Colors.white, size: 50),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Alice Johnson',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Guest User',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xB5515050),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Silver Member',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildProfileItem(context, 'Personal Information', Icons.person_outline, '/edit_profile'),
            _buildProfileItem(context, 'Addresses', Icons.location_on_outlined, '/addresses'),
            _buildProfileItem(context, 'Payment Methods', Icons.payment_outlined, '/payment_methods'),
            _buildProfileItem(context, 'Order History', Icons.history, '/orders'),
            _buildProfileItem(context, 'Notifications', Icons.notifications_none, '/notifications'),
            _buildProfileItem(context, 'Help & Support', Icons.help_outline, null, isHelp: true),
            _buildProfileItem(context, 'Logout', Icons.logout, null, isLogout: true),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context, String title, IconData icon, String? route,
      {bool isLogout = false, bool isHelp = false}) {
    return GestureDetector(
      onTap: () {
        if (route != null) {
          Navigator.pushNamed(context, route);
        } else if (isLogout) {
          _showLogoutDialog(context);
        } else if (isHelp) {
          _showHelpDialog(context);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xBE515050),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xD7FFFFFF)),
        ),
        child: Row(
          children: [
            Icon(icon, color: isLogout ? Colors.red : Colors.white),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: isLogout ? Colors.red : Colors.white,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: isLogout ? Colors.red : Colors.white70,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/');
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Help & Support'),
          content: const Text(
            'Need help? Contact our support team:\n\n'
                '📞 Phone: +91 98765 43210\n'
                '📧 Email: support@laundrymate.com\n'
                '💬 Chat: Available 24/7',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

// Add bottom navigation after the main widget
class ProfilePageWithNav extends StatefulWidget {
  const ProfilePageWithNav({Key? key}) : super(key: key);

  @override
  State<ProfilePageWithNav> createState() => _ProfilePageWithNavState();
}

class _ProfilePageWithNavState extends State<ProfilePageWithNav> {
  int _currentIndex = 3; // Profile tab

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ProfilePage(),
      bottomNavigationBar: CustomerBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
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
            // Already on profile page
              break;
          }
        },
      ),
    );
  }
}