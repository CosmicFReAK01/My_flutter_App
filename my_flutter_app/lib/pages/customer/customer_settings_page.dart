import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../widgets/customer_bottom_nav.dart';
import '../../widgets/customer_toggle_menu.dart';

class CustomerSettingsPage extends StatefulWidget {
  const CustomerSettingsPage({super.key});

  @override
  State<CustomerSettingsPage> createState() => _CustomerSettingsPageState();
}

class _CustomerSettingsPageState extends State<CustomerSettingsPage> {
  // Background image asset - developers can change this path manually
  static const String backgroundImageAsset = 'assets/images/laundry_background.png';
  
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _pushNotifications = true;
  bool _orderUpdates = true;
  bool _promotionalOffers = false;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'System';

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
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
            decoration: BoxDecoration(
              // Background image - developers can enable/disable by commenting/uncommenting
              image: const DecorationImage(
                image: AssetImage(backgroundImageAsset),
                fit: BoxFit.cover,
                opacity: 0.3,
              ),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF2A62FF),
                  Color(0xFF6C8EFD),
                  Color(0xFFF8F9FF),
                ],
              ),
            ),
            child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildProfileSection(context, appProvider),
              const SizedBox(height: 24),
              _buildNotificationSettings(),
              const SizedBox(height: 24),
              _buildAppPreferences(),
              const SizedBox(height: 24),
              _buildAccountSettings(),
              const SizedBox(height: 24),
              _buildSupportSection(),
            ],
            ),
          ),
          bottomNavigationBar: CustomerBottomNav(
            currentIndex: 3, // Profile/Settings tab
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
      },
    );
  }

  Widget _buildProfileSection(BuildContext context, AppProvider appProvider) {
    final profile = appProvider.currentProfile;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x40FFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x30FFFFFF)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: profile?.profileImageUrl != null
                    ? NetworkImage(profile!.profileImageUrl!)
                    : null,
                child: profile?.profileImageUrl == null
                    ? const Icon(Icons.person)
                    : null,
              ),
              title: Text(profile?.name ?? 'Guest User', style: const TextStyle(color: Colors.white)),
              subtitle: Text(profile?.email ?? 'No email', style: const TextStyle(color: Colors.white70)),
              trailing: const Icon(Icons.edit, color: Colors.white70),
              onTap: () => Navigator.pushNamed(context, '/edit-profile'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.white70),
              title: const Text('Manage Addresses', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
              onTap: () => Navigator.pushNamed(context, '/addresses'),
            ),
            ListTile(
              leading: const Icon(Icons.payment, color: Colors.white70),
              title: const Text('Payment Methods', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
              onTap: () => _showComingSoon(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x40FFFFFF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x30FFFFFF)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Notifications', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Receive all notifications', style: TextStyle(color: Colors.white70)),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            if (_notificationsEnabled) ...[
              const Divider(),
              SwitchListTile(
                title: const Text('Email Notifications', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Receive notifications via email', style: TextStyle(color: Colors.white70)),
                value: _emailNotifications,
                onChanged: (value) {
                  setState(() {
                    _emailNotifications = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('SMS Notifications', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Receive notifications via SMS', style: TextStyle(color: Colors.white70)),
                value: _smsNotifications,
                onChanged: (value) {
                  setState(() {
                    _smsNotifications = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Push Notifications'),
                subtitle: const Text('Receive push notifications'),
                value: _pushNotifications,
                onChanged: (value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                },
              ),
              const Divider(),
              const Text(
                'Notification Types',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SwitchListTile(
                title: const Text('Order Updates'),
                subtitle: const Text('Status updates for your orders'),
                value: _orderUpdates,
                onChanged: (value) {
                  setState(() {
                    _orderUpdates = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Promotional Offers'),
                subtitle: const Text('Deals and special offers'),
                value: _promotionalOffers,
                onChanged: (value) {
                  setState(() {
                    _promotionalOffers = value;
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAppPreferences() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'App Preferences',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.language, color: Colors.blue),
              title: const Text('Language'),
              subtitle: Text(_selectedLanguage),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showLanguageDialog(),
            ),
            ListTile(
              leading: const Icon(Icons.palette, color: Colors.blue),
              title: const Text('Theme'),
              subtitle: Text(_selectedTheme),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showThemeDialog(),
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.blue),
              title: const Text('Location Services'),
              subtitle: const Text('Allow location access'),
              trailing: Switch(
                value: true,
                onChanged: (value) => _showComingSoon(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Account',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.security, color: Colors.blue),
              title: const Text('Privacy & Security'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showComingSoon(context),
            ),
            ListTile(
              leading: const Icon(Icons.history, color: Colors.blue),
              title: const Text('Order History'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.pushNamed(context, '/orders'),
            ),
            ListTile(
              leading: const Icon(Icons.download, color: Colors.blue),
              title: const Text('Download Data'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showComingSoon(context),
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Delete Account'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showDeleteAccountDialog(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Support',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.help, color: Colors.blue),
              title: const Text('Help & FAQ'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showComingSoon(context),
            ),
            ListTile(
              leading: const Icon(Icons.contact_support, color: Colors.blue),
              title: const Text('Contact Support'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showComingSoon(context),
            ),
            ListTile(
              leading: const Icon(Icons.rate_review, color: Colors.blue),
              title: const Text('Rate App'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showComingSoon(context),
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.blue),
              title: const Text('About'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showAboutDialog(),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'English',
            'Spanish',
            'French',
            'German',
            'Hindi',
          ].map((language) => RadioListTile<String>(
            title: Text(language),
            value: language,
            groupValue: _selectedLanguage,
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!;
              });
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'System',
            'Light',
            'Dark',
          ].map((theme) => RadioListTile<String>(
            title: Text(theme),
            value: theme,
            groupValue: _selectedTheme,
            onChanged: (value) {
              setState(() {
                _selectedTheme = value!;
              });
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deletion feature coming soon'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'LaundryMate',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.local_laundry_service, size: 48),
      children: const [
        Text('Your trusted laundry service companion.'),
        SizedBox(height: 16),
        Text('© 2024 LaundryMate. All rights reserved.'),
      ],
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feature coming soon!'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
