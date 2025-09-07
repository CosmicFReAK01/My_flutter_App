import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Shop Info Controllers
  final TextEditingController shopNameController =
  TextEditingController(text: 'Fresh & Clean Laundry');
  final TextEditingController addressController =
  TextEditingController(text: '123 Main Street, City, State 12345');
  final TextEditingController phoneController =
  TextEditingController(text: '+1 (555) 123-4567');
  final TextEditingController emailController =
  TextEditingController(text: 'contact@freshcleanlaundry.com');
  final TextEditingController websiteController =
  TextEditingController(text: 'www.freshcleanlaundry.com');
  final TextEditingController descriptionController =
  TextEditingController(text: 'Professional laundry and dry cleaning services with 15+ years of experience.');

  // Operating Hours
  Map<String, Map<String, dynamic>> operatingHours = {
    'Monday': {'open': '08:00', 'close': '18:00', 'closed': false},
    'Tuesday': {'open': '08:00', 'close': '18:00', 'closed': false},
    'Wednesday': {'open': '08:00', 'close': '18:00', 'closed': false},
    'Thursday': {'open': '08:00', 'close': '18:00', 'closed': false},
    'Friday': {'open': '08:00', 'close': '18:00', 'closed': false},
    'Saturday': {'open': '09:00', 'close': '16:00', 'closed': false},
    'Sunday': {'open': '10:00', 'close': '14:00', 'closed': true},
  };

  // Notification Settings
  Map<String, bool> notifications = {
    'newOrders': true,
    'orderUpdates': true,
    'paymentReceived': true,
    'customerMessages': true,
    'dailySummary': false,
    'weeklyReport': true,
  };

  // Pricing Settings
  final TextEditingController deliveryFeeController =
  TextEditingController(text: '5.99');
  final TextEditingController minimumOrderController =
  TextEditingController(text: '15.00');
  final TextEditingController expressSurchargeController =
  TextEditingController(text: '3.50');
  final TextEditingController taxRateController =
  TextEditingController(text: '8.25');

  void saveShopInfo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Shop information saved successfully!')),
    );
  }

  void saveOperatingHours() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Operating hours saved successfully!')),
    );
  }

  void saveNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notification preferences saved successfully!')),
    );
  }

  void savePricing() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pricing settings saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Settings',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Manage your shop settings and preferences.',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 24),

          // Shop Information
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.store, color: Colors.blue, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Shop Information',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: shopNameController,
                        decoration: const InputDecoration(
                          labelText: 'Shop Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: websiteController,
                        decoration: const InputDecoration(
                          labelText: 'Website',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: saveShopInfo,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Shop Information'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Operating Hours
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.schedule, color: Colors.blue, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Operating Hours',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ...operatingHours.entries.map((entry) {
                  final day = entry.key;
                  final hours = entry.value;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            day,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Checkbox(
                          value: hours['closed'] as bool,
                          onChanged: (value) {
                            setState(() {
                              operatingHours[day]!['closed'] = value!;
                            });
                          },
                        ),
                        const Text('Closed'),
                        const Spacer(),
                        if (!(hours['closed'] as bool)) ...[
                          SizedBox(
                            width: 80,
                            child: TextFormField(
                              initialValue: hours['open'] as String,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              ),
                              onChanged: (value) {
                                operatingHours[day]!['open'] = value;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('to'),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 80,
                            child: TextFormField(
                              initialValue: hours['close'] as String,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              ),
                              onChanged: (value) {
                                operatingHours[day]!['close'] = value;
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
                ElevatedButton.icon(
                  onPressed: saveOperatingHours,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Operating Hours'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Pricing Settings
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.attach_money, color: Colors.blue, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Pricing Settings',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: deliveryFeeController,
                        decoration: const InputDecoration(
                          labelText: 'Delivery Fee (\$)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: minimumOrderController,
                        decoration: const InputDecoration(
                          labelText: 'Minimum Order (\$)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: expressSurchargeController,
                        decoration: const InputDecoration(
                          labelText: 'Express Surcharge (\$)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: taxRateController,
                        decoration: const InputDecoration(
                          labelText: 'Tax Rate (%)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: savePricing,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Pricing Settings'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Notification Settings
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.notifications, color: Colors.blue, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Notification Preferences',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ...notifications.entries.map((entry) {
                  final key = entry.key;
                  final enabled = entry.value;
                  final title = _getNotificationTitle(key);
                  final description = _getNotificationDescription(key);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                description,
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: enabled,
                          onChanged: (value) {
                            setState(() {
                              notifications[key] = value;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
                ElevatedButton.icon(
                  onPressed: saveNotifications,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Notification Settings'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getNotificationTitle(String key) {
    switch (key) {
      case 'newOrders':
        return 'New Orders';
      case 'orderUpdates':
        return 'Order Updates';
      case 'paymentReceived':
        return 'Payment Received';
      case 'customerMessages':
        return 'Customer Messages';
      case 'dailySummary':
        return 'Daily Summary';
      case 'weeklyReport':
        return 'Weekly Report';
      default:
        return key;
    }
  }

  String _getNotificationDescription(String key) {
    switch (key) {
      case 'newOrders':
        return 'Get notified when new orders are placed';
      case 'orderUpdates':
        return 'Get notified when order status changes';
      case 'paymentReceived':
        return 'Get notified when payments are received';
      case 'customerMessages':
        return 'Get notified when customers send messages';
      case 'dailySummary':
        return 'Receive daily business summary';
      case 'weeklyReport':
        return 'Receive weekly performance report';
      default:
        return 'Get notified when $key';
    }
  }

  @override
  void dispose() {
    shopNameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    emailController.dispose();
    websiteController.dispose();
    descriptionController.dispose();
    deliveryFeeController.dispose();
    minimumOrderController.dispose();
    expressSurchargeController.dispose();
    taxRateController.dispose();
    super.dispose();
  }
}