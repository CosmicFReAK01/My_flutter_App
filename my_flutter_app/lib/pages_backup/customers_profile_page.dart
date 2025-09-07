import 'package:flutter/material.dart';
import '../../widgets/notifications_drawer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const NotificationsEndDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/laundry_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar with back button
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF6A6866)),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Profile',
                      style: TextStyle(
                        color: Color(0xC5515050),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Builder(
                      builder: (drawerContext) => IconButton(
                        icon: const Icon(Icons.notifications, color: Colors.white),
                        onPressed: () {
                          Scaffold.of(drawerContext).openEndDrawer();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView(
                    children: [
                      // Profile header
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xA1514F4F),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFFFFFFF)),
                        ),
                        child: Column(
                          children: [
                            const CircleAvatar(
                              radius: 50,
                              backgroundColor: Color(0x60FFFFFF),
                              child: Icon(Icons.person, color: Color(0xFF58199F), size: 50),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'ALICE',
                              style: TextStyle(
                                color: Color(0xFF193345),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'alice.johnson@email.com',
                              style: TextStyle(
                                color:Color(0xFF47340E),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildProfileStat('Orders', '12', color: Color(0xFF0D4991)),
                                _buildProfileStat('Completed', '8', color: Color(0xFF0D4991)),
                                _buildProfileStat('Pending', '4', color: Color(0xFF0D4991)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Profile options
                      _buildProfileOption(Icons.edit, 'Edit Profile', () {
                        Navigator.pushNamed(context, '/edit-profile');
                      }),
                      _buildProfileOption(Icons.location_on, 'My Addresses', () {
                        Navigator.pushNamed(context, '/addresses');
                      }),
                      _buildProfileOption(Icons.settings, 'Settings', () {}),
                      _buildProfileOption(Icons.help, 'Help & Support', () {}),
                      _buildProfileOption(Icons.logout, 'Logout', () {}),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String value, {required Color color}) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xB29A9898),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFFFFF)),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
        onTap: onTap,
      ),
    );
  }
}
