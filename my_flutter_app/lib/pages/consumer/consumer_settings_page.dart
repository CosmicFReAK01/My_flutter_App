import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';

class ConsumerSettingsPage extends StatefulWidget {
  final VoidCallback onBack;
  const ConsumerSettingsPage({super.key, required this.onBack});

  @override
  State<ConsumerSettingsPage> createState() => _ConsumerSettingsPageState();
}

class _ConsumerSettingsPageState extends State<ConsumerSettingsPage> {
  bool _notificationsEnabled = true;
  bool _orderNotifications = true;
  bool _customerNotifications = true;
  bool _marketingEmails = false;
  bool _autoAcceptOrders = false;
  bool _businessHoursOnly = true;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'System';
  String _orderSoundAlert = 'Default';

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Business Settings'),
            backgroundColor: Colors.green[600],
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: widget.onBack,
              tooltip: 'Back to Dashboard',
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildBusinessProfile(context, appProvider),
              const SizedBox(height: 24),
              _buildOrderSettings(),
              const SizedBox(height: 24),
              _buildNotificationSettings(),
              const SizedBox(height: 24),
              _buildBusinessPreferences(),
              const SizedBox(height: 24),
              _buildAccountSettings(),
              const SizedBox(height: 24),
              _buildSupportSection(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBusinessProfile(BuildContext context, AppProvider appProvider) {
    final profile = appProvider.currentProfile;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Business Profile',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: profile?.profileImageUrl != null
                    ? NetworkImage(profile!.profileImageUrl!)
                    : null,
                child: profile?.profileImageUrl == null
                    ? const Icon(Icons.business)
                    : null,
              ),
              title: Text(profile?.businessName ?? profile?.name ?? 'Business'),
              subtitle: Text(profile?.email ?? 'No email'),
              trailing: const Icon(Icons.edit),
              onTap: () => Navigator.pushNamed(context, '/consumer-profile'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.store, color: Colors.green),
              title: const Text('Shop Locations'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.pushNamed(context, '/consumer-addresses'),
            ),
            ListTile(
              leading: const Icon(Icons.room_service, color: Colors.green),
              title: const Text('Manage Services'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.pushNamed(context, '/consumer-services'),
            ),
            ListTile(
              leading: const Icon(Icons.schedule, color: Colors.green),
              title: const Text('Business Hours'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showComingSoon(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Management',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Auto-Accept Orders'),
              subtitle: const Text('Automatically accept incoming orders'),
              value: _autoAcceptOrders,
              onChanged: (value) {
                setState(() {
                  _autoAcceptOrders = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Business Hours Only'),
              subtitle: const Text('Only receive orders during business hours'),
              value: _businessHoursOnly,
              onChanged: (value) {
                setState(() {
                  _businessHoursOnly = value;
                });
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.volume_up, color: Colors.green),
              title: const Text('Order Alert Sound'),
              subtitle: Text(_orderSoundAlert),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showSoundDialog(),
            ),
            ListTile(
              leading: const Icon(Icons.timer, color: Colors.green),
              title: const Text('Order Response Time'),
              subtitle: const Text('Maximum time to respond to orders'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showComingSoon(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Notifications'),
              subtitle: const Text('Receive all business notifications'),
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
                title: const Text('New Order Notifications'),
                subtitle: const Text('Alert when new orders arrive'),
                value: _orderNotifications,
                onChanged: (value) {
                  setState(() {
                    _orderNotifications = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Customer Messages'),
                subtitle: const Text('Notifications for customer inquiries'),
                value: _customerNotifications,
                onChanged: (value) {
                  setState(() {
                    _customerNotifications = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Marketing Emails'),
                subtitle: const Text('Business tips and promotional content'),
                value: _marketingEmails,
                onChanged: (value) {
                  setState(() {
                    _marketingEmails = value;
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessPreferences() {
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
              leading: const Icon(Icons.language, color: Colors.green),
              title: const Text('Language'),
              subtitle: Text(_selectedLanguage),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showLanguageDialog(),
            ),
            ListTile(
              leading: const Icon(Icons.palette, color: Colors.green),
              title: const Text('Theme'),
              subtitle: Text(_selectedTheme),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showThemeDialog(),
            ),
            ListTile(
              leading: const Icon(Icons.analytics, color: Colors.green),
              title: const Text('Business Analytics'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => Navigator.pushNamed(context, '/consumer-analytics'),
            ),
            ListTile(
              leading: const Icon(Icons.backup, color: Colors.green),
              title: const Text('Data Backup'),
              subtitle: const Text('Backup business data'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showComingSoon(context),
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
              'Account & Security',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.security, color: Colors.green),
              title: const Text('Privacy & Security'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showComingSoon(context),
            ),
            ListTile(
              leading: const Icon(Icons.payment, color: Colors.green),
              title: const Text('Payment Settings'),
              subtitle: const Text('Bank account and payment methods'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showComingSoon(context),
            ),
            ListTile(
              leading: const Icon(Icons.receipt, color: Colors.green),
              title: const Text('Tax Settings'),
              subtitle: const Text('Tax rates and invoice settings'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showComingSoon(context),
            ),
            ListTile(
              leading: const Icon(Icons.download, color: Colors.green),
              title: const Text('Export Business Data'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showComingSoon(context),
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
              'Support & Resources',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.help, color: Colors.green),
              title: const Text('Business Help Center'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showComingSoon(context),
            ),
            ListTile(
              leading: const Icon(Icons.school, color: Colors.green),
              title: const Text('Business Training'),
              subtitle: const Text('Learn to grow your business'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showComingSoon(context),
            ),
            ListTile(
              leading: const Icon(Icons.contact_support, color: Colors.green),
              title: const Text('Contact Business Support'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showComingSoon(context),
            ),
            ListTile(
              leading: const Icon(Icons.feedback, color: Colors.green),
              title: const Text('Send Feedback'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showComingSoon(context),
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.green),
              title: const Text('About LaundryMate Business'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showAboutDialog(),
            ),
          ],
        ),
      ),
    );
  }

  void _showSoundDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Alert Sound'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            'Default',
            'Chime',
            'Bell',
            'Notification',
            'Silent',
          ].map((sound) => RadioListTile<String>(
            title: Text(sound),
            value: sound,
            groupValue: _orderSoundAlert,
            onChanged: (value) {
              setState(() {
                _orderSoundAlert = value!;
              });
              Navigator.pop(context);
            },
          )).toList(),
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

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'LaundryMate Business',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.business, size: 48, color: Colors.green),
      children: const [
        Text('Manage your laundry business with ease.'),
        SizedBox(height: 16),
        Text('© 2024 LaundryMate Business. All rights reserved.'),
      ],
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Feature coming soon!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}
