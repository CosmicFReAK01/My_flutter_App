import 'package:flutter/material.dart';

class ConsumerNotificationsPage extends StatefulWidget {
  final VoidCallback? onBack;
  const ConsumerNotificationsPage({Key? key, this.onBack}) : super(key: key);

  @override
  State<ConsumerNotificationsPage> createState() => _ConsumerNotificationsPageState();
}

class _ConsumerNotificationsPageState extends State<ConsumerNotificationsPage> {
  final List<Map<String, dynamic>> notifications = [
    // ... your notifications data
  ];

  String selectedFilter = 'All';

  IconData getNotificationIcon(String type) {
    switch (type) {
      case 'order':
        return Icons.shopping_bag;
      case 'payment':
        return Icons.payment;
      case 'status':
        return Icons.check_circle;
      case 'message':
        return Icons.message;
      case 'summary':
        return Icons.analytics;
      default:
        return Icons.notifications;
    }
  }

  Color getNotificationColor(String type) {
    switch (type) {
      case 'order':
        return Colors.blue;
      case 'payment':
        return Colors.green;
      case 'status':
        return Colors.orange;
      case 'message':
        return Colors.purple;
      case 'summary':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  void markAsRead(int id) {
    setState(() {
      final index = notifications.indexWhere((n) => n['id'] == id);
      if (index != -1) notifications[index]['read'] = true;
    });
  }

  void markAllAsRead() {
    setState(() {
      for (var notification in notifications) notification['read'] = true;
    });
  }

  List<Map<String, dynamic>> getFilteredNotifications() {
    if (selectedFilter == 'All') return notifications;
    if (selectedFilter == 'Unread') return notifications.where((n) => !n['read']).toList();
    if (selectedFilter == 'Orders') {
      return notifications.where((n) => n['type'] == 'order').toList();
    }
    if (selectedFilter == 'Payments') {
      return notifications.where((n) => n['type'] == 'payment').toList();
    }
    if (selectedFilter == 'Messages') {
      return notifications.where((n) => n['type'] == 'message').toList();
    }
    return notifications;
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = notifications.where((n) => !n['read']).length;
    final filtered = getFilteredNotifications();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/consumer-home');
          },
        ),
        title: const Text('Notifications'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/laundry_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Notifications',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Stay updated. $unreadCount unread.',
                        style: const TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ],
                  ),
                  if (unreadCount > 0)
                    TextButton(
                      onPressed: markAllAsRead,
                      child: const Text('Mark all as read'),
                      style: TextButton.styleFrom(foregroundColor: Colors.blue),
                    ),
                ],
              ),
            ),
            SizedBox(height: 18),
            // Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
              child: Row(
                children: [
                  _buildFilterChip('All'),
                  SizedBox(width: 8),
                  _buildFilterChip('Orders'),
                  SizedBox(width: 8),
                  _buildFilterChip('Payments'),
                  SizedBox(width: 8),
                  _buildFilterChip('Messages'),
                  SizedBox(width: 8),
                  _buildFilterChip('Unread'),
                ],
              ),
            ),
            SizedBox(height: 18),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final notification = filtered[index];
                  final isRead = notification['read'] as bool;
                  final color = getNotificationColor(notification['type'] as String);
                  return GestureDetector(
                    onTap: () => markAsRead(notification['id'] as int),
                    child: Card(
                      elevation: isRead ? 0 : 2,
                      shadowColor: isRead ? Colors.grey[100] : color.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      color: isRead ? Colors.white.withOpacity(0.96) : color.withOpacity(0.08),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(11),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.17),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                getNotificationIcon(notification['type'] as String),
                                color: color,
                                size: 28,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        fit: FlexFit.loose,
                                        child: Text(
                                          notification['title'] as String,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        notification['time'] as String,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    notification['message'] as String,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!isRead)
                              Padding(
                                padding: const EdgeInsets.only(left: 9, top: 7),
                                child: Container(
                                  width: 9,
                                  height: 9,
                                  decoration: const BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    return FilterChip(
      label: Text(label),
      selected: selectedFilter == label,
      onSelected: (selected) {
        setState(() {
          selectedFilter = label;
        });
      },
      selectedColor: Colors.blue[100],
      checkmarkColor: Colors.blue,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(
        color: selectedFilter == label ? Colors.blue[900] : Colors.black54,
        fontWeight: selectedFilter == label ? FontWeight.bold : FontWeight.normal,
      ),
      elevation: 1,
      pressElevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
    );
  }
}
