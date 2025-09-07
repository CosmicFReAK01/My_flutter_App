import 'package:flutter/material.dart';

class NotificationsEndDrawer extends StatelessWidget {
  const NotificationsEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> demoNotifications = [
      {
        'title': 'Order #1234 Ready',
        'subtitle': 'Your laundry is ready for pickup.',
        'time': '2m ago'
      },
      {
        'title': 'Limited Time Offer',
        'subtitle': 'Get 20% off on dry cleaning today!',
        'time': '1h ago'
      },
      {
        'title': 'Order #1227 Delivered',
        'subtitle': 'Thanks for choosing Laundry Mate.',
        'time': 'Yesterday'
      },
    ];

    return Drawer(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SafeArea(
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 20,
                  offset: const Offset(-6, 0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Notifications',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white24, height: 1),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(0),
                    itemCount: demoNotifications.length,
                    separatorBuilder: (_, __) => const Divider(color: Colors.white12, height: 1),
                    itemBuilder: (context, index) {
                      final item = demoNotifications[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFF2A62FF),
                          child: Icon(Icons.notifications, color: Colors.white),
                        ),
                        title: Text(
                          item['title'] ?? '',
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          item['subtitle'] ?? '',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: Text(
                          item['time'] ?? '',
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


