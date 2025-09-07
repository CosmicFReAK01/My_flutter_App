import 'package:flutter/material.dart';
import '../../widgets/notifications_drawer.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final List<Map<String, String>> addresses = [
    {
          'type': 'Home',
      'address': '123 Main Street, Apartment 4B, New York, NY 10001',
      'name': 'Alice Johnson',
      'phone': '+91 98765 43210',
    },
    {
      'type': 'Office',
      'address': '456 Business Ave, Suite 200, New York, NY 10002',
      'name': 'Alice Johnson',
      'phone': '+91 98765 43210',
    },
  ];

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
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      ),
                    const SizedBox(width: 16),
                    const Text(
                      'My Addresses',
                          style: TextStyle(
                            color: Colors.white,
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
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: addresses.length,
                    itemBuilder: (context, index) {
                            final address = addresses[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                                color: const Color(0xB29A9898),
                            borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFFFFFFF)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                                          color: const Color(0xFF2A62FF),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          address['type']!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.white),
                                        onPressed: () {
                                          // Edit address
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          // Delete address
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    address['name']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    address['phone']!,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    address['address']!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Add new address
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add New Address'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A62FF),
                      foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
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
}
